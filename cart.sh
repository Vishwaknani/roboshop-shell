#! /bin/bash

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

curl -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip &>> $LOGFILE

VALIDATE $? "Download cart application" 

cd /app  &>> $LOGFILE

unzip -o /tmp/cart.zip &>> $LOGFILE

VALIDATE $? "Unzipping cart" 

npm install &>> $LOGFILE

VALIDATE $? "Installation dependency" 

cp /home/centos/roboshop-shell/cart.service /etc/systemd/system/cart.service &>> $LOGFILE

VALIDATE $? "Copying cart service file" 

systemctl daemon-reload &>> $LOGFILE

VALIDATE $? "cart deamon reload" 

systemctl enable cart &>> $LOGFILE

VALIDATE $? "ENABLING CATLOGUE" 

systemctl start cart &>> $LOGFILE

VALIDATE $? "Starting cart" 

