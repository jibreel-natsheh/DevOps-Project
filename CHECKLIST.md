# Deployment Checklist

Use this checklist to ensure you've completed all necessary steps for deployment.

## 📋 Pre-Deployment Checklist

### Local Development
- [ ] Cloned repository
- [ ] Node.js 18+ installed
- [ ] Dependencies installed (`npm install`)
- [ ] `.env.local` configured
- [ ] Application runs locally (`npm run dev`)
- [ ] Application builds successfully (`npm run build`)

### Docker
- [ ] Docker installed
- [ ] Docker Compose installed
- [ ] Dockerfile tested locally
- [ ] Docker Compose tested locally
- [ ] Images build without errors
- [ ] Containers run successfully

### Azure Prerequisites
- [ ] Azure subscription active
- [ ] Azure CLI installed
- [ ] Logged into Azure (`az login`)
- [ ] Subscription selected
- [ ] Resource quota checked
- [ ] Billing alerts configured

### Tools
- [ ] kubectl installed
- [ ] Terraform installed (1.6+)
- [ ] Git installed
- [ ] Text editor/IDE ready

## 🏗️ Infrastructure Deployment

### Terraform Setup
- [ ] Navigated to `terraform/` directory
- [ ] Copied `terraform.tfvars.example` to `terraform.tfvars`
- [ ] Configured all variables in `terraform.tfvars`:
  - [ ] `project_name`
  - [ ] `environment`
  - [ ] `location`
  - [ ] `postgres_admin_password` (strong password)
  - [ ] Node configuration
  - [ ] Tags
- [ ] Ran `terraform init`
- [ ] Ran `terraform validate`
- [ ] Ran `terraform fmt`

### Terraform Execution
- [ ] Ran `terraform plan`
- [ ] Reviewed plan output
- [ ] Confirmed resources to be created
- [ ] Ran `terraform apply`
- [ ] ⏱️ Waited 15-20 minutes for completion
- [ ] Verified all resources created
- [ ] Saved `terraform output` values
- [ ] Saved outputs to `outputs.json`

### Azure Resources Created
- [ ] Resource Group
- [ ] Virtual Network
- [ ] AKS Cluster
- [ ] Azure Container Registry (ACR)
- [ ] PostgreSQL Server
- [ ] Redis Cache
- [ ] Storage Account
- [ ] Key Vault
- [ ] NGINX Ingress Controller
- [ ] Cert-Manager
- [ ] Prometheus Stack

## ⚓ Kubernetes Deployment

### Cluster Access
- [ ] Got AKS credentials:
  ```bash
  az aks get-credentials \
    --resource-group <rg-name> \
    --name <cluster-name>
  ```
- [ ] Verified cluster connection (`kubectl cluster-info`)
- [ ] Listed nodes (`kubectl get nodes`)
- [ ] All nodes ready

### Namespace & Configuration
- [ ] Created namespace:
  ```bash
  kubectl apply -f k8s/namespace.yml
  ```
- [ ] Applied ConfigMap:
  ```bash
  kubectl apply -f k8s/configmap.yml
  ```
- [ ] Verified ConfigMap exists

### Secrets Creation
- [ ] Generated secure secrets (JWT, session, encryption)
- [ ] Created Docker registry secret (acr-secret)
- [ ] Created application secrets (ecommerce-secrets)
- [ ] Stored secrets in Azure Key Vault
- [ ] Verified all secrets exist
- [ ] Documented secret rotation schedule

### Application Deployment
- [ ] Applied PVC: `kubectl apply -f k8s/pvc.yml`
- [ ] Applied Services: `kubectl apply -f k8s/service.yml`
- [ ] Applied Deployments: `kubectl apply -f k8s/deployment.yml`
- [ ] Applied HPA: `kubectl apply -f k8s/hpa.yml`
- [ ] Applied Ingress: `kubectl apply -f k8s/ingress.yml`
- [ ] Or applied all: `kubectl apply -f k8s/`

### Verification
- [ ] Pods are running:
  ```bash
  kubectl get pods -n ecommerce
  ```
