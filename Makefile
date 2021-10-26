IMAGE_VERSION = 0.7
IMAGE_NAME = "DARE_VDI_Image_v${IMAGE_VERSION}"
BUNDLE_NAME = "DARE_VDI_Bundle_v${IMAGE_VERSION}"
WORKSPACE_IMAGE_ID = $(shell aws workspaces describe-workspace-images | jq '.Images[] | select(.Name==${IMAGE_NAME}) | .ImageId')
WORKSPACE_BUNDLE_ID = $(shell aws workspaces describe-workspace-bundles | jq '.Bundles[] | select(.Name==${BUNDLE_NAME}) | .BundleId')
WORKSPACE_DIRECTORY_ID = $(shell aws ds describe-directories | jq '.DirectoryDescriptions[] | select(.ShortName=="dare") | .DirectoryId')
WORKSPACE_REGISTRATION_CODE = $(shell aws workspaces describe-workspace-directories | jq '.Directories[] | select(.DirectoryId==${WORKSPACE_DIRECTORY_ID}) | .RegistrationCode')
WORKSPACE_ID_FOR_USERNAME = $(shell aws workspaces describe-workspaces | jq '.Workspaces[] | select(.UserName=="${username}") | .WorkspaceId')
BUILD_REGION ?= "eu-west-2"

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

.PHONY: tf-tfsec
tf-tfsec: guard-MODULE guard-BUILD_ENV ## Run tfsec security analysis
	cd terraform/root_modules/${MODULE} && terraform get && tfsec --tfvars-file=vars/${BUILD_ENV}.tfvars .

# Terraform

tf_chdir_arg=-chdir=terraform/root_modules/${MODULE}
tf_var_file_arg=-var-file=vars/${BUILD_ENV}.tfvars

.PHONY: tf-init
tf-init: guard-MODULE guard-BUILD_ENV ## Initialises the root module directory
	terraform ${tf_chdir_arg} init \
		-backend-config="bucket=nhsd-data-refinery-access-${BUILD_ENV}-terraform-state" \
		-backend-config="dynamodb_table=nhsd-data-refinery-access-${BUILD_ENV}-terraform-state-lock" \
		-backend-config="region=${BUILD_REGION}" \
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

# Onboarding

.PHONY: aws-share-image-to-test
aws-share-image-to-test: ## Share the current image version to test
	aws workspaces update-workspace-image-permission --image-id ${WORKSPACE_IMAGE_ID} --allow-copy-image --shared-account-id 130910604431
	@echo "Now run AWS_PROFILE=Ref_DARE-Access make aws-copy-workspace-image image_id=${WORKSPACE_IMAGE_ID}"

.PHONY: aws-unshare-image-from-test
aws-unshare-image-from-test: ## Unshare the current image version from test
	aws workspaces update-workspace-image-permission --image-id ${WORKSPACE_IMAGE_ID} --no-allow-copy-image --shared-account-id 130910604431

.PHONY: aws-copy-workspace-image
aws-copy-workspace-image: guard-image_id  ## Copy the shared image
	aws workspaces copy-workspace-image --source-image-id ${image_id} --source-region eu-west-2 --name ${IMAGE_NAME}

.PHONY: aws-create-bundle
aws-create-bundle:  ## Create a bundle for an image
	aws workspaces create-workspace-bundle --bundle-name ${BUNDLE_NAME} --bundle-description "VDI bundle for v${IMAGE_VERSION} image" --image-id ${WORKSPACE_IMAGE_ID} --compute-type Name=POWER --user-storage Capacity=50 --root-storage Capacity=80

.PHONY: aws-create-workspace
aws-create-workspace: guard-username ## Create a workspace for a given user
	aws workspaces create-workspaces --workspaces DirectoryId=${WORKSPACE_DIRECTORY_ID},UserName=${username},BundleId=${WORKSPACE_BUNDLE_ID},UserVolumeEncryptionEnabled=true,RootVolumeEncryptionEnabled=true,VolumeEncryptionKey=alias/workspace_encryption,WorkspaceProperties='{RunningMode=AUTO_STOP,RunningModeAutoStopTimeoutInMinutes=60,RootVolumeSizeGib=80,UserVolumeSizeGib=50,ComputeTypeName=POWER}' | jq

.PHONY: aws-migrate-workspace
aws-migrate-workspace: guard-username ## Migrate workspace for a given user to the latest bundle
	aws workspaces migrate-workspace --source-workspace-id ${WORKSPACE_ID_FOR_USERNAME} --bundle-id ${WORKSPACE_BUNDLE_ID}

.PHONY: aws-check-workspace-state
aws-check-workspace-state: guard-username ## Check the workspace state, and output the registration code if it is ready
	@if [ "`aws workspaces describe-workspaces | jq '.Workspaces[] | select(.UserName=="${username}") | .State'`" = "\"PENDING\"" ]; \
		then echo "Workspace is still being created"; \
	else \
		echo "Workspace creation complete"; \
		echo "Registration Code is ${WORKSPACE_REGISTRATION_CODE}"; \
	fi
