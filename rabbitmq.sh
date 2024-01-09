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

curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>> $LOGFILE

VALIDATE $? "downloading erlang script" &>> $LOGFILE

curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>> $LOGFILE

VALIDATE $? "downloading rabbitmq script"

dnf install rabbitmq-server -y  &>> $LOGFILE

VALIDATE $? "Installing rabbitmq server"

systemctl enable rabbitmq-server -y &>> $LOGFILE

VALIDATE $? "Enabling robbit mw server"

systemctl start rabbitmq-server  &>> $LOGFILE

VALIDATE $? "Started rabiitmQ  server"

rabbitmqctl add_user roboshop roboshop123 

VALIDATE $? "Create user"  &>> $LOGFILE

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"

VALIDATE $? "Set permissions"  &>> $LOGFILE

