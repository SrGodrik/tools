#! /bin/bash
#for profileaws in $(cat ~/.aws/credentials | cut -d '[' -f2| cut -d ']' -f1| grep -v aws| sort -u);
#do
#	for region in `aws ec2 describe-regions --output text | cut -f3`
#	do
#		aws ec2 describe-instances --query "Reservations[*].Instances[*].PublicIpAddress" --output=text --profile varys --region $region	
#	done
#done
for profileaws in $(cat ~/.aws/credentials | cut -d '[' -f2| cut -d ']' -f1| grep -v aws| sort -u);
do
	for region in `aws ec2 describe-regions --output text | cut -f3`
	do
		aws ec2 describe-addresses --profile $profileaws --region $region|grep PublicIp| cut -d '"' -f4
#		aws ec2 describe-addresses --profile $profileaws --region $region|grep 52.0.6
	done
done
