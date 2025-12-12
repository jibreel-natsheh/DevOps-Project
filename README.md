# Next.js E-commerce - Complete DevOps Learning Project 🎓

[![CI/CD Pipeline](https://github.com/jibreel-natsheh/DevOps-Project/workflows/CI/CD%20Pipeline/badge.svg)](https://github.com/jibreel-natsheh/DevOps-Project/actions)[![Terraform](https://github.com/jibreel-natsheh/DevOps-Project/workflows/Terraform%20Infrastructure/badge.svg)](https://github.com/jibreel-natsheh/DevOps-Project/actions)

**A hands-on DevOps learning project** featuring a production-ready Next.js e-commerce application deployed on Azure using modern DevOps practices: **Docker**, **Kubernetes (AKS)**, **Terraform (IaC)**, **CI/CD with GitHub Actions**, and **Azure Cloud Services**.

> 🎯 **Perfect for Software Engineering students** learning DevOps, Cloud Computing, and modern deployment practices!

## 🌐 Live Demo

**Application URL**: [http://172.185.141.111](http://172.185.141.111)

Deployed on Azure Kubernetes Service with full CI/CD automation!

## 🎓 Learning Objectives

By exploring this project, students will learn:

### 1. **Containerization with Docker**

-   Multi-stage Docker builds for optimization
-   Docker Compose for local development
-   Container best practices and security

### 2. **Container Orchestration with Kubernetes**

-   Deploying applications on Azure Kubernetes Service (AKS)
-   Managing deployments, services, and ingress controllers
-   ConfigMaps and Secrets management
-   Horizontal Pod Autoscaling (HPA)
-   Persistent storage with PVCs

### 3. **Infrastructure as Code (IaC) with Terraform**

-   Provisioning Azure cloud resources programmatically
-   Managing AKS clusters, databases, caching, and networking
-   Resource lifecycle management
-   State management and remote backends

### 4. **CI/CD with GitHub Actions**

-   Automated testing and building
-   Docker image building and pushing to ACR
-   Automated deployment to Kubernetes
-   Security scanning with Trivy
-   Environment management and secrets

### 5. **Cloud Services (Azure)**

-   Azure Kubernetes Service (AKS)
-   Azure Container Registry (ACR)
-   Azure PostgreSQL Flexible Server
-   Azure Redis Cache
-   Azure Key Vault for secrets
-   Virtual Networks and security

### 6. **Security Best Practices**

-   Secrets management (never commit secrets!)
-   Container vulnerability scanning
-   RBAC and service principals
-   Network policies and isolation

## 🚀 What's Included - DevOps Features

This repository demonstrates a **complete DevOps pipeline** with:

-   ✅ **Docker & Docker Compose** - Multi-stage builds with production optimization
-   ✅ **GitHub Actions CI/CD** - 3 automated pipelines (CI/CD, Terraform, PR checks)
-   ✅ **Terraform (IaC)** - Complete Azure infrastructure (7+ resources)
-   ✅ **Azure Kubernetes Service** - Production-grade container orchestration
-   ✅ **Azure Container Registry** - Private Docker image repository
-   ✅ **Secrets Management** - Kubernetes Secrets + Azure Key Vault
-   ✅ **Monitoring Ready** - Prometheus/Grafana compatible
-   ✅ **Auto-scaling** - Horizontal Pod Autoscaler (1-10 replicas)
-   ✅ **Security Scanning** - Trivy vulnerability scanning in CI/CD
-   ✅ **NGINX Ingress** - Load balancing and routing

## 📋 Table of Contents

-   [Learning Objectives](#-learning-objectives)
-   [Getting Started - For Students](#-getting-started---for-students)
-   [Application Features](#-application-features)
-   [DevOps Architecture](#-architecture)
-   [Exploring the Code](#-exploring-the-code)
-   [Running Locally](#-running-locally)
-   [Deploying to Azure](#-deploying-to-azure)
-   [Available Pages](#-available-pages)
-   [Tech Stack](#%EF%B8%8F-tech-stack)
-   [Documentation](#-documentation)
-   [Troubleshooting](#-troubleshooting)

## 🏁 Getting Started - For Students

### Prerequisites

Before you begin, ensure you have installed:

-   **Git** - [Download](https://git-scm.com/downloads)
-   **Node.js 18+** - [Download](https://nodejs.org/)
-   **Docker Desktop** - [Download](https://www.docker.com/products/docker-desktop)
-   **kubectl** - [Install Guide](https://kubernetes.io/docs/tasks/tools/)
-   **Azure CLI** (for cloud deployment) - [Install Guide](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
-   **Terraform** (for infrastructure) - [Download](https://www.terraform.io/downloads)

### Step 1: Clone and Explore

```bash
# Clone the repository
git clone https://github.com/jibreel-natsheh/DevOps-Project.git
cd DevOps-Project

# Explore the project structure
ls -la
```

**📁 Key Directories to Explore:**

-   `Dockerfile` - See how the app is containerized
-   `docker-compose.yml` - Local development setup
-   `.github/workflows/` - CI/CD pipelines
-   `k8s/` - Kubernetes manifests
-   `terraform/` - Infrastructure as Code
-   `src/` - Application source code

### Step 2: Run Locally (Docker)

```bash
# Start the application with Docker Compose
docker-compose up -d

# View running containers
docker ps

# View logs
docker-compose logs -f app

# Visit the application
# Open browser: http://localhost:3000

# Stop when done
docker-compose down
```

**🎯 Learning Exercise:**

-   Examine `Dockerfile` - Notice the multi-stage build strategy
-   Check `docker-compose.yml` - See how services are connected
-   Try modifying the code and rebuild: `docker-compose up --build`

### Step 3: Explore Kubernetes Manifests

```bash
# View Kubernetes configuration files
ls k8s/

# Examine the deployment
cat k8s/deployment.yml

# Examine the service
cat k8s/service.yml

# Examine the ingress
cat k8s/ingress.yml
```

**🎯 Learning Exercise:**

-   Understand how the app is deployed in Kubernetes
-   Note the environment variables and secrets usage
-   See how scaling is configured (replicas: 3)

### Step 4: Study the CI/CD Pipeline

```bash
# View GitHub Actions workflows
ls .github/workflows/

# Examine CI/CD pipeline
cat .github/workflows/ci-cd.yml

# Examine Terraform workflow
cat .github/workflows/terraform.yml
```

**🎯 Learning Points:**

-   **ci-cd.yml**: Builds, tests, scans, and deploys the application
-   **terraform.yml**: Manages infrastructure changes
-   **pr-checks.yml**: Validates pull requests

### Step 5: Understand Infrastructure as Code

```bash
# View Terraform files
ls terraform/

# Main infrastructure definition
cat terraform/resources.tf

# Variables
cat terraform/variables.tf

# Outputs (like connection strings)
cat terraform/outputs.tf
```

**🎯 What Terraform Creates:**

-   Azure Kubernetes Service (AKS) cluster
-   Azure Container Registry (ACR)
-   PostgreSQL Flexible Server database
-   Redis Cache for session storage
-   Storage Account for static assets
-   Virtual Network for security
-   Key Vault for secrets management

## ✨ Application Features

## ✨ Application Features

### E-commerce Functionality

-   **Product Catalog** - Browse products with filtering and search
-   **Shopping Cart** - Add/remove items, update quantities
-   **User Authentication** - Login and registration system
-   **Product Details** - Individual product pages with images
-   **Reviews & Ratings** - Customer feedback system
-   **Checkout Process** - Complete order workflow
-   **Responsive Design** - Works on desktop, tablet, and mobile

### Technical Stack

-   **Next.js 15** - React framework with SSR and SSG
-   **TypeScript** - Type-safe JavaScript
-   **Redux Toolkit** - State management with persistence
-   **SCSS** - Modern CSS with BEM methodology
-   **SWR** - Data fetching and caching

## 🔍 Exploring the Code

### Understanding the Docker Setup

**Dockerfile (Multi-stage Build):**

```dockerfile
# Stage 1: Dependencies - Install packagesFROM node:18-alpine AS depsWORKDIR /appCOPY package*.json ./RUN npm ci --legacy-peer-deps || npm install --legacy-peer-deps# Stage 2: Builder - Build the applicationFROM node:18-alpine AS builderWORKDIR /appCOPY --from=deps /app/node_modules ./node_modulesCOPY . .RUN npm run build# Stage 3: Runner - Production image (smallest size)FROM node:18-alpine AS runnerWORKDIR /appENV NODE_ENV productionCOPY --from=builder /app/public ./publicCOPY --from=builder /app/.next ./.nextCOPY --from=builder /app/node_modules ./node_modulesCOPY --from=builder /app/package.json ./package.jsonCMD ["npm", "start"]
```

**Why Multi-stage?**

-   Smaller final image (only production dependencies)
-   Faster deployments
-   More secure (no build tools in production)

### Understanding Kubernetes Deployment

**Key Concepts:**

1.  **Deployment** - Manages pod replicas (3 instances of your app)
2.  **Service** - Internal load balancer (ClusterIP)
3.  **Ingress** - External access point with NGINX
4.  **ConfigMap** - Non-sensitive configuration
5.  **Secrets** - Sensitive data (database passwords, API keys)
6.  **HPA** - Automatically scales from 1 to 10 pods based on CPU

### Understanding CI/CD Flow

```
Code Push → GitHub Actions Triggered    ↓Build & Test (Docker-based tests)    ↓Security Scan (Trivy)    ↓Build Docker Image    ↓Push to Azure Container Registry    ↓Deploy to AKS (kubectl set image)    ↓Verify Deployment (rollout status)    ↓Post-deployment Tests
```

## 🏃 Running Locally

## 🏃 Running Locally

### Option 1: Node.js Development Server (Fastest for Development)

```bash
# Install dependencies
npm install --legacy-peer-deps

# Create environment file (optional for basic features)
cp .env.example .env.local

# Run development server with hot reload
npm run dev

# Visit http://localhost:3000
```

**Use this when:** You're actively developing and want instant hot-reload.

### Option 2: Docker Compose (Closest to Production)

```bash
# Build and start all services
docker-compose up --build

# Run in background
docker-compose up -d

# View logs
docker-compose logs -f app

# Stop services
docker-compose down

# Visit http://localhost:3000
```

**Use this when:** You want to test the containerized version locally.

### Option 3: Docker Only

```bash
# Build the image
docker build -t ecommerce-app .

# Run the container
docker run -p 3000:3000 ecommerce-app

# Visit http://localhost:3000
```

## ☁️ Deploying to Azure

### Prerequisites for Cloud Deployment

1.  **Azure Account** - [Free Account](https://azure.microsoft.com/free/) ($200 credit for students)
2.  **GitHub Account** - For CI/CD
3.  **Azure CLI** - Installed and logged in
4.  **Terraform** - Installed

### Step 1: Fork This Repository

Click the "Fork" button on GitHub to create your own copy.

### Step 2: Provision Azure Infrastructure

```bash
# Login to Azure
az login

# Navigate to terraform directory
cd terraform

# Initialize Terraform
terraform init

# Review the infrastructure plan
terraform plan

# Apply (create resources) - Takes ~10-15 minutes
terraform apply

# Save the outputs (ACR name, AKS name, etc.)
terraform output
```

**💰 Cost Estimate:** ~$50-100/month with Free tier AKS

### Step 3: Configure GitHub Secrets

Go to your GitHub repository → Settings → Secrets and variables → Actions

Add these secrets (get values from Terraform outputs):

```bash
# Azure Container Registry
ACR_LOGIN_SERVER=<your-acr-name>.azurecr.io
ACR_USERNAME=<from: az acr credential show>
ACR_PASSWORD=<from: az acr credential show>
# Azure Kubernetes Service
AKS_CLUSTER_NAME=ecommerce-prod-aks
AKS_RESOURCE_GROUP=ecommerce-prod-rg
# Azure Service Principal (for Terraform)
AZURE_CREDENTIALS=<JSON from: az ad sp create-for-rbac>
# Application Secrets (generate your own)
DATABASE_URL=<from terraform output>
JWT_SECRET=<generate: openssl rand -base64 32>
SESSION_SECRET=<generate: openssl rand -base64 32>
STRIPE_SECRET_KEY=<your stripe key or dummy>
AZURE_STORAGE_KEY=<from terraform output>
```

### Step 4: Configure Terraform Backend (Recommended)

```bash
# Create storage for Terraform state
az storage account create \
  --name <unique-name>tfstate \
  --resource-group ecommerce-prod-rg \
  --sku Standard_LRS

az storage container create \
  --name tfstate \
  --account-name <unique-name>tfstate
```

Update `terraform/backend.tf` with your storage account details.

### Step 5: Deploy via CI/CD

```bash
# Push code to master branch
git add .
git commit -m "Initial deployment"
git push origin master

# GitHub Actions will automatically:
# 1. Build Docker image
# 2. Run security scans
# 3. Push to ACR
# 4. Deploy to AKS
```

### Step 6: Access Your Deployment

```bash
# Get AKS credentials
az aks get-credentials \
  --resource-group ecommerce-prod-rg \
  --name ecommerce-prod-aks

# Check deployment status
kubectl get pods -n ecommerce
kubectl get services -n ecommerce
kubectl get ingress -n ecommerce

# Get the public IP address
kubectl get ingress -n ecommerce
# Look for the ADDRESS column
```

Visit `http://<EXTERNAL-IP>` to see your deployed application!

## 🔧 Common Operations

### Viewing Logs

```bash
# View application logs
kubectl logs -n ecommerce -l app=ecommerce --tail=100 -f

# View specific pod
kubectl logs -n ecommerce <pod-name> -f
```

### Scaling the Application

```bash
# Manual scaling
kubectl scale deployment ecommerce-app --replicas=5 -n ecommerce

# Check HPA status (auto-scaling)
kubectl get hpa -n ecommerce
```

### Updating the Application

```bash
# Make code changes
# Commit and push
git add .
git commit -m "Updated feature X"
git push

# CI/CD automatically deploys the new version
# Monitor the rollout:
kubectl rollout status deployment/ecommerce-app -n ecommerce
```

### Rolling Back a Deployment

```bash
# View rollout history
kubectl rollout history deployment/ecommerce-app -n ecommerce

# Rollback to previous version
kubectl rollout undo deployment/ecommerce-app -n ecommerce

# Rollback to specific revision
kubectl rollout undo deployment/ecommerce-app --to-revision=2 -n ecommerce
```

## 📚 Documentation

### Core Documentation

-   **[DEPLOYMENT.md](./DEPLOYMENT.md)** - Complete step-by-step deployment guide
-   **[CI/CD Pipeline](./docs/CI_CD.md)** - GitHub Actions workflow details
-   **[Secrets Management](./docs/SECRETS_MANAGEMENT.md)** - Security best practices

### Learning Resources

**Docker:**

-   [Docker Documentation](https://docs.docker.com/)
-   [Docker Compose Tutorial](https://docs.docker.com/compose/gettingstarted/)
-   Multi-stage builds: See `Dockerfile` in this repo

**Kubernetes:**

-   [Kubernetes Basics](https://kubernetes.io/docs/tutorials/kubernetes-basics/)
-   [kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)
-   AKS Documentation: [Azure Kubernetes Service](https://learn.microsoft.com/en-us/azure/aks/)

**Terraform:**

-   [Terraform Get Started - Azure](https://learn.hashicorp.com/collections/terraform/azure-get-started)
-   [Azure Provider Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
-   Example: See `terraform/` directory in this repo

**CI/CD:**

-   [GitHub Actions Documentation](https://docs.github.com/en/actions)
-   [GitHub Actions for Azure](https://github.com/Azure/actions)
-   Example workflows: See `.github/workflows/` in this repo

## 🔍 Understanding the Infrastructure

### Complete Architecture Diagram

```
┌─────────────────────────────────────────────────────────────┐│                    GitHub Actions (CI/CD)                    ││  Build → Test → Security Scan → Push to ACR → Deploy       │└───────────────────────┬─────────────────────────────────────┘                        │                        ↓┌─────────────────────────────────────────────────────────────┐│                   Azure Container Registry                   ││              (Private Docker Image Storage)                  │└───────────────────────┬─────────────────────────────────────┘                        │                        ↓┌─────────────────────────────────────────────────────────────┐│             Azure Kubernetes Service (AKS)                   ││  ┌──────────────────────────────────────────────────────┐  ││  │         NGINX Ingress Controller (Load Balancer)     │  ││  │              Public IP: 172.185.141.111              │  ││  └─────────────────────┬────────────────────────────────┘  ││                        │                                     ││         ┌──────────────┴──────────────┐                     ││         │                              │                     ││  ┌──────▼──────┐  ┌──────▼──────┐  ┌─▼──────────┐         ││  │ Next.js Pod │  │ Next.js Pod │  │ Next.js Pod│         ││  │  (Replica 1)│  │  (Replica 2)│  │ (Replica 3)│         ││  └──────┬──────┘  └──────┬──────┘  └─┬──────────┘         ││         │                 │            │                     ││         └────────┬────────┴────────────┘                     ││                  │                                           │└──────────────────┼───────────────────────────────────────────┘                   │    ┌──────────────┼──────────────┐    │              │               │┌───▼─────────┐  ┌─▼───────────┐ ┌▼──────────────┐│   Redis     │  │ PostgreSQL  │ │ Azure Storage ││   Cache     │  │  Database   │ │   (Blobs)     ││ (Sessions)  │  │ (User Data) │ │   (Images)    │└─────────────┘  └─────────────┘ └───────────────┘
```

### Infrastructure Components (Terraform-managed)

Resource

Purpose

Specs

**AKS Cluster**

Container orchestration

1-3 nodes, auto-scaling, Standard_DC2s_v3 VMs

**Azure Container Registry**

Docker image storage

Standard tier, admin enabled

**PostgreSQL Flexible Server**

Database

Version 13, B_Standard_B1ms tier

**Redis Cache**

Session & caching

Basic C0 (250MB)

**Storage Account**

Static files & images

Standard LRS

**Key Vault**

Secrets management

Standard tier

**Virtual Network**

Network isolation

10.0.0.0/16 CIDR

### Kubernetes Resources

Resource Type

Name

Purpose

**Namespace**

`ecommerce`

Logical isolation

**Deployment**

`ecommerce-app`

Manages 3 pod replicas

**Service**

`ecommerce-service`

Internal load balancer (ClusterIP)

**Ingress**

`ecommerce-ingress`

External access with NGINX

**ConfigMap**

`ecommerce-config`

Non-sensitive configuration

**Secret**

`ecommerce-secrets`

Database credentials, API keys

**HPA**

`ecommerce-hpa`

Auto-scale 1-10 pods based on CPU

**PVC**

`redis-data`

Persistent storage for Redis

### Network Flow

1.  **User Request** → `http://172.185.141.111`
2.  **Azure Load Balancer** → Routes to NGINX Ingress Controller
3.  **NGINX Ingress** → Routes to `ecommerce-service`
4.  **Service** → Load balances across 3 pod replicas
5.  **Pod** → Serves the Next.js application
6.  **App** → Connects to PostgreSQL, Redis, Azure Storage

## 🛠️ Tech Stack

### Frontend Technologies

-   **Next.js 15** - React framework with SSR/SSG
-   **React 18** - UI library with hooks
-   **TypeScript** - Type-safe JavaScript
-   **Redux Toolkit** - State management
-   **SCSS/SASS** - Modern CSS with BEM methodology
-   **SWR** - Data fetching and caching library

### DevOps & Infrastructure

-   **Docker** - Container runtime
-   **Docker Compose** - Multi-container orchestration
-   **Kubernetes** - Container orchestration at scale
-   **Terraform** - Infrastructure as Code
-   **GitHub Actions** - CI/CD automation
-   **NGINX** - Ingress controller

### Cloud Services (Azure)

-   **AKS** - Azure Kubernetes Service
-   **ACR** - Azure Container Registry
-   **PostgreSQL** - Flexible Server (managed database)
-   **Redis Cache** - In-memory data store
-   **Key Vault** - Secrets management
-   **Storage Account** - Blob storage
-   **Virtual Network** - Network security

### Security & Monitoring

-   **Trivy** - Container vulnerability scanning
-   **Azure RBAC** - Role-based access control
-   **Kubernetes Secrets** - Encrypted configuration
-   **HPA** - Horizontal Pod Autoscaler

## 📄 Available Pages

-   **Home page**: `/` - Product showcase and featured items
-   **Products page**: `/products` - Full catalog with filtering
-   **Product detail**: `/product/[id]` - Individual product page
-   **Shopping cart**: `/cart` - Cart management
-   **Checkout**: `/cart/checkout` - Order completion
-   **Login**: `/login` - User authentication
-   **Register**: `/register` - New user signup
-   **404 page**: `/page-not-found` - Custom error page

## 🐛 Troubleshooting

### Common Issues and Solutions

#### Docker Build Fails

**Issue**: `npm ci` or peer dependency errors

```bash
# Solution: Use legacy peer deps flag (already in Dockerfile)
npm install --legacy-peer-deps
```

#### Pods Not Starting (ImagePullBackOff)

**Issue**: Can't pull image from ACR

```bash
# Check ACR credentials
az acr credential show --name <acr-name>

# Verify role assignment exists
az role assignment list --scope /subscriptions/<sub-id>/resourceGroups/<rg>/providers/Microsoft.ContainerRegistry/registries/<acr-name>

# Create role assignment manually if needed
az role assignment create \
  --assignee <aks-kubelet-identity> \
  --role AcrPull \
  --scope <acr-id>
```

#### Application Returns 404

**Issue**: Ingress not routing to the service

```bash
# Check ingress configuration
kubectl describe ingress ecommerce-ingress -n ecommerce

# Verify service endpoints
kubectl get endpoints ecommerce-service -n ecommerce

# Check NGINX ingress controller pods
kubectl get pods -n ingress-nginx
```

#### Deployment Timeout in CI/CD

**Issue**: Image tag mismatch between push and deployment

```bash
# Check available tags in ACR
az acr repository show-tags --name <acr-name> --repository ecommerce

# Verify the tag format matches in ci-cd.yml (should use short SHA)
# Fixed in line 195: Uses SHORT_SHA=$(echo ${{ github.sha }} | cut -c1-7)
```

#### Database Connection Errors

**Issue**: Can't connect to PostgreSQL

```bash
# Verify DATABASE_URL secret exists
kubectl get secret ecommerce-secrets -n ecommerce -o yaml

# Check firewall rules
az postgres flexible-server firewall-rule list \
  --resource-group <rg> \
  --name <postgres-server>

# Verify pods can reach database
kubectl exec -it <pod-name> -n ecommerce -- wget -O- <database-host>:5432
```

#### Terraform Apply Fails

**Issue**: Resource naming conflicts or quota issues

```bash
# Common fixes:
# 1. Change region if quota exceeded
# 2. Use random suffix for globally unique names (already implemented)
# 3. Check Azure subscription limits

# View Terraform state
terraform state list

# Remove stuck resources
terraform state rm <resource-name>
```

### Debug Commands Cheat Sheet

```bash
# Check pod status and events
kubectl get pods -n ecommerce
kubectl describe pod <pod-name> -n ecommerce

# View application logs
kubectl logs -f <pod-name> -n ecommerce

# Check all resources in namespace
kubectl get all -n ecommerce

# Port forward for local testing
kubectl port-forward svc/ecommerce-service 8080:80 -n ecommerce

# Execute commands in pod
kubectl exec -it <pod-name> -n ecommerce -- /bin/sh

# View secrets (base64 encoded)
kubectl get secret ecommerce-secrets -n ecommerce -o json

# Check resource usage
kubectl top nodes
kubectl top pods -n ecommerce
```

```
                    ↓
```

┌─────────────────────────────────────────────────────────────┐│ Azure Container Registry ││ (Private Docker Image Storage) │└───────────────────────┬─────────────────────────────────────┘ │ ↓┌─────────────────────────────────────────────────────────────┐│ Azure Kubernetes Service (AKS) ││ ┌──────────────────────────────────────────────────────┐ ││ │ NGINX Ingress Controller (Load Balancer) │ ││ │ Public IP: 172.185.141.111 │ ││ └─────────────────────┬────────────────────────────────┘ ││ │ ││ ┌──────────────┴──────────────┐ ││ │ │ ││ ┌──────▼──────┐ ┌──────▼──────┐ ┌─▼──────────┐ ││ │ Next.js Pod │ │ Next.js Pod │ │ Next.js Pod│ ││ │ (Replica 1)│ │ (Replica 2)│ │ (Replica 3)│ ││ └──────┬──────┘ └──────┬──────┘ └─┬──────────┘ ││ │ │ │ ││ └────────┬────────┴────────────┘ ││ │ │└──────────────────┼───────────────────────────────────────────┘ │ ┌──────────────┼──────────────┐ │ │ │┌───▼─────────┐ ┌─▼───────────┐ ┌▼──────────────┐│ Redis │ │ PostgreSQL │ │ Azure Storage ││ Cache │ │ Database │ │ (Blobs) ││ (Sessions) │ │ (User Data) │ │ (Images) │└─────────────┘ └─────────────┘ └───────────────┘

```
### Infrastructure Components (Terraform-managed)| Resource | Purpose | Specs ||----------|---------|-------|| **AKS Cluster** | Container orchestration | 1-3 nodes, auto-scaling, Standard_DC2s_v3 VMs || **Azure Container Registry** | Docker image storage | Standard tier, admin enabled || **PostgreSQL Flexible Server** | Database | Version 13, B_Standard_B1ms tier || **Redis Cache** | Session & caching | Basic C0 (250MB) || **Storage Account** | Static files & images | Standard LRS || **Key Vault** | Secrets management | Standard tier || **Virtual Network** | Network isolation | 10.0.0.0/16 CIDR |### Kubernetes Resources| Resource Type | Name | Purpose ||--------------|------|---------|| **Namespace** | `ecommerce` | Logical isolation || **Deployment** | `ecommerce-app` | Manages 3 pod replicas || **Service** | `ecommerce-service` | Internal load balancer (ClusterIP) || **Ingress** | `ecommerce-ingress` | External access with NGINX || **ConfigMap** | `ecommerce-config` | Non-sensitive configuration || **Secret** | `ecommerce-secrets` | Database credentials, API keys || **HPA** | `ecommerce-hpa` | Auto-scale 1-10 pods based on CPU || **PVC** | `redis-data` | Persistent storage for Redis |### Network Flow1. **User Request** → `http://172.185.141.111`2. **Azure Load Balancer** → Routes to NGINX Ingress Controller3. **NGINX Ingress** → Routes to `ecommerce-service`4. **Service** → Load balances across 3 pod replicas5. **Pod** → Serves the Next.js application6. **App** → Connects to PostgreSQL, Redis, Azure Storage## 🛠️ Tech Stack## 📦 Project Structure
```

next-ecommerce/├── .github/│ └── workflows/ # CI/CD pipelines├── docs/ # Documentation├── k8s/ # Kubernetes manifests├── terraform/ # Infrastructure as Code├── src/│ ├── components/ # React components│ ├── pages/ # Next.js pages│ ├── store/ # Redux store│ └── utils/ # Utility functions├── public/ # Static assets├── Dockerfile # Multi-stage Docker build├── docker-compose.yml # Local development└── DEPLOYMENT.md # Deployment guide

```
## 🤝 ContributingThis is an educational project, but contributions are welcome!1. Fork the repository2. Create your feature branch (`git checkout -b feature/ImprovementIdea`)3. Commit your changes (`git commit -m 'Add some improvement'`)4. Push to the branch (`git push origin feature/ImprovementIdea`)5. Open a Pull Request**Ideas for contributions:**- Add more comprehensive tests- Implement monitoring dashboards- Add more Terraform modules- Improve security hardening- Add multi-region deployment- Document advanced scenarios## 📝 LicenseThis project is open source and available under the [MIT License](LICENSE).## 🎯 Project GoalsThis project was created as a **comprehensive learning resource** for software engineering students to understand:1. **Modern application deployment** - From code to cloud2. **DevOps automation** - CI/CD pipelines that work3. **Cloud-native architecture** - Scalable and resilient systems4. **Infrastructure as Code** - Reproducible infrastructure5. **Container orchestration** - Kubernetes in practice6. **Security best practices** - Secrets, scanning, and RBAC## 🙏 Acknowledgments- **Original Next.js Application**: [lucaspulliese/next-ecommerce](https://github.com/lucaspulliese/next-ecommerce)- **UI Design**: [iceo](https://www.xdguru.com/free-xd-ecommerce-ui-kit-by-iceo/)- **DevOps Transformation**: Created for Software Engineering education at Smart Systems Master program- **Azure Documentation**: [Microsoft Learn](https://learn.microsoft.com/azure/)- **Kubernetes Community**: For excellent documentation and examples## 💡 Learning Tips### For Beginners1. Start with running the app locally using Docker Compose2. Study one Kubernetes manifest at a time3. Use `kubectl explain <resource>` to understand Kubernetes objects4. Read Terraform plan output carefully before applying### For Intermediate Students1. Modify the infrastructure (add a resource in Terraform)2. Customize the CI/CD pipeline (add a test stage)3. Implement health checks and readiness probes4. Experiment with different scaling strategies### For Advanced Students1. Implement blue-green or canary deployments2. Add service mesh (Istio/Linkerd)3. Set up centralized logging (ELK stack)4. Implement GitOps with ArgoCD or Flux5. Add chaos engineering tests
```