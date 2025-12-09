# DevOps Utility Scripts for Windows PowerShell
# Usage: .\scripts\devops.ps1 <command>

param(
    [Parameter(Position=0)]
    [string]$Command
)

# Helper functions
function Write-Success {
    param([string]$Message)
    Write-Host "✓ $Message" -ForegroundColor Green
}

function Write-ErrorMsg {
    param([string]$Message)
    Write-Host "✗ $Message" -ForegroundColor Red
}

function Write-Warning {
    param([string]$Message)
    Write-Host "⚠ $Message" -ForegroundColor Yellow
}

function Write-Info {
    param([string]$Message)
    Write-Host "ℹ $Message" -ForegroundColor Cyan
}

# Setup local development
function Setup-Local {
    Write-Info "Setting up local development environment..."
    
    # Check Node.js
    if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
        Write-ErrorMsg "Node.js is not installed. Please install Node.js 18+"
        exit 1
    }
    Write-Success "Node.js found: $(node --version)"
    
    # Install dependencies
    Write-Info "Installing dependencies..."
    npm ci
    Write-Success "Dependencies installed"
    
    # Copy env file if not exists
    if (-not (Test-Path .env.local)) {
        Copy-Item .env.example .env.local
        Write-Warning "Created .env.local - please configure it"
    } else {
        Write-Info ".env.local already exists"
    }
    
    Write-Success "Local setup complete! Run 'npm run dev' to start"
}

# Build Docker image
function Build-DockerImage {
    Write-Info "Building Docker image..."
    docker build -t ecommerce:latest .
    Write-Success "Docker image built: ecommerce:latest"
}

# Start Docker Compose
function Start-DockerCompose {
    Write-Info "Starting Docker Compose..."
    docker-compose up -d
    Write-Success "Services started"
    Write-Info "Application: http://localhost:3000"
    Write-Info "Redis: localhost:6379"
}

# Stop Docker Compose
function Stop-DockerCompose {
    Write-Info "Stopping Docker Compose..."
    docker-compose down
    Write-Success "Services stopped"
}

# Setup Azure infrastructure
function Setup-Azure {
    Write-Info "Setting up Azure infrastructure..."
    
    # Check if logged in to Azure
    try {
        az account show | Out-Null
        Write-Success "Azure CLI authenticated"
    } catch {
        Write-ErrorMsg "Not logged in to Azure. Run 'az login' first"
        exit 1
    }
    
    Push-Location terraform
    
    # Check if tfvars exists
    if (-not (Test-Path terraform.tfvars)) {
        Copy-Item terraform.tfvars.example terraform.tfvars
        Write-Warning "Created terraform.tfvars - please configure it"
        Pop-Location
        return
    }
    
    # Initialize Terraform
    Write-Info "Initializing Terraform..."
    terraform init
    Write-Success "Terraform initialized"
    
    # Validate
    Write-Info "Validating Terraform configuration..."
    terraform validate
    Write-Success "Configuration valid"
    
    # Plan
    Write-Info "Creating Terraform plan..."
    terraform plan -out=tfplan
    Write-Success "Plan created"
    
    # Ask for confirmation
    $confirm = Read-Host "Apply this plan? (yes/no)"
    if ($confirm -eq "yes") {
        terraform apply tfplan
        Write-Success "Infrastructure created!"
        
        # Save outputs
        terraform output -json | Out-File outputs.json
        Write-Info "Outputs saved to outputs.json"
    } else {
        Write-Warning "Skipped apply"
    }
    
    Pop-Location
}

# Deploy to Kubernetes
function Deploy-K8s {
    Write-Info "Deploying to Kubernetes..."
    
    # Check kubectl
    if (-not (Get-Command kubectl -ErrorAction SilentlyContinue)) {
        Write-ErrorMsg "kubectl is not installed"
        exit 1
    }
    
    # Check connection
    try {
        kubectl cluster-info | Out-Null
        Write-Success "Connected to Kubernetes cluster"
    } catch {
        Write-ErrorMsg "Cannot connect to Kubernetes cluster"
        Write-Info "Run: az aks get-credentials --resource-group <rg> --name <cluster>"
        exit 1
    }
    
    # Create namespace
    Write-Info "Creating namespace..."
    kubectl apply -f k8s/namespace.yml
    
    # Check secrets
    try {
        kubectl get secret ecommerce-secrets -n ecommerce | Out-Null
        Write-Success "Secrets exist"
    } catch {
        Write-Warning "Secrets not found. Please create secrets first:"
        Write-Info "kubectl create secret generic ecommerce-secrets --from-literal=DATABASE_URL='...' --namespace=ecommerce"
        exit 1
    }
    
    # Deploy
    Write-Info "Applying Kubernetes manifests..."
    kubectl apply -f k8s/
    Write-Success "Deployed!"
    
    # Wait for rollout
    Write-Info "Waiting for deployment..."
    kubectl rollout status deployment/ecommerce-app -n ecommerce --timeout=5m
    Write-Success "Deployment complete"
    
    # Show status
    Write-Info "Application status:"
    kubectl get pods -n ecommerce
    kubectl get services -n ecommerce
    kubectl get ingress -n ecommerce
}

