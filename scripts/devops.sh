#!/bin/bash
# Utility scripts for common tasks

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Helper functions
print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_info() {
    echo -e "${NC}ℹ $1${NC}"
}

# Function: Setup local development
setup_local() {
    print_info "Setting up local development environment..."
    
    # Check Node.js
    if ! command -v node &> /dev/null; then
        print_error "Node.js is not installed. Please install Node.js 18+"
        exit 1
    fi
    print_success "Node.js found: $(node --version)"
    
    # Install dependencies
    print_info "Installing dependencies..."
    npm ci
    print_success "Dependencies installed"
    
    # Copy env file if not exists
    if [ ! -f .env.local ]; then
        cp .env.example .env.local
        print_warning "Created .env.local - please configure it"
    else
        print_info ".env.local already exists"
    fi
    
    print_success "Local setup complete! Run 'npm run dev' to start"
}

# Function: Build Docker image
build_docker() {
    print_info "Building Docker image..."
    docker build -t ecommerce:latest .
    print_success "Docker image built: ecommerce:latest"
}

# Function: Start Docker Compose
start_docker() {
    print_info "Starting Docker Compose..."
    docker-compose up -d
    print_success "Services started"
    print_info "Application: http://localhost:3000"
    print_info "Redis: localhost:6379"
}

# Function: Stop Docker Compose
stop_docker() {
    print_info "Stopping Docker Compose..."
    docker-compose down
    print_success "Services stopped"
}

# Function: Setup Azure infrastructure
setup_azure() {
    print_info "Setting up Azure infrastructure..."
    
    # Check if logged in to Azure
    if ! az account show &> /dev/null; then
        print_error "Not logged in to Azure. Run 'az login' first"
        exit 1
    fi
    print_success "Azure CLI authenticated"
    
    cd terraform
    
    # Check if tfvars exists
    if [ ! -f terraform.tfvars ]; then
        cp terraform.tfvars.example terraform.tfvars
        print_warning "Created terraform.tfvars - please configure it"
        exit 0
    fi
    
    # Initialize Terraform
    print_info "Initializing Terraform..."
    terraform init
    print_success "Terraform initialized"
    
    # Validate
    print_info "Validating Terraform configuration..."
    terraform validate
    print_success "Configuration valid"
    
    # Plan
    print_info "Creating Terraform plan..."
    terraform plan -out=tfplan
    print_success "Plan created"
    
    # Ask for confirmation
    read -p "Apply this plan? (yes/no): " confirm
    if [ "$confirm" = "yes" ]; then
        terraform apply tfplan
        print_success "Infrastructure created!"
        
        # Save outputs
        terraform output -json > outputs.json
        print_info "Outputs saved to outputs.json"
    else
        print_warning "Skipped apply"
    fi
    
    cd ..
}

# Function: Deploy to Kubernetes
deploy_k8s() {
    print_info "Deploying to Kubernetes..."
    
    # Check kubectl
    if ! command -v kubectl &> /dev/null; then
        print_error "kubectl is not installed"
        exit 1
    fi
    
    # Check connection
    if ! kubectl cluster-info &> /dev/null; then
        print_error "Cannot connect to Kubernetes cluster"
        print_info "Run: az aks get-credentials --resource-group <rg> --name <cluster>"
        exit 1
    fi
    print_success "Connected to Kubernetes cluster"
    
    # Create namespace
    print_info "Creating namespace..."
    kubectl apply -f k8s/namespace.yml
    
    # Check secrets
    if ! kubectl get secret ecommerce-secrets -n ecommerce &> /dev/null; then
        print_warning "Secrets not found. Please create secrets first:"
        print_info "kubectl create secret generic ecommerce-secrets \\"
        print_info "  --from-literal=DATABASE_URL='...' \\"
        print_info "  --namespace=ecommerce"
        exit 1
    fi
    print_success "Secrets exist"
    
    # Deploy
    print_info "Applying Kubernetes manifests..."
    kubectl apply -f k8s/
    print_success "Deployed!"
    
    # Wait for rollout
    print_info "Waiting for deployment..."
    kubectl rollout status deployment/ecommerce-app -n ecommerce --timeout=5m
    print_success "Deployment complete"
    
    # Show status
    print_info "Application status:"
    kubectl get pods -n ecommerce
    kubectl get services -n ecommerce
    kubectl get ingress -n ecommerce
}

