
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