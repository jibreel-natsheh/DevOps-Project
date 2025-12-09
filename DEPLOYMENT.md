# Next.js E-commerce - Complete DevOps Demo Project

A production-ready Next.js e-commerce application demonstrating modern DevOps practices including CI/CD, containerization, Infrastructure as Code, and Kubernetes orchestration on Azure.

## 🚀 Features

### Application
- **Next.js 15** with TypeScript
- **Redux** for state management
- **Responsive design** with SCSS
- **Product catalog** with filtering and search
- **Shopping cart** functionality
- **User authentication**

### DevOps & Infrastructure
- ✅ **Docker & Docker Compose** - Containerization
- ✅ **GitHub Actions** - CI/CD pipelines
- ✅ **Terraform** - Infrastructure as Code
- ✅ **Azure Kubernetes Service (AKS)** - Container orchestration
- ✅ **Azure Container Registry (ACR)** - Container image storage
- ✅ **Azure PostgreSQL** - Managed database
- ✅ **Azure Redis Cache** - Caching layer
- ✅ **Azure Key Vault** - Secrets management
- ✅ **Helm Charts** - Kubernetes package management
- ✅ **NGINX Ingress** - Load balancing
- ✅ **Cert-Manager** - SSL certificate management
- ✅ **Prometheus & Grafana** - Monitoring

## 📋 Table of Contents

