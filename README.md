# Project Bedrock

EKS-based deployment of the AWS Retail Store sample app. Infrastructure is in `terraform/`; workloads are in `k8s/`. Region is **us-east-1**.

## What’s in here

- **terraform/** — VPC, EKS (`project-bedrock-cluster`), RDS, DynamoDB, IAM, S3/Lambda, etc.
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

Update `k8s/secrets.yaml`, `k8s/catalog-db-config.yaml`, and `k8s/orders-db-config.yaml` first.

```bash
kubectl apply --validate=false -f https://github.com/cert-manager/cert-manager/releases/download/v1.12.3/cert-manager.yaml
curl -L -o v2_8_2_full.yaml https://github.com/kubernetes-sigs/aws-load-balancer-controller/releases/download/v2.8.2/v2_8_2_full.yaml
kubectl apply -f v2_8_2_full.yaml
curl -L -o v2_8_2_ingclass.yaml https://github.com/kubernetes-sigs/aws-load-balancer-controller/releases/download/v2.8.2/v2_8_2_ingclass.yaml
kubectl apply -f v2_8_2_ingclass.yaml
kubectl apply -R -f k8s/ (or ../k8s/ if not in root folder. e.g if terminal is in terraform folder)
kubectl get pods -n retail-app
kubectl get ingress -n retail-app
```

Set `--cluster-name=project-bedrock-cluster` in `v2_8_2_full.yaml` before `kubectl apply -f v2_8_2_full.yaml`.

Use the ALB address from the ingress when the UI is up.

## Verify observability

```bash
aws logs describe-log-groups
kubectl get pods -n amazon-cloudwatch
```

You should see EKS control-plane log groups and container insights log groups/streams after traffic and pod activity.

## Grading output

```bash
cd terraform
terraform output -json > ../grading.json
```

## Verify serverless asset flow

```bash
echo "test" > test.txt
aws s3 cp test.txt s3://$(cd terraform && terraform output -raw assets_bucket_name)/test.txt
aws logs describe-log-groups
```

Confirm CloudWatch logs for `bedrock-asset-processor` include `Image received: test.txt`.

## CI/CD

`.github/workflows/terraform.yml` — plan on PR, apply on merge to `master`. Needs `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` (or OIDC) in repo secrets.

## Tear down

```bash
cd terraform
terraform destroy
```

Shut this down when you’re not working on it — NAT, EKS, and RDS add up quickly.
