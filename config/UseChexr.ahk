#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetBatchLines -1

MakeChexrGui:
if (AllowChexr = 0) {
	msgbox, pls compress a video first.
	Return
}

ItsANewSource := 0
ChexrWasUsed := 1

Gui, chexr:Color, DDCEE9
SetWorkingDir %A_ScriptDir%
SetBatchLines -1

Gui chexr:Add, Edit, +Center x43 y59 w120 h21 vCompressedTargetValue, 0088
Gui chexr:Add, Edit, +Center x43 y109 w120 h21 vCompressedReplaceValue, 4588
Gui chexr:Add, Text, x68 y34 w66 h23 +0x200, Target Value
Gui chexr:Add, Text, x56 y84 w98 h23 +0x200, Replacement Value
Gui chexr:Add, Edit, +Center x216 y59 w120 h21 vDatamoshedTargetValue, 2472
Gui chexr:Add, Edit, +Center x217 y109 w120 h21 vDatamoshedReplaceValue, 2200
Gui chexr:Add, Text, x243 y34 w66 h23 +0x200, Target Value
Gui chexr:Add, Text, x230 y84 w98 h23 +0x200, Replacement Value
Gui chexr:Add, GroupBox, x34 y12 w146 h196, Compressed AVI
Gui chexr:Add, GroupBox, x206 y11 w146 h196 +0x200, Datamoshed AVI
Gui chexr:Add, Button, x103 y224 w47 h40 gApplyHexEditOnCompressedAVI, Apply
;Gui chexr:Add, CheckBox, x161 y21 w16 h16, CheckBox
;Gui chexr:Add, CheckBox, x211 y21 w16 h16, CheckBox
Gui chexr:Add, Button, x55 y224 w47 h40 gViewHexEditOnCompressedAVI, View
Gui chexr:Add, Button, x283 y224 w47 h40 gApplyHexEditOnDatamoshedAVI, Apply
Gui chexr:Add, Button, x235 y224 w47 h40 gViewHexEditOnDatamoshedAVI, View
Gui chexr:Add, Button, x165 y232 w55 h24 gCloseWindow, Im Done
Gui chexr:Add, Edit, +Center x52 y161 w49 h21 vSkipByteCompressedVar, 20000
Gui chexr:Add, Edit, +Center x109 y161 w49 h21 vMaxReplaceTimesCompressedVar, 10
Gui chexr:Add, CheckBox, x71 y185 w12 h12 vCompressedSkipVar gEnableCompressedSkipAmount, CheckBox
Gui chexr:Add, CheckBox, x127 y185 w12 h12 vCompressedMaxVar gEnableCompressedMaxAmount, CheckBox
Gui chexr:Add, Text, x51 y136 w51 h23 +0x200, Skip Bytes
Gui chexr:Add, Text, x108 y136 w52 h23 +0x200, Max Times
Gui chexr:Add, Text, x225 y135 w51 h23 +0x200, Skip Bytes
Gui chexr:Add, Text, x282 y135 w52 h23 +0x200, Max Times
Gui chexr:Add, Edit, +Center x226 y160 w49 h21 vSkipByteDatamoshedVar, 20000
Gui chexr:Add, Edit, +Center x283 y160 w49 h21 vMaxReplaceTimesDatamoshedVar, 10
Gui chexr:Add, CheckBox, x245 y184 w12 h12 vDatamoshedSkipVar gEnableDatamoshedSkipAmount, CheckBox
Gui chexr:Add, CheckBox, x301 y184 w12 h12 vDatamoshedMaxVar gEnableDatamoshedMaxAmount, CheckBox

GuiControl, chexr:Disable, SkipByteCompressedVar
GuiControl, chexr:Disable, SkipByteDatamoshedVar
GuiControl, chexr:Disable, MaxReplaceTimesCompressedVar
GuiControl, chexr:Disable, MaxReplaceTimesDatamoshedVar

Gui chexr:-sysmenu
Gui chexr:Show, w387 h272, Chexr Hex Edit Interface

chexrpath := A_ScriptDir . "\config\chexr.exe " ;chexr.exe location.

Return



EnableCompressedSkipAmount:
GuiControlGet, CompressedSkipVar
if (CompressedSkipVar = 1) {
	GuiControl, chexr:Enable, SkipByteCompressedVar
	SkipVar := " s" . SkipByteCompressedVar
	Return
}

if (CompressedSkipVar = 0) {
	GuiControl, chexr:Disable, SkipByteCompressedVar
	SkipVar := ""
	Return
}
Return

EnableCompressedMaxAmount:
GuiControlGet, CompressedMaxVar
if (CompressedMaxVar = 1) {
	GuiControl, chexr:Enable, MaxReplaceTimesCompressedVar
	MaxTimesVar := " r" . MaxReplaceTimesCompressedVar
	Return
}

if (CompressedMaxVar = 0) {
	GuiControl, chexr:Disable, MaxReplaceTimesCompressedVar
	MaxTimesVar := ""
	Return
}
Return

