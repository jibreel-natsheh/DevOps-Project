# CI/CD Pipeline Documentation

This document explains the CI/CD pipelines implemented in this project using GitHub Actions.

## 📋 Overview

The project uses three main GitHub Actions workflows:

1. **CI/CD Pipeline** - Main deployment pipeline
2. **Terraform Infrastructure** - Infrastructure provisioning
3. **PR Checks** - Pull request validation

## 🔄 Workflow Architecture

```
┌─────────────┐
│   Git Push  │
└──────┬──────┘
       │
       ├─────────────────┐
       │                 │
       ▼                 ▼
┌──────────────┐   ┌──────────────┐
│  PR Checks   │   │  CI/CD Main  │
└──────────────┘   └──────┬───────┘
                          │
                          ▼
                   ┌──────────────┐
                   │  Build & Test│
                   └──────┬───────┘
                          │
                          ▼
                   ┌──────────────┐
                   │Security Scan │
                   └──────┬───────┘
                          │
                          ▼
                   ┌──────────────┐
                   │Docker Build  │
                   └──────┬───────┘
                          │
                          ▼
                   ┌──────────────┐
                   │Deploy to AKS │
                   └──────┬───────┘
                          │
                          ▼
                   ┌──────────────┐
                   │Post-Deploy   │
                   │    Tests     │
                   └──────────────┘
```

## 🚀 CI/CD Pipeline (ci-cd.yml)

### Trigger Events

```yaml
on:
  push:
    branches: [ main, master, develop ]
  pull_request:
    branches: [ main, master, develop ]
```

### Jobs

#### 1. Build and Test

**Purpose**: Validate code builds successfully

```yaml
Steps:
1. Checkout code
2. Setup Node.js 18.x
3. Install dependencies (npm ci)
4. Run linter
5. Build application
6. Run tests
7. Upload build artifacts
```

**Environment Variables**:
- `NODE_VERSION`: 18.x
- `NODE_ENV`: production
- `NEXT_PUBLIC_API_URL`: From secrets

**Outputs**:
- Build artifacts (`.next/` directory)

#### 2. Security Scan

**Purpose**: Check for vulnerabilities

```yaml
Steps:
1. Checkout code
2. Run npm audit
3. Run Trivy filesystem scan
4. Upload results to GitHub Security
```

**Tools**:
- `npm audit`: Node.js dependency scanner
- `Trivy`: Comprehensive vulnerability scanner

**Security Thresholds**:
- `npm audit`: Moderate level
- Trivy: All vulnerabilities reported

#### 3. Docker Build and Push

**Purpose**: Build and publish Docker image

**Conditions**:
- Only on `push` events
- Only on `main` or `master` branch

```yaml
Steps:
1. Checkout code
2. Setup Docker Buildx
3. Login to Azure Container Registry
4. Extract Docker metadata
5. Build and push image
6. Scan image with Trivy
7. Upload scan results
```

**Image Tags Generated**:
- `latest` - Latest build from main/master
- `{branch}-{sha}` - Branch name + commit SHA
- `{semver}` - Semantic version if tagged

**Build Optimization**:
- Layer caching enabled
- Multi-stage build
- BuildKit features

#### 4. Deploy to AKS

**Purpose**: Deploy application to Kubernetes

**Environment**: `production`

```yaml
Steps:
1. Checkout code
2. Azure Login
3. Set AKS context
4. Create namespace
5. Create image pull secret
6. Create application secrets
7. Deploy to AKS
8. Wait for rollout
9. Verify deployment
```

**Required Secrets**:
- `AZURE_CREDENTIALS`
- `AKS_RESOURCE_GROUP`
- `AKS_CLUSTER_NAME`
- `ACR_LOGIN_SERVER`
- `DATABASE_URL`
- `JWT_SECRET`
- etc.

#### 5. Post-Deployment Tests

**Purpose**: Verify deployment health

```yaml
Steps:
1. Checkout code
2. Wait for application startup
3. Run health check
4. Run smoke tests
```

**Tests Include**:
- Health endpoint check
- Basic API functionality
- Critical user paths

### Deployment Strategy

**Rolling Update**:
- Max surge: 1 pod
- Max unavailable: 1 pod
- Zero-downtime deployment

**Rollback**:
```bash
# Automatic rollback if health checks fail
kubectl rollout undo deployment/ecommerce-app -n ecommerce
```

## 🏗️ Terraform Pipeline (terraform.yml)

### Trigger Events

```yaml
on:
  push:
    branches: [ main, master ]
    paths: [ 'terraform/**' ]
  pull_request:
    branches: [ main, master ]
    paths: [ 'terraform/**' ]
  workflow_dispatch:  # Manual trigger
```

### Jobs

#### 1. Terraform Plan

**Purpose**: Validate and plan infrastructure changes

```yaml
Steps:
1. Checkout code
2. Setup Terraform
3. Azure Login
4. Terraform Format Check
5. Terraform Init
6. Terraform Validate
7. Terraform Plan
8. Upload plan artifact
```