- [ ] All pods in `Running` state
- [ ] Services created:
  ```bash
  kubectl get services -n ecommerce
  ```
- [ ] Ingress configured:
  ```bash
  kubectl get ingress -n ecommerce
  ```
- [ ] Deployment rollout complete:
  ```bash
  kubectl rollout status deployment/ecommerce-app -n ecommerce
  ```

### Health Checks
- [ ] Pods are healthy (readiness probe passing)
- [ ] Pods are alive (liveness probe passing)
- [ ] Application logs show no errors:
  ```bash
  kubectl logs -l app=ecommerce -n ecommerce
  ```
- [ ] Health endpoint responding:
  ```bash
  kubectl port-forward service/ecommerce-service 3000:80 -n ecommerce
  curl http://localhost:3000/api/health
  ```

## 🔄 CI/CD Setup

### GitHub Repository
- [ ] Repository exists on GitHub
- [ ] Code pushed to repository
- [ ] GitHub Actions enabled

### Azure Service Principal
- [ ] Created service principal:
  ```bash
  az ad sp create-for-rbac --name github-actions-ecommerce \
    --role contributor --scopes /subscriptions/<id> --sdk-auth
  ```
- [ ] Saved credentials securely
- [ ] Assigned necessary roles

### GitHub Secrets Configuration
Navigate to: **Repository → Settings → Secrets → Actions**

#### Azure Secrets
- [ ] `AZURE_CREDENTIALS` (Service principal JSON)
- [ ] `ARM_CLIENT_ID`
- [ ] `ARM_CLIENT_SECRET`
- [ ] `ARM_SUBSCRIPTION_ID`
- [ ] `ARM_TENANT_ID`

#### ACR Secrets
- [ ] `ACR_LOGIN_SERVER`
- [ ] `ACR_USERNAME`
- [ ] `ACR_PASSWORD`

#### AKS Secrets
- [ ] `AKS_RESOURCE_GROUP`
- [ ] `AKS_CLUSTER_NAME`

#### Application Secrets
- [ ] `DATABASE_URL`
- [ ] `JWT_SECRET`
- [ ] `SESSION_SECRET`
- [ ] `ENCRYPTION_KEY`
- [ ] `STRIPE_SECRET_KEY`
- [ ] `STRIPE_PUBLIC_KEY`
- [ ] `STRIPE_WEBHOOK_SECRET`
- [ ] `SMTP_PASSWORD`
- [ ] `AZURE_STORAGE_KEY`
- [ ] `SENTRY_DSN`
- [ ] `APPLICATION_INSIGHTS_KEY`
- [ ] `NEXT_PUBLIC_API_URL`

#### Terraform Secrets
- [ ] `POSTGRES_ADMIN_PASSWORD`

### Workflow Files
- [ ] `.github/workflows/ci-cd.yml` exists
- [ ] `.github/workflows/terraform.yml` exists
- [ ] `.github/workflows/pr-checks.yml` exists
- [ ] All workflows validated (no syntax errors)

### Test CI/CD
- [ ] Created test branch
- [ ] Pushed changes
- [ ] PR checks workflow ran successfully
- [ ] Merged to main
- [ ] CI/CD pipeline triggered
- [ ] Build and test job passed
- [ ] Security scan completed
- [ ] Docker image built and pushed
- [ ] Deployment to AKS succeeded
- [ ] Post-deployment tests passed

## 🔐 Security Checklist

### Secrets Management
- [ ] No secrets in Git repository
- [ ] `.gitignore` includes secret files
- [ ] Secrets stored in Azure Key Vault
- [ ] Kubernetes secrets created properly
- [ ] GitHub secrets configured
- [ ] Secret rotation schedule documented

### Access Control
- [ ] RBAC configured for AKS
- [ ] Service principal has minimal permissions
- [ ] Key Vault access policies set
- [ ] Network security groups configured
- [ ] ACR access restricted

### Security Scanning
- [ ] Trivy scanning enabled in CI/CD
- [ ] npm audit running
- [ ] Container images scanned
- [ ] Vulnerabilities reviewed and addressed

