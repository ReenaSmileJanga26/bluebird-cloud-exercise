# Bluebird Cloud Exercise (AWS + Terraform + ECS Fargate)

## Overview
Highly-available, multi-AZ web application using:
- VPC with public/private/db subnets across 2 AZs
- ALB + ECS Fargate service (private subnets)
- RDS (Multi-AZ) with managed password in Secrets Manager
- S3 bucket for static assets with encryption + lifecycle
- CI: app security checks, infra security checks + cost reports
- Ops: scheduled drift detection

## Prerequisites
- Terraform 1.14.3
- AWS CLI configured
- Permissions to create VPC, ECS, ALB, RDS, IAM, S3, CloudWatch, Secrets Manager

## Deploy (local)
```bash
cp infrastructure/terraform.tfvars.example infrastructure/terraform.tfvars
cd infrastructure
terraform init -upgrade
terraform apply
```

## Release (GitHub Actions)
- Configure secrets: AWS_ROLE_TO_ASSUME, INFRACOST_API_KEY
- Configure GitHub Environments: dev, prod (prod requires reviewers)
- Run workflow: Release with env dev/prod

## Validate
- /health should return HTTP 200
- CloudWatch alarms created for ALB 5xx, target unhealthy, RDS CPU

## Destroy
```bash
cd infrastructure
terraform destroy
```

## Estimated Monthly Cost Breakdown (AWS us-east-1, `dev`)

> **Purpose:** High-level estimate for this repository’s default “dev” footprint.  
> **Not a quote.** Prices vary by usage, discounts, free tier eligibility, taxes, and data transfer patterns.

### Inputs (from `terraform.tfvars`)
- Region: **us-east-1**
- ECS/Fargate:
  - `desired_count = 2` (baseline), `max_count = 4` (scale-out ceiling)
  - App port `3000`, health path `/health`
- Networking:
  - VPC across **2 AZs**
  - **NAT Gateway** enabled
  - `enable_vpc_endpoints = true` (Interface endpoints enabled)

### Assumptions (explicit)
These assumptions keep the estimate concrete and interview-defensible:

1. **Fargate task size**: `0.25 vCPU` + `0.5 GB` memory per task (typical “small dev” setting).
2. **Tasks run 24x7** at `desired_count = 2` (baseline).
3. **ALB usage** averages **~1 LCU** (low traffic).
4. **NAT data processed**: ~**20 GB/month** (reduced because VPC endpoints are enabled).
5. **VPC Interface Endpoints**: 4 endpoints (common set for ECS/ECR/Logs/Secrets):
   - `ecr.api`, `ecr.dkr`, `logs`, `secretsmanager`
   - Created in **2 AZs**
6. **RDS**: `db.t4g.micro`, **Multi-AZ**, 20 GB General Purpose SSD storage.
7. **Logs**: ~**5 GB/month** ingested into CloudWatch Logs; a few basic alarms.

If your actual Terraform differs (CPU/memory, endpoint count, NAT usage, DB size/class), adjust the “Qty/Usage” column and the totals will change.

---

### Monthly estimate (baseline: desired_count = 2)

| Component | Pricing Unit | Qty / Usage (assumed) | Est. Monthly |
|---|---:|---:|---:|
| **ECS on Fargate (compute)** | per vCPU-sec + GB-sec | 2 tasks x 0.25 vCPU + 0.5GB, 24x7 | **~$18.02** |
| **Application Load Balancer** | LB-hour + LCU-hour | 1 ALB, ~1 LCU avg | **~$22.27** |
| **NAT Gateway** | $/hour + $/GB processed | 1 NAT x 24x7 + 20 GB | **~$33.75** |
| **VPC Interface Endpoints** | $/AZ-hour + $/GB | 4 endpoints x 2 AZs (24x7) + small data | **~$58.80** |
| **RDS PostgreSQL (Multi-AZ)** | instance-hour | db.t4g.micro, Multi-AZ (~2x single-AZ) | **~$23.36** |
| **RDS storage** | $/GB-month | 20 GB | **~$2.30** |
| **S3 (static assets)** | $/GB-month | 10 GB | **~$0.23** |
| **ECR (image storage)** | $/GB-month | 5 GB | **~$0.50** |
| **CloudWatch Logs ingestion** | $/GB ingested | 5 GB/month | **~$2.50** |
| **CloudWatch alarms** | $/alarm-metric | ~4 standard alarms | **~$0.40** |
| **Secrets Manager** | $/secret-month | 1 secret | **~$0.40** |

**Estimated total (baseline dev): ~ $162/month**

---

### Scale-out sensitivity (if running at max capacity more often)
If the service runs closer to `max_count = 4` for long periods:

- **Fargate compute** roughly doubles: **~$36/month** instead of ~$18 (all else equal).
- ALB LCUs can increase with traffic; a jump from **1 → 2 LCUs** adds about **+$5.84/month** (0.008 * 730 hrs).

A realistic “busier dev” range: **~$175–$210/month** depending on scale-out duration and LCU usage.

---

## Biggest cost drivers (what interviewers usually expect you to call out)
1. **VPC Interface Endpoints (~$59/mo)**  
   Endpoints are great for security/compliance and can reduce NAT data, but they have a fixed hourly cost.
2. **NAT Gateway (~$33–$45+/mo depending on GB processed)**  
   NAT has a fixed hourly cost plus per-GB processing.

---

## Cost-optimization options (while keeping reliability)
These are common “startup budget” strategies:

1. **Dev environment:** consider disabling interface endpoints (`enable_vpc_endpoints=false`)  
   - Saves ~**$59/month** fixed cost.
   - Trade-off: more traffic may go through NAT (slightly higher variable cost), and you lose private access paths.
2. **Reduce NAT data processed** aggressively  
   - Keep endpoints only for the services that actually generate NAT traffic.
3. **Right-size the database for dev**  
   - If Multi-AZ is optional for dev only, Single-AZ can cut DB compute cost roughly in half (but reduces HA).
4. **Log volume management**  
   - Control log level; CloudWatch Logs ingestion is **per-GB**.

---

## Pricing references (verify in AWS Pricing Calculator for final numbers)
- Fargate (us-east-1 CPU/memory per-second rates): https://aws.amazon.com/fargate/pricing/
- ALB pricing (LB-hour and LCU-hour): https://aws.amazon.com/elasticloadbalancing/pricing/
- NAT Gateway pricing: https://aws.amazon.com/vpc/pricing/
- VPC endpoints (interface endpoints priced per AZ-hour + per-GB data):  
  https://aws.amazon.com/blogs/architecture/choosing-your-vpc-endpoint-strategy-for-amazon-s3/
- CloudWatch Logs pricing (ingestion per GB): https://aws.amazon.com/cloudwatch/pricing/
- CloudWatch alarm pricing example ($0.10 per alarm metric): https://aws.amazon.com/cloudwatch/pricing/
- Secrets Manager pricing ($0.40/secret/month): https://aws.amazon.com/secrets-manager/pricing/
- ECR pricing ($0.10 per GB-month example): https://aws.amazon.com/ecr/pricing/
- S3 Standard storage ($0.023 per GB-month for first 50 TB): https://aws.amazon.com/s3/pricing/
- RDS billing components (instance hours + storage, Multi-AZ bills multiple instances): https://aws.amazon.com/rds/postgresql/pricing/
- RDS db.t4g.micro on-demand “starting at” rate (used for estimate): https://instances.vantage.sh/aws/rds/db.t4g.micro

> Tip for the panel: mention you’d run **Infracost** in CI to produce an automated diff-based cost report for PRs, and use the **AWS Pricing Calculator** for a final estimate.