**Outputs**:
- `tfplan` file for apply stage

#### 2. Terraform Apply

**Purpose**: Apply infrastructure changes

**Conditions**:
- Only on `push` to main/master
- Requires approval (production environment)

```yaml
Steps:
1. Checkout code
2. Setup Terraform
3. Azure Login
4. Terraform Init
5. Download plan
6. Terraform Apply
7. Export outputs
8. Upload outputs
```

**Safety Features**:
- Manual approval required
- Plan must be reviewed
- State locked during apply

#### 3. Update K8s Config

**Purpose**: Update Kubernetes with new infrastructure

```yaml
Steps:
1. Checkout code
2. Azure Login
3. Download Terraform outputs
4. Get AKS credentials
5. Update ConfigMaps and Secrets
```

### State Management

**Backend Configuration**:
```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "terraform-state-rg"
    storage_account_name = "tfstatestorage"
    container_name       = "tfstate"
    key                  = "ecommerce.terraform.tfstate"
  }
}
```

**State Locking**:
- Automatic via Azure Storage
- Prevents concurrent modifications
- Ensures consistency

## ✅ PR Checks Pipeline (pr-checks.yml)

### Trigger Events

```yaml
on:
  pull_request:
    branches: [ main, master, develop ]
```

### Jobs

#### 1. Code Quality

**Purpose**: Ensure code standards

```yaml
Steps:
1. Checkout code
2. Setup Node.js
3. Install dependencies
4. Run ESLint
5. Check TypeScript types
```

**Checks**:
- ESLint rules compliance
- TypeScript compilation
- Code formatting

#### 2. Build Test

**Purpose**: Verify build succeeds

```yaml
Steps:
1. Checkout code
2. Setup Node.js
3. Install dependencies
4. Build application
```

#### 3. Docker Build Test

**Purpose**: Ensure Dockerfile works

```yaml
Steps:
1. Checkout code
2. Setup Docker Buildx
3. Build image (no push)
```

**Benefits**:
- Catch Docker issues early
- No registry pollution
- Fast feedback

#### 4. Security Scan

**Purpose**: Early vulnerability detection

```yaml
Steps:
1. Checkout code
2. Run npm audit
3. Run Trivy scan
```

#### 5. Terraform Validation

**Purpose**: Validate IaC changes

**Conditions**:
- Only if terraform files changed

```yaml
Steps:
1. Check changed files
2. Setup Terraform
3. Format check
4. Init (no backend)
5. Validate
```

#### 6. PR Comment

**Purpose**: Provide feedback on PR

```yaml
Steps:
1. Gather all job results
2. Format results
3. Post/update comment on PR
```

**Comment Format**:
```markdown
#### CI/CD Status 🚀
- Code Quality: ✅ success
- Build Test: ✅ success
- Docker Build: ✅ success
- Security Scan: ⚠️ warning
- Terraform Check: ✅ success

*Pusher: @username, Action: pull_request*
```

## 🔐 Required Secrets

### Setup Instructions

1. Navigate to: `Repository → Settings → Secrets and variables → Actions`
2. Click **New repository secret**
3. Add each secret below

### Azure Secrets

```yaml
# Service Principal for Azure authentication
AZURE_CREDENTIALS: |
  {
    "clientId": "...",
    "clientSecret": "...",
    "subscriptionId": "...",
    "tenantId": "..."
  }

# Terraform Azure Provider
ARM_CLIENT_ID: "service-principal-client-id"
ARM_CLIENT_SECRET: "service-principal-client-secret"
ARM_SUBSCRIPTION_ID: "azure-subscription-id"
ARM_TENANT_ID: "azure-tenant-id"

# Azure Container Registry
ACR_LOGIN_SERVER: "yourregistry.azurecr.io"
ACR_USERNAME: "acr-username"
ACR_PASSWORD: "acr-password"

# Azure Kubernetes Service
AKS_RESOURCE_GROUP: "ecommerce-prod-rg"
AKS_CLUSTER_NAME: "ecommerce-prod-aks"
```

### Application Secrets

```yaml
# Database
DATABASE_URL: "postgresql://user:pass@host:5432/db"

# Authentication
JWT_SECRET: "your-jwt-secret-64-chars"
SESSION_SECRET: "your-session-secret-64-chars"
ENCRYPTION_KEY: "your-32-char-encryption-key"

# Payment
STRIPE_SECRET_KEY: "sk_live_your_stripe_key"
STRIPE_PUBLIC_KEY: "pk_live_your_stripe_key"
STRIPE_WEBHOOK_SECRET: "whsec_your_webhook_secret"

# Email
SMTP_PASSWORD: "your-smtp-password"

# Azure Storage
AZURE_STORAGE_KEY: "your-storage-account-key"

# Monitoring
SENTRY_DSN: "your-sentry-dsn"
APPLICATION_INSIGHTS_KEY: "your-app-insights-key"

# Application
NEXT_PUBLIC_API_URL: "https://ecommerce.yourdomain.com"

# Terraform
POSTGRES_ADMIN_PASSWORD: "your-postgres-admin-password"
```

