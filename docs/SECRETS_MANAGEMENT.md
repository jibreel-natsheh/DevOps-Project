# Secrets Management Guide

This document outlines how to manage secrets securely in the e-commerce application across different environments.

## 🔐 Overview

The application uses multiple layers of secrets management:

1. **Local Development**: `.env.local` files (git-ignored)
2. **Docker**: Environment variables & Docker secrets
3. **Kubernetes**: Kubernetes Secrets
4. **Azure**: Azure Key Vault
5. **CI/CD**: GitHub Secrets

## 📋 Secret Types

### Application Secrets

| Secret Name | Purpose | Format | Rotation |
|------------|---------|--------|----------|
| `DATABASE_URL` | PostgreSQL connection | `postgresql://user:pass@host:5432/db` | Quarterly |
| `JWT_SECRET` | JWT token signing | 64+ character string | Annually |
| `SESSION_SECRET` | Session encryption | 64+ character string | Annually |
| `ENCRYPTION_KEY` | Data encryption | 32 character string | Annually |
| `STRIPE_SECRET_KEY` | Payment processing | `sk_live_...` | As needed |
| `STRIPE_WEBHOOK_SECRET` | Stripe webhooks | `whsec_...` | As needed |
| `SMTP_PASSWORD` | Email service | Password/API key | As needed |
| `AZURE_STORAGE_KEY` | Blob storage access | Azure key | Quarterly |

### Infrastructure Secrets

| Secret Name | Purpose | Format | Rotation |
|------------|---------|--------|----------|
| `ARM_CLIENT_SECRET` | Terraform Azure auth | UUID | Annually |
| `ACR_PASSWORD` | Container registry | Password | Quarterly |
| `POSTGRES_ADMIN_PASSWORD` | Database admin | Strong password | Quarterly |
| `REDIS_PASSWORD` | Redis authentication | Password | Quarterly |

## 🏠 Local Development

### Step 1: Copy Example Files

```bash
cp .env.example .env.local
cp .env.local.example .env.local
```

### Step 2: Generate Secure Secrets

```bash
# Generate JWT secret (64 characters)
openssl rand -hex 32

# Generate session secret (64 characters)
openssl rand -hex 32

# Generate encryption key (32 characters)
openssl rand -hex 16
```

### Step 3: Configure .env.local

```env
# Authentication
JWT_SECRET=your-generated-jwt-secret-here
SESSION_SECRET=your-generated-session-secret-here
ENCRYPTION_KEY=your-32-character-encryption-key

# Database (local)
DATABASE_URL=postgresql://localhost:5432/ecommerce_dev

# Redis (local)
REDIS_URL=redis://localhost:6379

# Development keys (use test keys)
STRIPE_SECRET_KEY=sk_test_your_test_key
STRIPE_PUBLIC_KEY=pk_test_your_test_key
```

### Step 4: Never Commit Secrets

Ensure `.gitignore` includes:
```
.env
.env.local
.env.*.local
secrets/
*.pem
*.key
```

## 🐳 Docker Secrets

### Using Docker Compose with .env file

```bash
# Create .env file for Docker Compose
cp .env.example .env

# Edit with production-like values
nano .env
```

### Using Docker Secrets (Swarm mode)

```bash
# Create secrets
echo "my-db-password" | docker secret create db_password -
echo "my-jwt-secret" | docker secret create jwt_secret -

# Reference in docker-compose.yml
services:
  app:
    secrets:
      - db_password
      - jwt_secret
    environment:
      DATABASE_PASSWORD_FILE: /run/secrets/db_password

secrets:
  db_password:
    external: true
  jwt_secret:
    external: true
```

## ☁️ Azure Key Vault

### Step 1: Create Key Vault

```bash
# Key Vault is created by Terraform
# Or create manually:
az keyvault create \
  --name ecommerce-prod-kv \
  --resource-group ecommerce-prod-rg \
  --location eastus
```

### Step 2: Store Secrets

```bash
# Store database connection string
az keyvault secret set \
  --vault-name ecommerce-prod-kv \
  --name database-url \
  --value "postgresql://user:pass@host:5432/db"

# Store JWT secret
az keyvault secret set \
  --vault-name ecommerce-prod-kv \
  --name jwt-secret \
  --value "your-jwt-secret"

# Store Stripe key
az keyvault secret set \
  --vault-name ecommerce-prod-kv \
  --name stripe-secret-key \
  --value "sk_live_your_key"
```

### Step 3: Retrieve Secrets

```bash
# Get secret value
az keyvault secret show \
  --vault-name ecommerce-prod-kv \
  --name jwt-secret \
  --query value -o tsv

# List all secrets
az keyvault secret list \
  --vault-name ecommerce-prod-kv
```

