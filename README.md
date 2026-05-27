# Project Bedrock

EKS-based deployment of the AWS Retail Store sample app. Infrastructure is in `terraform/`; workloads are in `k8s/`. Region is **us-east-1**.

## What’s in here

- **terraform/** — VPC, EKS (`project-bedrock-cluster`), RDS, DynamoDB, ALB controller, IAM, S3/Lambda, etc.
- **k8s/** — App manifests in namespace `retail-app`
- **lambda/** — `bedrock-asset-processor` (S3 upload trigger)
- **grading.json** — Run `terraform output -json` after apply (not committed until infra exists)

State lives in S3: `project-bedrock-tf-state-alt-soe-025-3702`. App assets bucket: `bedrock-assets-alt-soe-025-3702`.

## Before you start

- AWS CLI + Terraform 1.5+
- `kubectl` once the cluster exists
- Credentials with permission to create the usual VPC/EKS/RDS/IAM resources

Bootstrap state bucket once (if it doesn’t exist yet):

```bash
aws s3api create-bucket --bucket project-bedrock-tf-state-alt-soe-025-3702 --region us-east-1
aws s3api put-bucket-versioning --bucket project-bedrock-tf-state-alt-soe-025-3702 --versioning-configuration Status=Enabled
```

## Deploy infra

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

For kubectl:

```bash
aws eks update-kubeconfig --name project-bedrock-cluster --region us-east-1
kubectl get nodes
```

## Deploy the app

```bash
kubectl apply -f k8s/
kubectl get pods -n retail-app
kubectl get ingress -n retail-app
```

Use the ALB address from the ingress when the UI is up.

## Grading output

```bash
cd terraform
terraform output -json > ../grading.json
```

## CI/CD

`.github/workflows/terraform.yml` — plan on PR, apply on merge to `master`. Needs `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` (or OIDC) in repo secrets.

## Tear down

```bash
cd terraform
terraform destroy
```

Shut this down when you’re not working on it — NAT, EKS, and RDS add up quickly.
