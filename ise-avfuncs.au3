;Asks for uninstall of Kaspersky

Func kaspbox()
   If $iskasp = 1 Then
	  Local $kaspask = MsgBox(4, "Kaspersky was found.", "Kaspersky is an approved anti-virus. Do you want to uninstall it and install Symantec?")
	  If $kaspask = 6 Then
		 MsgBox(0, "Instructions!", "Please follow all instructions and restart when needed. The script will restart when your computer starts back up.")
		 FileCopy(@AutoItExe, @TempDir & "\ISE-Installer.exe")
		 FileInstall("prereboot.bat", @TempDir & "\prereboot.bat")
		 RunWait(@ComSpec & ' /c ' & @TempDir & '\prereboot.bat')
		 ;Call("WriteExtr")
		 Run(@TempDir & "\ISEInstall\files\kavremover.exe")
		 Exit
	  Else
		 MsgBox(0, "Kaspersky was found.", "Kaspersky will not be uninstalled.")
		 $installsav = False
	  EndIf
   EndIf
EndFunc

;Asks for uninstall of McAfee
Func mcabox()
   If $ismca = 1 Then
	  Local $mcaask = MsgBox(4, "McAfee was found.", "McAfee is an approved anti-virus. Do you want to uninstall it and install Symantec?")
	  If $mcaask = 6 Then
		 MsgBox(0, "Instructions!", "Please follow all instructions and restart when needed. The script will restart when your computer starts back up.")
		 FileCopy(@AutoItExe, @TempDir & "\ISE-Installer.exe")
		 FileInstall("prereboot.bat", @TempDir & "\prereboot.bat")
		 RunWait(@ComSpec & ' /c ' & @TempDir & '\prereboot.bat')
		 ;Call("WriteExtr")
		 Run(@TempDir & "\ISEInstall\files\MCPR.exe")
		 Exit
	  Else
		 MsgBox(0, "McAfee was found.", "McAfee will not be uninstalled.")
		 $installsav = False
	  EndIf
   EndIf
EndFunc

;Asks for uninstall of Trend Micro
Func trendbox()
   If $istrend = 1 Then
	  Local $trendask = MsgBox(4, "Trend Micro was found.", "Trend Micro is an approved anti-virus. Do you want to uninstall it and install Symantec?")
	  If $trendask = 6 Then
		 MsgBox(0, "Instructions!", "Please follow all instructions and restart when needed. The script will restart when your computer starts back up.")
		 FileCopy(@AutoItExe, @TempDir & "\ISE-Installer.exe")
		 FileInstall("prereboot.bat", @TempDir & "\prereboot.bat")
		 RunWait(@ComSpec & ' /c ' & @TempDir & '\prereboot.bat')
		 ;Call("WriteExtr")
		 Run(@TempDir & "\ISEInstall\files\trendremove.exe")
		 Exit
	  Else
		 MsgBox(0, "Trend Micro was found.", "Trend Micro will not be uninstalled.")
		 $installsav = False
	  EndIf
   EndIf
EndFunc

;Asks for uninstall of AVG
Func avgbox()
   If $isavg = 1 Then
	  Local $avgask = MsgBox(0, "AVG was found.", "AVG is not an approved anti-virus. Click ""Ok"" to uninstall it and install Symantec.")
	  MsgBox(0, "Instructions!", "Please follow all instructions and restart when needed. The script will restart when your computer starts back up.")
	  FileCopy(@AutoItExe, @TempDir & "\ISE-Installer.exe")
	  FileInstall("prereboot.bat", @TempDir & "\prereboot.bat")
	  RunWait(@ComSpec & ' /c ' & @TempDir & '\prereboot.bat')
	  ;Call("WriteExtr")
	  Run(@TempDir & "\ISEInstall\files\AVG_Remover.exe")
	  Exit
   EndIf
EndFunc

;Asks for uninstall of Avast
Func avastbox()
   If $isavast = 1 Then
	  Local $avastask = MsgBox(0, "Avast was found.", "Avast is not an approved anti-virus. Click ""Ok"" to uninstall it and install Symantec.")
	  MsgBox(0, "Instructions!", "The Add/Remove control panel window will open up. Uninstall Avast, restart the computer, and then rerun the script.")
	  ;FileCopy(@AutoItExe, @TempDir & "\ISE-Installer.exe")
	  ;FileInstall("prereboot.bat", @TempDir & "\prereboot.bat")
	  ;RunWait(@ComSpec & ' /c ' & @TempDir & '\prereboot.bat')
	  ;Call("WriteExtr")
	  RunWait(@ComSpec & ' /c control appwiz.cpl')
	  Exit
   EndIf
EndFunc

;Asks for uninstall of Norton
Func norbox()
   If $isnorton = 1 Then
	  Local $norask = MsgBox(4, "Norton was found.", "Norton is an approved anti-virus. Do you want to uninstall it and install Symantec?")
	  If $norask = 6 Then
		 MsgBox(0, "Instructions!", "Please follow all instructions and restart when needed. The script will restart when your computer starts back up.")
		 FileCopy(@AutoItExe, @TempDir & "\ISE-Installer.exe")
		 FileInstall("prereboot.bat", @TempDir & "\prereboot.bat")
		 RunWait(@ComSpec & ' /c ' & @TempDir & '\prereboot.bat')
		 ;Call("WriteExtr")
		 Run(@TempDir & "\ISEInstall\files\Norton_Removal_Tool.exe")
		 Exit
	  Else
		 MsgBox(0, "Norton was found.", "Norton will not be uninstalled.")
		 $installsav = False
	  EndIf
   EndIf
EndFunc

;Asks for uninstall of Comodo
Func comodobox()
   If $iscomodo = 1 Then
	  Local $comodoask = MsgBox(0, "Comodo was found.", "Comodo is not an approved anti-virus. Click ""Ok"" to uninstall it and install Symantec.")
	  MsgBox(0, "Instructions!", "The Add/Remove control panel window will open up. Uninstall Comofo, restart the computer, and then rerun the script.")
	  ;FileCopy(@AutoItExe, @TempDir & "\ISE-Installer.exe")
	  ;FileInstall("prereboot.bat", @TempDir & "\prereboot.bat")
	  ;RunWait(@ComSpec & ' /c ' & @TempDir & '\prereboot.bat')
	  ;Call("WriteExtr")
	  RunWait(@ComSpec & ' /c control appwiz.cpl')
	  Exit
   EndIf
EndFunc

;Asks for uninstall of Bit Defender
Func bitdefendbox()
   If $isbitdefend = 1 Then
	  Local $bitdefendask = MsgBox(0, "Bit Defender was found.", "Bit Defender is not an approved anti-virus. Click ""Ok"" to uninstall it and install Symantec.")
	  MsgBox(0, "Instructions!", "Please follow all instructions and restart when needed. The script will restart when your computer starts back up.")
	  FileCopy(@AutoItExe, @TempDir & "\ISE-Installer.exe")
	  FileInstall("prereboot.bat", @TempDir & "\prereboot.bat")
	  RunWait(@ComSpec & ' /c ' & @TempDir & '\prereboot.bat')
	  ;Call("WriteExtr")
	  Run(@TempDir & "\ISEInstall\files\Bitdefender_TotalUninstallTool.exe")
	  Exit
   EndIf
EndFunc