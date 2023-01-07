source common.sh

echo -e "\e[35m configuring nodejs repos\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash  &>>${LOG}
status_check


echo -e "\e[35m Install nodejs\e[0m"
yum install nodejs -y  &>>${LOG}

echo -e "\e[35m Add Application User\e[0m"
id roboshop &>>${LOG}
if [$? -ne 0] ; then
useradd roboshop  &>>${LOG}
fi
status_check




mkdir -p /app  &>>${LOG}
status_check

echo -e "\e[35m Downloading App Content\e[0m"
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip  &>>${LOG}
status_check

echo -e "\e[35m CleanUp old Content\e[0m"
rm -rf /app/* &>>${LOG}
status_check

echo -e "\e[35m Extracting App Content\e[0m"
cd /app
unzip /tmp/catalogue.zip  &>>${LOG}
npm install   &>>${LOG}
status_check


echo -e "\e[35m configuring Catalogue Service Files\e[0m"
cp ${script_location}/files/catalogue.service /etc/systemd/system/catalogue.service  &>>${LOG}
status_check

echo -e "\e[35m Reload systemD\e[0m"
systemctl daemon-reload  &>>${LOG}
status_check

echo -e "\e[35m Enable catalogue service\e[0m"
systemctl enable catalogue   &>>${LOG}
status_check

echo -e "\e[35m Start catalogue service\e[0m"
systemctl start catalogue  &>>${LOG}
status_check


echo -e "\e[35m configuring mongodb repo\e[0m"
cp ${script_location}/files/mongodb.repo /etc/yum.repos.d/mongo.repo  &>>${LOG}
status_check


echo -e "\e[35m Install mongo client\e[0m"
yum install mongodb-org-shell -y  &>>${LOG}
status_check


echo -e "\e[35m load Schema\e[0m"
mongo --host mongodb-dev.ambatis.online </app/schema/catalogue.js  &>>${LOG}
status_check