EnableDatamoshedSkipAmount:
GuiControlGet, DatamoshedSkipVar
if (DatamoshedSkipVar = 1) {
	GuiControl, chexr:Enable, SkipByteDatamoshedVar
	SkipVar := " s" . SkipByteDatamoshedVar
	Return
}

if (DatamoshedSkipVar = 0) {
	GuiControl, chexr:Disable, SkipByteDatamoshedVar
	SkipVar := ""
	Return
}
Return


EnableDatamoshedMaxAmount:
GuiControlGet, DatamoshedMaxVar
if (DatamoshedMaxVar = 1) {
	GuiControl, chexr:Enable, MaxReplaceTimesDatamoshedVar
	MaxTimesVar := " r" . MaxReplaceTimesDatamoshedVar
	
	Return
}

if (DatamoshedMaxVar = 0) {
	GuiControl, chexr:Disable, MaxReplaceTimesDatamoshedVar
	MaxTimesVar := ""
	Return
}
Return




ViewHexEditOnCompressedAVI:
Gui, Submit, NoHide
gosub, OutputLocation
gosub, EnableCompressedSkipAmount
gosub, EnableCompressedMaxAmount

InputAVI := InputFolder . "\output.avi"
OutputAVI := InputFolder . "\output-hexed-temp.avi"

HexEditMe := ComSpec . " /c " . chexrpath . InputAVI . " " . CompressedTargetValue . " " . CompressedReplaceValue . " " . OutputAVI . " " . SkipVar . " " . MaxTimesVar
chexr := ComObjCreate("WScript.Shell").Exec(HexEditMe).StdOut.ReadAll()
msgbox, %chexr%

ViewIt := ComSpec . " /c " . "mplayer " . OutputAVI
runwait, %ViewIt%
FileDelete, %OutputAVI% ;Remove Hex Edited AVI.

WinActivate, Chexr
Return



ApplyHexEditOnCompressedAVI:
Gui, Submit, NoHide
gosub, OutputLocation
gosub, EnableCompressedSkipAmount
gosub, EnableCompressedMaxAmount

InputAVI := InputFolder . "\output.avi"
OutputAVI := InputFolder . "\output-hexed-temp.avi"

HexEditMe := ComSpec . " /c " . chexrpath . InputAVI . " " . CompressedTargetValue . " " . CompressedReplaceValue . " " . OutputAVI . " " . SkipVar . " " . MaxTimesVar
chexr := ComObjCreate("WScript.Shell").Exec(HexEditMe).StdOut.ReadAll()
msgbox, %chexr%

FileDelete, %InputAVI% ;Remove original compressed avi.
FileMove, %OutputAVI%, %InputAVI% ;Rename the temp hex edited avi back to the original compressed avi name.

WinActivate, Chexr
Return



ViewHexEditOnDatamoshedAVI:
Gui, Submit, NoHide
gosub, OutputLocation
gosub, EnableDatamoshedSkipAmount
gosub, EnableDatamoshedMaxAmount

CheckFile := OutputFolder . "\output-moshed.avi"
if !FileExist(CheckFile) {
	msgbox, pls datamosh the video first.
	Return
}

InputAVI := OutputFolder . "\output-moshed.avi"
OutputAVI := OutputFolder . "\output-hexed-temp.avi"

HexEditMe := ComSpec . " /c " . chexrpath . InputAVI . " " . DatamoshedTargetValue . " " . DatamoshedReplaceValue . " " . OutputAVI . " " . SkipVar . " " . MaxTimesVar
chexr := ComObjCreate("WScript.Shell").Exec(HexEditMe).StdOut.ReadAll()
msgbox, %chexr%

ViewIt := ComSpec . " /c " . "mplayer " . OutputAVI
runwait, %ViewIt%
FileDelete, %OutputAVI% ;Remove Hex Edited AVI.

WinActivate, Chexr
Return



ApplyHexEditOnDatamoshedAVI:
Gui, Submit, NoHide
gosub, OutputLocation
gosub, EnableDatamoshedSkipAmount
gosub, EnableDatamoshedMaxAmount

CheckFile := OutputFolder . "\output-moshed.avi"
if !FileExist(CheckFile) {
	msgbox, pls datamosh the video first.
	Return
}

InputAVI := OutputFolder . "\output-moshed.avi"
OutputAVI := OutputFolder . "\output-hexed-temp.avi"
NewAVI := InputFolder . "\output.avi"


HexEditMe := ComSpec . " /c " . chexrpath . InputAVI . " " . DatamoshedTargetValue . " " . DatamoshedReplaceValue . " " . OutputAVI . " " . SkipVar . " " . MaxTimesVar
chexr := ComObjCreate("WScript.Shell").Exec(HexEditMe).StdOut.ReadAll()
msgbox, %chexr%

FileDelete, %InputAVI% ;Remove original moshed avi.
FileDelete, %NewAVI% ;Remove original compressed avi.
FileMove, %OutputAVI%, %NewAVI% ;Rename the temp hex edited avi back to the original compressed avi name.

WinActivate, Chexr
Return

CloseWindow:
Gui, chexr:Destroy
Return
