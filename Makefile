TEMPLATE ?= dist/aws-ecr-public.template.json
STACK_NAME ?= aws-lambda-docker
IMAGE_URI ?= 684279770417.dkr.ecr.eu-west-1.amazonaws.com/utilization-management-dev-storage@sha256:348612c6c3202e7c50bc3c2439e94d83f13b65c7259f358bba56e9b08aafb90b
VERSION = 1.2.0

build: serverless.template.yml api.openapi.yml lambda/*
	mkdir -p dist
	cfn-include -t -m serverless.template.yml > $(TEMPLATE)

test: build
	aws cloudformation deploy \
		--template-file $(TEMPLATE) \
		--stack-name $(STACK_NAME) \
		--capabilities CAPABILITY_IAM \
		--parameter-overrides \
			AuthBasicUsername=foo \
			AuthBasicPassword=bar \
			Authorizer=BASIC \
			ImageUri=$(IMAGE_URI)

publish: build
	aws s3 cp --acl public-read dist/aws-ecr-public.template.json s3://monken/aws-ecr-public/v$(VERSION)/template.json

clean:
	rm -rf dist
	aws cloudformation delete-stack --stack-name $(STACK_NAME)
