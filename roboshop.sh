#!/bin/bash

AMI=ami-0f3c7d07486cad139
SG_ID=sg-0e8c45124526c632d
INSTANCES=("mongodb" "redis" "mysql" rabbitmq" "catalogue" "user" "cart" "shipping"
"payment" "dispatch" "web")

for i in "${INSTANCES[@]}"
do
    if [$i == "mongodb" ] || [ $i == "mysql" ] || [ $i == "shipping" ]
    then 
        INSTANCE_TYPE="t3.small"
    else
        INSTANCE_TYPE="t2.micro"
    fi

    aws ec2 run-instances --image-id ami-0f3c7d07486cad139 --instance-type t2.micro
    --security-group-ids sg-0e8c45124526c632d
done

