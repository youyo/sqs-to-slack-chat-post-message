.DEFAULT_GOAL := help
User := $(shell id -un)
StackName := sqs-to-slack-chat-post-message
S3Bucket := "$(StackName)-$(User)-source"

## create bucket
bucket:
	aws s3 mb s3://$(S3Bucket)

## sam build
build:
	sam build --use-container

## Package
package:
	aws cloudformation package \
		--template-file .aws-sam/build/template.yaml \
		--s3-bucket $(S3Bucket) \
		--output-template-file sam-output.yaml

## Deploy
deploy:
	aws cloudformation deploy \
		--template-file sam-output.yaml \
		--s3-bucket $(S3Bucket) \
		--stack-name $(StackName) \
		--capabilities CAPABILITY_NAMED_IAM \
		--no-fail-on-empty-changeset \
		--parameter-overrides "SlackApiToken=${SLACK_API_TOKEN}"

## Update
update: build package deploy

## Create changesets
changesets:
	aws cloudformation deploy \
		--template-file sam-output.yaml \
		--s3-bucket $(S3Bucket) \
		--stack-name $(StackName) \
		--capabilities CAPABILITY_NAMED_IAM \
		--no-fail-on-empty-changeset \
		--no-execute-changeset \
		--parameter-overrides "SlackApiToken=${SLACK_API_TOKEN}"

## Output
output:
	aws cloudformation describe-stacks \
        --stack-name $(StackName) | jq '.Stacks[0].Outputs'

## Show help
help:
	@make2help $(MAKEFILE_LIST)

.PHONY: help
.SILENT:
