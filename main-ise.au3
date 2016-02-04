#pragma compile(FileDescription, ECU Network Setup)
#pragma compile(ProductName, ECU Network Setup)
#pragma compile(ProductVersion, 3.4)
#pragma compile(FileVersion, 3.4)
#pragma compile(LegalCopyright, © Tim Small 2014-2015)
#pragma compile(CompanyName, 'ECU Pirate Techs')

;
;The ECU Network Setup tool
;Created by Tim Small for PirateTechs at East Carolina University
;

#include <GUIConstantsEx.au3>
#include <ServiceControl.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <ProgressConstants.au3>
#include <FileConstants.au3>
#include <Array.au3>
#include <File.au3>
#include <Misc.au3>
#include "ise-avfuncs.au3"
;#include "ise-troubleshoot.au3"
#include "ise-maininstall.au3"
#RequireAdmin

;Core file locations
Global $tempapp = @TempDir & "\ISE-Installer.exe"
Global $mainapp = @AutoItExe
Global $conffile = @TempDir & "\ISEconfig.ini"
Global $extrafolder = @ScriptDir & "\savupdate\"


;This is the version and the build date that will show up on the intro page.
Global $sver = "3.5"
Global $sdate = "02/01/2016"

;After a reboot, we use the temporary app. We do a check here to make sure it's currently not the temp app.
;If it is, it deletes the temp app.
If $tempapp <> $mainapp Then
   FileDelete($tempapp)
EndIf

;Makes sure to not overwrite a pre-exisiting config file.
If FileExists($conffile) == 0 Then
   FileInstall("config.ini", @TempDir & "\ISEconfig.ini")
EndIf

;Reads from the config file if a restore point is needed
;Will more thank likely be changed to IsFirstBoot to maximize effiecieny with extracting files as well.
Global $NeedSysRestore = IniRead($conffile, "Main", "CreateRestorePoint", "True")
Global $NeedExtract = IniRead($conffile, "Main", "ExtractFiles", "True")

;Pre-Variables
Global $iswin8 = False
Global $iswin10 = False
If @OSArch == "X86" Then
   Global $is32 = True
Else
   Global $is32 = False
EndIf

;Detecting if the OS is Windows 8/8.1 or 10.
;Different methods of disabling Windows Defender is done for Windows 8/8.1 and 10, requiring two different functions.
;However, I need to test the Windows 10 method on Windows 8/8.1 as it might work.
If @OSVersion = "WIN_8" Or @OSVersion = "WIN_81" Then
   $iswin10 = True
EndIf

If @OSVersion = "WIN_10" Then
   $iswin10 = True
EndIf

;$isadvanced was never implemented
;Global $isadvanced = False
Global $installsav = True

;Pre-Start deletions and extractions
;Also legacy code
FileDelete(@TempDir & "\avscan.txt")
FileDelete(@TempDir & "\netint.txt")
FileDelete(@TempDir & "\findav.bat")
FileDelete(@TempDir & "\files.exe")
DirRemove(@HomeDrive & "\ISELogs", 1)
DirRemove(@TempDir & "\ISEInstall")
FileInstall("findav.bat", @TempDir & "\findav.bat")
FileInstall("files.exe", @TempDir & "\files.exe")
FileInstall("intnames.bat", @TempDir & "\intnames.bat")
DirCreate(@TempDir & "\ISEInstall")
DirCreate(@HomeDrive & "\ISELogs")
FileInstall("createrestore.vbs", @TempDir & "\ISEInstall\createrestore.vbs")
FileInstall("createrestore.bat", @TempDir & "\ISEInstall\createrestore.bat")

;Creates a base log file. Might deprecate this since the log files for SAV/Cisco are broken.
Global $logname = @HomeDrive & "\ISELogs\Main-log.txt"
Global $SAVlogname = @HomeDrive & "\ISELogs\SAV-install-log.txt"
Global $Ciscologname = @HomeDrive & "\ISELogs\Cisco-install-log.txt"
Global $unCiscologname = @HomeDrive & "\ISELogs\Cisco-uninstall-log.txt"
_FileCreate($logname)
FileWrite($logname, "The ISE Installer log file stores the installer logs and command outputs." & @CRLF)

