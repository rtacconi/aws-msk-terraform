LAYERS=terraform/layers

create-state: check-vars
	cd terraform/00_state \
		&& terraform init \
		&& terraform apply -auto-approve -var prefix="${project}-${environ}"

init: check-vars
	$(call tf_init,10_network)

test2:
	$(call tf_init,20_msk)
	$(call tf_plan,20_msk)
	$(call tf_apply,20_msk)
	$(call tf_destroy,20_msk)

plan: check-vars
	$(call tf_plan,10_network)

apply: check-vars
	$(call tf_apply,10_network)

destroy: check-vars
	$(call tf_destroy,10_network)

check-vars:
	echo "Checking if project is setup..."
	@test ${project}
	echo "Checking if environ is setup..."
	@test ${environ}
	echo "Checking if AWS_PROFILE is setup..."
	@test ${AWS_PROFILE}

define tf_init
	cd terraform/layers/$(1)/environments/${environ} && rm -rf .terraform/ \
		&& TF_DATA_DIR=$(shell pwd)/terraform/layers/$(1)/environments/${environ}/.terraform \
			terraform -chdir=../.. init \
			-backend=true -backend-config=$(shell pwd)/terraform/layers/$(1)/environments/${environ}/backend.tfvars
endef

define tf_plan
	cd terraform/layers/$(1)/environments/${environ}/ \
		&& TF_DATA_DIR=$(shell pwd)/terraform/layers/$(1)/environments/${environ}/.terraform \
			terraform -chdir=../.. plan \
				-var-file=$(shell pwd)/terraform/layers/$(1)/environments/${environ}/terraform.tfvars \
				-out=$(shell pwd)/terraform/layers/$(1)/environments/${environ}/.terraform/terraformout.plan
endef

define tf_apply
	cd terraform/layers/$(1)/environments/${environ}/ \
		&& TF_DATA_DIR=$(shell pwd)/terraform/layers/$(1)/environments/${environ}/.terraform \
			terraform -chdir=../.. \
				apply \
				$(shell pwd)/terraform/layers/$(1)/environments/${environ}/.terraform/terraformout.plan
endef

define tf_destroy
	cd terraform/layers/$(1)/environments/${environ}/ \
		&& TF_DATA_DIR=$(shell pwd)/terraform/layers/$(1)/environments/${environ}/.terraform \
			terraform -chdir=../.. \
				destroy -auto-approve \
				-var-file=$(shell pwd)/terraform/layers/$(1)/environments/${environ}/terraform.tfvars
endef

apply_layers:
	for d in $(shell ls ${LAYERS}); do \
		echo $${d}; \
		$(call tf_init,$${d}) \
	done
