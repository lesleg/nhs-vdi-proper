MODULE?=1_network

# Terraform
DIR:=terraform/root_modules/${MODULE}

# Forces Terraform to place state data within the root module
export TF_DATA_DIR:=${DIR}/.terraform

# Set env to 'dev' by default
BUILD_ENV?=dev

TERRAFORM_STATE_BUCKET=nhsd-data-refinery-access-${BUILD_ENV}-terraform-state
TERRAFORM_STATE_LOCK_TABLE=nhsd-data-refinery-access-${BUILD_ENV}-terraform-state-lock

VAR_FILE = vars/${BUILD_ENV}.tfvars

# Set the WORKSPACE to 'branch_name' by default
WORKSPACE ?= $(shell git rev-parse --abbrev-ref HEAD)

init: ## Saves the state file into the S3 bucket / DynamoDB table
	terraform -chdir=${DIR} init \
	-backend-config="bucket=${TERRAFORM_STATE_BUCKET}" \
	-backend-config="dynamodb_table=${TERRAFORM_STATE_LOCK_TABLE}" \
	-reconfigure

plan: init ## Create plan for terraform changes
	terraform -chdir=${DIR} plan -var-file=${VAR_FILE}

plan-destroy: init ## Create plan for terraform destroy changes
	terraform -chdir=${DIR} plan -destroy -var-file=${VAR_FILE}

force-unlock: init ## Create plan for terraform changes
	terraform -chdir=${DIR} force-unlock ${ID}

destroy: init ## Destroy terraform resources defined within a given root module
	terraform -chdir=${DIR} destroy -var-file=${VAR_FILE} -auto-approve=true

fmt: ## Format terraform files
	terraform fmt --recursive

fmt-check: ## Check terraform file format
	terraform fmt -recursive -check

terraform-validate: init ## Validate terraform root module
	terraform -chdir=${DIR} validate

deploy: init ## Apply Terraform changes
	terraform -chdir=${DIR} apply -var-file=${VAR_FILE} -auto-approve=true

# Packer commands

packer-build:
	@$(MAKE) -C packer/amazon-linux-base build

packer-validate:
	@$(MAKE) -C packer/amazon-linux-base validate

# Terraform Workspace commands
workspace-new: init
	terraform -chdir=${DIR} workspace new ${WORKSPACE}

workspace-list: init
	terraform -chdir=${DIR} workspace list

workspace-select: init
	terraform -chdir=${DIR} workspace select ${WORKSPACE}

workspace-delete: init
	terraform -chdir=${DIR} workspace delete ${WORKSPACE}

workspace-show: init
	terraform -chdir=${DIR} workspace show

# Release

release-get-version:
	@$(MAKE) -s -C scripts/release get-version

release-get-tag:
	@$(MAKE) -s -C scripts/release get-tag

release-tag-patch-version:
	@$(MAKE) -C scripts/release tag-patch

release-tag-minor-version:
	@$(MAKE) -C scripts/release tag-minor

release-tag-major-version:
	@$(MAKE) -C scripts/release tag-major