### Step 4: Grant Access

```bash
# Grant access to service principal
az keyvault set-policy \
  --name ecommerce-prod-kv \
  --spn YOUR_SERVICE_PRINCIPAL_ID \
  --secret-permissions get list

# Grant access to user
az keyvault set-policy \
  --name ecommerce-prod-kv \
  --upn user@domain.com \
  --secret-permissions get list set delete
```

## ⚓ Kubernetes Secrets

### Step 1: Create from Literals

```bash
kubectl create secret generic ecommerce-secrets \
  --from-literal=DATABASE_URL='postgresql://user:pass@host:5432/db' \
  --from-literal=JWT_SECRET='your-jwt-secret' \
  --from-literal=SESSION_SECRET='your-session-secret' \
  --from-literal=ENCRYPTION_KEY='your-encryption-key' \
  --from-literal=STRIPE_SECRET_KEY='sk_live_your_key' \
  --from-literal=STRIPE_WEBHOOK_SECRET='whsec_your_secret' \
  --namespace=ecommerce
```

### Step 2: Create from Files

```bash
# Create secret files (don't commit!)
echo -n 'postgresql://...' > db-url.txt
echo -n 'your-jwt-secret' > jwt-secret.txt

# Create secret from files
kubectl create secret generic ecommerce-secrets \
  --from-file=DATABASE_URL=db-url.txt \
  --from-file=JWT_SECRET=jwt-secret.txt \
  --namespace=ecommerce

# Clean up files
rm db-url.txt jwt-secret.txt
```

### Step 3: Create from Azure Key Vault

Install Azure Key Vault CSI Driver:

```bash
# Add Helm repo
helm repo add csi-secrets-store-provider-azure \
  https://azure.github.io/secrets-store-csi-driver-provider-azure/charts

# Install driver
helm install csi-secrets-store-provider-azure/csi-secrets-store-provider-azure \
  --generate-name \
  --namespace kube-system
```

Create SecretProviderClass:

```yaml
apiVersion: secrets-store.csi.x-k8s.io/v1
kind: SecretProviderClass
metadata:
  name: azure-keyvault
  namespace: ecommerce
spec:
  provider: azure
  parameters:
    usePodIdentity: "false"
    useVMManagedIdentity: "true"
    userAssignedIdentityID: "YOUR_IDENTITY_ID"
    keyvaultName: "ecommerce-prod-kv"
    objects: |
      array:
        - |
          objectName: database-url
          objectType: secret
          objectVersion: ""
        - |
          objectName: jwt-secret
          objectType: secret
          objectVersion: ""
    tenantId: "YOUR_TENANT_ID"
```

### Step 4: Update Secrets

```bash
# Delete and recreate
kubectl delete secret ecommerce-secrets -n ecommerce
kubectl create secret generic ecommerce-secrets \
  --from-literal=DATABASE_URL='new-value' \
  --namespace=ecommerce

# Or patch existing
kubectl create secret generic ecommerce-secrets \
  --from-literal=JWT_SECRET='new-secret' \
  --namespace=ecommerce \
  --dry-run=client -o yaml | kubectl apply -f -

# Restart pods to pick up new secrets
kubectl rollout restart deployment/ecommerce-app -n ecommerce
```

### Step 5: View Secrets (Debugging)

```bash
# Get secret (base64 encoded)
kubectl get secret ecommerce-secrets -n ecommerce -o yaml

# Decode specific key
kubectl get secret ecommerce-secrets -n ecommerce \
  -o jsonpath='{.data.JWT_SECRET}' | base64 --decode
```

## 🔄 GitHub Secrets

### Step 1: Access Secrets Settings

1. Go to your GitHub repository
2. Click **Settings**
3. Navigate to **Secrets and variables** → **Actions**
4. Click **New repository secret**

### Step 2: Add Secrets

#### Azure Authentication

```bash
# Create service principal and get credentials
az ad sp create-for-rbac \
  --name "github-actions-ecommerce" \
  --role contributor \
  --scopes /subscriptions/YOUR_SUBSCRIPTION_ID \
  --sdk-auth

# Output is your AZURE_CREDENTIALS secret (entire JSON)
```

Add these secrets:
- `AZURE_CREDENTIALS`: Full JSON output from above
- `ARM_CLIENT_ID`: From service principal
- `ARM_CLIENT_SECRET`: From service principal
- `ARM_SUBSCRIPTION_ID`: Your subscription ID
- `ARM_TENANT_ID`: Your tenant ID

#### Azure Container Registry

