#!/bin/bash

ID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
R="\e[31m"
G="\e[32m"
N="\e[0m"

LOGFILE="/tmp/$0-$TIMESTAMP.log"

VALIDATE(){
    if [  $1 -ne 0 ]
    then 
        echo -e "$2 ..$R FAILED $N"
        exit 1
        
    else 
        echo -e "$2..$G SUCCESS $N"
    fi    
}

if [ $ID -ne 0 ]
then
    echo -e "$R ERROR:: run with root user $N"
    exit 1
else 
    echo "you are root user"

fi

dnf install nginx -y

VALIDATE $? "Installing nginx"

systemctl enable nginx

VALIDATE $? "ENabling nginx"

systemctl start nginx

VALIDATE $? "started nginx"

rm -rf /usr/share/nginx/html/*

VALIDATE $? "Remove default sebsites"

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip

VALIDATE $? "downloaded application"

cd /usr/share/nginx/html

VALIDATE $? "MOVING NGINX FILE DIRETORY"

unzip -o /tmp/web.zip

VALIDATE $? "Unzipping web"

cp /home/centos/roboshop-shell/roboshop.conf /etc/nginx/default.d/roboshop.conf 

VALIDATE $? "Copied roboshop nginx"

systemctl restart nginx 

VALIDATE $? "Restarted nginx"