#!/bin/sh
#Removing Credentials file 
rm -vf ${HOME}/.aws/credentials

#Creating IAM Role 
echo "Creating IAM Role"
aws iam create-role --role-name eksworkshop-admin --assume-role-policy-document file:///home/ec2-user/environment/automation/scripts/policy.json
aws iam attach-role-policy --role-name eksworkshop-admin --policy-arn arn:aws:iam::aws:policy/AdministratorAccess
aws iam create-instance-profile --instance-profile-name eksworkshop-admin
aws iam add-role-to-instance-profile --role-name eksworkshop-admin --instance-profile-name eksworkshop-admin
instance_id=`curl http://169.254.169.254/latest/meta-data/instance-id`
sleep 10
#Attaching Instance Profile to EC2 Instance
echo "Attaching Instance Profile to EC2  Instance"
aws ec2 associate-iam-instance-profile --instance-id $instance_id --iam-instance-profile Name=eksworkshop-admin
#Resetting environment variables 
unset AWS_DEFAULT_REGION
unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
unset AWS_SESSION_TOKEN
