# Terraform + GCP 

This repository contains a minimal **Terraform configuration** that creates:
- A custom VPC network (`my-vpc`)
- A single Debian-based VM (`terraform-vm`) with an external IP address



---

## 🚀 Prerequisites

Before you run this project, you need:

- **Google Cloud SDK (gcloud)** → [Install Guide](https://cloud.google.com/sdk/docs/install)
- **Terraform CLI** → [Install Guide](https://developer.hashicorp.com/terraform/install)

---

## 🔑 Setup & Authentication

1. **Login to GCP & select project**

```bash
gcloud auth login

gcloud config set project gothic-sled-472317-e1

gcloud iam service-accounts create terraform --display-name "Terraform Service Account"

gcloud projects add-iam-policy-binding gothic-sled-472317-e1 \
  --member="serviceAccount:terraform@gothic-sled-472317-e1.iam.gserviceaccount.com" \
  --role="roles/editor"

gcloud iam service-accounts keys create ~/terraform-key.json \
  --iam-account=terraform@gothic-sled-472317-e1.iam.gserviceaccount.com
```

Set credentials environment variable
```bash 
export GOOGLE_APPLICATION_CREDENTIALS=~/terraform-key.json
```

## ▶️ Deploy Infrastructure

Initialize Terraform, plan, and apply:

```bash
terraform init
terraform plan
terraform apply
```

📚 Notes

- machine_type is e2-micro (free-tier eligible).

- Change zone, machine_type, or image in main.tf to customize your VM.

- Always run terraform plan before apply to preview changes.


---
