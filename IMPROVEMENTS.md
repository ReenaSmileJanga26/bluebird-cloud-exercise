# Improvements

- Add CloudFront CDN in front of S3/ALB.
- Add WAF on ALB.
- Add blue/green deployments for ECS with CodeDeploy.
- Add SBOM generation and image signing (cosign).
- Add Terratest for infra testing.
- Use separate AWS roles and separate Terraform state per environment (dev/prod) cleanly.
