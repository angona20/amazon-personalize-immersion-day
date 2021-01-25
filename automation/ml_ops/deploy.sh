#!/bin/bash
sudo service docker start
sudo usermod -a -G docker ec2-user
docker ps
pip install aws-sam-cli
sam --version
sam deploy --template-file template.yaml --stack-name id-ml-ops --capabilities CAPABILITY_IAM --s3-bucket $1
bucket=$(aws cloudformation describe-stacks --stack-name id-ml-ops --query "Stacks[0].Outputs[?OutputKey=='InputBucketName'].OutputValue" --output text)
aws s3 sync ./data s3://$bucket
aws s3 cp ./params.json s3://$bucket 