;Get Cisco Version
Global $curCiscover = "4.9.5.8"

RunWait(@ComSpec & " /c " & "wmic product where name=""Cisco NAC Agent "" get version > " & @TempDir & "\ISEInstall\cisco_ver.txt", "", @SW_HIDE)
FileOpen(@TempDir & "\ISEInstall\cisco_ver.txt")
Global $installedCiscover = FileReadLine(@TempDir & "\ISEInstall\cisco_ver.txt", 2)
$installedCiscover = StringStripWS($installedCiscover, 8)
FileClose(@TempDir & "\ISEInstall\cisco_ver.txt")

If $installedCiscover = "" Then
   $installedCiscover = 0
EndIf

Global $ciscoOutOfDate = False

If $installedCiscover <> $curCiscover Then
   $ciscoOutOfDate = True
EndIf


;Creates GUI to let user know it is making a restore point and extracting core files.
Global $7zipwin = GUICreate("ECU Network Setup", 250, 50, -1, -1, BitXOR($GUI_SS_DEFAULT_GUI, $WS_MINIMIZEBOX))
Global $7zipText = GUICtrlCreateLabel("Creating a restore point...", 0, 10, 250, 30, $SS_CENTER)
GUICtrlSetFont($7ziptext, 14, 400)
GUISetState(@SW_SHOW)

;If it's a first run of the setup tool, it will make a restore point and make note of it in the config file.
;Just a note, this is placed here so that extracted files from the files.exe archive doesn't end up in the restore point.
If $NeedSysRestore = "True" Then
   ;RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore", "SystemRestorePointCreationFrequency", "REG_DWORD", "0")
   ;RunWait(@ComSpec & ' /c ' & @TempDir & "\ISEInstall\createrestore.bat")

   Call("PrepareSysRestore")
   Local $CrtSysRes = Run("PowerShell.exe -ExecutionPolicy Bypass -Command ""Checkpoint-Computer -Description 'ECU Network Setup'""", "")
   ProcessWaitClose($CrtSysRes)
   IniWrite($conffile, "Main", "CreateRestorePoint", "False")
EndIf

GUICtrlSetData($7zipText, "Extracting files...")

If $NeedExtract = "True" Then
   RunWait(@TempDir & '\files.exe -o"' & @TempDir & '/ISEInstall/" -y', "", @SW_HIDE)
   ProcessWaitClose("files.exe")
   IniWrite($conffile, "Main", "ExtractFiles", "False")
EndIf

GUIDelete($7zipwin)

Opt("GUIOnEventMode", 1)
Global $mainwin = GUICreate("ECU Network Setup", 450, 400, -1, -1, BitXOR($GUI_SS_DEFAULT_GUI, $WS_MINIMIZEBOX))

Call("stageOne")

GUISetState(@SW_SHOW)

Global $aPos = WinGetPos("[ACTIVE]")

GUISetState()

   While 1
	  Sleep(100)
   WEnd


Func stageOne() ;Creates the base UI, nothing special about it except contact info and instructions.

   Global $nameText = GUICtrlCreateLabel("ECU Network Setup (BETA)", 0, 10, 450, 20, $SS_CENTER)
   GUICtrlSetFont($nameText, 15, 700)

   Global $headerText = GUICtrlCreateLabel("", 0, 40, 450, 20, $SS_CENTER)
   GUICtrlSetFont($headertext, 11, 600, 2)

   Global $bodyText = GUICtrlCreateLabel("Welcome to the ECU Network Setup tool, please click next to start the installation process." & @CRLF & "" & @CRLF & "If you have any issues or need help, please visit Pirate Techs in Rawl 108 or call us at (252) 328-5407." & @CRLF & "" & @CRLF & "Version: " & $sver & "(" & $sdate & ")", 20, 70, 410, 270)
   If $ciscoOutOfDate = True Then
	  GUICtrlSetData($bodyText, GUICtrlRead($bodyText) & @CRLF & "" & @CRLF & "Cisco is out of date, will be updated.")
   EndIf

  ; If $extrainstall = True Then
