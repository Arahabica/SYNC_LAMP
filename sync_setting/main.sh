#!/bin/bash

cd `dirname $0`
AMI_ID="ami-xxxxxxxx"
IPS=`aws ec2 describe-instances --filters "Name=image-id,Values=${AMI_ID}" | jq '.Reservations[].Instances[].PublicIpAddress'`
php main.php ${IPS}