### Creating Azure Service Principal

```bash
# Create service principal with contributor role
az ad sp create-for-rbac \
  --name "github-actions-ecommerce" \
  --role contributor \
  --scopes /subscriptions/YOUR_SUBSCRIPTION_ID \
  --sdk-auth

# Output (use as AZURE_CREDENTIALS):
{
  "clientId": "...",
  "clientSecret": "...",
  "subscriptionId": "...",
  "tenantId": "...",
  "activeDirectoryEndpointUrl": "...",
  "resourceManagerEndpointUrl": "...",
  "activeDirectoryGraphResourceId": "...",
  "sqlManagementEndpointUrl": "...",
  "galleryEndpointUrl": "...",
  "managementEndpointUrl": "..."
}
```

## 📊 Monitoring & Notifications

### GitHub Actions UI

View workflow runs:
1. Go to **Actions** tab
2. Select workflow
3. View run details

### Status Badges

Add to README.md:
```markdown
![CI/CD](https://github.com/username/repo/workflows/CI/CD%20Pipeline/badge.svg)
![Terraform](https://github.com/username/repo/workflows/Terraform%20Infrastructure/badge.svg)
```

### Notifications

**Slack Integration** (optional):
```yaml
- name: Notify Slack
  uses: 8398a7/action-slack@v3
  with:
    status: ${{ job.status }}
    text: 'Deployment completed'
    webhook_url: ${{ secrets.SLACK_WEBHOOK }}
  if: always()
```

## 🐛 Troubleshooting

### Common Issues

#### 1. Build Failures

**Symptom**: Build job fails

**Debug**:
```bash
# Run locally
npm ci
npm run build

# Check logs in Actions tab
# Look for specific error messages
```

**Solutions**:
- Update dependencies
- Fix TypeScript errors
- Check environment variables

#### 2. Docker Push Fails

**Symptom**: Cannot push to ACR

**Debug**:
```bash
# Test ACR login locally
az acr login --name YOUR_ACR_NAME

# Check ACR credentials
az acr credential show --name YOUR_ACR_NAME
```

**Solutions**:
- Verify ACR secrets are correct
- Check ACR exists and is accessible
- Ensure service principal has AcrPush role

#### 3. Kubernetes Deployment Fails

**Symptom**: Pods not starting

**Debug**:
```bash
# Check deployment
kubectl get deployment ecommerce-app -n ecommerce

# Check pods
kubectl get pods -n ecommerce

# View logs
kubectl logs -l app=ecommerce -n ecommerce

# Describe pod
kubectl describe pod POD_NAME -n ecommerce
```

**Solutions**:
- Verify secrets exist
- Check image pull secret
- Review resource limits
- Check application logs

#### 4. Terraform Apply Fails

**Symptom**: Infrastructure changes fail

**Debug**:
```bash
# Run terraform plan locally
cd terraform
terraform init
terraform plan

# Check Azure quotas
az vm list-usage --location eastus
```

**Solutions**:
- Review plan before apply
- Check Azure resource limits
- Verify service principal permissions
- Review Terraform state

### Manual Interventions

#### Skip CI for commits

```bash
# Add [skip ci] to commit message
git commit -m "Update docs [skip ci]"
```

#### Retry failed workflow

1. Go to Actions tab
2. Select failed workflow
3. Click **Re-run jobs**

#### Cancel running workflow

1. Go to Actions tab
2. Select running workflow
3. Click **Cancel workflow**

#### Manual deployment

```bash
# Trigger manual deployment
gh workflow run ci-cd.yml

# Or using GitHub UI:
# Actions → CI/CD Pipeline → Run workflow
```

## 📈 Optimization Tips

### 1. Faster Builds

```yaml
# Use cache
- uses: actions/cache@v3
  with:
    path: ~/.npm
    key: ${{ runner.os }}-node-${{ hashFiles('**/package-lock.json') }}

# Use npm ci instead of npm install
- run: npm ci
```

### 2. Parallel Jobs

```yaml
jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        node-version: [16, 18, 20]
```

### 3. Conditional Steps

```yaml
- name: Deploy
  if: github.ref == 'refs/heads/main'
  run: deploy.sh
```

### 4. Reusable Workflows

Create `.github/workflows/reusable-build.yml`:
```yaml
on:
  workflow_call:
    inputs:
      environment:
        required: true
        type: string
```

Use in other workflows:
```yaml
jobs:
  build:
    uses: ./.github/workflows/reusable-build.yml
    with:
      environment: production
```

## 📚 Resources

- [GitHub Actions Documentation](https://docs.github.com/actions)
- [Azure DevOps Documentation](https://docs.microsoft.com/azure/devops)
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)
- [Kubernetes CI/CD](https://kubernetes.io/docs/tasks/manage-kubernetes-objects/)

---

**Questions?** Open an issue or contact the DevOps team.
