#!/bin/bash

AMI=ami-0f3c7d07486cad139
SG_ID=sg-0e8c45124526c632d
INSTANCES=("mongodb" "redis" "mysql" "rabbitmq" "catalogue" "user" "cart" "shipping" "payment" "dispatch" "web")
ZONE_ID=Z0824185329GEFCO1CV59
DOMAIN_NAME="Vishwak.online"

for i in "${INSTANCES[@]}"
do
    if [[ $i == "mongodb" || $i == "mysql" || $i == "shipping" ]]; then
    INSTANCE_TYPE="t2.small"
    else
        INSTANCE_TYPE="t2.micro"
    fi

    PRIVATE_IPADDRESS=$(aws ec2 run-instances \
                    --image-id ami-03265a0778a880afb \
                    --count 1 \
                    --instance-type "$INSTANCE_TYPE" \
                    --security-group-ids sg-02deaf6b5f3dd44c0 \
                    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]" \
                    --query 'Instances[0].PrivateIpAddress' \
                    --output text)
    echo "$i : $PRIVATE_IPADDRESS" 
    aws route53 change-resource-record-sets \
    --hosted-zone-id "$ZONE_ID" \
    --change-batch "{
        \"Changes\": [{
            \"Action\": \"UPSERT\",
            \"ResourceRecordSet\": {
                \"Name\": \"$i.$DOMAIN_NAME\",
                \"Type\": \"A\",
                \"TTL\": 1,
                \"ResourceRecords\": [{\"Value\": \"$PRIVATE_IPADDRESS\"}]
            }
        }]
    }"
    echo "record created successfully for $i : $i.$DOMAIN_NAME"
done

