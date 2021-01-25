#!/bin/bash
sudo service docker start
sudo usermod -a -G docker ec2-user
docker ps
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
test -r ~/.bash_profile && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bash_profile
echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.profile
brew --version
brew tap aws/tap
brew install aws-sam-cli
sam --version
sam deploy --template-file template.yaml --stack-name id-ml-ops --capabilities CAPABILITY_IAM --s3-bucket $1
bucket=$(aws cloudformation describe-stacks --stack-name id-ml-ops --query "Stacks[0].Outputs[?OutputKey=='InputBucketName'].OutputValue" --output text)
aws s3 sync ./data s3://$bucket
aws s3 cp ./params.json s3://$bucket 