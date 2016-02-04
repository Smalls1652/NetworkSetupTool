Func StartSRP()

If @OSVersion = "WIN_VISTA" Or @OSVersion = "WIN_7" Then
    If $CmdLine[0] = 0 Then
        $objShell = ObjCreate("Shell.Application")
        ; $objShell.ShellExecute "wscript.exe", """" & _
        ; WScript.ScriptFullName & """" & " uac","", "runas", 1
    Else
	  CreateSRP()
    EndIf
EndIf

If @OSVersion = "WIN_8" Or @OSVersion = "WIN_81" Or @OSVersion = "WIN_10" Then

   RegWrite("HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore\", "SystemRestorePointCreationFrequency", "REG_DWORD", "0")

   If $CmdLine[0] = 0 Then
	  $objShell = ObjCreate("Shell.Application")
	  ; $objShell.ShellExecute "wscript.exe", """" & _
	  ; WScript.ScriptFullName & """" & " uac","", "runas", 1
   Else
	  CreateSRP()
   EndIf
EndIf
EndFunc

Func CreateSRP()
    $SRP = ObjGet("winmgmts:.rootdefault:Systemrestore")
    $sDesc = "ECU Network Setup"
    If StringStripWS($sDesc, 3) <> "" Then
        $sOut = $RP.createrestorepoint($sDesc, 0, 100)
        If $sOut <> 0 Then
            MsgBox(16, "Error", "Error " & $sOut & ": Unable to create Restore Point.")
        EndIf
    EndIf
EndFunc