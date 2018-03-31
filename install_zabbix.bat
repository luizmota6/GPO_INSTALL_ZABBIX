@echo off

set SERVERWIN="IP DO SERVER"
set SERVERZABBIX="IP DO SERVER"

wmic os get osarchitecture | findstr "64-bit" >NUL && SET ARCH=64-bit || SET ARCH=32-bit


if %ARCH% == 64-bit (
	GOTO :64bit 
) else (
	GOTO :32bit
)

:32bit
echo "32 bit Operating System" >System.txt
if exist "C:\zabbix_x86" GOTO exit
mkdir C:\zabbix_x86
robocopy \\%SERVERWIN%\NETLOGON\zabbix_deploy_x86\zabbix_x86 "C:\zabbix_x86"  /e /tee /log:gravadox86.log /r:1 /w:1
echo Server=%SERVERZABBIX% >> C:\zabbix_x86\zabbix_agentd.conf
echo Hostname=%computername% >> C:\zabbix_x86\zabbix_agentd.conf
echo StartAgents=5 >> C:\zabbix_x86\zabbix_agentd.conf
echo DebugLevel=3 >> C:\zabbix_x86\zabbix_agentd.conf
echo LogFile=C:\zabbix_x86\zabbix_agentd.log >> C:\zabbix_x86\zabbix_agentd.conf
echo Timeout=3 >> C:\zabbix_x86\zabbix_agentd.conf

C:\zabbix_x86\zabbix_agentd.exe --config C:\zabbix_x86\zabbix_agentd.conf --install
net start "Zabbix Agent"

GOTO SUCCESS
GOTO exit


:64bit
echo "64 bit Operating System" >System.txt
if exist "C:\zabbix_x64" GOTO exit
mkdir C:\zabbix_x64
robocopy \\%SERVERWIN%\NETLOGON\zabbix_deploy_x64\zabbix_x64 "C:\zabbix_x64"  /e /tee /log:gravadox64.log /r:1 /w:1
echo Server=%SERVERZABBIX% >> C:\zabbix_x64\zabbix_agentd.conf
echo Hostname=%computername% >> C:\zabbix_x64\zabbix_agentd.conf
echo StartAgents=5 >> C:\zabbix_x64\zabbix_agentd.conf
echo DebugLevel=3 >> C:\zabbix_x64\zabbix_agentd.conf
echo LogFile=C:\zabbix_x64\zabbix_agentd.log >> C:\zabbix_x64\zabbix_agentd.conf
echo Timeout=3 >> C:\zabbix_x64\zabbix_agentd.conf

C:\zabbix_x64\zabbix_agentd.exe --config C:\zabbix_x64\zabbix_agentd.conf --install
net start "Zabbix Agent"


GOTO exit
GOTO SUCCESS