```bash
# Get ACR credentials
az acr credential show --name YOUR_ACR_NAME

# Add these secrets:
ACR_LOGIN_SERVER=yourregistry.azurecr.io
ACR_USERNAME=username-from-above
ACR_PASSWORD=password-from-above
```

#### Application Secrets

Add the same secrets you use in Kubernetes:
- `DATABASE_URL`
- `JWT_SECRET`
- `SESSION_SECRET`
- `STRIPE_SECRET_KEY`
- etc.

### Step 3: Use Secrets in Workflows

```yaml
- name: Deploy
  env:
    DATABASE_URL: ${{ secrets.DATABASE_URL }}
    JWT_SECRET: ${{ secrets.JWT_SECRET }}
  run: |
    kubectl create secret generic ecommerce-secrets \
      --from-literal=DATABASE_URL="${{ secrets.DATABASE_URL }}" \
      --namespace=ecommerce
```

## 🔒 Best Practices

### 1. Secret Rotation

```bash
# Set reminder for rotation
# Rotate secrets quarterly or after security incidents

# Update in all places:
# 1. Generate new secret
NEW_SECRET=$(openssl rand -hex 32)

# 2. Update in Key Vault
az keyvault secret set \
  --vault-name ecommerce-prod-kv \
  --name jwt-secret \
  --value "$NEW_SECRET"

# 3. Update in Kubernetes
kubectl create secret generic ecommerce-secrets \
  --from-literal=JWT_SECRET="$NEW_SECRET" \
  --namespace=ecommerce \
  --dry-run=client -o yaml | kubectl apply -f -

# 4. Restart application
kubectl rollout restart deployment/ecommerce-app -n ecommerce

# 5. Update GitHub Secrets manually
```

### 2. Principle of Least Privilege

```bash
# Grant minimal permissions
az keyvault set-policy \
  --name ecommerce-prod-kv \
  --spn SERVICE_PRINCIPAL_ID \
  --secret-permissions get list  # NOT set, delete
```

### 3. Audit Access

```bash
# Enable Key Vault logging
az monitor diagnostic-settings create \
  --name KeyVaultAudit \
  --resource /subscriptions/.../vaults/ecommerce-prod-kv \
  --logs '[{"category": "AuditEvent","enabled": true}]'

# View Kubernetes secret access
kubectl get events --namespace=ecommerce | grep secret
```

### 4. Separate Environments

```
environments/
├── dev/
│   └── secrets.yml.enc      # Encrypted secrets for dev
├── staging/
│   └── secrets.yml.enc      # Encrypted secrets for staging
└── prod/
    └── secrets.yml.enc      # Encrypted secrets for prod
```

### 5. Never Commit Secrets

```bash
# Use git-secrets to prevent commits
git clone https://github.com/awslabs/git-secrets
cd git-secrets
make install

# Add patterns
git secrets --add 'sk_live_[A-Za-z0-9]+'
git secrets --add 'password\s*=\s*.+'

# Scan repository
git secrets --scan
```

### 6. Use Sealed Secrets (Optional)

```bash
# Install Sealed Secrets controller
kubectl apply -f https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.24.0/controller.yaml

# Install kubeseal CLI
brew install kubeseal

# Create sealed secret
kubectl create secret generic mysecret \
  --from-literal=password=secret \
  --dry-run=client -o yaml | \
  kubeseal -o yaml > mysealedsecret.yaml

# Commit sealed secret (safe!)
git add mysealedsecret.yaml
```

## 🚨 Security Incidents

### If Secrets Are Compromised

1. **Immediately rotate affected secrets**
   ```bash
   # Generate new secrets
   # Update in all locations
   # Restart affected services
   ```

2. **Audit access logs**
   ```bash
   # Check Key Vault access
   az monitor activity-log list \
     --resource-group ecommerce-prod-rg \
     --start-time 2024-01-01
   ```

3. **Revoke compromised credentials**
   ```bash
   # Delete service principal
   az ad sp delete --id APP_ID
   
   # Revoke tokens
   # Update API keys
   ```

4. **Notify stakeholders**
   - Security team
   - DevOps team
   - Management

## 📚 Additional Resources

- [Azure Key Vault Documentation](https://docs.microsoft.com/azure/key-vault/)
- [Kubernetes Secrets](https://kubernetes.io/docs/concepts/configuration/secret/)
- [GitHub Encrypted Secrets](https://docs.github.com/actions/security-guides/encrypted-secrets)
- [OWASP Secrets Management](https://cheatsheetseries.owasp.org/cheatsheets/Secrets_Management_Cheat_Sheet.html)

---

**Remember: The best secret is one that never needs to exist. Use managed identities and service principals whenever possible.**