# Function: Get logs
get_logs() {
    local service=$1
    if [ -z "$service" ]; then
        print_info "Getting application logs..."
        kubectl logs -l app=ecommerce -n ecommerce --tail=100
    else
        print_info "Getting logs for $service..."
        kubectl logs deployment/$service -n ecommerce --tail=100
    fi
}

# Function: Port forward
port_forward() {
    print_info "Setting up port forwarding..."
    print_info "Access application at http://localhost:3000"
    kubectl port-forward service/ecommerce-service 3000:80 -n ecommerce
}

# Function: Cleanup
cleanup() {
    print_warning "This will destroy all resources. Are you sure?"
    read -p "Type 'yes' to confirm: " confirm
    
    if [ "$confirm" = "yes" ]; then
        # Delete K8s resources
        print_info "Deleting Kubernetes resources..."
        kubectl delete namespace ecommerce --ignore-not-found=true
        print_success "Kubernetes resources deleted"
        
        # Destroy Terraform
        cd terraform
        print_info "Destroying Terraform resources..."
        terraform destroy -auto-approve
        print_success "Infrastructure destroyed"
        cd ..
        
        print_success "Cleanup complete"
    else
        print_warning "Cleanup cancelled"
    fi
}

# Function: Health check
health_check() {
    print_info "Checking application health..."
    
    # Local
    if curl -f http://localhost:3000/api/health &> /dev/null; then
        print_success "Local application is healthy"
    else
        print_error "Local application is not responding"
    fi
    
    # Kubernetes
    if kubectl get pods -n ecommerce &> /dev/null; then
        print_info "Kubernetes pods:"
        kubectl get pods -n ecommerce
    fi
}

# Function: Generate secrets
generate_secrets() {
    print_info "Generating secure secrets..."
    
    echo "# Generated Secrets - DO NOT COMMIT"
    echo ""
    echo "JWT_SECRET=$(openssl rand -hex 32)"
    echo "SESSION_SECRET=$(openssl rand -hex 32)"
    echo "ENCRYPTION_KEY=$(openssl rand -hex 16)"
    echo ""
    print_success "Secrets generated. Copy to your .env file"
}

# Main menu
show_menu() {
    echo ""
    echo "================================"
    echo "  E-commerce DevOps Scripts"
    echo "================================"
    echo "1.  Setup local development"
    echo "2.  Build Docker image"
    echo "3.  Start Docker Compose"
    echo "4.  Stop Docker Compose"
    echo "5.  Setup Azure infrastructure"
    echo "6.  Deploy to Kubernetes"
    echo "7.  Get application logs"
    echo "8.  Port forward (local access)"
    echo "9.  Health check"
    echo "10. Generate secrets"
    echo "11. Cleanup (destroy all)"
    echo "0.  Exit"
    echo "================================"
}

# Main script
main() {
    if [ $# -eq 0 ]; then
        while true; do
            show_menu
            read -p "Select option: " choice
            
            case $choice in
                1) setup_local ;;
                2) build_docker ;;
                3) start_docker ;;
                4) stop_docker ;;
                5) setup_azure ;;
                6) deploy_k8s ;;
                7) get_logs ;;
                8) port_forward ;;
                9) health_check ;;
                10) generate_secrets ;;
                11) cleanup ;;
                0) exit 0 ;;
                *) print_error "Invalid option" ;;
            esac
            
            echo ""
            read -p "Press Enter to continue..."
        done
    else
        # Command line arguments
        case $1 in
            setup) setup_local ;;
            build) build_docker ;;
            start) start_docker ;;
            stop) stop_docker ;;
            azure) setup_azure ;;
            deploy) deploy_k8s ;;
            logs) get_logs $2 ;;
            forward) port_forward ;;
            health) health_check ;;
            secrets) generate_secrets ;;
            cleanup) cleanup ;;
            *) 
                echo "Usage: $0 {setup|build|start|stop|azure|deploy|logs|forward|health|secrets|cleanup}"
                exit 1
                ;;
        esac
    fi
}

main "$@"
