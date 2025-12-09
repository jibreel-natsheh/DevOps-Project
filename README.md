# Next.js E-commerce - DevOps Demo Project

[![CI/CD Pipeline](https://github.com/lucaspulliese/next-ecommerce/workflows/CI/CD%20Pipeline/badge.svg)](https://github.com/lucaspulliese/next-ecommerce/actions)
[![Terraform](https://github.com/lucaspulliese/next-ecommerce/workflows/Terraform%20Infrastructure/badge.svg)](https://github.com/lucaspulliese/next-ecommerce/actions)

A production-ready Next.js e-commerce application demonstrating modern DevOps practices including **CI/CD**, **Docker**, **Kubernetes (AKS)**, **Terraform**, and **Azure cloud infrastructure**.

## 🚀 What's New - DevOps Features

This repository has been transformed into a **complete DevOps demonstration project** featuring:

- ✅ **Docker & Docker Compose** - Multi-stage builds with production optimization
- ✅ **GitHub Actions CI/CD** - Automated build, test, and deployment pipelines
- ✅ **Terraform (IaC)** - Complete Azure infrastructure provisioning
- ✅ **Azure Kubernetes Service (AKS)** - Production-grade container orchestration
- ✅ **Azure Container Registry** - Private Docker image repository
- ✅ **Secrets Management** - Azure Key Vault & Kubernetes Secrets
- ✅ **Monitoring** - Prometheus, Grafana, and Application Insights
- ✅ **Auto-scaling** - Horizontal Pod Autoscaler (HPA)
- ✅ **SSL/TLS** - Automatic certificate management with cert-manager
- ✅ **Security Scanning** - Trivy vulnerability scanning in CI/CD

## 📋 Table of Contents

- [Features](#features)
- [Quick Start](#quick-start)
- [Documentation](#documentation)
- [Architecture](#architecture)
- [Screenshots](#screenshots)
- [Available Pages](#available-pages)
- [Contributing](#contributing)

## ✨ Features

### Application Features
- **Next.js 15** with TypeScript
- **Redux** for state management with persistence
- **Responsive design** with SCSS and BEM methodology
- **Product catalog** with filtering and search
- **Shopping cart** functionality
- **User authentication** (login/register)
- **Product reviews** and ratings
- **Checkout process**

### DevOps Features
- **Containerization**: Docker multi-stage builds
- **Orchestration**: Kubernetes manifests for AKS
- **Infrastructure as Code**: Terraform for Azure resources
- **CI/CD**: GitHub Actions workflows
- **Security**: Secrets management, vulnerability scanning
- **Monitoring**: Application and infrastructure observability
- **Scalability**: Auto-scaling with HPA and AKS node pools

## 🏃 Quick Start

### Local Development

```bash
# Clone the repository
git clone https://github.com/lucaspulliese/next-ecommerce.git
cd next-ecommerce

# Install dependencies
npm install

# Copy environment variables
cp .env.example .env.local

# Run development server
npm run dev
```

Visit `http://localhost:3000` 🎉

### Docker Compose

```bash
# Build and run with Docker Compose
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

### Production Deployment

See [DEPLOYMENT.md](./DEPLOYMENT.md) for complete deployment instructions.

## 📚 Documentation

- **[Deployment Guide](./DEPLOYMENT.md)** - Complete guide for deploying to Azure AKS
- **[CI/CD Documentation](./docs/CI_CD.md)** - GitHub Actions pipeline details
- **[Secrets Management](./docs/SECRETS_MANAGEMENT.md)** - Security and secrets best practices

## 🏗️ Architecture

### Application Architecture

```
┌─────────────────────────────────────────────┐
│              Load Balancer / Ingress        │
└────────────────┬────────────────────────────┘
                 │
        ┌────────┴────────┐
        │                 │
┌───────▼──────┐  ┌──────▼───────┐
│  Next.js App │  │  Next.js App │  (Replicas)
│   (Pods)     │  │   (Pods)     │
└───────┬──────┘  └──────┬───────┘
        │                │
        └────────┬────────┘
                 │
    ┌────────────┼────────────┐
    │            │            │
┌───▼───┐  ┌────▼────┐  ┌───▼──────┐
│ Redis │  │ PostgreSQL│  │  Azure   │
│ Cache │  │ Database │  │  Storage │
└───────┘  └─────────┘  └──────────┘
```

### Infrastructure Components

#### Azure Resources (Terraform-managed)
- **AKS Cluster** - 3-10 node auto-scaling Kubernetes cluster
- **Azure Container Registry** - Private Docker registry
- **PostgreSQL Server** - Managed database
- **Redis Cache** - Session and data caching
- **Storage Account** - Blob storage for static assets
- **Key Vault** - Secrets management
- **Virtual Network** - Network isolation

#### Kubernetes Resources
- **Deployments** - Application and Redis
- **Services** - ClusterIP and LoadBalancer
- **Ingress** - NGINX-based routing with SSL
- **ConfigMaps** - Non-sensitive configuration
- **Secrets** - Sensitive data (encrypted)
- **HPA** - Horizontal Pod Autoscaler
- **PVC** - Persistent storage for Redis

## 🎨 Screenshots

![Next Ecommerce screenshot](https://lucaspulliese.com/wp-content/uploads/2020/09/ecommerce-1.jpg)

![Next Ecommerce screenshot](https://lucaspulliese.com/wp-content/uploads/2020/09/ecommerce-2.jpg)

## 📄 Available Pages

- **Home page**: `/`
- **Products page**: `/products`
- **Product single page**: `/product/1`
- **Cart page**: `/cart`
- **Checkout page**: `/cart/checkout`
- **Login page**: `/login`
- **Register page**: `/register`
- **404 page**: `/page-not-found`

## 🛠️ Tech Stack

### Frontend
- Next.js 15
- React 18
- TypeScript
- Redux Toolkit
- SCSS/SASS
- SWR for data fetching

### DevOps
- Docker & Docker Compose
- Kubernetes
- Terraform
- GitHub Actions
- Azure Cloud Platform

### Infrastructure
- Azure Kubernetes Service (AKS)
- Azure Container Registry (ACR)
- Azure PostgreSQL
- Azure Redis Cache
- Azure Key Vault
- Azure Storage Account

## 📦 Project Structure

```
next-ecommerce/
├── .github/
│   └── workflows/          # CI/CD pipelines
├── docs/                   # Documentation
├── k8s/                    # Kubernetes manifests
├── terraform/              # Infrastructure as Code
├── src/
│   ├── components/         # React components
│   ├── pages/              # Next.js pages
│   ├── store/              # Redux store
│   └── utils/              # Utility functions
├── public/                 # Static assets
├── Dockerfile              # Multi-stage Docker build
├── docker-compose.yml      # Local development
└── DEPLOYMENT.md           # Deployment guide
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is open source and available under the [MIT License](LICENSE).

## 🙏 Acknowledgments

- Original design by [iceo](https://www.xdguru.com/free-xd-ecommerce-ui-kit-by-iceo/)
- DevOps transformation for educational purposes
- Thanks to all contributors and stargazers! ⭐

## 📧 Support

- **Issues**: [GitHub Issues](https://github.com/lucaspulliese/next-ecommerce/issues)
- **Discussions**: [GitHub Discussions](https://github.com/lucaspulliese/next-ecommerce/discussions)

---

**Made with ❤️ for learning DevOps practices**

If you found this project helpful, please consider giving it a star ⭐

