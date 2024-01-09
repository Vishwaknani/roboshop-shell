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

dnf install maven -y &>> $LOGFILE

VALIDATE $? "Installing nodejs:18"

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

curl -L -o /tmp/shipping.zip https://roboshop-builds.s3.amazonaws.com/shipping.zip

cd /app

unzip -o /tmp/shipping.zip

VALIDATE $? "Unzipping file"

mvn clean package

VALIDATE $? "Installing depenencies"

mv target/shipping-1.0.jar shipping.jar

cp /home/centos/roboshop-shell/shipping.service /etc/systemd/system/shipping.service

VALIDATE $? "COPYING SHIPPIng servics"

systemctl daemon-reload

VALIDATE $? "Deamon reloaded"

systemctl enable shipping 

VALIDATE $? "ENABLE SHIPPING"

systemctl start shipping

VALIDATE $? "Start shipping"

dnf install mysql -y

VALIDATE $? "Installing mysql"

mysql -h mysql.vishwak.online -uroot -pRoboShop@1 < /app/schema/shipping.sql 

VALIDATE $? "loading shipping data"

systemctl restart shipping 

VALIDATE $? "Restar shipping"