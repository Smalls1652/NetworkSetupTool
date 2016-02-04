set iswin8=0

ver | findstr /i "6\.2\." > nul
if %ERRORLEVEL%==0 (
set yomomma=1
set iswin8=1
)
ver | findstr /i "6\.3\." > nul
if %ERRORLEVEL%==0 (
set yomomma=1
set iswin8=1
)
	
	type NUL > %Temp%\reboot.bat
	echo @echo off >> %Temp%\reboot.bat
	echo cd %Temp%\ >> %Temp%\reboot.bat
	echo echo Please wait... >> %Temp%\reboot.bat
	echo timeout /t 10 >> %Temp%\reboot.bat
	echo start "ISE-Installer" ISE-Installer.exe >> %Temp%\reboot.bat
	REG ADD HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce /f /v "iseinstallerreboot" /t REG_SZ /d %Temp%\reboot.bat
	if %iswin8%==1 (
	REG ADD HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\StartPage\ /f /v "OpenAtLogon" /t REG_DWORD /d 0
	)
	exit