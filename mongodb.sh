source common.sh

print_head "Copy mangod repo files"
cp ${script_location}/files/mongodb.repo /etc/yum.repos.d/mongo.repo  &>>${LOG}
status_check

print_head "Install mangod "
yum install mongodb-org -y   &>>${LOG}
status_check


print_head "update mangod listen address "
 sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf  &>>${LOG}
 status_check

print_head "Enable mangod "
systemctl enable mongod   &>>${LOG}
status_check

print_head "Install mangod "
systemctl restart mongod  &>>${LOG}
status_check



