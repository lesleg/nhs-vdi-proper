TF_LAYER ?= 1_network
TF_ROOT=terraform/layers/${TF_LAYER}
TF_AUTO_APPROVE = false
BUILD_ENV = dev
VAR_FILE = vars/${BUILD_ENV}.tfvars

init:
	cd ${TF_ROOT} && terraform init \
	-backend-config="bucket=nhsd-dspp-dpsa-${BUILD_ENV}-terraform-state" \
    -backend-config="dynamodb_table=nhsd-dspp-dpsa-${BUILD_ENV}-terraform-state" \
	-reconfigure

output: init
	cd ${TF_ROOT} && terraform output

plan: init
	cd ${TF_ROOT} && terraform plan -var-file="${VAR_FILE}"

plan-destroy: init
	cd ${TF_ROOT} && terraform plan -destroy -var-file=${VAR_FILE}

deploy: init
	cd ${TF_ROOT} && terraform apply -var-file="${VAR_FILE}" -no-color -auto-approve=${TF_AUTO_APPROVE}

fmt-check:
	terraform fmt -recursive -check

terraform-validate: init
	cd ${TF_ROOT} && terraform validate -no-color

destroy: init
	cd ${TF_ROOT} && terraform destroy -var-file="${VAR_FILE}" -no-color -auto-approve=${TF_AUTO_APPROVE}