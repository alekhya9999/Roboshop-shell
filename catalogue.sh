source common.sh

print_head "configuring node js repos"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash  &>>${LOG}
status_check


print_head "Install nodejs"
yum install nodejs -y  &>>${LOG}

print_head "Add Application User"
id roboshop &>>${LOG}
if [$? -ne 0 ] ; then
useradd roboshop  &>>${LOG}
fi
status_check




mkdir -p /app  &>>${LOG}
status_check

 print_head "Downloading App Content"
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip  &>>${LOG}
status_check

print_head "CleanUp old Content"
rm -rf /app/* &>>${LOG}
status_check

print_head "Extracting App Content"
cd /app
unzip /tmp/catalogue.zip  &>>${LOG}
npm install   &>>${LOG}
status_check


print_head " configuring Catalogue Service Files"
cp ${script_location}/files/catalogue.service /etc/systemd/system/catalogue.service  &>>${LOG}
status_check

print_head " Reload systemD"
systemctl daemon-reload  &>>${LOG}
status_check

print_head " Enable catalogue servic"
systemctl enable catalogue   &>>${LOG}
status_check

print_head " Start catalogue servic"
systemctl start catalogue  &>>${LOG}
status_check


print_head " configuring mongodb repo"
cp ${script_location}/files/mongodb.repo /etc/yum.repos.d/mongo.repo  &>>${LOG}
status_check


print_head " Install mongo client"
yum install mongodb-org-shell -y  &>>${LOG}
status_check


print_head " load Schema"
mongo --host mongodb-dev.ambatis.online </app/schema/catalogue.js  &>>${LOG}
status_check
