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

# Clean up plan file
clean: ## Clean up generated files
	@echo "Cleaning up Terraform plan file..."
	rm -f $(TERRAFORM_DIR)/$(PLANFILE)

# Show available commands
help: ## Show help for Makefile
	@echo "Available targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'
