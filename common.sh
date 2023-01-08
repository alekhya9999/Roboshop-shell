
script_location=$(pwd)
LOG=/tmp/roboshop.log

status_check() {
if [ $? -eq 0 ]; then
echo SUCCESS
else
echo Failure
echo Please Refer file log - ${LOG}
exit
fi
    
}
print_head () {
    echo -e "\e[1m $1 \e[0m"
}

NODEJS () {
    
print_head "configuring node js repos"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash  &>>${LOG}
status_check


print_head "Install nodejs"
yum install nodejs -y  &>>${LOG}

print_head "Add Application User"
id roboshop &>>${LOG}

 if [ $? -ne 0 ]; then
useradd roboshop  &>>${LOG}
fi
status_check




mkdir -p /app  &>>${LOG}
status_check

 print_head "Downloading App Content"
curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip  &>>${LOG}
status_check

print_head "CleanUp old Content"
rm -rf /app/* &>>${LOG}
status_check

print_head "Extracting App Content"
cd /app
unzip /tmp/${component}.zip  &>>${LOG}
npm install   &>>${LOG}
status_check


print_head " configuring component Service Files"
cp ${script_location}/files/${component}.service /etc/systemd/system/${component}.service  &>>${LOG}
status_check

print_head " Reload systemD"
systemctl daemon-reload  &>>${LOG}
status_check

print_head " Enable ${component} servic"
systemctl enable ${component}   &>>${LOG}
status_check

print_head " Start ${component} servic"
systemctl start ${component}  &>>${LOG}
status_check



if [ ${schema_load} == "true" ]; then
print_head " configuring mongodb repo"
cp ${script_location}/files/mongodb.repo /etc/yum.repos.d/mongo.repo  &>>${LOG}
status_check


print_head " Install mongo client"
yum install mongodb-org-shell -y  &>>${LOG}
status_check


print_head " load Schema"
mongo --host mongodb-dev.ambatis.online </app/schema/${component}.js  &>>${LOG}
status_check
fi
    
}