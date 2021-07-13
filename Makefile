.PHONY: help
help: ## Print info about each available command in this Makefile
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(firstword $(MAKEFILE_LIST)) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

guard-%:
	@ if [ "${${*}}" = "" ]; then \
		echo "Environment variable $* not set"; \
		exit 1; \
	fi

# Linting

.PHONY: tf-fmt
tf-fmt: ## Format terraform files
	terraform fmt --recursive

.PHONY: tf-fmt-check
tf-fmt-check: ## Check terraform file format (For use in CI, locally just use tf-fmt)
	terraform fmt -recursive -check -diff

# Terraform

tf_chdir_arg=-chdir=terraform/root_modules/${MODULE}
tf_var_file_arg=-var-file=../../vars/${BUILD_ENV}.tfvars

.PHONY: tf-init
tf-init: guard-MODULE guard-BUILD_ENV ## Initialises the root module directory
	terraform ${tf_chdir_arg} init \
		-backend-config="bucket=nhsd-data-refinery-access-${BUILD_ENV}-terraform-state" \
		-backend-config="dynamodb_table=nhsd-data-refinery-access-${BUILD_ENV}-terraform-state-lock" \
		-reconfigure

.PHONY: tf-validate
tf-validate: guard-MODULE tf-init ## Validate terraform root module
	terraform ${tf_chdir_arg} validate

.PHONY: tf-plan
tf-plan: guard-MODULE guard-BUILD_ENV tf-init ## Create plan for terraform changes
	terraform ${tf_chdir_arg} plan ${tf_var_file_arg}

.PHONY: tf-apply
tf-apply: guard-MODULE guard-BUILD_ENV tf-init ## Apply Terraform changes (in CI set EXTRA_ARGS to -auto-approve=true)
	terraform ${tf_chdir_arg} apply ${tf_var_file_arg} ${EXTRA_ARGS}

.PHONY: tf-plan-destroy
tf-plan-destroy: guard-MODULE guard-BUILD_ENV tf-init ## Create plan for terraform destroy changes
	terraform ${tf_chdir_arg} plan -destroy ${tf_var_file_arg}

.PHONY: tf-destroy
tf-destroy: guard-MODULE guard-BUILD_ENV tf-init ## Destroy terraform resources defined within a given root module (in CI set EXTRA_ARGS to -auto-approve=true)
	terraform ${tf_chdir_arg} destroy ${tf_var_file_arg} ${EXTRA_ARGS}
