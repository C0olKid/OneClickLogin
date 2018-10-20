#!/bin/bash
username=""
password=""
loginurl="http://ipgw.neu.edu.cn/srun_portal_pc.php?ac_id=1&"
logouturl="http://ipgw.neu.edu.cn/include/auth_action.php"
agent="Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101 Firefox/60.0"

function httpRequest() { 
    #curl 请求 
    info=`curl -s -m 10 --connect-timeout 10 -I $loginurl` 

    #获取返回码 
    code=`echo $info|grep "HTTP"|awk '{print $2}'` 

    #对响应码进行判断 
    if [ "$code" == "200" ]; then login
        if [ $? == 0 ]; then getInfo
        else
            #服务需要对登出作出反应，睡眠1秒
            logout && sleep 1 && login
            if [ $? == 0 ]; then getInfo; else echo "login failed"; fi
        fi
    else echo "Please Check your network connection"; fi 
}

function login() {
    curl $loginurl -s -A "$agent" -d "username=$username&password=$password&action=login" | grep -q "sum_seconds"
}

function logout() {
    info=`curl $logouturl -s -d "username=$username&password=$password&action=logout"`
}

function getInfo() {
    curl -s -d "action=get_online_info" $logouturl|awk -F '[,]' '{printf "Used Traffic:%0.2fMB\nBalance:%s\n",$1/1000000,$3}'
}

httpRequest
