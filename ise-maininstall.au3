Func installdorm()

	  Call("changeProgBar", 30)

   ;Symantec install

   If $installsav = True And $installsym = 1 Then

	  FileWrite($logname, @CRLF & "Starting Symantec install")
	  FileWrite($logname, @CRLF & "----------------------")
	  FileWrite($logname, @CRLF)
	  FileWrite($logname, "SAV log file is located at: " & $SAVlogname)

	  GUICtrlSetData($bodyText, "Installing Symantec... ")
	  Call("changeProgBar", 50)

	  If $is32 = True Then
		 RunWait("msiexec /i " & @TempDir & "\ISEInstall\files\SEP\Sep.msi /quiet /L*V " & $SAVlogname)
	  Else
		 RunWait("msiexec /i " & @TempDir & "\ISEInstall\files\SEPx64\Sep64.msi /quiet /L*V " & $SAVlogname)
	  EndIf

	  GUICtrlSetData($bodyText, GUICtrlRead($bodyText) & "Finished." & @CRLF)

	  ;If $runningLiveUpdate = True Then ;Checks the checkbox to run Symantec LiveUpdate
		; GUICtrlSetData($bodyText, GUICtrlRead($bodyText) & "" & @CRLF & "Running Symantec LiveUpdate... ")
		 ;$ret = DllCall("WinInet.dll","int","InternetGetConnectedState","int_ptr",0,"int",0) ;Checks for Internet
;
;		 If $ret[0] Then
;			$sX = TRUE ;Connected
;		 Else
;			$sX = FALSE ;Not connected
;		 Endif
;
;		 If $sX = TRUE Then
;			RunWait(@ProgramFilesDir & "/Symantec/Symantec Endpoint Protection/SepLiveUpdate.exe", "", @SW_MINIMIZE)
;			GUICtrlSetData($bodyText, GUICtrlRead($bodyText) & "Finished." & @CRLF)
;		 Else
;			GUICtrlSetData($bodyText, GUICtrlRead($bodyText) & "Failed (No Internet Connection)." & @CRLF)
;		 EndIf
;	  EndIf

;	  If $extrainstall = True Then
;		 GUICtrlSetData($bodyText, GUICtrlRead($bodyText) & "" & @CRLF & "Running Symantec Offline updates... ")
;		 For $i = 1 To $extrafiles[0]
;			RunWait($extrafiles[$i] & " /q")
;		 Next
;		 GUICtrlSetData($bodyText, GUICtrlRead($bodyText) & "Finished." & @CRLF)
;	  EndIf

   Else
	  GUICtrlSetData($bodyText, "Skipping Symantec Install..." & @CRLF)
   EndIf
   FileWrite($logname, @CRLF)

   ;End Symantec install

   ;Cisco NAC Agent uninstall
   ;
   ;This is done to prevent any errors in the install/upgrade process from a previous version of the NAC Agent.

   If $installcisco = 1 Then
   FileWrite($logname, @CRLF & "Starting Cisco NAC uninstall")
   FileWrite($logname, @CRLF & "----------------------")
   FileWrite($logname, @CRLF)
   FileWrite($logname, "Cisco uninstall log file is located at: " & $unCiscologname)

   Call("changeProgBar", 60)
   GUICtrlSetData($bodyText, GUICtrlRead($bodyText) & "" & @CRLF & "Uninstalling Cisco NAC... ")
   ;RunWait("msiexec /x {3657178B-CDB0-46B0-8C43-E1FB50DA313D} /quiet /L*V " & $unCiscologname)
   RunWait("wmic product where name=""Cisco NAC Agent "" uninstall", "", @SW_HIDE)
   GUICtrlSetData($bodyText, GUICtrlRead($bodyText) & "Finished." & @CRLF)
   FileWrite($logname, @CRLF)

   ;End Cisco NAC Agent uninstall

   ;Cisco NAC Agent install

   FileWrite($logname, @CRLF & "Starting Cisco NAC install")
   FileWrite($logname, @CRLF & "----------------------")
   FileWrite($logname, @CRLF)
   FileWrite($logname, "Cisco log file is located at: " & $Ciscologname)

   Call("changeProgBar", 70)
   GUICtrlSetData($bodyText, GUICtrlRead($bodyText) & "" & @CRLF & "Installing Cisco NAC... ")
   RunWait("msiexec /i " & @TempDir & "\ISEInstall\files\nacagent.msi /quiet /L*V " & $Ciscologname)
   GUICtrlSetData($bodyText, GUICtrlRead($bodyText) & "Finished." & @CRLF)
   Call("changeProgBar", 100)
   FileWrite($logname, @CRLF)

   Else
   GUICtrlSetData($bodyText, GUICtrlRead($bodyText) & "" & @CRLF & "Skipping Cisco Install... " & @CRLF)
   EndIf

   ;End Cisco NAC Agent install