;	  GUICtrlSetData($bodyText, GUICtrlRead($bodyText) & "" & @CRLF & "(Offline SAV definitions have been loaded)")
 ;  EndIf
  ; GUICtrlSetFont($bodyText, 10)

   ;Global $buttonBack = GUICtrlCreateButton("Troubleshoot", 5, 360, 75, 30)
   ;GUICtrlSetState($buttonBack, $GUI_HIDE)

   Global $advancedInstall = GUICtrlCreateCheckbox("Advanced Install", 10, 360, 250, 30)
   ;GUICtrlSetState($defaultInstall, $GUI_CHECKED)
   ;Global $runLiveUp = GUICtrlCreateCheckbox("Run Symantec Updates (If Required)", 10, 360, 250, 30)
   ;If $extrainstall = True Then
	;  GUICtrlSetState($runLiveUp, $GUI_UNCHECKED)
	 ; GUICtrlSetState($runLiveUp, $GUI_DISABLE)
   ;Else
	;  GUICtrlSetState($runLiveUp, $GUI_CHECKED)
   ;EndIf

   Global $buttonNext = GUICtrlCreateButton("Next", 395, 360, 50, 30)

   GUICtrlSetOnEvent($buttonNext, "preInstall")
   ;GUICtrlSetOnEvent($buttonBack, "opentrouble")
   GUISetOnEvent($GUI_EVENT_CLOSE, "closedown")

EndFunc

Func preInstall()

   If GUICtrlRead($advancedInstall) = 1 Then
	  Global $isadvanced = True
	  Call("stageChangeInstalls")
   Else
	  Global $isadvanced = False
	  Call("stageTwo")
   EndIf

EndFunc

Func stageChangeInstalls()
   GUICtrlSetState($bodyText, $GUI_HIDE)
   GUICtrlDelete($advancedInstall)

   Global $askinstallnetworkprefs = GUICtrlCreateCheckbox("Install network profiles", 20, 70, 410, 15)
   Global $askinstallsav = GUICtrlCreateCheckbox("Install Symantec Endpoint Protection", 20, 100, 410, 15)
   Global $askinstallcisco = GUICtrlCreateCheckbox("Install Cisco NAC Agent", 20, 130, 410, 15)

   GUICtrlSetOnEvent($buttonNext, "stageTwo")
EndFunc

