TEMPLATE ?= dist/aws-ecr-public.template.json
STACK_NAME ?= aws-lambda-docker

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
			Authorizer=BASIC

publish: build
	aws s3 cp --acl public-read dist/aws-ecr-public.template.json s3://monken/aws-ecr-public/v$(VERSION)/template.json

clean:
	rm -rf dist
	aws cloudformation delete-stack --stack-name $(STACK_NAME)