# Get logs
function Get-Logs {
    param([string]$Service)
    
    if ([string]::IsNullOrEmpty($Service)) {
        Write-Info "Getting application logs..."
        kubectl logs -l app=ecommerce -n ecommerce --tail=100
    } else {
        Write-Info "Getting logs for $Service..."
        kubectl logs deployment/$Service -n ecommerce --tail=100
    }
}

# Port forward
function Start-PortForward {
    Write-Info "Setting up port forwarding..."
    Write-Info "Access application at http://localhost:3000"
    kubectl port-forward service/ecommerce-service 3000:80 -n ecommerce
}

# Health check
function Test-Health {
    Write-Info "Checking application health..."
    
    # Local
    try {
        $response = Invoke-WebRequest -Uri http://localhost:3000/api/health -UseBasicParsing
        if ($response.StatusCode -eq 200) {
            Write-Success "Local application is healthy"
        }
    } catch {
        Write-ErrorMsg "Local application is not responding"
    }
    
    # Kubernetes
    try {
        kubectl get pods -n ecommerce
    } catch {
        Write-Warning "Cannot access Kubernetes cluster"
    }
}

# Generate secrets
function New-Secrets {
    Write-Info "Generating secure secrets..."
    
    Write-Host "`n# Generated Secrets - DO NOT COMMIT`n"
    
    $jwt = [Convert]::ToBase64String([System.Security.Cryptography.RandomNumberGenerator]::GetBytes(32))
    $session = [Convert]::ToBase64String([System.Security.Cryptography.RandomNumberGenerator]::GetBytes(32))
    $encryption = [Convert]::ToBase64String([System.Security.Cryptography.RandomNumberGenerator]::GetBytes(16))
    
    Write-Host "JWT_SECRET=$jwt"
    Write-Host "SESSION_SECRET=$session"
    Write-Host "ENCRYPTION_KEY=$encryption"
    Write-Host ""
    
    Write-Success "Secrets generated. Copy to your .env file"
}

# Cleanup
function Remove-All {
    Write-Warning "This will destroy all resources. Are you sure?"
    $confirm = Read-Host "Type 'yes' to confirm"
    
    if ($confirm -eq "yes") {
        # Delete K8s resources
        Write-Info "Deleting Kubernetes resources..."
        kubectl delete namespace ecommerce --ignore-not-found=true
        Write-Success "Kubernetes resources deleted"
        
        # Destroy Terraform
        Push-Location terraform
        Write-Info "Destroying Terraform resources..."
        terraform destroy -auto-approve
        Write-Success "Infrastructure destroyed"
        Pop-Location
        
        Write-Success "Cleanup complete"
    } else {
        Write-Warning "Cleanup cancelled"
    }
}

# Show menu
function Show-Menu {
    Write-Host "`n================================"
    Write-Host "  E-commerce DevOps Scripts"
    Write-Host "================================"
    Write-Host "1.  Setup local development"
    Write-Host "2.  Build Docker image"
    Write-Host "3.  Start Docker Compose"
    Write-Host "4.  Stop Docker Compose"
    Write-Host "5.  Setup Azure infrastructure"
    Write-Host "6.  Deploy to Kubernetes"
    Write-Host "7.  Get application logs"
    Write-Host "8.  Port forward (local access)"
    Write-Host "9.  Health check"
    Write-Host "10. Generate secrets"
    Write-Host "11. Cleanup (destroy all)"
    Write-Host "0.  Exit"
    Write-Host "================================`n"
}

# Main execution
if ([string]::IsNullOrEmpty($Command)) {
    while ($true) {
        Show-Menu
        $choice = Read-Host "Select option"
        
        switch ($choice) {
            "1"  { Setup-Local }
            "2"  { Build-DockerImage }
            "3"  { Start-DockerCompose }
            "4"  { Stop-DockerCompose }
            "5"  { Setup-Azure }
            "6"  { Deploy-K8s }
            "7"  { Get-Logs }
            "8"  { Start-PortForward }
            "9"  { Test-Health }
            "10" { New-Secrets }
            "11" { Remove-All }
            "0"  { exit 0 }
            default { Write-ErrorMsg "Invalid option" }
        }
        
        Write-Host ""
        Read-Host "Press Enter to continue..."
    }
} else {
    switch ($Command.ToLower()) {
        "setup"   { Setup-Local }
        "build"   { Build-DockerImage }
        "start"   { Start-DockerCompose }
        "stop"    { Stop-DockerCompose }
        "azure"   { Setup-Azure }
        "deploy"  { Deploy-K8s }
        "logs"    { Get-Logs }
        "forward" { Start-PortForward }
        "health"  { Test-Health }
        "secrets" { New-Secrets }
        "cleanup" { Remove-All }
        default {
            Write-Host "Usage: .\scripts\devops.ps1 {setup|build|start|stop|azure|deploy|logs|forward|health|secrets|cleanup}"
            exit 1
        }
    }
}
