# OneClickLogin
IP网关一键登录

# Windows使用方法
先从官网下载curl，解压后把curl.exe放在C:\Windows\System32下，或者自己另外配置环境变量也行  
把login_windows.bat以文本文件的形式打开，或者从编辑器打开文件，填写用户名密码字段  
```bat
set username=201xxxxx
set password=xxxxxxxx
```
不需要添加引号啥的  
保存之后，以后直接双击该bat文件即可直接登录  

# Linux使用方法
Linux大多数发行版默认有curl，如果没有另外自行安装  
把该sh文件打开，填写用户名密码字段  
```shell
username="201xxxxx"
password="xxxxxxxx"
```
需要添加引号  
保存以后终端运行该程序即可登录网关  

### Agent字段可以自行修改为想要的agent
### 可以把脚本添加在开机启动任务里，实现开机自动登录网关