Func stageTwo() ;Scans for anti-virus suites. It's using the old legacy AV scanner from back in July, but it will be updated before final release.
   GUICtrlDelete($advancedInstall)
   ;Gathering data for advanced install if needed
   If $isadvanced = True Then
	  Global $installnetworkprefs = GUICtrlRead($askinstallnetworkprefs)
	  Global $installsym = GUICtrlRead($askinstallsav)
	  Global $installcisco= GUICtrlRead($askinstallcisco)
	  GUICtrlDelete($askinstallnetworkprefs)
	  GUICtrlDelete($askinstallsav)
	  GUICtrlDelete($askinstallcisco)
   Else
	  Global $installnetworkprefs = 1
	  Global $installsym = 1

	  If $ciscoOutOfDate = True Then
		 Global $installcisco = 1
	  Else
		 Global $installcisco = 0
	  EndIf
   EndIf

   ;Brings back the main text element and hides the next button.
   GUICtrlSetState($bodyText, $GUI_SHOW)
   GUICtrlSetState($buttonNext, $GUI_HIDE)

   ;;Old code for running LiveUpdates during install since it never worked.
   ;;
   ;Local $liv = GUICtrlRead($runLiveUp)
   ;Global $runningLiveUpdate = ""
   ;If $liv = 1 Then
   ;$runningLiveUpdate = True
   ;Else
	;  $runningLiveUpdate = False
   ;EndIf
   ;GUICtrlDelete($runLiveUp)
   ;;

   Global $progrockbar = GUICtrlCreateProgress(5, 360, 440)

   ;GUICtrlSetState($buttonBack, $GUI_HIDE)
   If $installsym = 1 Then

   Local $hasConn = False
   Call("CheckConnection")

   Local $getremoval = False
   If TRUE Then
	  Local $getremoval = True
   EndIf

   GUICtrlSetData($headerText, "Checking for Antivirus software")
   GUICtrlSetData($bodyText, "")

   RunWait(@ComSpec & ' /c ' & @TempDir & "\findav.bat", "",  @SW_HIDE )

   Global $iskasp = FileReadLine(@TempDir & "\avscan.txt", 1)
   Call("kaspbox")

   Global $ismca = FileReadLine(@TempDir & "\avscan.txt", 2)
   Call("mcabox")

   Global $istrend = FileReadLine(@TempDir & "\avscan.txt", 3)
   Call("trendbox")

   Global $isavg = FileReadLine(@TempDir & "\avscan.txt", 4)
   Call("avgbox")

   Global $isavast = FileReadLine(@TempDir & "\avscan.txt", 5)
   Call("avastbox")

   Global $isnorton = FileReadLine(@TempDir & "\avscan.txt", 6)
   Call("norbox")

   Global $iscomodo = FileReadLine(@TempDir & "\avscan.txt", 7)
   Call("comodobox")

   Global $isbitdefend = FileReadLine(@TempDir & "\avscan.txt", 8)
   Call("bitdefendbox")

   Global $isavira = FileReadLine(@TempDir & "\avscan.txt", 9)
   Call("avirabox")

   If $installsav = True Then
	  If $iswin8 = True Then
		 Call("win8checkwindefend")
	  EndIf
	  If $iswin10 = True Then
		 Call("win10checkwindefend")
	  EndIf
   EndIf

   EndIf

   Call("stageThree") ;Considering how outdated the legacy code is, jumping to stage 3 is the best idea.
EndFunc

Func stageThree() ;Sets up 802.1x services and profiles.

   ;GUICtrlSetState($buttonNext, $GUI_DISABLE)

   If $installnetworkprefs = 1 Then

   GUICtrlSetData($headerText, "Setting up network profiles")
   Call("heyohtwo")

   EndIf

   Call("stageFour")

EndFunc

Func stageFour()
   GUICtrlSetData($headerText, "Installing Required Software")

   Call("installdorm")

   GUICtrlDelete($progrockbar)
   Call("everybodycleanup")
   GUICtrlSetOnEvent($buttonNext, "closedown")
   GUICtrlSetData($buttonNext, "Close")
   GUICtrlSetData($bodyText, GUICtrlRead($bodyText) & "" & @CRLF & "All needed software and changes have been made. Click close to exit the program.")
   GUICtrlSetState($buttonNext, $GUI_SHOW)
   FileDelete($conffile) ;Deletes the conf file for future installs to have a clean slate

   ;Old Code Begin
   ;
   ;GUICtrlSetOnEvent($buttonNext, "stageFour")
   ;GUICtrlSetState($buttonNext, $GUI_SHOW)
   ;
   ;Old Code End

EndFunc

Func PrepareSysRestore()
   ;Windows 8 and above require a specific registry edit so that restore points can be created more than once in 24 hours.
   ;Not exactly optimal to do, but this is the best thing to do to have a safe restore point just in case something breaks during install.
   If @OSVersion = "WIN_8" Or @OSVersion = "WIN_81" Or @OSVersion = "WIN_10" Then
	  If $is32 = True Then
		 RegWrite("HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\SystemRestore", "SystemRestorePointCreationFrequency", "REG_DWORD", "0")
	  Else
		 RunWait("REG ADD ""HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\SystemRestore"" /f /v ""SystemRestorePointCreationFrequency"" /t REG_DWORD /d ""0"" /reg:64")
	  EndIf
   EndIf
EndFunc

Func closedown()
   GUISetState(@SW_HIDE)
   Exit
EndFunc