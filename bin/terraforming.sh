#!/usr/bin/env bash

export AWS_REGION=eu-central-1

# start with the first group to create the state file
terraforming asg --tfstate > terraforming/terraform.tfstate

groups=( dbpg dbsg dbsn ec2 ecc ecsn eip elb iamg iamgm iamgp iamip iamp iamr iamrp iamu iamup igw nacl nif r53r r53z rds rs rt rta s3 sg sn sqs vpc )

# then the rest
for grp in "${groups[@]}"
do
    terraforming $grp > terraforming/$grp.tf
    terraforming $grp --tfstate --merge terraforming/terraform.tfstate --overwrite
done
