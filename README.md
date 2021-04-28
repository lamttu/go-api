# Go-API

A REST API integrated with AWS lambda written in Go and Terraform

## How to run

`scripts.sh` is provided to run the program

## Functionalities

- [x] API Gateway -> Lambda for GET requests
- [ ] Set up Github actions to automatically deploy
- [ ] Version lambda to allows CI/CD
- [ ] Improve scripts.sh 
- [ ] Explore deploying lambda with a container image

## Stretch goals
- [ ] Get path parameters and echo back
- [ ] Authorization

## Materials

- https://learn.hashicorp.com/tutorials/terraform/lambda-api-gateway
- https://docs.aws.amazon.com/lambda/latest/dg/golang-package.html

## Gotchas

- For `aws_api_gateway_integration`, [Lambda function can only be invoked via `POST`](https://github.com/amazon-archives/aws-apigateway-importer/issues/9#issuecomment-129651005) 


