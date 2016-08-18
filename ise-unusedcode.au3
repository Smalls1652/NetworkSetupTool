;; Behold! Code that never shall be used again!
;;
;; Maybe.

;;This was used for installing offline SAV updates.
;
;Global $extrainstall = False
;If FileExists($extrafolder) == 1 Then
;   If $extrafolder <> @TempDir & "\savupdate\" Then
;	  DirCopy($extrafolder, @TempDir & "\savupdate\")
;   EndIf
;
;   Global $extrafiles = _FileListToArray($extrafolder, "*", 1, True)
;   If @error = 1 Or @error = 2 Or @error = 3 Or @error = 4 Then
;	  $extrainstall = False
;   Else
;	  $extrainstall = True
;   EndIf
;

   ;For $i = 1 To $extrafiles[0]
	  ;MsgBox(0, "", $extrafiles[$i])
   ;Next

;EndIf