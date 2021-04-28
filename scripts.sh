#!/usr/bin/env bash

# Create bucket for lambda zip
aws s3api create-bucket --bucket go-api-lambda --create-bucket-configuration LocationConstraint=ap-southeast-2 --profile personal

# Build and zip package https://docs.aws.amazon.com/lambda/latest/dg/golang-package.html
go build -o main main.go
build-lambda-zip.exe -o go-api-get.zip main 

# Copy zip file to the bucket
aws s3 cp go-api-get.zip s3://go-api-lambda/go-api-get.zip 

# Deploy terraform
terraform apply