1. [Prerequisites](#prerequisites)
2. [Local Development](#local-development)
3. [Docker Setup](#docker-setup)
4. [Azure Infrastructure Setup](#azure-infrastructure-setup)
5. [Kubernetes Deployment](#kubernetes-deployment)
6. [CI/CD Pipeline](#cicd-pipeline)
7. [Environment Variables](#environment-variables)
8. [Monitoring & Observability](#monitoring--observability)
9. [Troubleshooting](#troubleshooting)

## 📦 Prerequisites

### Required Tools
- **Node.js** 18.x or higher
- **npm** or **yarn**
- **Docker** and **Docker Compose**
- **Azure CLI** 2.50+
- **kubectl** 1.28+
- **Terraform** 1.6+
- **Git**

### Azure Requirements
- Azure subscription
- Azure CLI authenticated
- Contributor access to subscription

### GitHub Requirements
- GitHub account
- Repository with Actions enabled

## 🏠 Local Development

### 1. Clone the Repository
```bash
git clone https://github.com/yourusername/next-ecommerce.git
cd next-ecommerce
```

### 2. Install Dependencies
```bash
npm install
```

### 3. Set Up Environment Variables
```bash
cp .env.example .env.local
```

Edit `.env.local` and configure your local environment variables.

### 4. Run Development Server
```bash
npm run dev
```

Visit `http://localhost:3000` to see the application.

### 5. Build for Production
```bash
npm run build
npm start
```

## 🐳 Docker Setup

### Build Docker Image
```bash
docker build -t ecommerce:latest .
```

### Run with Docker Compose
```bash
# Start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop all services
docker-compose down
```

The application will be available at:
- Application: `http://localhost:3000`
- Redis: `localhost:6379`

### Test Docker Image Locally
```bash
docker run -p 3000:3000 \
  -e NODE_ENV=production \
  -e NEXT_PUBLIC_API_URL=http://localhost:3000 \
  ecommerce:latest
```

## ☁️ Azure Infrastructure Setup

### Prerequisites
1. **Install Azure CLI**
   ```bash
   # Windows (PowerShell)
   winget install Microsoft.AzureCLI
   
   # macOS
   brew install azure-cli
   
   # Linux
   curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
   ```

2. **Login to Azure**
   ```bash
   az login
   az account set --subscription "YOUR_SUBSCRIPTION_ID"
   ```

### Step 1: Initialize Terraform

```bash
cd terraform

# Initialize Terraform
terraform init

# Validate configuration
terraform validate

# Format Terraform files
terraform fmt
```

### Step 2: Configure Variables

1. Copy the example variables file:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

2. Edit `terraform.tfvars` with your values:
   ```hcl
   project_name       = "ecommerce"
   environment        = "prod"
   location           = "East US"
   postgres_admin_password = "YourSecurePassword123!"
   ```

### Step 3: Plan Infrastructure

```bash
terraform plan -out=tfplan
```

Review the planned changes carefully.

### Step 4: Apply Infrastructure

```bash
terraform apply tfplan
```

This will create:
- Resource Group
- Virtual Network
- AKS Cluster (3 nodes)
- Azure Container Registry
- PostgreSQL Server
- Redis Cache
- Storage Account
- Key Vault
- NGINX Ingress Controller
- Cert-Manager
- Prometheus Stack

**⏱️ This process takes approximately 15-20 minutes.**

### Step 5: Get Outputs

```bash
terraform output
terraform output -json > outputs.json
```

Save important outputs:
```bash
# Get AKS credentials
az aks get-credentials \
  --resource-group $(terraform output -raw resource_group_name) \
  --name $(terraform output -raw aks_cluster_name)

# Test kubectl connection
kubectl get nodes
```

## ⚓ Kubernetes Deployment

### Step 1: Configure kubectl

```bash
# Verify connection
kubectl cluster-info
kubectl get nodes
```

### Step 2: Create Namespace

```bash
kubectl apply -f k8s/namespace.yml
```

### Step 3: Create Secrets

⚠️ **Never commit secrets to Git!**

```bash
# Create Docker registry secret
kubectl create secret docker-registry acr-secret \
  --docker-server=YOUR_ACR_NAME.azurecr.io \
  --docker-username=YOUR_ACR_USERNAME \
  --docker-password=YOUR_ACR_PASSWORD \
  --namespace=ecommerce

# Create application secrets
kubectl create secret generic ecommerce-secrets \
  --from-literal=DATABASE_URL='postgresql://user:pass@host:5432/db' \
  --from-literal=JWT_SECRET='your-jwt-secret' \
  --from-literal=SESSION_SECRET='your-session-secret' \
  --from-literal=ENCRYPTION_KEY='your-32-char-encryption-key' \
  --from-literal=STRIPE_SECRET_KEY='sk_live_your_key' \
  --namespace=ecommerce
```

### Step 4: Deploy ConfigMap

```bash
kubectl apply -f k8s/configmap.yml
```

### Step 5: Deploy Application

```bash
# Deploy all resources
kubectl apply -f k8s/

# Watch deployment progress
kubectl get pods -n ecommerce -w

# Check deployment status
kubectl rollout status deployment/ecommerce-app -n ecommerce
```

### Step 6: Verify Deployment

```bash
# Check pods
kubectl get pods -n ecommerce

# Check services
kubectl get services -n ecommerce

# Check ingress
kubectl get ingress -n ecommerce

# View logs
kubectl logs -f deployment/ecommerce-app -n ecommerce
```

### Step 7: Access Application

```bash
# Get ingress IP
kubectl get ingress -n ecommerce

# Test locally (if no DNS configured)
kubectl port-forward service/ecommerce-service 3000:80 -n ecommerce
```

Visit `http://localhost:3000` or your configured domain.

## 🔄 CI/CD Pipeline

### GitHub Actions Workflows

This project includes three workflows:

#### 1. **CI/CD Pipeline** (`.github/workflows/ci-cd.yml`)
Triggered on push to `main`/`master` or pull requests.

**Jobs:**
- Build and Test
- Security Scan
- Docker Build & Push
- Deploy to AKS
- Post-Deployment Tests

#### 2. **Terraform Infrastructure** (`.github/workflows/terraform.yml`)
Manages infrastructure changes.

**Jobs:**
- Terraform Plan
- Terraform Apply (on merge)
- Update K8s Configuration

#### 3. **PR Checks** (`.github/workflows/pr-checks.yml`)
Runs on all pull requests.

**Jobs:**
- Code Quality
- Build Test
- Docker Build Test
- Security Scan
- Terraform Validation

### Setting Up GitHub Secrets

Navigate to: **Repository → Settings → Secrets and variables → Actions**

#### Required Secrets:

```yaml
# Azure Authentication
AZURE_CREDENTIALS: '{"clientId":"...","clientSecret":"...","subscriptionId":"...","tenantId":"..."}'
ARM_CLIENT_ID: "your-client-id"
ARM_CLIENT_SECRET: "your-client-secret"
ARM_SUBSCRIPTION_ID: "your-subscription-id"
ARM_TENANT_ID: "your-tenant-id"

# Azure Container Registry
ACR_LOGIN_SERVER: "yourregistry.azurecr.io"
ACR_USERNAME: "your-acr-username"
ACR_PASSWORD: "your-acr-password"

# AKS
AKS_RESOURCE_GROUP: "ecommerce-prod-rg"
AKS_CLUSTER_NAME: "ecommerce-prod-aks"

# Application Secrets
DATABASE_URL: "postgresql://user:pass@host:5432/db"
JWT_SECRET: "your-jwt-secret"
SESSION_SECRET: "your-session-secret"
STRIPE_SECRET_KEY: "sk_live_your_key"
NEXT_PUBLIC_API_URL: "https://ecommerce.yourdomain.com"

# Terraform
POSTGRES_ADMIN_PASSWORD: "your-postgres-password"
```

### Creating Azure Service Principal

```bash
# Create service principal
az ad sp create-for-rbac \
  --name "github-actions-ecommerce" \
  --role contributor \
  --scopes /subscriptions/YOUR_SUBSCRIPTION_ID \
  --sdk-auth

# Output will be your AZURE_CREDENTIALS secret
```

### Triggering Workflows

```bash
# Push to main triggers full CI/CD
git push origin main

# Create PR triggers PR checks
git checkout -b feature/new-feature
git push origin feature/new-feature
# Create PR on GitHub

# Manual trigger (for terraform)
# Go to Actions tab → Terraform Infrastructure → Run workflow
```

## 🔐 Environment Variables

### Application Environment Variables

#### Public Variables (ConfigMap)
- `NODE_ENV` - Environment (development/production)
- `PORT` - Application port (default: 3000)
- `NEXT_PUBLIC_API_URL` - Public API URL
- `REDIS_URL` - Redis connection URL
- `LOG_LEVEL` - Logging level (info/debug/error)

#### Secret Variables (Kubernetes Secrets / Key Vault)
- `DATABASE_URL` - PostgreSQL connection string
- `JWT_SECRET` - JWT signing secret
- `SESSION_SECRET` - Session encryption secret
- `ENCRYPTION_KEY` - Data encryption key (32 chars)
- `STRIPE_SECRET_KEY` - Stripe payment gateway key
- `STRIPE_WEBHOOK_SECRET` - Stripe webhook secret
- `SMTP_PASSWORD` - Email service password
- `AZURE_STORAGE_KEY` - Azure Blob Storage key

### Managing Secrets

#### Using Azure Key Vault

```bash
# Store secret in Key Vault
az keyvault secret set \
  --vault-name "your-keyvault-name" \
  --name "jwt-secret" \
  --value "your-secret-value"

# Retrieve secret
az keyvault secret show \
  --vault-name "your-keyvault-name" \
  --name "jwt-secret" \
  --query value -o tsv
```

#### Using Kubernetes Secrets

```bash
# Create secret
kubectl create secret generic my-secret \
  --from-literal=key=value \
  --namespace=ecommerce

# Update secret
kubectl create secret generic my-secret \
  --from-literal=key=new-value \
  --namespace=ecommerce \
  --dry-run=client -o yaml | kubectl apply -f -

# View secret (base64 encoded)
kubectl get secret my-secret -n ecommerce -o yaml
```

## 📊 Monitoring & Observability

### Prometheus & Grafana

Access Prometheus:
```bash
kubectl port-forward -n monitoring svc/prometheus-kube-prometheus-prometheus 9090:9090
```
Visit: `http://localhost:9090`

Access Grafana:
```bash
# Get admin password
kubectl get secret -n monitoring prometheus-grafana -o jsonpath="{.data.admin-password}" | base64 --decode

kubectl port-forward -n monitoring svc/prometheus-grafana 3000:80
```
Visit: `http://localhost:3000`

### Application Logs

```bash
# View application logs
kubectl logs -f deployment/ecommerce-app -n ecommerce

# View logs from all pods
kubectl logs -l app=ecommerce -n ecommerce --tail=100

# Stream logs
kubectl logs -f -l app=ecommerce -n ecommerce
```

### Metrics

```bash
# Pod metrics
kubectl top pods -n ecommerce

# Node metrics
kubectl top nodes

# HPA status
kubectl get hpa -n ecommerce
```

## 🔧 Troubleshooting

### Common Issues

#### 1. Pods Not Starting

```bash
# Check pod status
kubectl describe pod POD_NAME -n ecommerce

# Check events
kubectl get events -n ecommerce --sort-by='.lastTimestamp'

# Check logs
kubectl logs POD_NAME -n ecommerce
```

#### 2. ImagePullBackOff Error

```bash
# Verify ACR secret
kubectl get secret acr-secret -n ecommerce

# Recreate secret
kubectl delete secret acr-secret -n ecommerce
kubectl create secret docker-registry acr-secret \
  --docker-server=YOUR_ACR.azurecr.io \
  --docker-username=YOUR_USERNAME \
  --docker-password=YOUR_PASSWORD \
  --namespace=ecommerce
```

#### 3. Database Connection Issues

```bash
# Test database connectivity from pod
kubectl exec -it POD_NAME -n ecommerce -- /bin/sh
# Inside pod:
nc -zv YOUR_POSTGRES_HOST 5432
```

#### 4. Ingress Not Working

```bash
# Check ingress controller
kubectl get pods -n ingress-nginx

# Check ingress resource
kubectl describe ingress ecommerce-ingress -n ecommerce

# Get ingress IP
kubectl get ingress -n ecommerce
```

### Useful Commands

```bash
# Restart deployment
kubectl rollout restart deployment/ecommerce-app -n ecommerce

# Scale deployment
kubectl scale deployment/ecommerce-app --replicas=5 -n ecommerce

# Update image
kubectl set image deployment/ecommerce-app \
  ecommerce-app=NEW_IMAGE:TAG \
  -n ecommerce

# Rollback deployment
kubectl rollout undo deployment/ecommerce-app -n ecommerce

# Delete and redeploy
kubectl delete -f k8s/
kubectl apply -f k8s/
```

## 🧪 Testing

### Run Tests Locally

```bash
# Unit tests
npm test

# Build test
npm run build

# Docker build test
docker build -t ecommerce:test .
```

### Run Smoke Tests

```bash
# Health check
curl -f http://localhost:3000/api/health

# Load products
curl http://localhost:3000/api/products
```

## 🚀 Scaling

### Manual Scaling

```bash
# Scale pods
kubectl scale deployment/ecommerce-app --replicas=10 -n ecommerce

# Scale nodes (AKS)
az aks scale \
  --resource-group ecommerce-prod-rg \
  --name ecommerce-prod-aks \
  --node-count 5
```

### Auto-scaling

HPA is configured in `k8s/hpa.yml`:
- Min replicas: 3
- Max replicas: 10
- Target CPU: 70%
- Target Memory: 80%

## 📚 Additional Resources

- [Next.js Documentation](https://nextjs.org/docs)
- [Azure Kubernetes Service](https://docs.microsoft.com/azure/aks/)
- [Terraform Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [GitHub Actions](https://docs.github.com/actions)
- [Docker Documentation](https://docs.docker.com/)
- [Kubernetes Documentation](https://kubernetes.io/docs/)

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👥 Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## 📧 Support

For issues or questions, please open a GitHub issue or contact the maintainers.

---

**Made with ❤️ for demonstrating modern DevOps practices**
