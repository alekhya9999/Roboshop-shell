
script_location=$(pwd)
LOG=/tmp/roboshop.log

echo -e "\e[35m configuring nodejs repos\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash  &>>${LOG}
if [ $? -eq 0 ]; then
echo SUCCESS
else
echo Failure
exit
fi


echo -e "\e[35m Install nodejs\e[0m"
yum install nodejs -y  &>>${LOG}

echo -e "\e[35m Add Application User\e[0m"
useradd roboshop  &>>${LOG}

if [ $? -eq 0 ]; then
echo SUCCESS
else
echo Failure
echo Please Refer file log - ${LOG}
exit
fi



mkdir -p /app  &>>${LOG}
if [ $? -eq 0 ]; then
echo SUCCESS
else
echo Failure
exit
fi

echo -e "\e[35m Downloading App Content\e[0m"
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip  &>>${LOG}
if [ $? -eq 0 ]; then
echo SUCCESS
else
echo Failure
exit
fi
echo -e "\e[35m CleanUp old Content\e[0m"
rm -rf /app/* &>>${LOG}
if [ $? -eq 0 ]; then
echo SUCCESS
else
echo Failure
exit
fi

echo -e "\e[35m Extracting App Content\e[0m"
cd /app
unzip /tmp/catalogue.zip  &>>${LOG}
npm install   &>>${LOG}
if [ $? -eq 0 ]; then
echo SUCCESS
else
echo Failure
exit
fi


echo -e "\e[35m configuring Catalogue Service Files\e[0m"
cp ${script_location}/files/catalogue.service /etc/systemd/system/catalogue.service  &>>${LOG}
if [ $? -eq 0 ]; then
echo SUCCESS
else
echo Failure
exit
fi

echo -e "\e[35m Reload systemD\e[0m"
systemctl daemon-reload  &>>${LOG}
if [ $? -eq 0 ]; then
echo SUCCESS
else
echo Failure
exit
fi

echo -e "\e[35m Enable catalogue service\e[0m"
systemctl enable catalogue   &>>${LOG}
if [ $? -eq 0 ]; then
echo SUCCESS
else
echo Failure
exit
fi

echo -e "\e[35m Start catalogue service\e[0m"
systemctl start catalogue  &>>${LOG}
if [ $? -eq 0 ]; then
echo SUCCESS
else
echo Failure
exit
fi

echo -e "\e[35m configuring mongodb repo\e[0m"
cp ${script_location}/files/mongodb.repo /etc/yum.repos.d/mongo.repo  &>>${LOG}
if [ $? -eq 0 ]; then
echo SUCCESS
else
echo Failure
exit
fi


echo -e "\e[35m Install mongo client\e[0m"
yum install mongodb-org-shell -y  &>>${LOG}
if [ $? -eq 0 ]; then
echo SUCCESS
else
echo Failure
exit
fi


echo -e "\e[35m load Schema\e[0m"
mongo --host mongodb-dev.ambatis.online </app/schema/catalogue.js  &>>${LOG}
if [ $? -eq 0 ]; then
echo SUCCESS
else
echo Failure
exit
fi

