#!/bin/bash
username=""
password=""
loginurl="http://ipgw.neu.edu.cn/srun_portal_pc.php?ac_id=1&"
logouturl="http://ipgw.neu.edu.cn/include/auth_action.php"
agent="User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101 Firefox/60.0"
dfile="tmp1.txt"
rfile="tmp2.txt"

function httpRequest() { 
    #curl 请求 
    wget -Sq -O $dfile -o $rfile -T 10 $loginurl

    #获取返回码 
    code=`cat $rfile|grep "HTTP"|awk '{print $2}'` 

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
    wget -q -O $dfile --header="$agent" --post-data="username=$username&password=$password&action=login" $loginurl
    cat $dfile | grep -q "sum_seconds"
}

function logout() {
    wget $logouturl -q -O $dfile --post-data="username=$username&password=$password&action=logout"
}

function getInfo() {
    wget -q -O $dfile --post-data="action=get_online_info" $logouturl;
    cat $dfile | awk -F '[,]' '{printf "Used Traffic:%0.2fMB\nBalance:%s\n",$1/1000000,$3}'
}

httpRequest
