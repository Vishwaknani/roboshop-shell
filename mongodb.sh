#!/bin/bash

ID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
R="\e[31m"
G="\e[32m"
N="\e[0m"

LOGFILE="/tmp/%0-$TIMESTAMP.log"

VALIDATE(){
    if [  $1 -ne 0 ]
    then 
        echo -e "$2 ..$R failed $N"
    else 
        echo -e "$2..$G SUCCESS $N"
    fi    
}

if [ $ID -ne 0 ]
then
    echo -e "$R ERROR:: run with root user $N"
    exit 11
else 
    echo "you are root user"

fi

cp mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE

VALIDATE $? "copied mongo repo"

dnf install mongodb-org -y &>> $LOGFILE

VALIDATE $? "Installing Mongodb"

systemctl enable mongod

VALIDATE $? "enabling mongod"

systemctl start mongod

VALIDATE $? "Starting mongod"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>> $LOGFILE


VALIDATE $? "Remote  access to mongodb"

systemctl restart mongod  &>> $LOGFILE

VALIDATE $? "Restarting mongoDB"