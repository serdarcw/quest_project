#!/bin/bash
yum update -y
yum install git -y
amazon-linux-extras install docker -y
systemctl start docker
systemctl enable docker
usermod -a -G docker ec2-user
newgrp docker
cd /home/ec2-user/
git clone https://github.com/serdarcw/quest_project.git
cd quest_project
docker build -t serkan/quest:latest .
docker run -p 80:3000 -d  --env SECRET_WORD=everything-starts-with-i-can-do serkan/quest:latest