EndFunc

Func win8checkwindefend() ;Revamped to automatically disable Windows Defender with simulated clicks. A fallback method will be added later.

   Local $iswindon = _ServiceRunning("", "WinDefend")
   While $iswindon = 1
	  ;MsgBox(64, "Windows Defender needs to be disabled.", "This computer is running Windows 8/8.1." & @CRLF & "In order to prevent any issues with the SAV install, Windows Defender must be disabled." & @CRLF & "Here's how to disable Windows Defender:" & @CRLF & "1. Click Settings." & @CRLF & "2. Uncheck ""Turn on real-time protection""" & @CRLF & "3. Click Administrator." & @CRLF & "4. Uncheck ""Turn on this app.""" & @CRLF & "5. Click save changes." & @CRLF & "6. A prompt should pop up and say that it is turned off." & @CRLF & "7. Click close and the script will proceed.")
	  ;RunWait(@HomeDrive & "\Program Files\Windows Defender\MSASCui.exe")
	  Run(@HomeDrive & "\Program Files\Windows Defender\MSASCui.exe")
	  WinWaitActive("Windows Defender")
	  ;WinActivate("Windows Defender")
	  ControlClick("Windows Defender", "Settings", "[CLASS:ATL:BUTTON; INSTANCE:4]")
	  ControlClick("Windows Defender", "Settings", "[CLASS:ATL:SysListView32; INSTANCE:1]", "left", 1, 49, 127)
	  ControlClick("Windows Defender", "Settings", "[CLASS:ATL:BUTTON; INSTANCE:16]", "left", 1, 6, 14)
	  ControlClick("Windows Defender", "Settings", "[CLASS:ATL:BUTTON; INSTANCE:17]", "left", 1, 32, 10)
	  WinWaitActive("Windows Defender", "&Close")
	  ControlClick("Windows Defender", "&Close", "[CLASS:Button; INSTANCE:1]", "left", 1, 31, 13)

	  $iswindon = _ServiceRunning("", "WinDefend")

	  If $iswindon = 1 Then
		 ;MsgBox(16, "Windows Defender needs to be disabled.", "Warning: Windows Defender was not disabled!")
		 Call("win8checkwindefend")
	  EndIf
   WEnd
EndFunc

Func win10checkwindefend() ;This may actually work for Windows 8/8.1. Need to test it in the future.
   Local $iswindon = _ServiceRunning("", "WinDefend")
	  If $is32 = True Then
		 Run(@TempDir & "\ISEInstall\files\nircmd32.exe runassystem REG ADD ""HKLM\Software\Microsoft\Windows Defender"" /f /v ""DisableAntiSpyware"" /t REG_DWORD /d 1", "", @SW_HIDE)
		 Run(@TempDir & "\ISEInstall\files\nircmd32.exe runassystem REG ADD ""HKLM\Software\Microsoft\Windows Defender\Real-Time Protection"" /f /v ""DisableOnAccessProtection"" /t REG_DWORD /d 1", "", @SW_HIDE)
		 Run(@TempDir & "\ISEInstall\files\nircmd32.exe runassystem REG ADD ""HKLM\Software\Microsoft\Windows Defender\Real-Time Protection"" /f /v ""DisableScanOnRealtimeEnable"" /t REG_DWORD /d 1", "", @SW_HIDE)
	  Else
		 Run(@TempDir & "\ISEInstall\files\nircmd64.exe runassystem REG ADD ""HKLM\Software\Microsoft\Windows Defender"" /f /v ""DisableAntiSpyware"" /t REG_DWORD /d 1", "", @SW_HIDE)
		 Run(@TempDir & "\ISEInstall\files\nircmd64.exe runassystem REG ADD ""HKLM\Software\Microsoft\Windows Defender\Real-Time Protection"" /f /v ""DisableOnAccessProtection"" /t REG_DWORD /d 1", "", @SW_HIDE)
		 Run(@TempDir & "\ISEInstall\files\nircmd64.exe runassystem REG ADD ""HKLM\Software\Microsoft\Windows Defender\Real-Time Protection"" /f /v ""DisableScanOnRealtimeEnable"" /t REG_DWORD /d 1", "", @SW_HIDE)
	  EndIf
	  $iswindon = _ServiceRunning("", "WinDefend")
EndFunc

