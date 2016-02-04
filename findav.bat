@echo off
@setlocal enableextensions
@cd /d "%~dp0"

set iskas=0
set ismcafee=0
set istrend=0
set isavg=0
set isavast=0
set isnorton=0
set iscomodo=0
set isbitdefendertotal=0
set isavira=0

for /F "tokens=3 delims=: " %%H in ('sc query "mfecore" ^| findstr "        STATE"') do (
  if /I "%%H" NEQ "RUNNING" (
   set ismcafee=1 ) else (
   echo. )
)
	
for /F "tokens=3 delims=: " %%H in ('sc query "MSK80Service" ^| findstr "        STATE"') do (
  if /I "%%H"=="RUNNING" (
   set ismcafee=1 ) else (
   echo. )
)
for /F "tokens=3 delims=: " %%H in ('sc query "McAPExe" ^| findstr "        STATE"') do (
  if /I "%%H"=="RUNNING" (
   set ismcafee=1 ) else (
   echo. )
)
for /F "tokens=3 delims=: " %%H in ('sc query "mfefire" ^| findstr "        STATE"') do (
  if /I "%%H"=="RUNNING" (
   set ismcafee=1 ) else (
   echo. )
)
for /F "tokens=3 delims=: " %%H in ('sc query "HomeNetSvc" ^| findstr "        STATE"') do (
  if /I "%%H"=="RUNNING" (
   set ismcafee=1 ) else (
   echo. )
)	
for /F "tokens=3 delims=: " %%H in ('sc query "MOBKbackup" ^| findstr "        STATE"') do (
  if /I "%%H"=="RUNNING" (
   set ismcafee=1 ) else (
   echo. )
)   
for /F "tokens=3 delims=: " %%H in ('sc query "McMPFSvc" ^| findstr "        STATE"') do (
  if /I "%%H"=="RUNNING" (
   set ismcafee=1 ) else (
   echo. )
)	
for /F "tokens=3 delims=: " %%H in ('sc query "mcpltsvc" ^| findstr "        STATE"') do (
  if /I "%%H"=="RUNNING" (
   set ismcafee=1 ) else (
   echo. )
)
for /F "tokens=3 delims=: " %%H in ('sc query "McProxy" ^| findstr "        STATE"') do (
  if /I "%%H"=="RUNNING" (
   set ismcafee=1 ) else (
   echo. )
)
for /F "tokens=3 delims=: " %%H in ('sc query "McODS" ^| findstr "        STATE"') do (
  if /I "%%H"=="RUNNING" (
   set ismcafee=1 ) else (
   echo. )  
)   
for /F "tokens=3 delims=: " %%H in ('sc query "mfevtp" ^| findstr "        STATE"') do (
  if /I "%%H"=="RUNNING" (
   set ismcafee=1 ) else (
   echo. )
)   
for /F "tokens=3 delims=: " %%H in ('sc query "McNaiAnn" ^| findstr "        STATE"') do (
  if /I "%%H"=="RUNNING" (
   set ismcafee=1 ) else (
   echo. )
)
for /F "tokens=3 delims=: " %%H in ('sc query "Amsp" ^| findstr "        STATE"') do (
  if /I "%%H"=="RUNNING" (
   set istrend=1 ) else (
   echo. )
)
for /F "tokens=3 delims=: " %%H in ('sc query "AVP" ^| findstr "        STATE"') do (
  if /I "%%H"=="RUNNING" (
   set iskas=1 ) else (
   echo. )
)
for /F "tokens=3 delims=: " %%H in ('sc query "avgfws" ^| findstr "        STATE"') do (
  if /I "%%H"=="RUNNING" (
   set isavg=1 ) else (
   echo. )
)
for /F "tokens=3 delims=: " %%H in ('sc query "avgsvc" ^| findstr "        STATE"') do (
  if /I "%%H"=="RUNNING" (
   set isavg=1 ) else (
   echo. )
)
for /F "tokens=3 delims=: " %%H in ('sc query "avgwd" ^| findstr "        STATE"') do (
  if /I "%%H"=="RUNNING" (
   set isavg=1 ) else (
   echo. )
)
for /F "tokens=3 delims=: " %%H in ('sc query "AVGIDSAgent" ^| findstr "        STATE"') do (
  if /I "%%H"=="RUNNING" (
   set isavg=1 ) else (
   echo. )
)
for /F "tokens=3 delims=: " %%H in ('sc query "avast! Antivirus" ^| findstr "        STATE"') do (
  if /I "%%H"=="RUNNING" (
   set isavast=1 ) else (
   echo. )
)
for /F "tokens=3 delims=: " %%H in ('sc query "N360" ^| findstr "        STATE"') do (
  if /I "%%H"=="RUNNING" (
   set isnorton=1 ) else (
   echo. )
)
for /F "tokens=3 delims=: " %%H in ('sc query "NIS" ^| findstr "        STATE"') do (
  if /I "%%H"=="RUNNING" (
   set isnorton=1 ) else (
   echo. )
)
for /F "tokens=3 delims=: " %%H in ('sc query "NS" ^| findstr "        STATE"') do (
  if /I "%%H"=="RUNNING" (
   set isnorton=1 ) else (
   echo. )
)
for /F "tokens=3 delims=: " %%H in ('sc query "NAV" ^| findstr "        STATE"') do (
  if /I "%%H"=="RUNNING" (
   set isnorton=1 ) else (
   echo. )
)
for /F "tokens=3 delims=: " %%H in ('sc query "CmdAgent" ^| findstr "        STATE"') do (
  if /I "%%H"=="RUNNING" (
   set iscomodo=1 ) else (
   echo. )
)
for /F "tokens=3 delims=: " %%H in ('sc query "CmdAgent" ^| findstr "        STATE"') do (
  if /I "%%H"=="RUNNING" (
   set iscomodo=1 ) else (
   echo. )
)
for /F "tokens=3 delims=: " %%H in ('sc query "CLPSLauncher" ^| findstr "        STATE"') do (
  if /I "%%H"=="RUNNING" (
   set iscomodo=1 ) else (
   echo. )
)
for /F "tokens=3 delims=: " %%H in ('sc query "cmdvirth" ^| findstr "        STATE"') do (
  if /I "%%H"=="RUNNING" (
   set iscomodo=1 ) else (
   echo. )
)
for /F "tokens=3 delims=: " %%H in ('sc query "VSSERV" ^| findstr "        STATE"') do (
  if /I "%%H"=="RUNNING" (
   set isbitdefendertotal=1 ) else (
   echo. )
)
for /F "tokens=3 delims=: " %%H in ('sc query "AntiVirService" ^| findstr "        STATE"') do (
  if /I "%%H"=="RUNNING" (
   set isavira=1 ) else (
   echo. )
)
for /F "tokens=3 delims=: " %%H in ('sc query "AntiVirSchedulerService" ^| findstr "        STATE"') do (
  if /I "%%H"=="RUNNING" (
   set isavira=1 ) else (
   echo. )
)
for /F "tokens=3 delims=: " %%H in ('sc query "Avira.OE.ServiceHost" ^| findstr "        STATE"') do (
  if /I "%%H"=="RUNNING" (
   set isavira=1 ) else (
   echo. )
)

type nul > %Temp%\avscan.txt

::Line 1
echo %iskas% >> %Temp%\avscan.txt

::Line 2
echo %ismcafee% >> %Temp%\avscan.txt

::Line 3
echo %istrend% >> %Temp%\avscan.txt

::Line 4
echo %isavg% >> %Temp%\avscan.txt

::Line 5
echo %isavast% >> %Temp%\avscan.txt

::Line 6
echo %isnorton% >> %Temp%\avscan.txt

::Line 7
echo %iscomodo% >> %Temp%\avscan.txt

::Line 8
echo %isbitdefendertotal% >> %Temp%\avscan.txt

::Line 9
echo %isavira% >> %Temp%\avscan.txt