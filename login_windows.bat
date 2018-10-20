@echo off
set username=
set password=
set loginurl=http://ipgw.neu.edu.cn/srun_portal_pc.php?ac_id=1
set logouturl=http://ipgw.neu.edu.cn/include/auth_action.php
set agent="Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:62.0) Gecko/20100101 Firefox/62."

setlocal ENABLEDELAYEDEXPANSION
for /f "tokens=2" %%i in ('curl -s -m 10 --connect-timeout 10 -I !loginurl!^|findstr "HTTP/1.1 \d{3}"') do set code=%%i
if !code! == 200 (
	curl -s -A !agent! -d "username=!username!&password=!password!&action=login" !loginurl!|findstr "sum_seconds" >nul 2>nul
	if !errorlevel! == 0 (
		for /f "tokens=1,3 delims=," %%i in ('curl -s -A !agent! -d "action=get_online_info" !logouturl!') do set flux=%%i & set money=%%j
		echo Used Traffic: !flux:~0,-7!MB
		echo Balance: !money!
	) else (
		curl -s -A !agent! -d "username=!username!&password=!password!&action=logout" !logouturl!
		ping -n 2 127.1>nul
		curl -s -A !agent! -d "username=!username!&password=!password!&action=login" !loginurl!|findstr "sum_seconds" >nul 2>nul
		if !errorlevel! == 0 (
			for /f "tokens=1,3 delims=," %%i in ('curl -s -A !agent! -d "action=get_online_info" !logouturl!') do set flux=%%i & set money=%%j
			echo Used Traffic: !flux:~0,-7!MB
			echo Balance: !money!
		) else (
			echo loginfailed
		)
	)
) else (
	echo Please check your network connection
)
setlocal ENABLEDELAYEDEXPANSION
pause
