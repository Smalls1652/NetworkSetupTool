Func opentrouble()
   Global $troublewin = GUICreate("ISE-Installer Troubleshoot", 250, 200, -1, -1, BitXOR($GUI_SS_DEFAULT_GUI, $WS_MINIMIZEBOX))

   GUICtrlCreateLabel("Troubleshoot Menu for ISE", 55, 10)

   Global $reseteight = GUICtrlCreateButton("Reset 802.1x", 75, 50, 100)
   Global $resetwinsock = GUICtrlCreateButton("Reset Winsock", 75, 100, 100)
   Global $resetipsettings = GUICtrlCreateButton("Reset IP Settings", 75, 150, 100)

   GUICtrlSetOnEvent($reseteight, "ResetEightOhTwo")
   GUICtrlSetOnEvent($resetwinsock, "ResetWinsock")
   GUICtrlSetOnEvent($resetipsettings, "ResetNetworkSettings")
   GUISetOnEvent($GUI_EVENT_CLOSE, "closedowntrouble")

   GUISetState(@SW_SHOW)

    While 1
        Switch GUIGetMsg()
            Case $GUI_EVENT_CLOSE
                ExitLoop
		 EndSwitch
   WEnd

EndFunc

Func ResetEightOhTwo()
   RunWait("sc config dot3svc start= auto")
   RunWait("sc start dot3svc")
   RunWait("netsh lan add profile filename=" & @TempDir & "\ISEInstall\files\8021x.xml")
   RunWait("netsh wlan add profile filename=" & @TempDir & "\ISEInstall\files\campusliving.xml")
   MsgBox(0, "802.1x Reset", "LAN and Wireless profiles for 802.1x have been reset.")
EndFunc

Func ResetWinsock()
   RunWait("netsh winsock reset")
   MsgBox(0, "Winsock Reset", "The winsock catalog has been reset, but won't be completed until the next restart. Please restart your machine as soon as possible.")
EndFunc

Func ResetNetworkSettings()
   RunWait(@ComSpec & ' /c ' & @TempDir & "\intnames.bat", "",  @SW_HIDE )

   Local $netlines = _FileCountLines(@TempDir & "\netint.txt")
   Local $curline = 1

   While $curline <= $netlines
	  Local $nettname = FileReadLine(@TempDir & "\netint.txt", $curline)
	  RunWait("netsh interface ipv4 set dns " & $nettname & " dhcp")
	  RunWait("netsh interface ipv4 set address " & $nettname & " dhcp")
	  $curline = $curline + 1
   WEnd
   MsgBox(0, "Reset Network Settings", "Successfully reset all network settings.")
EndFunc

Func closedowntrouble()
   GUIDelete($troublewin)
EndFunc