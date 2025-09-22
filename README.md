# Terraform Infrastructure Repository

### ❗Note on Current Setup

> **⚠️ Due to AWS Free Tier limitations**, ALB creation is restricted.  
> As a temporary workaround, the application is **exposed directly using the EC2 instance's public IP**.  
> This is not recommended for production but suitable for testing/demo purposes under AWS trial accounts.


This repository manages cloud infrastructure using **Terraform** with a CI/CD pipeline powered by **GitHub Actions**.  

## 📂 Repository Structure

## 📁 Project Structure

```text
.
├── modules/  # Reusable Terraform modules (e.g., EC2, VPC, ECR, etc.)
│   ├── ec2/
│   ├── vpc/
│   ├── ecr/
│   └── ...
└── env/     # Environment-specific configurations
    ├── non-prod/  # Non-production environment
    │   ├── main.tf
    │   ├── variables.tf
    │   └── terraform.tfvars
    └── prod/    # Production environment
        ├── main.tf
        ├── variables.tf
        └── terraform.tfvars
```

- **`modules/`** → All reusable infrastructure modules.  
- **`env/`** → Each environment (`non-prod`, `prod`) contains its own Terraform state & configuration.  

---

## CI/CD Workflow (GitHub Actions)

The pipeline is defined in `.github/workflows/terraform.yml`.  

### Trigger Rules
- **On Push (automatic):**  
  - Changes under `env/non-prod/**` → Deploys automatically to **non-prod**.  
- **On Workflow Dispatch (manual):**  
  - Developers can manually trigger the pipeline and choose between `non-prod` or `prod`.  

### Jobs
1. **Terraform Plan**
   - Runs `terraform init`, `validate`, and `plan`.  
   - Generates an execution plan (`tfplan`).  
   - Always runs automatically.      

2. **Terraform Apply**
   - Applies infrastructure changes (`terraform apply`).  
   - Behavior depends on the environment:
     - **non-prod:** Runs automatically after plan.  
     - **prod:** Requires **manual approval** in GitHub UI before apply.  

---

##  Github Environments

### 🔹 Non-Prod
- Default target for pushes.  
- Used for development & testing.  
- CI/CD auto-runs **plan + apply** on every push.  

### 🔹 Prod
- Used for production workloads.  
- CI/CD requires **manual trigger** (`workflow_dispatch`).  
- **Manual approval required** before `apply` step (via GitHub Environments protection rules).  

---

## Security & Approvals
- GitHub **Environments** (`non-prod`, `prod`) are used for access control.  
- **Prod Environment:**  
  - Protected with required reviewers.  
  - Apply job will **pause until approval** is given by authorized reviewers.  

---

## How to Use

### Deploying Non-Prod (Automatic)
1. Commit changes under `env/non-prod/`.  
2. Push to `main`.  
3. GitHub Actions will:
   - Run `terraform plan`  
   - Auto-run `terraform apply`  

### Deploying Prod (Manual & Secure)
1. Go to **Actions tab → Terraform workflow → Run workflow**.  
2. Select **prod** as the environment.  
3. Pipeline will:
   - Run `terraform plan`  
   - Wait for **manual approval**  
   - Apply changes once approved  


---

## CI/CD Flow Diagram

```mermaid
flowchart TD
    A[Push to main / Workflow Dispatch] --> B{Which Environment?}
    B -->|non-prod| C[Terraform Plan]
    C --> D[Terraform Apply Automatically]
    B -->|prod| E[Terraform Plan]
    E --> F[Manual Approval Required]
    F --> G[Terraform Apply After Approval]

    style A fill:#f9f,stroke:#333,stroke-width:2px
    style B fill:#bbf,stroke:#333,stroke-width:2px
    style C fill:#bfb,stroke:#333,stroke-width:2px
    style D fill:#0f0,stroke:#333,stroke-width:2px
    style E fill:#bfb,stroke:#333,stroke-width:2px
    style F fill:#ff0,stroke:#333,stroke-width:2px
    style G fill:#0f0,stroke:#333,stroke-width:2px
