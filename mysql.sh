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

dnf module disable mysql -y &>> $LOGFILE

VALIDATE $? "Disabling mysql" 

cp mysql.repo /etc/yum.repos.d/mysql.repo &>> $LOGFILE
 
VALIDATE $? "Copying mysql  repo" 

dnf install mysql-community-server -y

VALIDATE $? "Installing mysql community" &>> $LOGFILE

systemctl enable mysqld &>> $LOGFILE

VALIDATE $? "Enabling mysql id"

systemctl start mysqld &>> $LOGFILE

VALIDATE $? "Started mysql"

mysql_secure_installation --set-root-pass RoboShop@1 &>> $LOGFILE

VALIDATE $? "Setting up mysql root password"

