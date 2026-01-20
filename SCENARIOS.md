# Scenarios

## 1) Traffic spike (10x)
ECS service scales via target tracking policy. Improve by:
- scaling on ALB RequestCountPerTarget
- increase task CPU/memory
- add CloudFront caching for static

## 2) Security incident
Use CloudWatch logs, ALB access logs (add-on), VPC Flow Logs (add-on).
Improvements: WAF, tighter SG egress, IAM least-priv review, GuardDuty.

## 3) Reduce costs by 30%
- Reduce RDS size (if acceptable), consider Single-AZ for non-prod
- Right-size tasks, use scheduled scaling, consider Fargate Spot for non-prod
- Minimize NAT usage further with endpoints; consider removing NAT where possible

## 4) Region outage (DR)
Use multi-region approach:
- replicate container images to secondary region
- DB: cross-region replica or backup/restore
RTO/RPO depends on replication strategy; start with hours (backup/restore), improve to minutes with replicas.
