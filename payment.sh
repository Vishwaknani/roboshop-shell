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
    echo "you are root User"

fi

dnf install python36 gcc python3-devel -y

VALIDATE $? "Installing python "

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

VALIDATE $? "Make directory"

curl -L -o /tmp/payment.zip https://roboshop-builds.s3.amazonaws.com/payment.zip &>> $LOGFILE

VALIDATE $? "Downloading roboshopbuild"

cd /app 

unzip -o /tmp/payment.zip  &>> $LOGFILE

VALIDATE $? "Unzipping payment"

pip3.6 install -r requirements.txt &>> $LOGFILE

VALIDATE $? "Installing dependencies"

cp /home/centos/roboshop-shell/payment.service /etc/systemd/system/payment.service

VALIDATE $? "Copying payment service"

systemctl daemon-reload &>> $LOGFILE

VALIDATE $? "Deamon reloded"


systemctl enable payment &>> $LOGFILE

VALIDATE $? "Enabling payment"

systemctl start payment &>> $LOGFILE

VALIDATE $? "Started payment" 