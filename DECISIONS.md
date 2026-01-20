## ECS Fargate
Chosen for managed compute, simplified ops, and easy autoscaling.

## Single NAT Gateway
Cost-optimized design with a single NAT gateway.
Trade-off: reduced AZ-level redundancy for outbound traffic.

## VPC Endpoints
Interface endpoints for ECR/Logs/Secrets Manager reduce NAT data processing and improve security posture.

## RDS Multi-AZ + Managed Secrets
RDS Multi-AZ for HA; managed master password stored in Secrets Manager.

## DevSecOps
- App CI includes SAST (CodeQL) and container scanning (Trivy).
- Infra CI includes linting (tflint), IaC scanning (tfsec), and cost reporting (Infracost).
- Drift detection scheduled workflow.