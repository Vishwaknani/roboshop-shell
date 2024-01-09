#!/bin/bash

ID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
R="\e[31m"
G="\e[32m"
N="\e[0m"
MONGDB_HOST="mongodb.vishwak.online"
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

dnf module disable nodejs -y &>> $LOGFILE

VALIDATE $? "disable current nodejs" 

dnf module enable nodejs:18 -y &>> $LOGFILE

VALIDATE $? "Enabling nodejs:18" 

dnf install nodejs -y &>> $LOGFILE

VALIDATE $? "Install nodejs:18" 

id roboshop
if [ $? -ne 0 ]
then
useradd roboshop &>> $LOGFILE

VALIDATE $? "User creation"
else
    echo -e "roboshop already exits"

VALIDATE $? "create roboshp user"
fi

mkdir -p /app &>> $LOGFILE

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>> $LOGFILE

VALIDATE $? "Download catalogue application" 

cd /app  &>> $LOGFILE

unzip -o /tmp/catalogue.zip &>> $LOGFILE

VALIDATE $? "Unzipping catalogue" 

npm install &>> $LOGFILE

VALIDATE $? "Installation dependency" 

cp /home/centos/roboshop-shell/catalogue.service /etc/systemd/system/catalogue.service &>> $LOGFILE

VALIDATE $? "Copying catalogue service file" 

systemctl daemon-reload &>> $LOGFILE

VALIDATE $? "Catalogue deamon reload" 

systemctl enable catalogue &>> $LOGFILE

VALIDATE $? "ENABLING CATLOGUE" 

systemctl start catalogue &>> $LOGFILE

VALIDATE $? "Starting catalogue" 

cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE

VALIDATE $? "Copying mongo repo" 

dnf install mongodb-org-shell -y &>> $LOGFILE

VALIDATE $? "Installing mongodb client" 

mongo --host $MONGDB_HOST </app/schema/catalogue.js

VALIDATE $? "Loading catalogue data into mongodbb"