SHELL = /usr/bin/env bash

AWS_ACCOUNT_ID = $(shell aws sts get-caller-identity --query Account --output text)
BUCKET = mattermost-$(AWS_ACCOUNT_ID)


ifneq ($(parameter-overrides),)
parameter-overrides-x = --parameter-overrides $(parameter-overrides)
endif

define cfn-deploy-args
--stack-name mattermost-$(stackname) \
--template-file infra/aws/$(stackname).yaml \
$(parameter-overrides-x) \
--capabilities CAPABILITY_IAM \
--no-fail-on-empty-changeset
endef


check-variables:
	@if [ -z $${stackname} ]; then \
		printf "You must supply a 'stackname' environment variable. Aborting.\n" && exit 1; \
	fi
	@if [ -z $${env} ]; then \
		printf "You must supply an 'env' environment variable. Aborting.\n" && exit 1; \
	fi

cfn-deploy: check-variables
	aws cloudformation deploy $(cfn-deploy-args)

source-to-s3:
	aws s3 cp --recursive . s3://$(BUCKET)/source/

s3-wipe:
	python3 -c "import boto3; boto3.resource('s3').Bucket('$(BUCKET)').object_versions.delete()"

cfn-delete: check-variables
	@aws cloudformation delete-stack --stack-name $(stackname)
	@printf "Stack delete request sent. Waiting for delete completion...\n"
	@aws cloudformation wait stack-delete-complete --stack-name $(stackname)
	@printf "Done.\n"

ssm-configure-instance:
	@echo Not configured && exit 1 #aws ssm start-session --target
