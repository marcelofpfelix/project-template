# https://www.gnu.org/software/make/manual/make.html#index-_002eEXPORT_005fALL_005fVARIABLES
.EXPORT_ALL_VARIABLES:

# refers to terraform workspace and k8s cluster
context := lab

# create terraform workspace
workspace:
	terraform workspace new ${context}

# create k8s namespace
namespace:
	terraform workspace select ${context}
	kubectl config use-context ${context}

# re-usable context command (linking terraform workspace with k8s cluster)
context:
	kubectl config use-context ${context}
	terraform workspace select ${context}

#
# terraform targets
#
init:
	terraform init
fmt:
	terraform fmt
validate:
	terraform validate

#
# project targets
#
plan: context fmt validate
	terraform plan -out=terraform.tfplan

apply: context
	terraform apply terraform.tfplan

plan-destroy: context fmt validate
	terraform plan --destroy

destroy: context fmt validate
	terraform destroy
