# Define variables
TERRAFORM=terraform
TERRAFORM_DIR=terraform
PLANFILE=terraform.plan

# Default action when `make` is called with no target
.DEFAULT_GOAL := help

init: ## Initialize terraform
	@echo "Initializing Terraform..."
	$(TERRAFORM) -chdir=$(TERRAFORM_DIR) init

plan: init ## Create and show a terraform plan
	@echo "Planning Terraform changes..."
	$(TERRAFORM) -chdir=$(TERRAFORM_DIR) plan -out=$(PLANFILE)

apply: plan ## Apply the terraform plan
	@echo "Applying Terraform changes..."
	$(TERRAFORM) -chdir=$(TERRAFORM_DIR) apply $(PLANFILE)

destroy: init ## Destroy all infrastructure
	@echo "Destroying Terraform-managed infrastructure..."
	$(TERRAFORM) -chdir=$(TERRAFORM_DIR) destroy

validate: init ## Validate terraform configuration
	@echo "Validating Terraform configuration..."
	$(TERRAFORM) -chdir=$(TERRAFORM_DIR) validate

# Terraform format (auto-format terraform files)
fmt: ## Format terraform files
	@echo "Formatting Terraform files..."
	$(TERRAFORM) -chdir=$(TERRAFORM_DIR) fmt -recursive

 # Format eks-policy.json using jq
format-json: ## Format eks-policy.json
	@echo "Formatting eks-policy.json with jq..."
	jq . policies/eks-policy.json > policies/eks-policy-formatted.json || { echo "Failed to format JSON"; exit 1; }

move-formatted-json: ## Move formatted eks-policy.json back to original file
	@echo "Moving formatted JSON file to eks-policy.json..."
	mv -v policies/eks-policy-formatted.json policies/eks-policy.json || { echo "Failed to move formatted JSON"; exit 1; }

# Target to format and move JSON together
format-eks-policy: format-json move-formatted-json ## Format and move eks-policy.json


# Clean up plan file
clean: ## Clean up generated files
	@echo "Cleaning up Terraform plan file..."
	rm -f $(TERRAFORM_DIR)/$(PLANFILE)

# Show available commands
help: ## Show help for Makefile
	@echo "Available targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'
