create-state: check-vars
	ls -la
	mkdir terraform/state/environments/${environ}
	cd terraform/state/environments/${environ} \
		&& terraform init ../.. \
		&& terraform apply -auto-approve -var prefix="${project}-${environ}" ../..

destroy-state: check-vars
	cd terraform/state/environments/${environ} \
		&& terraform destroy -var prefix="${project}-${environ}" -auto-approve ../..
	rm -rf terraform/state/environments/${environ}

init: check-vars
	rm -rf .terraform/modules
	cd terraform/environments/$(environ) && rm -rf .terraform/
	cd terraform/environments/$(environ) \
	  && terraform init -backend=true -backend-config=backend.tfvars ../..

plan: check-vars
	cd terraform/environments/$(environ) \
		&& terraform plan -out .terraform/terraformout.plan ../..

apply: check-vars
	cd terraform/environments/$(environ) \
		&& terraform apply -auto-approve .terraform/terraformout.plan

destroy: check-vars
	cd terraform/environments/$(environ) \
		&& terraform destroy -auto-approve ../..

check-vars:
	echo "Checking if project is setup..."
	@test ${project}
	echo "Checking if environ is setup..."
	@test ${environ}
	echo "Checking if AWS_PROFILE is setup..."
	@test ${AWS_PROFILE}
	echo "Checking if AWS_DEFAULT_REGION is setup..."
	@test ${AWS_DEFAULT_REGION}