Func heyohtwo()


   FileWrite($logname, @CRLF & "Output of network and service commands")
   FileWrite($logname, @CRLF & "----------------------")

   ;Remove any conflicting IP/WINSOCK settings
   Local $resetIPvFOUR = RunWait(@ComSpec & " /C netsh interface ipv4 reset", "", @SW_HIDE, $STDOUT_CHILD)
   Local $resetIPvSIX = RunWait(@ComSpec & " /C netsh interface ipv6 reset", "", @SW_HIDE, $STDOUT_CHILD)
   Local $resetPROXY = RunWait(@ComSpec & " /C netsh interface portproxy reset", "", @SW_HIDE, $STDOUT_CHILD)
   Local $resetWINSOCK = RunWait(@ComSpec & " /C netsh winsock reset", "", @SW_HIDE, $STDOUT_CHILD)

   ;;Restarts should be done after all installs are finished.

   ;Make 802.1x service start on startup
   Call("changeProgBar", 0)
   GUICtrlSetData($bodyText, "Setting 802.1x service to start automatically...")
   Local $servStart = RunWait(@ComSpec & " /C sc config dot3svc start= auto", "", @SW_HIDE, $STDOUT_CHILD)
   ProcessWaitClose($servStart)
   Local $servStartoutput = StdoutRead($servStart)
   FileWrite($logname, @CRLF)
   FileWrite($logname, $servStartoutput)
   FileWrite($logname, @CRLF)
   GUICtrlSetData($bodyText, GUICtrlRead($bodyText) & "Finished." & @CRLF)

   ;Start the 802.1x service
   Call("changeProgBar", 5)
   GUICtrlSetData($bodyText, GUICtrlRead($bodyText) & "" & @CRLF & "Starting the 802.1x service... ")
   Local $servAuto = Run(@ComSpec & " /C sc start dot3svc", "", @SW_HIDE, $STDOUT_CHILD)
   ProcessWaitClose($servAuto)
   Local $servAutooutput = StdoutRead($servAuto)
   FileWrite($logname, @CRLF)
   FileWrite($logname, $servAutooutput)
   FileWrite($logname, @CRLF)
   GUICtrlSetData($bodyText, GUICtrlRead($bodyText) & "Finished." & @CRLF)

   ;Adds network profiles for the ethernet and Campus-Living wireless network.
   Call("changeProgBar", 10)
   GUICtrlSetData($bodyText, GUICtrlRead($bodyText) & "" & @CRLF & "Adding ethernet/wireless profiles... ")
   Local $ethProfile = Run(@ComSpec & " /C netsh lan add profile filename=" & @TempDir & "\ISEInstall\files\8021x.xml", "", @SW_HIDE, $STDOUT_CHILD)
   ProcessWaitClose($ethProfile)
   Local $ethProfileoutput = StdoutRead($ethProfile)
   FileWrite($logname, @CRLF)
   FileWrite($logname, $ethProfileoutput)
   FileWrite($logname, @CRLF)
   RunWait("netsh wlan delete profile name=""Campus-Living""", "", @SW_HIDE)
   RunWait("netsh wlan delete profile name=""buccaneer""", "", @SW_HIDE)
   Local $clProfile = Run(@ComSpec & " /C netsh wlan add profile filename=" & @TempDir & "\ISEInstall\files\campusliving.xml", "", @SW_HIDE, $STDOUT_CHILD)
   ProcessWaitClose($clProfile)
   Local $clProfileoutput = StdoutRead($clProfile)
   FileWrite($logname, $clProfileoutput)
   FileWrite($logname, @CRLF)
   Local $bucProfile = Run(@ComSpec & " /C netsh wlan add profile filename=" & @TempDir & "\ISEInstall\files\buccaneer.xml", "", @SW_HIDE, $STDOUT_CHILD)
   ProcessWaitClose($bucProfile)
   Local $bucProfileoutput = StdoutRead($bucProfile)
   FileWrite($logname, $bucProfileoutput)
   FileWrite($logname, @CRLF)

   Call("changeProgBar", 20)
EndFunc

Func changeProgBar($y) ;Usage: Call(("changeProgBar", number)

   Local $z = GUICtrlRead($progrockbar)

   While $z <= $y
	  $z = $z + 1
	  GUICtrlSetData($progrockbar, $z)
   WEnd
EndFunc

Func CheckConnection()

   $ret = DllCall("WinInet.dll","int","InternetGetConnectedState","int_ptr",0,"int",0)

   If $ret[0] Then
	  $hasConn = True ;Connected
   Else
	  $hasConn = False ;Not connected
   Endif

EndFunc

Func everybodycleanup() ;This removes all of the files associated with the installer.
   DirRemove(@TempDir & "\ISEInstall", 1)
   FileDelete(@TempDir & "\reboot.bat")
   FileDelete(@TempDir & "\avscan.txt")
   FileDelete(@TempDir & "\netint.txt")
   FileDelete(@TempDir & "\findav.bat")
   FileDelete(@TempDir & "\intnames.bat")
   FileDelete(@TempDir & "\files.exe")
EndFunc