#!/bin/bash
yum update -y
yum install docker -y
service docker start
usermod -aG docker ec2-user

#Login to ecr
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 934192905430.dkr.ecr.us-east-1.amazonaws.com
# clean the old containers if running
sudo docker stop myapp || true
sudo docker rm myapp || true
# Run Docker container
sudo docker run -d --name myapp -p 80:5000 934192905430.dkr.ecr.us-east-1.amazonaws.com/myapp:latest
