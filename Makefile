$(info [Makefile] Loading commons variables from env/base.env ...)
include env/base.env

terraform-init:
	terraform -chdir=$(TERRAFORM_DIR) init -backend-config="bucket=${AWS_BUCKET_NAME}" -backend-config="key=${AWS_BUCKET_KEY_NAME}" -backend-config="region=${AWS_REGION}"

terraform-validate:
	terraform -chdir=$(TERRAFORM_DIR) validate -no-color

terraform-plan:
	terraform -chdir=$(TERRAFORM_DIR) plan -no-color

terraform-apply:
	terraform -chdir=$(TERRAFORM_DIR) apply -auto-approve -input=false