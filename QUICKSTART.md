# Quick Start Guide

This guide will help you get started with the project in 5 minutes.

## 🚀 For Developers (Local Development)

### 1. Prerequisites
- Node.js 18+ installed
- npm or yarn

### 2. Setup

```bash
# Clone the repository
git clone https://github.com/lucaspulliese/next-ecommerce.git
cd next-ecommerce

# Install dependencies
npm install

# Copy environment file
cp .env.example .env.local

# Start development server
npm run dev
```

### 3. Access
Open [http://localhost:3000](http://localhost:3000) in your browser.

That's it! You're ready to develop. 🎉

---

## 🐳 For Docker Users

### 1. Prerequisites
- Docker installed
- Docker Compose installed

### 2. Setup

```bash
# Clone the repository
git clone https://github.com/lucaspulliese/next-ecommerce.git
cd next-ecommerce

# Start with Docker Compose
docker-compose up -d
```

### 3. Access
- Application: [http://localhost:3000](http://localhost:3000)
- Redis: `localhost:6379`

### 4. Stop

```bash
docker-compose down
```

---

## ☁️ For DevOps Engineers (Azure Deployment)

### 1. Prerequisites
- Azure subscription
- Azure CLI installed and logged in
- kubectl installed
- Terraform installed
- GitHub account

### 2. Infrastructure Setup

```bash
# Clone the repository
git clone https://github.com/lucaspulliese/next-ecommerce.git
cd next-ecommerce/terraform

# Login to Azure
az login

# Copy and edit variables
cp terraform.tfvars.example terraform.tfvars
nano terraform.tfvars  # Edit with your values

# Initialize Terraform
terraform init

# Plan and apply
terraform plan -out=tfplan
terraform apply tfplan
```

**⏱️ This takes ~15-20 minutes**

### 3. Deploy Application

```bash
# Get AKS credentials
az aks get-credentials \
  --resource-group $(terraform output -raw resource_group_name) \
  --name $(terraform output -raw aks_cluster_name)

# Create namespace
kubectl apply -f ../k8s/namespace.yml

# Create secrets (replace with actual values)
kubectl create secret generic ecommerce-secrets \
  --from-literal=DATABASE_URL='your-db-url' \
  --from-literal=JWT_SECRET='your-jwt-secret' \
  --namespace=ecommerce

# Deploy application
kubectl apply -f ../k8s/
```

### 4. Setup CI/CD

1. Fork the repository on GitHub
2. Add secrets to GitHub (see [docs/CI_CD.md](./docs/CI_CD.md))
3. Push to main branch - automatic deployment!

### 5. Access

```bash
# Get ingress IP
kubectl get ingress -n ecommerce

# Or port-forward for testing
kubectl port-forward service/ecommerce-service 3000:80 -n ecommerce
```

---

## 🎓 For Students

### Learning Path

1. **Week 1**: Local development
   - Clone and run locally
   - Explore the codebase
   - Make small changes

2. **Week 2**: Docker
   - Build Docker image
   - Run with Docker Compose
   - Understand multi-stage builds

3. **Week 3**: Kubernetes
   - Learn about pods, deployments, services
   - Study the K8s manifests in `k8s/`
   - Deploy to local Kubernetes (minikube)

4. **Week 4**: Terraform
   - Study infrastructure code in `terraform/`
   - Learn about Azure resources
   - Practice with Terraform commands

5. **Week 5**: CI/CD
   - Understand GitHub Actions workflows
   - Study `.github/workflows/`
   - Set up your own pipeline

6. **Week 6**: Monitoring & Security
   - Learn about secrets management
   - Set up monitoring
   - Implement security best practices

### Resources

- [Docker Tutorial](https://docs.docker.com/get-started/)
- [Kubernetes Basics](https://kubernetes.io/docs/tutorials/kubernetes-basics/)
- [Terraform Learn](https://learn.hashicorp.com/terraform)
- [GitHub Actions Docs](https://docs.github.com/actions)
- [Azure Learn](https://docs.microsoft.com/learn/azure/)

---

## 🆘 Troubleshooting

### Application won't start locally

```bash
# Clear cache and reinstall
rm -rf node_modules package-lock.json .next
npm install
npm run dev
```

### Docker build fails

```bash
# Clear Docker cache
docker system prune -a

# Rebuild
docker-compose build --no-cache
docker-compose up
```

### Kubernetes pods not starting

```bash
# Check pod status
kubectl get pods -n ecommerce

# View logs
kubectl logs -l app=ecommerce -n ecommerce

# Describe pod for details
kubectl describe pod <pod-name> -n ecommerce
```

### Can't connect to Azure

```bash
# Re-login
az login
az account set --subscription "YOUR_SUBSCRIPTION_ID"

# Verify connection
az account show
```

---

## 📖 Next Steps

- Read the [DEPLOYMENT.md](./DEPLOYMENT.md) for detailed deployment instructions
- Check [docs/CI_CD.md](./docs/CI_CD.md) for CI/CD pipeline details
- Review [docs/SECRETS_MANAGEMENT.md](./docs/SECRETS_MANAGEMENT.md) for security

---

## 💡 Tips

### For Development
- Use `npm run dev` for hot reload
- Check `http://localhost:3000/api/health` for health status
- Redux DevTools available in browser

### For Docker
- Use `docker-compose logs -f app` to follow logs
- Volume mounts for development: add to docker-compose.yml
- Use `docker-compose exec app sh` to enter container

### For Kubernetes
- Use `kubectl get all -n ecommerce` to see all resources
- Use `kubectl port-forward` for local access
- Use `kubectl logs -f` to follow logs in real-time

### For Terraform
- Always run `terraform plan` before apply
- Use `terraform output` to get resource details
- Keep state file secure (use remote backend)

---

**Happy Learning! 🚀**

Questions? Open an issue on GitHub.