### SSL/TLS
- [ ] Cert-manager installed
- [ ] Let's Encrypt configured
- [ ] Ingress configured for HTTPS
- [ ] SSL certificates issued
- [ ] HTTP to HTTPS redirect enabled

## 📊 Monitoring & Logging

### Prometheus & Grafana
- [ ] Prometheus installed and running
- [ ] Grafana installed and running
- [ ] Grafana admin password retrieved
- [ ] Dashboards configured
- [ ] Alerts configured

### Application Insights (Optional)
- [ ] Application Insights created
- [ ] Instrumentation key configured
- [ ] Application reporting metrics

### Logging
- [ ] Can view pod logs
- [ ] Logs aggregated (if using centralized logging)
- [ ] Log retention configured

## 🌐 DNS & Networking

### Domain Configuration
- [ ] Domain name acquired (if applicable)
- [ ] DNS A record created
- [ ] Pointed to ingress IP address
- [ ] DNS propagated (check with `nslookup`)
- [ ] SSL certificate issued for domain

### Network Testing
- [ ] Application accessible via public IP
- [ ] Application accessible via domain name
- [ ] HTTPS working
- [ ] API endpoints responding
- [ ] Health check endpoint accessible

## 🧪 Testing

### Smoke Tests
- [ ] Home page loads
- [ ] Products page loads
- [ ] Product detail page loads
- [ ] Cart functionality works
- [ ] API health check passes
- [ ] No console errors

### Performance Tests
- [ ] Load time acceptable
- [ ] API response time good
- [ ] No memory leaks
- [ ] No excessive CPU usage

### Integration Tests
- [ ] Database connection working
- [ ] Redis connection working
- [ ] Storage access working
- [ ] External APIs working

## 📖 Documentation

### Project Documentation
- [ ] README.md updated
- [ ] DEPLOYMENT.md complete
- [ ] QUICKSTART.md available
- [ ] CI/CD documentation complete
- [ ] Secrets management guide complete

### Operational Documentation
- [ ] Architecture diagrams created
- [ ] Runbook created
- [ ] Troubleshooting guide written
- [ ] Recovery procedures documented
- [ ] Contact information documented

## 🚀 Post-Deployment

### Verification
- [ ] Application accessible to users
- [ ] All features working
- [ ] Performance acceptable
- [ ] Monitoring showing healthy state
- [ ] No critical alerts

### Team Notification
- [ ] Team notified of deployment
- [ ] Access credentials shared securely
- [ ] Documentation links shared
- [ ] Support procedures communicated

### Backup & Recovery
- [ ] Backup strategy defined
- [ ] Database backups configured
- [ ] State files backed up
- [ ] Recovery tested

## 📝 Maintenance

### Regular Tasks
- [ ] Secret rotation schedule set
- [ ] Dependency update schedule set
- [ ] Security patch schedule set
- [ ] Backup verification schedule set
- [ ] Cost review schedule set

### Monitoring
- [ ] Alerts configured
- [ ] On-call rotation set (if applicable)
- [ ] Incident response plan ready
- [ ] Escalation procedures defined

## ✅ Final Sign-Off

- [ ] All checklist items completed
- [ ] Application tested by QA (if applicable)
- [ ] Stakeholders approved
- [ ] Deployment documented
- [ ] Lessons learned documented

---

## 📞 Support Contacts

**DevOps Team**: devops@yourcompany.com  
**On-Call**: +1-XXX-XXX-XXXX  
**Slack**: #devops-support  
**Documentation**: https://docs.yourcompany.com  

---

## 🎯 Next Steps

After completing this checklist:

1. Monitor application for 24-48 hours
2. Review metrics and logs
3. Optimize based on performance data
4. Document any issues and resolutions
5. Plan for future improvements

---

**Deployment Date**: __________  
**Deployed By**: __________  
**Verified By**: __________  
**Sign-Off**: __________  

---

**Remember**: This is a living document. Update it based on your experience and lessons learned.
