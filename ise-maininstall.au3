Func installdorm()

	  Call("changeProgBar", 30)

   ;Making some return code variables to alert users of install errors.

   ;Symantec install

   If $installsav = True And $installsym = 1 Then

	  FileWrite($logname, @CRLF & "Starting Symantec install")
	  FileWrite($logname, @CRLF & "----------------------")
	  FileWrite($logname, @CRLF)
	  ;FileWrite($logname, "SAV log file is located at: " & $SAVlogname)

	  GUICtrlSetData($bodyText, "Installing Symantec... ")
	  Call("changeProgBar", 50)

	  If $is32 = True Then
		 Local $savrunins = RunWait("msiexec /i " & @TempDir & "\ISEInstall\files\SEP\Sep.msi /quiet /L*V " & $SAVlogname)
	  Else
		 Local $savrunins = RunWait("msiexec /i " & @TempDir & "\ISEInstall\files\SEPx64\Sep64.msi /quiet /L*V " & $SAVlogname)
	  EndIf

	  Local $openSAVLog = FileOpen($SAVlogname)
	  Local $readSAVLog = FileRead($openSAVlog)
	  FileWrite($logname, $readSAVLog & "" & @CRLF)
	  FileClose($openSAVLog)

	  If $savrunins = "0" Then
		 GUICtrlSetData($bodyText, GUICtrlRead($bodyText) & "Finished." & @CRLF)
	  Else
		 $SAVhadError = True
		 GUICtrlSetData($bodyText, GUICtrlRead($bodyText) & "Failed (Error " & $savrunins & ")" & @CRLF)
	  EndIf

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

   Call("changeProgBar", 60)
   GUICtrlSetData($bodyText, GUICtrlRead($bodyText) & "" & @CRLF & "Uninstalling Cisco NAC... ")
   Local $runUnCisco = Run("wmic product where name=""Cisco NAC Agent "" uninstall", "", @SW_HIDE, $STDOUT_CHILD)
   ProcessWaitClose($runUnCisco)
   Local $runUnCiscooutput = StdoutRead($runUnCisco)
   FileWrite($logname, @CRLF)
   FileWrite($logname, $runUnCiscooutput)
   GUICtrlSetData($bodyText, GUICtrlRead($bodyText) & "Finished." & @CRLF)
   FileWrite($logname, @CRLF)

   ;End Cisco NAC Agent uninstall

   ;Cisco NAC Agent install

   FileWrite($logname, @CRLF & "Starting Cisco NAC install")
   FileWrite($logname, @CRLF & "----------------------")
   FileWrite($logname, @CRLF)
   ;FileWrite($logname, "Cisco log file is located at: " & $Ciscologname)

   Call("changeProgBar", 70)
   GUICtrlSetData($bodyText, GUICtrlRead($bodyText) & "" & @CRLF & "Installing Cisco NAC... ")
   Local $ciscorunins = RunWait("msiexec /i " & @TempDir & "\ISEInstall\files\nacagent.msi /quiet /L*V " & $Ciscologname)

   Local $openCiscoLog = FileOpen($Ciscologname)
   Local $readCiscoLog = FileRead($openCiscolog)
   FileWrite($logname, $readCiscoLog & "" & @CRLF)
   FileClose($openCiscoLog)

   If $ciscorunins = "0" Then
	  GUICtrlSetData($bodyText, GUICtrlRead($bodyText) & "Finished." & @CRLF)
   Else
	  $CiscohadError = True
	  GUICtrlSetData($bodyText, GUICtrlRead($bodyText) & "Failed (Error " & $ciscorunins & ")." & @CRLF)
   EndIf

   Call("changeProgBar", 100)
   FileWrite($logname, @CRLF)

   Else
   GUICtrlSetData($bodyText, GUICtrlRead($bodyText) & "" & @CRLF & "Skipping Cisco Install... " & @CRLF)
   EndIf

   ;End Cisco NAC Agent install
EndFunc

Func win10checkwindefend() ;As of March 1st, 2016... This method is not going to work on updated Windows 10 machines. It will still work for non-updated Windows 10 and Windows 8 machines.
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


   ;Remove any conflicting IP/WINSOCK settings
   Local $resetIPvFOUR = RunWait(@ComSpec & " /C netsh interface ipv4 reset", "", @SW_HIDE, $STDOUT_CHILD)
   Local $resetIPvSIX = RunWait(@ComSpec & " /C netsh interface ipv6 reset", "", @SW_HIDE, $STDOUT_CHILD)
   Local $resetPROXY = RunWait(@ComSpec & " /C netsh interface portproxy reset", "", @SW_HIDE, $STDOUT_CHILD)
   Local $resetWINSOCK = RunWait(@ComSpec & " /C netsh winsock reset", "", @SW_HIDE, $STDOUT_CHILD)

   ;;Restarts should be done after all installs are finished.

   ;Make 802.1x service start on startup
   Call("changeProgBar", 0)
   GUICtrlSetData($bodyText, "Setting 802.1x service to start automatically...")
   Local $servStart = Run(@ComSpec & " /C sc config dot3svc start=auto", "", @SW_HIDE, $STDOUT_CHILD)
   ProcessWaitClose($servStart)
   Local $servStartoutput = StdoutRead($servStart)
   FileWrite($logname, @CRLF & "Setting 802.1x service to start automatically")
   FileWrite($logname, @CRLF & "----------------------")
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
   FileWrite($logname, @CRLF & "Starting the 802.1x service")
   FileWrite($logname, @CRLF & "----------------------")
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
   FileWrite($logname, @CRLF & "Adding wireless/ethernet profiles")
   FileWrite($logname, @CRLF & "----------------------")
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
