;Datamosh ToolKit AHk Edition
;Joining the powers of FFmpeg, MEncoder and Tomato into one <3
;Thrown together by yours Truly, Pandela
#SingleInstance Force
#NoEnv
SetWorkingDir %A_ScriptDir%
SetBatchLines -1

#Include config\GetCodecs.ahk ; Populate the MEncoder and FFmpeg Codec lists!!! <3

;Custom GUI for baking yo files.
BakeGUI() {
	WinWaitClose, cmd
	Gui, 3:Color, DDCEE9	
	Gui, 3:Add, Button, x10 y66 w35 h24 gPlsBakeYUV, YUV
	Gui, 3:Add, Button, x46 y66 w35 h24 gPlsBakeMP4, MP4
	Gui, 3:Add, Button, x82 y66 w35 h24 gPlsBakePNG, PNG
	Gui, 3:Add, Button, x118 y66 w35 h24 Default gNoReBake, Nah
	Gui, 3:Add, Text, x2 y2 w162 h63, `n      Would ulike to get Baked? `n(Makes the Video compatible with       FFmpeg, and maybe larger.)
	Gui, 3:Show, w162 h100,To Bake`, or Not To Bake?
	Gui, 3:-Sysmenu
	WinWaitClose, To Bake`, or Not To Bake?
}

AMV2GUI() {
	WinWaitClose, cmd
	Gui, 3:Color, DDCEE9	
	Gui, 3:Add, Button, x10 y66 w35 h24 gAMV2Preset640, 640
	Gui, 3:Add, Button, x46 y66 w35 h24 gAMV2Preset1280, 1280
	Gui, 3:Add, Button, x82 y66 w35 h24 gOption4k, 4K
	Gui, 3:Add, Button, x118 y66 w35 h24 Default gOptionNone, Nah
	Gui, 3:Add, Text, x2 y-2 w162 h66, `n        Would ulike to Remove                       The Watermark? `n  (In case ur cheap like me and        don't wanna pay for this codec.) ;yet
	Gui, 3:Show, w162 h100,AMV2 Watermark Removal Hack
	Gui, 3:-Sysmenu
	WinWaitClose, AMV2 Watermark Removal Hack	
}


;Input, Forced Options and Extra Filter GUI Stuff
Gui, Color, DDCEE9
pic := A_ScriptDir . "\config\Background.png"
Gui, Add, Pic, x0 y0 w486 h363 vBack, %pic%
;I HAD TO MOVE THE GUI PIC BACKGROUND PLACEMENT HERE TO MAKE IT WORK!!!
Gui Add, GroupBox, x154 y10 w314 h83 ,
Gui Add, CheckBox,  x165 y34 w10 h12 vIsCustomFolder gCustomFolderMessage
Gui Add, Button, x165 y34 w44 h43 gSelectSource, Source
Gui Add, Edit, x285 y45 w63 h21 +Center vResolutionVar, 640x360
Gui Add, Text, x291 y29 w49 h14 +0x200 +BackgroundTrans, Resolution
Gui Add, Edit, x361 y45 w30 h21 +Center vFrameRateVar, 60
Gui Add, Text, x366 y29 w22 h14 +0x200 +BackgroundTrans, FPS
Gui Add, CheckBox, x311 y70 w10 h12 gEnableForceRes vForceRes, CheckBox
Gui Add, CheckBox, x371 y70 w10 h12 gEnableForceRate vForceRate, CheckBox
Gui Add, CheckBox, x237 y43 w10 h12 gBatchInputMessage vIsBatchInput, CheckBox
Gui Add, Text, x216 y28 w55 h14 +BackgroundTrans, Batch Input
Gui Add, CheckBox, x237 y70 w10 h12 gEnableOtherOptions vIsOtherOptionsOn, CheckBox
Gui Add, Text, x219 y56 w65 h14 +BackgroundTrans, Extra Stuff
Gui Add, Button, x406 y31 w47 h21 gMakeChexrGui, Hex Edit
Gui Add, Button, x406 y52 w47 h28 gForceBake, Force Bake

;MEncoder GUI Stuff
Gui Add, GroupBox, x17 y97 w168 h125 ,
Gui Add, ComboBox, x37 y184 w120 vMencoderCodecs Choose6, %CodecList%
Gui Add, Edit, x37 y136 w120 h21 vMEncoderOptions, -nosound -noskip
Gui Add, Text, x52 y120 w90 h15 +0x200 +BackgroundTrans, MEncoder Options
Gui Add, CheckBox, x47 y159 w104 h23 vRescaleMEncoderCodec hWndRescaleMEncoderCodec, Attempt Rescale?
Gui Add, Button, x158 y183 w22 h23 vMEncoderCompression gPreMEncoderCompression, GO

;FFmpeg GUI Stuff
Gui Add, GroupBox, x17 y226 w168 h125 , 
Gui Add, ComboBox, x39 y314 w120 vFFmpegCodecs, %FFEncoderList%
Gui Add, Edit, x38 y266 w120 h21 vFFmpegOptions, -bf 0 -g 999999 -an
Gui Add, Text, x60 y250 w90 h15 +BackgroundTrans, FFmpeg Options
Gui Add, Button, x158 y265 w22 h23 vFFGetOptions gListCodecOptions, ?
Gui Add, Button, x159 y313 w22 h23 vFFmpegCompression gPreFFmpegCompression, GO
Gui Add, Slider, x19 y289 w164 h18 Range0-1000 vVideoQuality gVideoQualitySlider AltSubmit, 10

;Tomato GUI Stuff
Gui Add, GroupBox, x198 y97 w270 h254,
Gui Add, ComboBox, x265 y171 w120 Choose7 vTomatoMode, irep|ikill|iswap|bloom|pulse|shuffle|overlapped|jiggle|reverse|invert|void
Gui Add, Edit, x303 y217 w41 h21 vTomatoFrameCount +Center, 4
Gui Add, Edit, x303 y264 w41 h21 vTomatoFramePosition +Center, 2
Gui Add, Text, x293 y195 w62 h23 +0x200 +BackgroundTrans, Frame Count
Gui Add, Text, x288 y242 w71 h23 +0x200 +BackgroundTrans, Frame Position
Gui Add, Text, x282 y148 w81 h23 +0x200 +BackgroundTrans, Datamosh Mode
Gui Add, Button, x269 y289 w110 h46 vTomatoMOSHIT gCommenceTomatoDatamosh -E0x200 BackgroundTrans -Border, DATAMOSH IT

;WinSet, Region, % "0-0" "W" 110-1 " " "H" 46-1 R10-10, DATAMOSH IT
;GuiControl, Move, TomatoMOSHIT, w110-2 h46-2 x269-1 y289-1
;Trying to remove the button borders :(
;WinSet, Region, Region, 1-1 W200 H150, DATAMOSH IT
;GuiControl, Move, TomatoMOSHIT, % "x" 269 " y" 289 " w" 110 - 1

Gui Add, Button, x387 y289 w65 h46 vReCompress gReCompressMoshedOutput, Recompress
Gui Add, Button, x214 y289 w48 h46 vTomatoRecycle gRecycleTomatoOutput, Remosh
Gui Add, Button, x438 y111 w23 h23 vTomatoHalpButton gTomatoHalp, ?
Gui Add, CheckBox, x227 y123 w13 h22 vPythonLocationIsOn gEnableForcePythonLocation, CheckBox
Gui Add, Text, x205 y110 w65 h13, Force Python

;Compress with FFmpeg or MEncoder GUI Radio elements
Gui Add, Radio, x168 y106 w15 h16 gEnableME vEnableMEncoderCodec Checked
Gui Add, Radio, x168 y235 w15 h16 gEnableFF vEnableFFmpegCodec

;WebCam GUI Stuff
Gui Add, GroupBox, x17 y10 w127 h83 +0x300,
Gui Add, ComboBox, x22 y28 w117 vWebCamName, %DeviceList%
Gui Add, Button, x21 y55 w50 h31 gGetDevices, List Devices
Gui Add, Button, x90 y55 w50 h31 gSelectWebcam, Use Device

;Disable some stuff by default.
GuiControl, 1:Disable, FFmpegCodecs
GuiControl, 1:Disable, FFmpegOptions
GuiControl, 1:Disable, FFGetOptions
GuiControl, 1:Disable, FFmpegCompression
GuiControl, 1:Disable, VideoQuality
GuiControl, 1:Disable, TomatoMode
GuiControl, 1:Disable, TomatoFrameCount
GuiControl, 1:Disable, TomatoFramePosition
GuiControl, 1:Disable, TomatoMOSHIT
GuiControl, 1:Disable, TomatoRecycle
GuiControl, 1:Disable, ResolutionVar
GuiControl, 1:Disable, FrameRateVar
GuiControl, 1:Disable, Recompress

;You probably shouldn't touch any of these but the MP4BakeOptions, if for example you want to remove -noskip.
MP4BakeOptions := " -ovc x264 -x264encopts crf=1.0 -nosound -noskip " ;NoSkip prevents duplicate/frozen frames on mp4 output.
WebcamSource := ""
isBatchFilename := 0
RecompressVar := "MEncoder" ;Default Compressor.
BatchInputHelpMsg := 1 ;Display help msg once once every startup.
GlobalResolutionVar := 0 ;Needed this in order for the Extra Options to work correctly.
ReverseDecompression := 0
ReverseOnce := 1
isRecompressed := 0
WebcamCompression := "0"
AllowChexr := 0
ChexrWasUsed := 0
ForcedBake := 0
NoGetDiffPls := 0
NewOptions := 1
WinName := "Use This Codec Window Pls <3" ;The Hidden Child Windows name.
CustomFolderHelpMessage := 1

;Gui Window Names.
Gui Show, w485 h363, Datamosh Den - Ver 1.8.8 (Beta)
Gui Child:Show, w170 h120 x13 y205, %WinName%
Gui Child: -sysmenu

;Set Main window as parent and hide child window used to highlight FFmpeg Section.
DllCall("SetParent", UInt, WinExist(WinName) , UInt, WinExist("Datamosh Den"))
ControlGet, childWin, Hwnd,,%WinName%
;msgbox, If You Comment out the "Gui Child:Hide" And Place This messgage box here, it'll force the hidden child window out of hiding lol.
Gui Child:Hide
sleep, 50
Send, {Tab}


#Include config\GetFFmpeg.ahk ;Check if FFmpeg and newer MEncoder package is in folder, if so extract it.
#Include config\GetDifference.ahk ;Get the duration difference between the moshed and original video.
#Include config\UseChexr.ahk ;Hex edit the AVI to force compression artifacts.
Return

HighlightFFmpegWindow:
Gui, Hide
sleep, 300
Gui Child:Show

Loop 8 {
	DllCall( "FlashWindow", UInt,childWin, Int,True )
	Sleep 100
}
DllCall( "FlashWindow", UInt,childWin, Int,False )

Gui Child:Hide
sleep, 800
Gui, Show
GuiControl,,EnableFFmpegCodec,1 ;This Wont work in this label for some reason. So You have to click FFmpeg Codecs Radio Button Manually for now.
Return


EnableOtherOptions:
GuiControlGet, IsOtherOptionsOn

if (IsOtherOptionsOn = 1) {
	global UseOtherOptions = 1
	gosub, OtherOptions
}

if (IsOtherOptionsOn = 0) {
	msgbox, Disabled Extra Options :(
	
	global UseOtherOptions = 0		
	global EncHori := 0
	global EncVert := 0
	global EncTrans := 0
	global EncRev := 0
	global EncInv := 0
	global EncHue := 0
	global DecHori := 0
	global DecVert := 0
	global DecTrans := 0
	global DecRev := 0
	global DecInv := 0
	global DecHue := 0
	global ReverseCompression := 0	
	global EncodeReversibleFilterVal := ""
	global DecodeReversibleFilterVal := ""
	
}
Return

#Include config\AutoXYWH.ahk
OtherOptions:
DetectHiddenWindows, off
EncodeReversibleFilterVal := "" ;Reset Filter Vals
DecodeReversibleFilterVal := "" ;Reset Filter Vals

if(WinExist("Datamosh ")) && (NewOptions = 1) {
	gui, New
	NewOptions := 0
	sleep, 200
	Gui, +Hwndgui_id	
}
else

if(!WinExist("Extra Options")) {
      WinShow, ahk_id %gui_id%
return
}

Gui, Color, DDCEE9
Gui  +Resize
Gui Add, Button, x10 y330 w81 h27 gSuperHiddenCustomPresets, oWo
Gui Add, CheckBox, x12 y28 w120 h23 vEncHori gDisableCustomFilters, Horizontal Flip
Gui Add, CheckBox, x136 y28 w120 h23 +0x220 vDecHori gDisableCustomFilters, Horizontal Flip
Gui Add, CheckBox, x12 y53 w120 h23 vEncVert gDisableCustomFilters, Vertical Flip
Gui Add, CheckBox, x136 y53 w120 h23 +0x220 vDecVert gDisableCustomFilters, Vertical Flip
Gui Add, CheckBox, x12 y78 w120 h23 vEncTrans gDisableCustomFilters, Transpose
Gui Add, CheckBox, x136 y78 w120 h23 +0x220 vDecTrans gDisableCustomFilters, Transpose
Gui Font, s9 Underline, Verdana
Gui Add, Text, x12 y2 w120 h23 +0x200, Encoding Filters:
Gui Font
Gui Font, s9 Underline, Verdana
Gui Add, Text, x136 y2 w120 h23 +0x200 +0x2, Decoding Filters:
Gui Font
Gui Add, CheckBox, x12 y103 w60 h23 vEncRev gDisableCustomFilters, Reverse
Gui Add, CheckBox, x196 y103 w60 h23 +0x220 vDecRev gDisableCustomFilters, Reverse
Gui Add, CheckBox, x12 y153 w42 h23 vEncHue gEnableHueSlider, Hue
Gui Add, CheckBox, x215 y153 w41 h23 +0x220 vDecHue gDisableCustomFilters, Hue
Gui Add, CheckBox, x12 y128 w60 h23 vEncInv gDisableCustomFilters, Invert
Gui Add, CheckBox, x196 y128 w60 h23 +0x220 vDecInv gDisableCustomFilters, Invert
Gui Add, Edit, hWndhEdtValue2 x153 y241 w109 h60 vCustomDecodeFilterVal -VScroll
Gui Font, s8, Georgia
Gui Add, Text, x10 y208 w95 h31 +Disabled vEncText, Custom Encode`n           Filter:
Gui Font
Gui Add, CheckBox, x26 y222 w13 h13 vEnableCustomEncodeWindowVar gEnableCustomEncodeWindow, CheckBox
Gui Add, Edit, hWndhEdtValue x5 y241 w109 h60 vCustomEncodeFilterVal -VScroll,-lavfi "hue=h=2500/12*mod(t\,2500):s=3"
Gui Font, s8, Georgia
Gui Add, Text, x161 y208 w95 h31 +Disabled vDecText, Custom Decode`n           Filter:
Gui Add, CheckBox, x177 y223 w13 h13 vEnableCustomDecodeWindowVar gEnableCustomDecodeWindow, CheckBox
Gui Font
gosub, EnableForceRes
huh = oshitwaddupyowhatareudoingtodayimdoingjustdandythanksforaskinglolihopeyouhaveawonderfuldaykthxbaikmsroflmao
GuiControl, Disable, CustomDecodeFilterVal
GuiControl, Disable, CustomEncodeFilterVal
Gui Add, Button, x93 y148 w81 h27 gCloseExtraOptions, Submit



;Close GUI after hitting ENTER Key 
GuiControlGet, ForceResVar,,ForceRes
OnMessage(0x100, "OnKeyDown")
OnKeyDown(wParam)
{
	;had to add these globals here in order for the values to be available to the function. idk another way at the moment.
	global EncHori
	global EncVert
	global EncTrans
	global EncRev
	global EncInv
	global EncHue
	global DecHori
	global DecVert
	global DecTrans
	global DecRev
	global DecInv
	global DecHue
	global RecompressVar
	global EncodeReversibleFilterVal
	global DecodeReversibleFilterVal
	global ResolutionVar
	global ForceResVar
	global ReverseCompression
	
	IfWinActive, Extra ;The second GUI windows name.
	{
		if (wParam = 13) ;This is the Enter Key Param
		{
			gosub, CloseExtraOptions
		}
	}
}

Gui  -sysmenu
Gui Show, w267 h305, Extra Options - Press The Enter Key When Done`n-%huh%
Gui, +MinSize +MinSize267x ;Limit the how small option the window gets :3 
Return



EnableCustomEncodeWindow:
GuiControlGet, EnableCustomEncodeWindowVar
if (EnableCustomEncodeWindowVar = 0) {
	GuiControl, Disable, CustomEncodeFilterVal
	GuiControl, Disable, EncText
	
	
}

if (EnableCustomEncodeWindowVar = 1) {
	GuiControl, Enable, CustomEncodeFilterVal
	GuiControl, Enable, EncText
	
}

;Reset other controls since you're using the custom filters instead of my presets and shit.
GuiControl,,EncHori,0
GuiControl,,DecHori,0
GuiControl,,EncVert,0
GuiControl,,DecVert,0
GuiControl,,EncTrans,0
GuiControl,,DecTrans,0
GuiControl,,EncRev,0
GuiControl,,DecRev,0
GuiControl,,EncInv,0
GuiControl,,DecInv,0
GuiControl,,EncHue,0
GuiControl,,DecHue,0
Return

EnableCustomDecodeWindow:
GuiControlGet, EnableCustomDecodeWindowVar
if (EnableCustomDecodeWindowVar = 0) {
	GuiControl, Disable, CustomDecodeFilterVal
	GuiControl, Disable, DecText
	
}

if (EnableCustomDecodeWindowVar = 1) {
	GuiControl, Enable, CustomDecodeFilterVal
	GuiControl, Enable, DecText
	
}

;Reset other controls since you're using the custom filters instead of my presets and shit.
GuiControl,,EncHori,0
GuiControl,,DecHori,0
GuiControl,,EncVert,0
GuiControl,,DecVert,0
GuiControl,,EncTrans,0
GuiControl,,DecTrans,0
GuiControl,,EncRev,0
GuiControl,,DecRev,0
GuiControl,,EncInv,0
GuiControl,,DecInv,0
GuiControl,,EncHue,0
GuiControl,,DecHue,0
Return


DisableCustomFilters:
if (EnableCustomEncodeWindowVar = 1) {
	GuiControl,,EnableCustomEncodeWindowVar,0
	GuiControl, Disable, CustomEncodeFilterVal
	GuiControl, Disable, EncText
	
}

if (EnableCustomDecodeWindowVar = 1) {
	GuiControl,,EnableCustomDecodeWindowVar,0
	GuiControl, Disable, CustomDecodeFilterVal
	GuiControl, Disable, DecText
	
}
Return


GuiSize:
;Resize the custom filter edit box natively with the GUI size.
;If (A_EventInfo == 0) {
;	Return
;}
;Removed the above cus it was messing up my shit for some reason.

GuiControlGet, EnableCustomEncodeWindowVar
if (EnableCustomEncodeWindowVar = 1) {
	AutoXYWH("wh*", hEdtValue)
}

GuiControlGet, EnableCustomDecodeWindowVar
if (EnableCustomDecodeWindowVar = 1) {
	AutoXYWH("wh*", hEdtValue2)
}
Return

SuperHiddenCustomPresets:
k += 2
m := Mod(k, 3)
s := Floor(m) 

sleep, 10
cus_presets := ["-lavfi " . chr(0x22) . "split=outputs=4[1][2][3][4];[1]setpts='if(eq(N,0),PTS,PTS+0.1/TB)'[1];[2]setpts='if(eq(N,0),PTS,PTS+0.6/TB)'[2];[1][2]blend=all_mode=addition128[v1];[3]setpts='if(eq(N,0),PTS,PTS+1.1/TB)'[3];[4]setpts='if(eq(N,0),PTS,PTS+1.6/TB)'[4];[3][4]blend=all_mode=addition128[v2];[v2][v1]mix=weights=100 100" . chr(0x22) 
                , "-lavfi " . chr(0x22) . "transpose=1,split[a][b];[b]hflip[b];[a][b]hstack[c];[c]split[d][e];[e]vflip[e];[d][e]vstack,transpose=1" . chr(0x22)
                , "-lavfi " . chr(0x22) . "split=outputs=4[1][2][3][4];[1]setpts='if(eq(N,0),PTS,PTS+0.1/TB)'[1];[2]setpts='if(eq(N,0),PTS,PTS+0.6/TB)'[2];[1][2]blend=all_mode=addition128[v1];[3]setpts='if(eq(N,0),PTS,PTS+1.1/TB)'[3];[4]setpts='if(eq(N,0),PTS,PTS+1.6/TB)'[4];[3][4]blend=all_mode=addition128[v2];[v2][v1]mix=weights=100 100,hue=h=2500/12*mod(t\,2500):s=3" . chr(0x22)]

CustomPreset := cus_presets[s+1]

sleep, 10
GuiControl,, CustomEncodeFilterVal, %CustomPreset%
Return

CloseExtraOptions:
Gui, Submit, NoHide

if (RecompressVar = "MEncoder") && (EnableCustomEncodeWindowVar = 1) && RegExMatch(CustomEncodeFilterVal,"(-lavfi )") {
	msgbox, Looks like you're using an FFmpeg Filter :o`nMake sure FFMpeg Options/Codecs is selected if using the -lavfi flag!!!
	gosub, HighlightFFmpegWindow
	Return
}

if (RecompressVar = "MEncoder") && (EnableCustomEncodeWindowVar = 1) && RegExMatch(CustomEncodeFilterVal,"( frei0r)") {
	msgbox, Looks like you're using an Frei0r Filter :o`nPlease use FFmpeg Options/Codecs for this only.`n`nFor now.
	gosub, HighlightFFmpegWindow
	Return
}

msgbox, Using the selected %RecompressVar% Filters!
Gui, Hide
Return


GetFilters:
		;Horizontal Filters
if (EncHori = 0) {
;EncodeReversibleFilterVal := ""
}
if (EncHori = 1) && (RecompressVar = "MEncoder") {
	EncodeReversibleFilterVal .= "," . "mirror"
}
if (EncHori = 1) && (RecompressVar = "FFmpeg") {
	EncodeReversibleFilterVal .= "," . "hflip"
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
if (DecHori = 0) {
;DecodeReversibleFilterVal := ""
}
if (DecHori = 1) && (RecompressVar = "MEncoder") {
	DecodeReversibleFilterVal .= "," . "mirror"
}
if (DecHori = 1) && (RecompressVar = "FFmpeg") {
	DecodeReversibleFilterVal .= "," . "mirror"
}


		;Vertical Filters
if (EncVert = 0) {
;EncodeReversibleFilterVal := ""
}
if (EncVert = 1) && (RecompressVar = "MEncoder") {
	EncodeReversibleFilterVal .= "," . "flip"
}
if (EncVert = 1) && (RecompressVar = "FFmpeg") {
	EncodeReversibleFilterVal .= "," . "vflip"
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
if (DecVert = 0) {
;DecodeReversibleFilterVal := ""
}
if (DecVert = 1) && (RecompressVar = "MEncoder") {
	DecodeReversibleFilterVal .= "," . "flip"
}
if (DecVert = 1) && (RecompressVar = "FFmpeg") {
	DecodeReversibleFilterVal .= "," . "flip"
}


		;Transpose Filters
if (EncTrans = 0) {
;EncodeReversibleFilterVal := ""
}
if (EncTrans = 1) && (RecompressVar = "MEncoder") {
	EncodeReversibleFilterVal .= "," . "rotate=0"
}
if (EncTrans = 1) && (RecompressVar = "FFmpeg") {
	EncodeReversibleFilterVal .= "," . "transpose=0"
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
if (DecTrans = 0) {
;DecodeReversibleFilterVal := ""
}
if (DecTrans = 1) && (EncVert = 0) && (EncHori = 0) && (RecompressVar = "MEncoder") else if (RecompressVar = "FFmpeg") {
	DecodeReversibleFilterVal .= "," . "rotate=0"
}
if (DecTrans = 1) && (EncVert = 1) && (EncHori = 1) && (RecompressVar = "MEncoder") else if (RecompressVar = "FFmpeg") {
	DecodeReversibleFilterVal .= "," . "rotate=1" ;FFmpeg version is transpose=0
}
if (DecTrans = 1) && (EncVert = 0) && (EncHori = 1) && (RecompressVar = "MEncoder") else if (RecompressVar = "FFmpeg") {
	DecodeReversibleFilterVal .= "," . "rotate=2" ;FFmpeg version is transpose=0
}
if (DecTrans = 1) && (EncVert = 1) && (EncHori = 0) && (RecompressVar = "MEncoder") else if (RecompressVar = "FFmpeg") {
	DecodeReversibleFilterVal .= "," . "rotate=2" ;FFmpeg version is transpose=0
}


		;Reverse Filters.
if (EncRev = 0) {
;EncodeReversibleFilterVal := ""
}
if (EncRev = 1) && (RecompressVar = "MEncoder") {
	EncodeReversibleFilterVal .= "," . "scale"
}
if (EncRev = 1) && (RecompressVar = "FFmpeg") {
	EncodeReversibleFilterVal .= "," . "reverse"
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
if (DecRev = 0) {
;DecodeReversibleFilterVal := ""
}
if (DecRev = 1) && (RecompressVar = "MEncoder") {
	DecodeReversibleFilterVal .= "," . "scale"
}
if (DecRev = 1) && (RecompressVar = "FFmpeg") {
	DecodeReversibleFilterVal .= "," . "reverse"
}


		;Invert Filters
if (EncInv = 0) {
;EncodeReversibleFilterVal := ""
}
if (EncInv = 1) && (RecompressVar = "MEncoder") {
	EncodeReversibleFilterVal .= "," . "eq2=0:-1:0,scale"
}
if (EncInv = 1) && (RecompressVar = "FFmpeg") {
	EncodeReversibleFilterVal .= "," . "eq=-1"
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
if (DecInv = 0) {
;DecodeReversibleFilterVal := ""
}
if (DecInv = 1) && (RecompressVar = "MEncoder") {
	DecodeReversibleFilterVal .= "," . "eq2=0:-1:0,scale"
}
if (DecInv = 1) && (RecompressVar = "FFmpeg") {
	DecodeReversibleFilterVal .= "," . "eq2=0:-1:0,scale"
}


		;Hue Filters
if (EncHue = 0) {
;EncodeReversibleFilterVal := ""
}
if (EncHue = 1) && (RecompressVar = "MEncoder") {
	EncodeReversibleFilterVal .= "," . "hue=" . HueValue . ":" . SatValue . ",scale" ;Scale is needed to correct the colorspace I guess?
}
if (EncHue = 1) && (RecompressVar = "FFmpeg") {
	EncodeReversibleFilterVal .= "," . "hue=" . HueValue . ":" . SatValue
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
if (DecHue = 0) {
;DecodeReversibleFilterVal := ""
}
if (DecHue = 1) && !RegExMatch(HueValue,"(-)") && (RecompressVar = "MEncoder") {
	DecodeReversibleFilterVal .= "," . "hue=-" . HueValue . ":" . SatValue . ",scale"
}
if (DecHue = 1) && !RegExMatch(HueValue,"(-)") && (RecompressVar = "FFmpeg") {
	DecodeReversibleFilterVal .= "," . "hue=-" . ":" . HueValue . ":" . SatValue
}
if (DecHue = 1) && RegExMatch(HueValue,"(-)") && (RecompressVar = "FFmpeg") or (RecompressVar = "MEncoder") {
	if InStr(HueValue, "-") {
		StringTrimLeft, HueValue2, HueValue, 1 ;Remove the negative symbol.
	}
	
	if InStr(SatValue, "-") {
		StringTrimLeft, SatValue2, SatValue, 1 ;Remove the negative symbol.
	}
	
	DecodeReversibleFilterVal .= "," . "hue=" . HueValue2 . ":" . SatValue2
}

StringTrimLeft, EncodeReversibleFilterVal, EncodeReversibleFilterVal, 1 ;Remove extra comma

CheckComma := SubStr(DecodeReversibleFilterVal, 1, 1) ;Crop string down to first char.
if (CheckComma = ",") { ;Check if first char in string is a comma.
	StringTrimLeft, DecodeReversibleFilterVal, DecodeReversibleFilterVal, 1 ;Remove extra comma
	;DecodeReversibleFilterVal := SubStr(DecodeReversibleFilterVal, 1, -2) ;I tried this but it removed more than 1.
	DecodeReversibleFilterVal := " -vf " . DecodeReversibleFilterVal ;add -vf to string.
	
}
Return

EnableHueSlider:
gosub, DisableCustomFilters
GuiControlGet, EncHue
if (EncHue = 0) {
	Return
}

if (EncHue = 1) {
	Gui, hue:Color, DDCEE9	
	Gui hue:Add, Button, x11 y132 w154 h33 gCloseHueMenu, Apply Hue Changes
	Gui hue:Add, Slider, x2 y61 w172 h32 Range-180-180 vHueValue gHueColorSlider AltSubmit, 0
	Gui hue:Add, Text, x85 y35 w16 h23 +0x200, 0
	Gui hue:Add, Text, x149 y36 w24 h23 +0x200, 180
	Gui hue:Add, Text, x5 y35 w24 h23 +0x200, -180
	Gui hue:Font, s9, Consolas
	Gui hue:Add, Text, x8 y0 w172 h33 +0x200, Ghetto Hue Color Picker
	Gui hue:Add, Slider, x2 y97 w172 h32 Range-10-10 vSatValue gSaturationColorSlider AltSubmit, 1
	
	;Gui Show, w176 h170, 
	Gui hue:Font
	Gui hue:Show, w176 h170, `n
	Gui hue:-sysmenu
}
Return

F8::
msgbox, wot
return

HueColorSlider:
tooltip % "Hue: " . HueValue
SetTimer, RemoveToolTip2, 500
return

RemoveToolTip2:
SetTimer, RemoveToolTip2, Off
ToolTip
return

SaturationColorSlider:
tooltip % "Saturation: " . SatValue
SetTimer, RemoveToolTip4, 500
return

RemoveToolTip4:
SetTimer, RemoveToolTip4, Off
ToolTip
return

CloseHueMenu:
Gui, hue:Submit, NoHide
gosub, GetFilters
Gui, hue:Destroy
Return



EnableReverseVideo:
gosub, EnableForceRes
gosub, OutputLocation

ReverseFilter := " -vf reverse "

if (ResolutionVar = NewResVar) && (GlobalResolutionVar = 1) {
	ResolutionVar := "" ;Clear this annoying bug I cant hunt down yet.	
	ResolutionVar := "-s " . NewResVar
}

if (ResolutionVar = NewResVar) && (GlobalResolutionVar = 0) {
	ResolutionVar := "" ;Clear this annoying bug I cant hunt down yet.	
}

CheckFile := InputFolder . "\output.avi"

if (EncRev = 1) && (isRecompressed = 0) {
	;sourceFile := DefaultSourceFile
}

if (EncRev = 0) && (isRecompressed = 0) {
	;sourceFile := DefaultSourceFile ;this should be the bug
	Return
}

if (EncRev = 1) && (isRecompressed = 1) {
	SourceFile := OutputFolder . "\output-moshed.avi"
}

if (EncRev = 0) && (isRecompressed = 1) {
	SourceFile := OutputFolder . "\output-moshed.avi"
	Return
}

if (EncRev = 0) && (isRecompressed = 1) && (WebcamCompression = 1) {
	SourceFile := OutputFolder . "\webcam-output.avi"
	Return
}

if (EncRev = 1) {
	if FileExist(CheckFile) && (ReverseOnce = 1) && (isRecompressed = 0) {
		sourceFileRev := DefaultSourceFile
		
		if (ReverseWebcam = 1) {
			sourceFileRev := InputFolder . "\webcam-output.avi"
		}
		
		FFReverseCompress := ComSpec . " /c " . " ffmpeg -i " . chr(0x22) . sourceFileRev . chr(0x22) . " " . ResolutionVar . " " . " -f avi -c:v huffyuv " . ReverseFilter . " " . InputFolder . "\output2.avi -y"

		
		runwait, %FFReverseCompress%	
		SourceFile := InputFolder . "\output2.avi"
		ReverseCompression := "0"
		;ReverseOnce := 0
		Return
	}
	
	
	if FileExist(CheckFile) && (ReverseOnce = 1) && (isRecompressed = 1) {
		;FileMove, %InputFolder%/output2.avi, %InputFolder%/output.avi
		msgbox, Since you have 'Reverse' Enabled during Recompress`nWe have to bake the video before passing to to FFmpeg...
		YUVBake := "mplayer " . CustomCodecFix . " -sws 4 " . DecodeReversibleFilterVal . " " . " -vo yuv4mpeg " . OutputFolder . "\output-moshed.avi"
		runwait, %YUVBake%
		WinWaitClose, cmd
		FileMove, stream.yuv,  %OutputFolder%\ImBaked.yuv
		sleep, 1
		sourceFileRev := OutputFolder . "\ImBaked.yuv"
		
		if (ReverseWebcam = 1) && (isRecompressed = 0) {
			sourceFileRev := InputFolder . "\webcam-output.avi"
		}
		
		if (ReverseWebcam = 1) && (isRecompressed = 1) {
			sourceFileRev := OutputFolder . "\ImBaked.yuv"
		}
		
		FFReverseCompress := ComSpec . " /c " . " ffmpeg -i " . chr(0x22) . sourceFileRev . chr(0x22) . " " . ResolutionVar . FrameRate . " -f avi -c:v huffyuv -vf reverse " . InputFolder . "\output2.avi -y"
		
		msgbox, %FFReverseCompress%
		runwait, %FFReverseCompress%
		SourceFile := InputFolder . "\output2.avi"
		ReverseCompression := "0"
          ;ReverseOnce := 0
	}
	
}
Return

UnReverseVideo:
gosub, OutputLocation
gosub, EnableForceRes

if (DecRev = 1) {
	msgbox, aw shit you have reverse enabled for decoding, here we go.`nBtw if probably won't work well with the video/audio sync options.
	inputFile := OutputFolder . "\" . BakedFilename	
	FFReverseCompress := ComSpec . " /k " . " ffmpeg -i " . chr(0x22) . inputFile . chr(0x22) . " " . ResolutionVar . FrameRate . " -f avi -c:v huffyuv -vf reverse " . InputFolder . "\unreversed-output.avi -y"
	msgbox, %FFReverseCompress%
	runwait, %FFReverseCompress%	
	
	sourceFileReversed := InputFolder . "\unreversed-output.avi"
	ShowIt := "cmd.exe /c ffplay -i " . sourceFileReversed . " -loop 0"
	
	runwait, %ShowIt%
	ReverseCompression := "0"
	UnReverseCompression := 1
	return
	
}
else
	Return



BatchInputMessage:
Gui, Submit, NoHide
if (IsBatchInput = 1) && if (BatchInputHelpMsg = 1){
	msgbox, ohey batch input is enabled!`nUse the Source button to select a folder...`n`nThen press GO.
}

if (IsBatchInput = 0) && if (BatchInputHelpMsg = 1) {
	msgbox, ohey batch input is disabled!`nUse the source button to select a file...`n`nThen press GO.`nThis dialog won't bother you anymore.
	BatchInputHelpMsg := 0 ;Turns off the help box until next startup.
}
Return

CustomFolderMessage:
Gui, Submit, NoHide
if (IsCustomFolder = 1) && (CustomFolderHelpMessage = 1) {
	msgbox, I see you found this option, with this on all your output files are made in the same folder as the input folder.
}

if (IsCustomFolder = 0) && (CustomFolderHelpMessage = 1) {
	msgbox, You deactivated the custom output folder function,`nit will still work if you check this box again.`n`nThis message will no longer pop up, however.
	CustomFolderHelpMessage := 0 ;Turns off the help box until next startup.
}
Return

VideoQualitySlider:
;Gui,Submit,NoHide
int := VideoQuality/10
fra := Mod(int, 10)
fra := SubStr(fra, InStr(fra,".")+1, 1 )
val :=  Floor(int) "." fra
VQuality := val
tooltip % "Video Quality: " . VQuality
SetTimer, RemoveToolTip1, 500
return

RemoveToolTip1:
SetTimer, RemoveToolTip1, Off
ToolTip
return

GetDevices: ;Thank u again for the Regex, Salz <3
MakeList := ""
DirtyList := ""
msgbox,4096,,
(
Choose your webcam device name from this list.
)
gibdevice := "ffmpeg -f dshow -list_devices true -i null"
List := ComObjCreate("WScript.Shell").Exec(gibdevice).StdErr.ReadAll()
List.Visible := false

text := List
texts := StrSplit(text, "`n", "`r")
for i, thisText in texts {
	RegExMatch(thisText, "O)^\[(?:\w+)\s*@\s*(?:[[:xdigit:]]+)\]\s*""(.*?)""$", thisMatch)
	MakeList .= "|" . thisMatch.Value(1)
}

DirtyList := StrReplace(MakeList, "||||", "|") ;Remove Duplicate "|" pipe bars.
StringTrimLeft, DeviceList, DirtyList, 4 ;Remove Duplicate "|" pipe bars at beginning.
DeviceList := StrReplace(DeviceList, "|||", "$") ;Split Video & Audio devices.
;Prune Audio Devices.
Needle := "$"
DeviceList := SubStr(DeviceList, 1, InStr(DeviceList, Needle)-1) . "|"

GuiControl,, WebCamName, |%DeviceList%
 ;GuiControl, Disable, ListWebcams
GuiControl, Choose, WebCamName, 2
 ;Control, ShowDropDown,, ComboBox2
Return

SelectWebcam:
Gui, Submit, NoHide
GuiControl, 1:Disable, FrameRateVar ;This fucks up the compression, unless the FPS you use matches one supported by the device.
GuiControl, 1:, ForceRate, 0
GuiControl,, IsBatchInput, 0 ;Disable the BatchInput checkbox to avoid filename conflicts.
IsBatchInput := "0" ;Resets the input to be just WebCam, if in case for example you were doing batch datamoshing before this.

WebCam := " -f dshow -i video=" . chr(0x22) . WebCamName . chr(0x22) . " "
WebcamCompression := "1"
ReverseWebcam := 1 ; HERE IS WHERE I LAST EDITED

msgbox, %WebCamName% selected as input device.`n   Hit this button every time before "GO"`n       if you want to record a new video.`n`n                 Press Q to stop Webcam.
Return

WebCamCompression:
;Gui, Submit, NoHide
gosub, OutputLocation
gosub, EnableForceRes

if (ResolutionVar = NewResVar) && (GlobalResolutionVar = 1) {
	ResolutionVar := "" ;Clear this annoying bug I cant hunt down yet.	
	ResolutionVar := "-s " . NewResVar
}

if (ResolutionVar = NewResVar) && (GlobalResolutionVar = 0) {
	ResolutionVar := "" ;Clear this annoying bug I cant hunt down yet.	
}


if (WebcamCompression = 1) {
	FFWebcamCompress := ComSpec . " /c " . " ffmpeg " . InputFrameRate . WebCam . ResolutionVar . " -f avi -c:v huffyuv " . InputFolder . "\webcam-output.avi -y"
	
	runwait, %FFWebcamCompress%
	SourceFile := InputFolder . "\webcam-output.avi"
	WebcamCompression := "0"
	return
	
}
Return



SelectSource:
Gui, Submit, NoHide
WebcamCompression := "0"

if (IsBatchInput = 1) {
	FileCreateDir, %A_ScriptDir%\Batch-Output
	FileSelectFolder,leFolder, *%A_ScriptDir%,3,Select The Input Folder.....................
	if errorlevel {
		msgbox, You Didnt Select Anything lol
		return
	}
}
else
	FileSelectFile, SourceFile,,,Select Source For Datamoshing......................................
DefaultSourceFile := SourceFile
ItsANewSource := 1
if errorlevel {
	msgbox, You Didnt Select Anything lol
	return
}
Return



EnableME:
GuiControlGet, EnableMEncoderCodec
if (EnableMEncoderCodec = 1) {
	GuiControl, 1:Enable, MencoderCodecs
	GuiControl, 1:Enable, MencoderOptions
	GuiControl, 1:Enable, RescaleMEncoderCodec
	GuiControl, 1:Enable, MEncoderCompression
	
	GuiControl, 1:Disable, FFmpegCodecs
	GuiControl, 1:Disable, FFmpegOptions
	GuiControl, 1:Disable, FFmpegCompression
	GuiControl, 1:Disable, FFGetOptions
	GuiControl, 1:Disable, VideoQuality
	
	GuiControl, 1:Disable, TomatoMode
	GuiControl, 1:Disable, TomatoFrameCount
	GuiControl, 1:Disable, TomatoFramePosition
	GuiControl, 1:Disable, TomatoMOSHIT
	GuiControl, 1:Disable, TomatoRecycle
	GuiControl, 1:, FFmpegOptions, -bf 0 -g 999999 -an
	
	
	RecompressVar := "MEncoder"
}
return

EnableFF:
GuiControlGet, EnableFFmpegCodec
if (EnableFFmpegCodec = 1) {
	GuiControl, 1:Enable, FFmpegCodecs
	GuiControl, 1:Enable, FFmpegOptions
	GuiControl, 1:Enable, FFmpegCompression
	GuiControl, 1:Enable, FFGetOptions
	GuiControl, 1:Enable, VideoQuality
	
	GuiControl, 1:Disable, MencoderCodecs
	GuiControl, 1:Disable, MEncoderOptions
	GuiControl, 1:Disable, RescaleMEncoderCodec
	GuiControl, 1:Disable, MEncoderCompression
	
	GuiControl, 1:Disable, TomatoMode
	GuiControl, 1:Disable, TomatoFrameCount
	GuiControl, 1:Disable, TomatoFramePosition
	GuiControl, 1:Disable, TomatoMOSHIT
	GuiControl, 1:Disable, TomatoRecycle
	GuiControl, 1:, MEncoderOptions, -nosound -noskip
	
	
	RecompressVar := "FFmpeg"
}
return



EnableForceRes:
Gui, Submit, NoHide
GuiControlGet, ForceRes

NewResVar := ResolutionVar

if (ForceRes = 1) && (ForceRate = 0) && (RecompressVar = "FFmpeg") {
	GuiControl, 1:Enable, ResolutionVar
	ResolutionVar := " -vf scale=" . ResolutionVar
	global GlobalResolutionVar := 1
}

if (ForceRes = 1) && (ForceRate = 0) && (RecompressVar = "MEncoder") {
	GuiControl, 1:Enable, ResolutionVar
	ResolutionVar := " -vf scale=" . ResolutionVar
	ResolutionVar := StrReplace(ResolutionVar, "x", ":")
	global GlobalResolutionVar := 1
	
}

if (ForceRes = 0) {
	GuiControl, 1:Disable, ResolutionVar
	ResolutionVar := ""
	global GlobalResolutionVar := 0
}

if (ForceRate = 1) && (ForceRes = 1) && (RecompressVar = "FFmpeg") {
	ResolutionVar := ""
}

if (ForceRate = 1) && (ForceRes = 1) && (RecompressVar = "MEncoder") {
	ResolutionVar := StrReplace(ResolutionVar, "x", ":")
}
Return

;WIP
EnableForceRate:
Gui, Submit, NoHide
GuiControlGet, ForceRate
GuiControlGet, ForceRes

if (ForceRate = 1) && (RecompressVar = "FFmpeg") {
	GuiControl, 1:Enable, FrameRateVar
	FrameRate := " -vf fps=" . FrameRateVar
	InputFrameRate := " -r " . FrameRateVar
}

if (ForceRate = 1) && (RecompressVar = "MEncoder") {
	GuiControl, 1:Enable, FrameRateVar
	FrameRate := " -fps " . FrameRateVar
}

if (ForceRate = 0) {
	GuiControl, 1:Disable, FrameRateVar
	FrameRate := ""
	InputFrameRate := ""
}

if (ForceRate = 0) && (ForceRes = 1) && (IsOtherOptionsOn = 0) && (RecompressVar = "FFmpeg") {
	FrameRate := ""
}


if (ForceRate = 1) && (ForceRes = 1) && (IsOtherOptionsOn = 0) && (RecompressVar = "FFmpeg") {
	FrameRate := " -vf fps=" . FrameRateVar . "," . "scale=" . ResolutionVar
	ResolutionVar := ""
}


if (ForceRate = 1) && (ForceRes = 1) && (IsOtherOptionsOn = 1) && (RecompressVar = "FFmpeg") {
	FrameRate := " -vf fps=" . FrameRateVar . "," . "scale=" . ResolutionVar
}

if (ForceRate = 1) && (ForceRes = 1) && (RecompressVar = "MEncoder") {
	GuiControl, 1:Enable, FrameRateVar
	ResolutionVar := " -vf scale=" . StrReplace(ResolutionVar, "x", ":")
	FrameRate := " -fps " . FrameRateVar
}
Return
;WIP

GetFilterOptionsAndFixStrings:
;If force scale is enabled, add a comma and scale filter before all of these.
gosub, EnableForceRes			
if (GlobalResolutionVar = 1) && (IsOtherOptionsOn = 1) {
	ResolutionVar := StrReplace(ResolutionVar, "x", ":") ;For MEncoder scale filter compatibility,
	EncodeReversibleFilterVal := ResolutionVar . "," . EncodeReversibleFilterVal
			;DecodeReversibleFilterVal := ResolutionVar . "," . DecodeReversibleFilterVal
}

;If force scale is enabled, But filters are off, don't add a comma.
if (GlobalResolutionVar = 1) && (IsOtherOptionsOn = 0) else if (EnableForceRate = 1) {
	ResolutionVar := StrReplace(ResolutionVar, "x", ":") ;For MEncoder scale filter compatibility,
	EncodeReversibleFilterVal := ResolutionVar . EncodeReversibleFilterVal
	DecodeReversibleFilterVal := ResolutionVar . DecodeReversibleFilterVal
}

			;msgbox, %EncodeReversibleFilterVal%
			;msgbox, %DecodeReversibleFilterVal%

if (UseOtherOptions = 0) { ;Remove the extra options/Reversible filters, if disabled. HERE
	EncodeReversibleFilterVal := ""
	DecodeReversibleFilterVal := ""
	vfFlag := ""
}

;Reset the Forced Resolution Variable, because its being used in the Reversible filter variable instead.
if (UseOtherOptions = 1) {
	ResolutionVar := "" 
	vfFlag := " -vf "	
}


;If force scale is disabled, add "-vf" to the filter variable.
if (GlobalResolutionVar = 0) && if (UseOtherOptions = 1) {
	EncodeReversibleFilterVal := vfFlag . EncodeReversibleFilterVal
	;DecodeReversibleFilterVal := vfFlag . DecodeReversibleFilterVal
	;DecodeReversibleFilterVal := " -vf " . DecodeReversibleFilterVal ;HERE
	ResolutionVar := ""
	ResolutionVar2 := ""			
}

;idk if i need this anymore
if (GlobalResolutionVar = 1) && (UseOtherOptions = 1) {
;ResolutionVar := ""
}

 ;if filters aren't selected, clear the entire variables.
if (DecodeReversibleFilterVal = " -vf ") {
	DecodeReversibleFilterVal := ""
}

;if filters aren't selected, clear the entire variables.
if (EncodeReversibleFilterVal = " -vf ") {
	EncodeReversibleFilterVal := ""
}

;idk if i need this anymore
;StringTrimLeft, DecodeReversibleFilterVal, DecodeReversibleFilterVal, 1 ;REMOVED FOR BUG FIX


gosub, EnableForceRate ;This was also an annoying bug I didnt know how else to fix.
if (ForceRate = 1) && (ForceRes = 1) && (IsOtherOptionsOn = 1) && (RecompressVar = "FFmpeg") {
	FrameRate := " -vf fps=" . FrameRateVar . "," . "scale=" . ResolutionVar . EncodeReversibleFilterVal
	ResolutionVar := ""
	EncodeReversibleFilterVal := ""
}

if (ForceRate = 1) && (ForceRes = 1) && (IsOtherOptionsOn = 1) && (RecompressVar = "MEncoder") {
	FrameRate := " -fps " . FrameRateVar
}

if (ForceRate = 0) && (ForceRes = 1) && (IsOtherOptionsOn = 0) && (RecompressVar = "FFmpeg") {
	ResolutionVar2 := ResolutionVar
	ResolutionVar := ""
	EncodeReversibleFilterVal := " -vf scale=" . ResolutionVar2
}

if (ForceRes = 1) && (ForceRate = 0) && (IsOtherOptionsOn = 0) && (RecompressVar = "MEncoder") {
	ResolutionVar := " -vf scale=" . StrReplace(ResolutionVar, "x", ":")	
	EncodeReversibleFilterVal := ""	
}

if (ForceRes = 0) && (ForceRate = 0) && (IsOtherOptionsOn = 0) && (RecompressVar = "MEncoder") {
	ResolutionVar := ""
	EncodeReversibleFilterVal := ""	
}

if (ForceRate = 1) && (ForceRes = 1) && (IsOtherOptionsOn = 0) && (RecompressVar = "MEncoder") {
	EncodeReversibleFilterVal := ""
}


;Important Bug Fixes Here!
if (ForceRes = 0) && (IsOtherOptionsOn = 1) {
	ResolutionVar := "" ;Reset the Forced Resolution Variable, this was a very annoying bug idk how else to fix.
}

if (ForceRes = 1) && (IsOtherOptionsOn = 1) {
	;EncodeReversibleFilterVal := ""	
	TempResolutionVar := ResolutionVar ;Allocate the string in the ResolutionVar variable before clearing, so we can use it in the Custom Encode and Decode Filters.
	ResolutionVar := "" ;Reset the Forced Resolution Variable, because its being used in the Reversible filter variable instead.
}

;HERE
;if (ForceRes = 1) && (IsOtherOptionsOn = 0) {
	;EncodeReversibleFilterVal := ""	
;	TempResolutionVar := ResolutionVar ;Allocate the string in the ResolutionVar variable before clearing, so we can use it in the Custom Encode and Decode Filters.
;	ResolutionVar := "" ;Reset the Forced Resolution Variable, because its being used in the Reversible filter variable instead.
;}



;Messy bug fixes idk im very sleepy.
if (ForceRate = 1) && (ForceRes = 0) && (IsOtherOptionsOn = 1) && (RecompressVar = "FFmpeg") {
	StringTrimLeft, EncodeReversibleFilterVal, EncodeReversibleFilterVal, 5
	EncodeReversibleFilterVal2 := EncodeReversibleFilterVal
	FrameRate := " -vf fps=" . FrameRateVar . "," . EncodeReversibleFilterVal2
	EncodeReversibleFilterVal := ""
	
	NewString := FrameRate
	ReverseString := DllCall( "msvcrt.dll\_strrev", Str, NewString, UInt,0, Str) ;Reverses string cus idk how to use SubStr backwards.
	CheckComma := SubStr(ReverseString, 1, 1) ;Crop string down to first char.
	if (CheckComma = ",") { ;Check if first char in reversed string is a comma.
		FrameRate := SubStr(FrameRate, 1, -1) ;Remove comma if last char is such.
		FrameRate := StrReplace(FrameRate, "`n", "") ;Removes linebreak and shit.
	}
	
}

;ayy
if (ForceRate = 0) && (ForceRes = 1) && (IsOtherOptionsOn = 1) && (RecompressVar = "FFmpeg") or (RecompressVar = "MEncoder") {
	;Made this bug fix cus FFmpeg doesn't like trailing commas in filter options.
	NewString := EncodeReversibleFilterVal
	ReverseString := DllCall( "msvcrt.dll\_strrev", Str, NewString, UInt,0, Str) ;Reverses string cus idk how to use SubStr backwards.
	CheckComma := SubStr(ReverseString, 1, 1) ;Crop string down to first char.
	if (CheckComma = ",") { ;Check if first char in reversed string is a comma.
		EncodeReversibleFilterVal := SubStr(EncodeReversibleFilterVal, 1, -1) ;Remove comma if last char is such.
		EncodeReversibleFilterVal := StrReplace(EncodeReversibleFilterVal, "`n", "") ;Removes linebreak and shit.
	}
}

if (ForceRate = 0) && (ForceRes = 0) && (IsOtherOptionsOn = 0) && (RecompressVar = "FFmpeg") {
	ResolutionVar := "" ;Clear unused res var
}

if (ForceRate = 0) && (ForceRes = 0) && (IsOtherOptionsOn = 0) && (RecompressVar = "MEncoder") {
	ResolutionVar := "" ;Clear unused res var
}

if (ForceRate = 1) && (ForceRes = 0) && (IsOtherOptionsOn = 0) && (RecompressVar = "MEncoder") {
	ResolutionVar := "" ;Clear unused res var
}




;Custom Encode Filter Shit Here Now.
if (EnableCustomEncodeWindowVar = 1) && (ForceRes = 0) && (ForceRate = 0) && (IsOtherOptionsOn = 1) {
	EncodeReversibleFilterVal := " " . CustomEncodeFilterVal
	EncodeReversibleFilterVal := StrReplace(EncodeReversibleFilterVal, "`n", "") ;Removes linebreak and shit.
	;msgbox, why
	Return
}

if (EnableCustomEncodeWindowVar = 1) && (ForceRes = 1) && (ForceRate = 0) && (IsOtherOptionsOn = 1) {
	TempResolutionVar := ",scale=" . StrReplace(TempResolutionVar, "x", ":")		
	EncodeReversibleFilterVal := " " . CustomEncodeFilterVal . TempResolutionVar
	EncodeReversibleFilterVal := StrReplace(EncodeReversibleFilterVal, "`n", "") ;Removes linebreak and shit.
	;msgbox, wao1
	Return
}

if (EnableCustomEncodeWindowVar = 1) && (ForceRes = 1) && (ForceRate = 1) && (IsOtherOptionsOn = 1) {
	;Made this bug fix cus FFmpeg doesn't like trailing commas in filter options.
	NewString := FrameRate
	ReverseString := DllCall( "msvcrt.dll\_strrev", Str, NewString, UInt,0, Str) ;Reverses string cus idk how to use SubStr backwards.
	CheckComma := SubStr(ReverseString, 1, 1) ;Crop string down to first char.
	if (CheckComma = ",") { ;Check if first char in reversed string is a comma.
		FrameRate := SubStr(FrameRate, 1, -1) ;Remove comma if last char is such.
	}
	
	FrameRate := StrReplace(FrameRate, " -vf", "")
	FrameRate := StrReplace(FrameRate, " ", ",")	
	EncodeReversibleFilterVal := " " . CustomEncodeFilterVal
	EncodeReversibleFilterVal := StrReplace(EncodeReversibleFilterVal, "`n", "") ;Removes linebreak and shit.
	;msgbox, wao2 %FrameRate%
	Return	
}


if (EnableCustomEncodeWindowVar = 1) && (ForceRes = 0) && (ForceRate = 1) && (IsOtherOptionsOn = 1) {
	;Made this bug fix cus FFmpeg doesn't like trailing commas in filter options.
	NewString := FrameRate
	ReverseString := DllCall( "msvcrt.dll\_strrev", Str, NewString, UInt,0, Str) ;Reverses string cus idk how to use SubStr backwards.
	CheckComma := SubStr(ReverseString, 1, 1) ;Crop string down to first char.
	if (CheckComma = ",") { ;Check if first char in reversed string is a comma.
		FrameRate := SubStr(FrameRate, 1, -1) ;Remove comma if last char is such.
	}
	
	FrameRate := StrReplace(FrameRate, " -vf", "")
	FrameRate := StrReplace(FrameRate, " ", ",")	
	EncodeReversibleFilterVal := " " . CustomEncodeFilterVal
	EncodeReversibleFilterVal := StrReplace(EncodeReversibleFilterVal, "`n", "") ;Removes linebreak and shit.
	;msgbox, wao8888 %ResolutionVar%
	Return	
}



if (IsOtherOptionsOn = 0) && (ForceRate = 0) && (ForceRes = 1) {
	;EncodeReversibleFilterVal := ""
	;EnableCustomEncodeWindowVar := ""
	;ResolutionVar := ""
	;msgbox, urgayest %TempResolutionVar%
	Return
}

;If Extra Options is disabled, clear the var.
if (IsOtherOptionsOn = 0) && (ForceRate = 1) && (ForceRes = 0) {
	EncodeReversibleFilterVal := ""
	GuiControl,,EnableCustomEncodeWindowVar,0
	EnableCustomEncodeWindowVar := ""
	ResolutionVar := ""
	EncodeReversibleFilterVal := StrReplace(EncodeReversibleFilterVal, "`n", "") ;Removes linebreak and shit.
	;msgbox, MEMES
	Return
}
Return


PreMEncoderCompression:
if (SourceFile = "") && (WebcamCompression = 0) {
	msgbox, uhhh you didn't select a video source???
	Return
}

if (IsBatchInput = 0) {
	goto, MEncoderCompression
	Return
}

if (IsBatchInput = 1) {
	goto, BatchME
	Return
}
Return

MEncoderCompression:
Gui, Submit, Nohide
SplitPath, MencoderCodecs,,,, codecname,
FileCreateDir, MEncoder-Output\%codecname%

GuiControlGet, ForceRes
GuiControl, 1:Disable, TomatoMode
GuiControl, 1:Disable, TomatoFrameCount
GuiControl, 1:Disable, TomatoFramePosition
GuiControl, 1:Disable, TomatoMOSHIT
GuiControl, 1:Disable, TomatoRecycle
GuiControl, 1:Disable, Recompress

RecompressVar := "MEncoder"
config = ":compdata=dialog"
OutputFilename := "./MEncoder-Output/" . codecname . "/output.avi" ;Default output filename.
EncodeReversibleFilterVal := "" ;Reset Filter value to avoid conflictions.
DecodeReversibleFilterVal := "" ;Reset Filter value to avoid conflictions.


if (MencoderCodecs = "vp31vfw.dll") {
	config = "" ;Configure dialog is broken for vp3.	
}


gosub, WebCamCompression
gosub, EnableReverseVideo
gosub, EnableForceRes
gosub, GetFilters
gosub, EnableForceRate
gosub, GetFilterOptionsAndFixStrings
;gosub, CustomFiltersOptions ;Havent made this for MEncoder yet.
;gosub, OutputLocation


if (UseOtherOptions = 0) { ;Remove the extra options/Reversible filters, if disabled.
	EncodeReversibleFilterVal := ""
	DecodeReversibleFilterVal := ""
	vfFlag := ""
}

;if (ForceRes = 1) && if (UseOtherOptions = 1) {
;	ResolutionVar := "" ;Reset the Forced Resolution Variable, because its being used in the Reversible filter variable instead.
;}

if (MencoderCodecs = "Amv2Codec.dll") else if (MencoderCodecs = "Amv2mtCodec.dll") else if (MencoderCodecs = "Amv3Codec.dll") {
	gosub, CustomAMVCompression ;Remove Watermark.
	Return
}

if (isBatchFilename = 1) { ; This is where the Batch output stuff happens.
	fileVal +=1
	Pack := "0000"
	zeropad := (SubStr(Pack, 1, StrLen(Pack) - StrLen(fileVal)) . fileVal) ;ZeroPadding for filenames
	OutputFilename := "./Batch-Output/output_" . zeropad . ".avi"	
}

if (ResolutionVar = NewResVar) {
	ResolutionVar := "" ;Clear this annoying bug I cant hunt down yet.
}


MECommand := ComSpec . " /c " . " mencoder " . MEncoderOptions . " " . chr(0x22) . SourceFile . chr(0x22) . ResolutionVar . EncodeReversibleFilterVal . FrameRate . " -of avi -o " . OutputFilename . " -ovc vfw -xvfwopts codec=" . MencoderCodecs . config
msgbox, %MECommand% ;Used for checking if the command syntax is correct.

  ;Execute MEncoder Here, also reads Standard Error Output.
MEoutput := ComObjCreate("WScript.Shell").Exec(MECommand).StdErr.ReadAll()



;Remove any extra avi made by the reverse video filter.
CheckFile := InputFolder . "\output2.avi"
if FileExist(CheckFile) {
	FileDelete, %InputFolder%/output2.avi
}

;Remove any extra baked yuv output files after compression.
CheckFile := OutputFolder . "\ImBaked.yuv"
if FileExist(CheckFile) {
	FileDelete, %OutputFolder%/ImBaked.yuv
}

;Remove any extra datamoshed output files after compression, to avoid chexr file confliction with previous input file.
CheckFile := OutputFolder . "\output-moshed.avi"
if FileExist(CheckFile) {
	FileDelete, %CheckFile%
}



If RegExMatch(MEoutput,"(Compressor doesn't have a configure dialog)") else IF RegExMatch(MEoutput,"(Compressor configure dialog failed!)")  {
	msgbox, Looks like the compressor lacks a configuration dialog or it failed, disabling.
	config := ""
	MECommand := cmd.exe /k "mencoder " . chr(0x22) SourceFile . chr(0x22) . ResolutionVar . " -of avi -o " . OutputFilename . " -ovc vfw -xvfwopts codec=" . MencoderCodecs . config . " -nosub -nosound"
	MEoutput := ComObjCreate("WScript.Shell").Exec(MECommand).StdErr.ReadAll()
	;msgbox, %MECommand% ;Used for checking of the command syntax is correct.
	
	
	
	IF RegExMatch(MEoutput,"(failed)") else IF RegExMatch(MEoutput,"(not aligned)") {
		msgbox, ffs something is wrong with resolution, falling back to Attempt Rescale.
		GoSub, MERetryScale
	}
	
}

GuiControlGet, RescaleMEncoderCodec
If (RescaleMEncoderCodec = 1) && RegExMatch(MEoutput,"(ICCompressQuery failed)") else IF RegExMatch(MEoutput,"(FATAL)") {
	msgbox, Testing a buttload of possible resolutions now, sit tight. %MEoutput% `n %RescaleMEncoderCodec%
	gosub, MERetryScale
}

If RegExMatch(MEoutput,"(ICCompressQuery failed)") else IF RegExMatch(MEoutput,"(FATAL)") {
	msgbox,
(
FUCK THE COMPRESSION FAILED!!!
(If it's -2 You PROBABLY need to adjust the resolution to one
that the Codec suports. 
check http://samples.mplayerhq.hu/V-codecs/ for existing video samples)

YOUR ERROR IS:
======================================
%MEoutput%
(Enable the "Attempt Rescale" option to try and bypass this)
======================================

Possible Error Codes:
ICERR_OK		0
ICERR_DONTDRAW	1
ICERR_NEWPALETTE	2
ICERR_GOTOKEYFRAME	3
ICERR_STOPDRAWING	4

ICERR_UNSUPPORTED	-1
ICERR_BADFORMAT	-2
ICERR_MEMORY		-3
ICERR_INTERNAL		-4
ICERR_BADFLAGS		-5
ICERR_BADPARAM		-6
ICERR_BADSIZE		-7
ICERR_BADHANDLE	-8
ICERR_CANTUPDATE	-9
ICERR_ABORT		-10
ICERR_ERROR		-100
ICERR_BADBITDEPTH	-200
ICERR_BADIMAGESIZE	-201

ICERR_CUSTOM		-400
)
	
	Return
}

;Keep Tomato disabled until a compression is achieved.
if (NoTomato4U = 1) {
	msgbox, Tomato is disabled still :(
	return
}

;If Compression didn't fail, enable the Tomato window.
if (isBatchFilename = 0) {
	msgbox, You may now use the Tomato window to Datamosh!
}
GuiControl, 1:Enable, TomatoMode
GuiControl, 1:Enable, TomatoFrameCount
GuiControl, 1:Enable, TomatoFramePosition
GuiControl, 1:Enable, TomatoMOSHIT
AllowChexr := 1
EncodeReversibleFilterVal := "" ;Clear the var to avoid bugs becuase I'm dumb and losing track of what I'm doing.
Return

CustomAMVCompression:
FileCreateDir, AMV-Output
Gui, Submit, NoHide
if (SourceFile = "") {
	msgbox, Select Something Yo.
	return
}

RecompressVar := "AMV"
config = ":compdata=dialog"
RecompressVar := "MEncoder"
whichPreset := ""

;Places black bar at the bottom of the video, isolating the watermark, -sws 4 helps with quality loss upon scaling.
AMV2BufferWatermark1 := " -sws 4 -vf scale=640:360,expand=0:-70:0:0,scale=640:360" 
AMV2BufferWatermark2 := " -sws 4 -vf scale=1280:720,expand=0:-170:0:0,scale=1280:720"
AMV2BufferWatermark3 := " -sws 4 -vf scale=3840:2160,expand=0:-330:0:0,scale=3840:2160"


;Crops out the isolated watermark, used during baking. Left here for reference.
;AMV2RemoveWatermark1 := "-vf crop=640:300:0:60"
;AMV2RemoveWatermark2 := "-vf crop=1280:580:0:140"
;AMV2RemoveWatermark3 := " -vf crop=3840:1860:0:290"


gosub, WebCamCompression
gosub, EnableReverseVideo
gosub, EnableForceRate
gosub, EnableForceRes
;gosub, GetFilters
;gosub, GetFilterOptionsAndFixStrings



if (UseOtherOptions = 0) { ;Remove the extra options/Reversible filters, if disabled.
	EncodeReversibleFilterVal := ""
	DecodeReversibleFilterVal := ""
}

if (ForceRes = 1) && if (UseOtherOptions = 1) {
	ResolutionVar := "" ;Reset the Forced Resolution Variable, because its being used in the Reversible filter variable instead.
}

msgbox, Testing Custom AMV compression, removing watermark, etc.
;Select Preset for now.
AMV2GUI()
if (UseOtherOptions = 1) {
	EncodeReversibleFilterVal := StrReplace(EncodeReversibleFilterVal, "-vf ", "") ;Remove -vf
	EncodeReversibleFilterVal := Trim(EncodeReversibleFilterVal) ;Remove spaces.
	
	whichPreset := whichPreset . "," . EncodeReversibleFilterVal
}


MECommand := ComSpec . " /c " . " mencoder " . chr(0x22) . SourceFile . chr(0x22) . whichPreset . FrameRate . " -of avi -o " . InputFolder . "\output.avi -ovc vfw -xvfwopts codec=" . MencoderCodecs . config . " -nosub -nosound"

MEoutput := ComObjCreate("WScript.Shell").Exec(MECommand).StdErr.ReadAll()


msgbox, You may now use the Tomato window to Datamosh!
GuiControl, 1:Enable, TomatoMode
GuiControl, 1:Enable, TomatoFrameCount
GuiControl, 1:Enable, TomatoFramePosition
GuiControl, 1:Enable, TomatoMOSHIT
Return

;AMV2 Watermark Removal Presets
AMV2Preset640:
Gui, 3:Destroy
whichPreset := AMV2BufferWatermark1
Sel := 1
return

AMV2Preset1280:
Gui, 3:Destroy
whichPreset := AMV2BufferWatermark2
Sel := 2
return

Option4K:
Gui, 3:Destroy
whichPreset := AMV2BufferWatermark3
Sel := 3
Return

OptionNone:
Gui, 3:Destroy
whichPreset := ResolutionVar
Sel := 4
Return
;/AMV2 Watermark Removal Presets


ListCodecOptions:
Gui, Submit, NoHide
msgbox, These are the options you can use for the %FFmpegCodecs% codec.
GetOptions := "ffmpeg -h encoder=" . FFmpegCodecs
runwait, cmd.exe /k %GetOptions%
Return

PreFFmpegCompression:
if (SourceFile = "") && (WebcamCompression = 0) {
	msgbox, uhhh you didn't select a video source???
	Return
}

if (IsBatchInput = 0) {
	goto, FFmpegCompression
	Return
}

if (IsBatchInput = 1) {
	goto, BatchFF
	Return
}
Return

;wao now we got all the FFmpeg codecs too lol
FFmpegCompression:
Gui, Submit, Nohide


;Set the Frei0r System Environment Variable value so FFmpeg can find it!
Frei0rDir := A_ScriptDir . "\FREI0R-FILTERS"
EnvSet, FREI0R_PATH, %Frei0rDir%


FFOutputFolder := "FFmpeg-Output\" . FFmpegCodecs
FileCreateDir, %FFOutputFolder%
if ErrorLevel {
	msgbox, fuck idk why that happened, PM me?
}

GuiControl, 1:Disable, TomatoMode
GuiControl, 1:Disable, TomatoFrameCount
GuiControl, 1:Disable, TomatoFramePosition
GuiControl, 1:Disable, TomatoMOSHIT
GuiControl, 1:Disable, TomatoRecycle


OutputFilename := "./FFmpeg-Output/" . FFmpegCodecs .  "/output.avi"
RecompressVar := "FFmpeg"
EncodeReversibleFilterVal := ""
DecodeReversibleFilterVal := ""

gosub, WebCamCompression
gosub, EnableReverseVideo
gosub, EnableForceRes
gosub, VideoQualitySlider ; For some reason I had to place this here or else the VideoQuality var lost its decimal.
gosub, GetFilters
gosub, EnableForceRate
gosub, GetFilterOptionsAndFixStrings
gosub, OutputLocation


if (isBatchFilename = 1) {
	fileVal +=1
	Pack := "0000"
	zeropad := (SubStr(Pack, 1, StrLen(Pack) - StrLen(fileVal)) . fileVal) ;ZeroPadding for filenames.
	OutputFilename := "./Batch-Output/output_" . zeropad . ".avi"
}

if (ForcedBake = 1) {
	SourceFile := InputFolder . "\Moshed\" . BakedFilename
}

if (ResolutionVar = NewResVar) {
	ResolutionVar := "" ;Clear this annoying bug I cant hunt down yet.
}

sleep, 10
FFCommand := ComSpec . " /k " . " ffmpeg " . InputFrameRate . " -i " . chr(0x22) . SourceFile . chr(0x22) . ResolutionVar . EncodeReversibleFilterVal . FrameRate . " -f avi -strict -2 -c:v " . FFmpegCodecs . " -q:v " . VQuality . " " . FFmpegOptions . " " . OutputFilename . " -y"
MsgBox, %FFCommand% ;Used for testing if the command syntax is correct.

  ;Execute FFmpeg Here, also reads Standard Error Output.
;runwait, %FFCommand%
FFoutput := ComObjCreate("WScript.Shell").Exec(FFCommand).StdErr.ReadAll()

;This trims all the extra bullshit the FFmpeg devs didnt omit from Standard Error Output(STDERR).
StartingPos := InStr(FFoutput, "[")
FFoutput := SubStr(FFoutput, StartingPos + 25)



;Remove any extra avi made by the reverse video filter.
CheckFile := InputFolder . "\output2.avi"
if FileExist(CheckFile) {
	FileDelete, %InputFolder%/output2.avi
}

;Remove any extra baked yuv output files after compression.
CheckFile := OutputFolder . "\ImBaked.yuv"
if FileExist(CheckFile) {
	FileDelete, %OutputFolder%/ImBaked.yuv
}

;Remove any extra datamoshed output files after compression, to avoid chexr file confliction with previous input file.
CheckFile := OutputFolder . "\output-moshed.avi"
if FileExist(CheckFile) {
	FileDelete, %CheckFile%
}



;If you used an incorrect Frie0r filter name, this should be triggered.
IF RegExMatch(FFoutput,"(Could not find module )") && RegExMatch(FFoutput,"(Parsed_frei0r)") {
	msgbox, You probably used the wrong Frei0r filter name.`n`n`n%FFoutput%
	Return
}

;If you used incorrect filter settings, this should be triggered.
IF RegExMatch(FFoutput,"(Error initializing complex filters)") or RegExMatch(FFoutput,"(Invalid argument)") {
	msgbox, You either used the wrong filter or filter settings.`n`n`n%FFoutput%
	Return
}

IF RegExMatch(FFoutput,"(The specified picture size)") or RegExMatch(FFoutput,"(maybe incorrect parameters)") {
	msgbox, oshit an error, my first guess is video resolution is probably wrong.`n%FFoutput%
	gosub, FFRetryScale
}

;Gonna add an MPlayer workaround here soon?
IF RegExMatch(FFoutput,"( find codec parameters for stream )") or RegExMatch(FFoutput,"(unknown codec)") {
	msgbox, Seems FFmpeg cant decode this video codec.`nPlease try something else or try again.
	Return
}

;Gonna add an MPlayer workaround here soon?
IF RegExMatch(FFoutput,"(Invalid data found)") {
	msgbox, There may have been an issue decoding.`nThis message is normal however, if you hex edited the avi.
}



;Keep Tomato disabled until a compression is achieved.
if (NoTomato4U = 1) {
	msgbox, Tomato is disabled still :(
	return
}

if (isBatchFilename = 0) {
	msgbox, You may now use the Tomato window to Datamosh!	
}
GuiControl, 1:Enable, TomatoMode
GuiControl, 1:Enable, TomatoFrameCount
GuiControl, 1:Enable, TomatoFramePosition
GuiControl, 1:Enable, TomatoMOSHIT
AllowChexr := 1
EncodeReversibleFilterVal := "" ;Clear the var to avoid bugs because I'm dumb and losing track of what I'm doing.
Return



FFRetryScale:
config := ""
NoTomato4U := 0
TryRes +=1
ResArray := ["16:16", "352:288" , "120:90" , "128:128" , "256:256" , "320:200" , "320:240" , "400:240" , "480:576" , "500:500" , "512:256" , "640:320" , "640:360" , "640:480" , "720:480" , "1280:720" , "1366:768" , "1440:1080" , "1920:1080" , "3840:2160" , "7680:4320" , "15360:8640"]
ResolutionVar := " -vf scale=" . ResArray[TryRes]


if (ResolutionVar = " -vf scale=") {
	msgbox, WTF NOTHING WORKED?!? Sorry.
	NoTomato4U := 1 ;Keep Tomato disabled until a compression is achieved.
	TryRes := "" ;Reset the array counter, again.
	return
}

gosub, OutputLocation

FFCommand := ComSpec . " /c " . " ffmpeg -i " . chr(0x22) . SourceFile . chr(0x22) . ResolutionVar . " -f avi -strict -2 -c:v " . FFmpegCodecs . " -q:v " . VQuality . " " . FFmpegOptions . " " . InputFolder . "\output.avi -y"
   ;MsgBox, %FFCommand%

  ;Execute FFmpeg Here, also reads Standard Error Output.
FFoutput := ComObjCreate("WScript.Shell").Exec(FFCommand).StdErr.ReadAll()


IF RegExMatch(FFoutput,"(The specified picture size)") else IF RegExMatch(FFoutput,"(maybe incorrect parameters)") {
	;This trims all the extra bullshit the FFmpeg devs didnt omit from Standard Error Output(STDERR).	
	StartingPos := InStr(FFoutput, "[")
	FFoutput := SubStr(FFoutput, StartingPos + 25)
	msgbox, it failed, again. `n`n %FFoutput% `n`n %ResolutionVar%
	gosub, FFRetryScale
	return
}

IF RegExMatch(FFoutput,"(muxing overhead)") else IF RegExMatch(FFoutput,"(frame=)") {
	Gui, 2:Add, Button, x10 y66 w70 h24 gKeepRescale, Keep
	Gui, 2:Add, Button, x83 y66 w70 h24 Default gFFTryAgain, Retry
	Gui, 2:Add, Text, x2 y2 w162 h63, `n      Looks like it worked? `n Res was: %ResolutionVar%
	Gui, 2:Show, w162 h92,We Got A Live One!!!
	Gui, 2:-Sysmenu
	WinWaitClose, We Got A Live One!!!
	return
}

msgbox, wot? I dont know what happened anymore... %ResolutionVar% `n`n %FFoutput%
TryRes := "" ;Reset the array counter, again.
Return



MERetryScale:
config := ""
NoTomato4U := 0
TryRes +=1
ResArray := ["16:16", "64:64" , "120:90" , "128:128" , "256:256" , "320:200" , "320:240" , "400:240" , "480:576" , "500:500" , "512:256" , "640:320" , "640:360" , "640:480" , "720:480" , "1280:720" , "1366:768" , "1440:1080" , "1920:1080" , "3840:2160" , "7680:4320" , "15360:8640"]
ResolutionVar := " -vf scale=" . ResArray[TryRes]

if (MencoderCodecs = "smv2.dll") {
	config := ":compdata=dialog "
	;Forces Compression Dialog on ReScale, since this codec NEEDS it in order to compress lolol.
}

if (ResolutionVar = " -vf scale=") {
	msgbox, WTF NOTHING WORKED?!? Sorry.
	NoTomato4U := 1 ;Keep Tomato disabled until a compression is achieved.
	TryRes := "" ;Reset the array counter, again.
	return
}

gosub, OutputLocation

MECommand := ComSpec . " /c " . " mencoder " . chr(0x22) . SourceFile . chr(0x22) . ResolutionVar . FrameRate . " -of avi -o " . InputFolder . "\output.avi -ovc vfw -xvfwopts codec=" . MencoderCodecs . config . " -nosub -nosound"
  ;msgbox, %MECommand% ;Used for checking of the command syntax is correct.

  ;Execute MEncoder Here, also reads Standard Error Output.
MEoutput := ComObjCreate("WScript.Shell").Exec(MECommand).StdErr.ReadAll()



If RegExMatch(MEoutput,"(ICCompressQuery failed)") else IF RegExMatch(MEoutput,"(FATAL)") else IF RegExMatch(MEoutput,"(failed)") else IF RegExMatch(MEoutput,"(not aligned)")  {
	msgbox, it failed, again. `n`n %MEoutput% `n`n %ResolutionVar%
	gosub, MERetryScale
	return
}

If (MEoutput = "") else IF RegExMatch(MEoutput,"(Skipping frame)") else IF RegExMatch(MEoutput,"(duplicate frame)") else IF RegExMatch(MEoutput,"(Scene change)") {
	Gui, 2:Add, Button, x10 y66 w70 h24 gKeepRescale, Keep
	Gui, 2:Add, Button, x83 y66 w70 h24 Default gMETryAgain, Retry
	Gui, 2:Add, Text, x2 y2 w162 h63, `n      Looks like it worked? `n Res was: %ResolutionVar%
	Gui, 2:Show, w162 h92,We Got A Live One!!!
	Gui, 2:-Sysmenu
	WinWaitClose, We Got A Live One!!!
	return
}

msgbox, wot? I dont know what happened anymore... %ResolutionVar% `n`n %MEoutput%
TryRes := "" ;Reset the array counter, again.
Return



KeepRescale:
Gui, 2:Destroy
TryRes := ""
return

METryAgain:
Gui, 2:Destroy
Gosub, MERetryScale
return

FFTryAgain:
Gui, 2:Destroy
Gosub, FFRetryScale
return


BatchME:
;Gui, Submit, NoHide
FileCreateDir, %A_ScriptDir%\Batch-Output

extensions := "mp4,webm,avi,mkv,yuv"

Loop,%leFolder%\*
{  ; count the amount of target files in folder so we can stop the loop properly.
	if A_LoopFileExt in %extensions%		
		countfiles += 1
	stoploop := countfiles
}

Loop,%leFolder%\*
{
	TargetFiles := A_LoopFileFullPath
	SplitPath, TargetFiles, name, dir, ext, name_no_ext,
	if A_LoopFileExt in %extensions%
	{
		sourceFile := TargetFiles
		isBatchFilename := 1
		gosub, MEncoderCompression
		
	}
	if (A_Index = stoploop) {
		msgbox, o shit its done, now you can datamosh all them files.
		
		isBatchFilename := 0
		countfiles := 0
		fileVal := 0
		zeropad := ""
		
		gosub, CommenceBatchTomatoDatamosh
		break
	}
}
if ErrorLevel {
	msgbox, FUCK you did it now, didn't you?
}
return

BatchFF:
;Gui, Submit, NoHide
FileCreateDir, %A_ScriptDir%\Batch-Output

extensions := "mp4,webm,avi,mkv,yuv"

Loop,%leFolder%\*
{  ; count the amount of target files in folder so we can stop loop properly.
	if A_LoopFileExt in %extensions%		
		countfiles += 1
	stoploop := countfiles
}

Loop,%leFolder%\*
{
	TargetFiles := A_LoopFileFullPath
	SplitPath, TargetFiles, name, dir, ext, name_no_ext,
	if A_LoopFileExt in %extensions%
	{
		sourceFile := TargetFiles
		isBatchFilename := 1
		gosub, FFmpegCompression
		
	}
	if (A_Index = stoploop) {
		msgbox, o shit its done, now you can datamosh all them files.
		
		isBatchFilename := 0
		countfiles := 0
		fileVal := 0
		zeropad := ""
		
		gosub, CommenceBatchTomatoDatamosh
		break
	}
}
if ErrorLevel {
	msgbox, FUCK you did it now, didn't you?
}
return



CustomCodecShit:
GuiControlGet, MencoderCodecs
Gui, Submit, NoHide
CustomCodecFix := ""

gosub, OutputLocation

if (MencoderCodecs = "x265vfw.dll") {
	
	CustomCodecFix := ""
	LemmeSeeIt := "cmd.exe /c new-mplayer " . CustomCodecFix . " " . OutputFolder . "\output-moshed.avi -loop 0"
	PNGBake := "new-mplayer " . CustomCodecFix . " " . OutputFolder . "\output-moshed.avi -vo png:outdir=FRAMES -cache 1024"
	MP4Bake := "new-mencoder " . CustomCodecFix . " " . OutputFolder . "\output-moshed.avi -ovc x264 -x264encopts crf=1.0 " . MEncoderOptions " -o " . OutputFolder . "\ImBaked.mp4 -of lavf"
	YUVBake := "new-mplayer " . CustomCodecFix . " -vo yuv4mpeg " . OutputFolder "\output-moshed.avi"
}


if (MencoderCodecs = "smv2.dll") {
	
	CustomCodecFix := "-vc smv2Old"
	;Forces the custom decoder I added to the codecs.config
}

if (MencoderCodecs = "smv2vfw.dll") {
	
	CustomCodecFix := "-vc smv2vfw"
	;Forces the custom decoder I added to the codecs.config
	;remove this whole if statement if you want to confuse mplayer and use the incorrect decoder for some spicy glitches.
}

;Removes the watermark burnt into the video by AMV2
if (MencoderCodecs = "Amv2Codec.dll") or (MencoderCodecs = "Amv2mtCodec.dll") or (MencoderCodecs = "Amv3Codec.dll") {
	;msgbox, Using Custom AMV2 Watermark Removal.
    ;Crops out the isolated watermark
	AMV2RemoveWatermark1 := " -sws 4 -vf crop=640:300:0:60,scale=640:360"
	AMV2RemoveWatermark2 := " -sws 4 -vf crop=1280:580:0:140,scale=1280:720"
	AMV2RemoveWatermark3 := " -sws 4 -vf crop=3840:1860:0:290,scale=3840:2160"
	
	
	if (Sel = 1) {
		CustomCodecFix := AMV2RemoveWatermark1
		LemmeSeeIt := "cmd.exe /c mplayer " . CustomCodecFix . " " . OutputFolder . "\output-moshed.avi -loop 0"
	}
	if (sel = 2) {
		CustomCodecFix := AMV2RemoveWatermark2
		LemmeSeeIt := "cmd.exe /c mplayer " . CustomCodecFix . " " . OutputFolder . " output-moshed.avi -loop 0"
	}
	if (sel = 3) {
		CustomCodecFix := AMV2RemoveWatermark3
		LemmeSeeIt := "cmd.exe /c mplayer " . CustomCodecFix . " " . OutputFolder . " output-moshed.avi -loop 0 -fs"
	}
	
	Return
	
}
Return



TestPython:
if (WeGotPython = 1) {
	return
}

regread, python, HKLM, SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\python.exe
if (python = "") or !RegExMatch(python,"(Python27)")  {
	msgbox, Enter your Python27 Path/Folder.`n`nIts usually like "C:\Python27"
	Gui, 10:Color, DDCEE9	
	Gui 10:Add, Edit, x0 y8 w120 h21 vCustomPythonPath,
	Gui 10:Add, Button, x0 y50 w120 h21 gSubmitPythonLocation, ok
	Gui 10:-sysmenu	
	Gui 10:Show, w120 h80, Paste le Path Here
	WeGotPython := ""
	WinWaitClose, Paste le Path Here
	return
	
}

If RegExMatch(python,"(Python27)")
{
	return
}
Return

EnableForcePythonLocation:
GuiControlGet, PythonLocationIsOn
if (PythonLocationIsOn = 1) {
	gosub, ForcePythonLocation
	Return
}

if (PythonLocationIsOn = 0) {
	;If disabled it reads the python location from the registry instead.
	regread, pythonLoc, HKLM, SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\python.exe
	python := pythonLoc
	msgbox, Disabled Forced Python Location!
	Return
}
Return


ForcePythonLocation:
msgbox, Enter your Python27 Path/Folder.`n`nIts usually like "C:\Python27"
Gui, 10:Color, DDCEE9
Gui 10:Add, Edit, x0 y8 w120 h21 vCustomPythonPath,
Gui 10:Add, Button, x10 y50 w100 h21 gSubmitPythonLocation, ok
Gui 10:-sysmenu
Gui 10:Show, w120 h80, Paste le Path Here
WeGotPython := 1
WinWaitClose, Paste le Path Here
return

SubmitPythonLocation:
Gui, Submit, NoHide
sleep, 50
python := CustomPythonPath . "\python.exe" ;Adds python.exe to folder path.
WeGotPython := 1
Gui, 10:Destroy
Return


TomatoHalp:
msgbox, 
(
COMPRESS A SOURCE WITH EITHER OF THE "GO" BUTTONS, FIRST!
           -c is FRAME COUNT & -n is FRAME POSITION, btw.
===========================================
Take out all iframes except for the first one:
python tomato.py -i input.avi -m ikill output.avi

Duplicate 50 times the 100th frame:
python tomato.py -i input.avi -m bloom -c 50 -n 100 output.avi

Duplicates 5 times a frame every 10 frame:
python tomato.py -i input.avi -m pulse -c 5 -n 10 output.avi

Shuffles all of the frames in the video:
python tomato.py -i input.avi -m shuffle output.avi

Copy 4 frames taken starting from every 2nd frame. 
i.e [1 2 3 4 3 4 5 6 5 6 7 8 7 8...]:
python tomato.py -i input.avi -m overlapped -c 4 -n 2 output.avi
===========================================

)
Return



OutputLocation:
Gui, Submit, NoHide
if (RecompressVar = "FFmpeg") && (ForcedBake = 0) && (IsCustomFolder = 0) {
	InputFolder := RecompressVar . "-Output\" . FFmpegCodecs
	OutputFolder := RecompressVar . "-Output\" . FFmpegCodecs . "\Moshed"
	FileCreateDir, %OutputFolder%
	;msgbox, %OutputFolder%
}

if (RecompressVar = "MEncoder") && (ForcedBake = 0) && (IsCustomFolder = 0) {
	SplitPath, MencoderCodecs,,,, codecname,	
	InputFolder := RecompressVar . "-Output\" . codecname
	OutputFolder := RecompressVar . "-Output\" . codecname . "\Moshed"
	FileCreateDir, %OutputFolder%
	;msgbox, kms
}

if (RecompressVar = "FFmpeg") && (isBatchInput = 1) {
	InputFolder := "Batch-Output\" . FFmpegCodecs
	OutputFolder := "Batch-Output-Moshed\" . FFmpegCodecs
	FileCreateDir, %OutputFolder%
	;msgbox, %OutputFolder%
}

if (RecompressVar = "MEncoder") && (isBatchInput = 1) {
	SplitPath, MencoderCodecs,,,, codecname,	
	InputFolder := "Batch-Output\" . codecname
	OutputFolder := "Batch-Output-Moshed\" . codecname
	FileCreateDir, %OutputFolder%
	;msgbox, %OutputFolder%
}

;Wao now we can transfer datamoshed artifacts from MEncoder to FFmpeg, via baking since FFMpeg doesnt enjoy Tomatoes.
if (RecompressVar = "FFmpeg") && (ForcedBake = 1) {
	SplitPath, MencoderCodecs,,,, codecname,	
	InputFolder := "MEncoder-Output\" . codecname
	OutputFolder := RecompressVar . "-Output\" . FFmpegCodecs . "\Moshed"
	FileCreateDir, %OutputFolder%
}


;<3 <3 <3
if (RecompressVar = "FFmpeg") && (ForcedBake = 0) && (IsCustomFolder = 1) {
	SplitPath, DefaultSourceFile,,InputFileDir
	InputFolder := InputFileDir . "\" . RecompressVar . "-Output\" . FFmpegCodecs
	OutputFolder := InputFileDir . "\" . RecompressVar . "-Output\" . FFmpegCodecs . "\Moshed"
	
	FileCreateDir, %OutputFolder%
	OutputFilename := InputFolder . "\output.avi" ;Default output filename.
}

if (RecompressVar = "MEncoder") && (IsCustomFolder = 1) {
	SplitPath, DefaultSourceFile,,InputFileDir	
	SplitPath, MencoderCodecs,,,, codecname,	
	InputFolder := InputFileDir . "\" . RecompressVar . "-Output\" . codecname
	OutputFolder := InputFileDir . "\" . RecompressVar . "-Output\" . codecname . "\Moshed"	
	
	FileCreateDir, %OutputFolder%
	OutputFilename := InputFolder . "\output.avi" ;Default output filename.	
}
Return



CommenceTomatoDatamosh:
;Destroy AVI Index via Tomato for Datamoshed Goodness!!!
Gui, Submit, Nohide

LemmeSeeIt := ComSpec . " /c " . "mplayer " . CustomCodecFix . " " . OutputFolder . "\output-moshed.avi -loop 0" ;Default.

gosub, CustomCodecShit
gosub, TestPython
gosub, OutputLocation
NoGetDiffPls := 0
ForcedBake := 0
ChexrWasUsed := 0 ;If you use Datamosh It immediately after using chexr, this will reset this var and use "output-moshed.avi" instead of "output.avi".

;Remove the datamoshed avi if it existms before using Tomato to Datamosh, to avoid file conflicts.
CheckMe := OutputFolder . "\output-moshed.avi"
if FileExist(CheckMe) {
	FileDelete,%CheckMe%
}

RunTomato := ComSpec . " /c " . python . " tomato.py -i " . InputFolder . "/output.avi -m " . TomatoMode . " -c " . TomatoFrameCount . " -n " . TomatoFramePosition . " " . OutputFolder . "/output-moshed.avi"
;msgbox, %RunTomato%
;runwait, %ComSpec% /k %python% tomato.py -i %InputFolder%/output.avi -m %TomatoMode% -c %TomatoFrameCount% -n %TomatoFramePosition% ./%OutputFolder%/output-moshed.avi
runwait, %RunTomato%
runwait, %LemmeSeeIt%
;open custom baking menu afterwards
BakeGUI()

GuiControl, 1:Enable, TomatoRecycle
GuiControl, 1:Enable, Recompress
Return

RecycleTomatoOutput:
;This is the ReMosh button.
;Destroy AVI Index of the Previous file via Tomato for even more Datamoshed Goodness!!!
Gui, Submit, Nohide

gosub, CustomCodecShit
gosub, TestPython
gosub, OutputLocation
NoGetDiffPls := 0
ForcedBake := 0

LemmeSeeIt := "mplayer " . CustomCodecFix . " " . OutputFolder . "/output-moshed2.avi -loop 0"

runwait, %ComSpec% /c %python% tomato.py -i ./%OutputFolder%/output-moshed.avi -m %TomatoMode% -c %TomatoFrameCount% -n %TomatoFramePosition% ./%OutputFolder%/output-moshed2.avi
runwait, %LemmeSeeIt%
;Rename File back to original.
FileDelete, %OutputFolder%/output-moshed.avi
FileMove, %OutputFolder%/output-moshed2.avi, %OutputFolder%/output-moshed.avi
;open custom baking menu afterwards 
BakeGUI()
Return

CommenceBatchTomatoDatamosh:
;Destroy AVI Index via Tomato for Datamoshed Goodness!
;Currently uses the selected Datamosh settings in the GUI, gonna add an option to use an array soon.
Gui, Submit, NoHide
FileRemoveDir, Batch-Output-Moshed
sleep, 300
FileRemoveDir, Batch-Output
sleep, 300
FileCreateDir, Batch-Output-Moshed

Loop,%A_ScriptDir%\Batch-Output\*.avi
{
	If RegExMatch(A_LoopFileExt,"(avi)")
		countfiles += 1
	stoploop := countfiles
}

Loop,%A_ScriptDir%\Batch-Output\*.avi
{
	TargetFiles := A_LoopFileFullPath
	SplitPath, TargetFiles, name, dir, ext, name_no_ext,
	If RegExMatch(A_LoopFileExt,"(avi)")
	{
		sourceFile := TargetFiles
		isBatchFilename := 1
		fileVal +=1
		Pack := "0000"
		zeropad := (SubStr(Pack, 1, StrLen(Pack) - StrLen(fileVal)) . fileVal) ;ZeroPadding for filenames.
		FileLocation :=  " ./Batch-Output-Moshed/moshed_" . zeropad . ".avi"
		
		gosub, CustomCodecShit
		gosub, TestPython
		Runit := ComSpec . " /c " . python . " tomato.py -i " . chr(0x22) . sourceFile . chr(0x22) . " -m " . TomatoMode . " -c "  . TomatoFrameCount . " -n  " . TomatoFramePosition . FileLocation
		runwait, %Runit%
	}
	if (A_Index = stoploop) {
	;	msgbox, o shit its done, now you can join all them videos.
	;	gosub, ConcatenateMe
		isBatchFilename := 0
		countfiles := 0
		fileVal := 0
		zeropad := ""
		
		;Now we gotta count and get the names of the moshed avi files.
		Loop,%A_ScriptDir%\Batch-Output-Moshed\*.avi
		{
			If RegExMatch(A_LoopFileExt,"(avi)")
				countfiles += 1
			stoploop2 := countfiles
			ConcatString .= chr(0x22) . A_LoopFileFullPath . chr(0x22) . " " ; Wrap each filename in double quotes.
			ConcatString := StrReplace(ConcatString, "`r`n", " ") ;Removes linebreak and shit.
		}
		if (A_Index = stoploop2) {
			msgbox, joining files nao
			;gosub, PlsBakeMP4Batch ;Concat them all into a single mp4, for now.
		     ;open custom baking menu afterwards
			BatchBake := 1
			countfiles := 0
			NoGetDiffPls := 0
			ForcedBake := 0			
			
			LemmeSeeItBatch := "mplayer " . ConcatString
			runwait, %LemmeSeeItBatch%
			
			BakeGUI()
			WinWaitClose, Shall We Bake Some More???
			GuiControl, 1:Enable, TomatoRecycle
			GuiControl, 1:Enable, Recompress
			BatchBake := 0
			break
		}
	}
	if ErrorLevel {
		msgbox, FUCK you did it now, didn't you?
	}
}
Return

;Error Testing Here ATM
ReCompressMoshedOutput:
if (ItsANewSource = 1 ) && (ChexrWasUsed = 0) {
	SourceFile := OutputFolder . "\output-moshed.avi"
	msgbox, 1
}

if (ItsANewSource = 0) && (ChexrWasUsed = 1) {
	SourceFile := InputFolder . "\output.avi"
	msgbox, 2
}

if (ItsANewSource = 0) && (ChexrWasUsed = 0) {
	SourceFile := OutputFolder . "\output-moshed.avi"	
	msgbox, 3
	
}


if (RecompressVar = "MEncoder") {
	msgbox, Compressing the moshed file,`nwith the current MEncoder vfw codec selected!
	isRecompressed := 1
	gosub, MEncoderCompression
	isRecompressed := 0
	ForcedBake := 0 ;Reset Forced Bake Var
	;NoGetDiffPls := 0	
	return
}

if (RecompressVar = "FFmpeg") {
	msgbox, Compressing the moshed file, `nwith the current FFmpeg codec selected!
	isRecompressed := 1	
	gosub, FFmpegCompression
	isRecompressed := 0
	ForcedBake := 0 ;Reset Forced Bake Var
	;NoGetDiffPls := 0	
	return
}

if (RecompressVar = "AMV") {
	msgbox, Compressing the moshed file,`nwith the beta AMV2 Watermark removal!
	isRecompressed := 1	
	gosub, CustomAMVCompression
	isRecompressed := 0
	ForcedBake := 0
	return
}
Return


PlsBakePNG:
Gui, 3:Destroy

if (RecompressVar = "FFmpeg") {
	whichCodec := FFmpegCodecs . "-FRAMES"
}

if (RecompressVar = "MEncoder") {
	SplitPath, MencoderCodecs,,,, codecname,	
	whichCodec := "" . codecname . "-FRAMES"
}

DirName := "PNG-Output"

FileRemoveDir, %DirName%\%whichCodec%, 1 ;Delete the folder first every time, to avoid conflicting frames from previous video.
sleep, 50
FileCreateDir, %DirName%

gosub, CustomCodecShit ;Temporary fix for HEVC/H265 decoding.
gosub, OutputLocation ;Get the foldername the Datamoshed avi is in.

inputFile := "\output-moshed.avi "
if (BatchBake = 1) {
	inputFile := " " . ConcatString . " "
	OutputFolder := ""
}


CheckItOut := ComSpec . " /c " . "ffplay -i " . DirName . "\" . whichCodec . "\%08d.png -loop 0"
PNGBake := ComSpec . " /c " . "mplayer -vo png:outdir=PNG-Output\" . whichCodec . " -cache 1024 " . " -sws 4 " . DecodeReversibleFilterVal . " " . CustomCodecFix . OutputFolder . inputFile

runwait, %PNGBake%
sleep, 20
WinWaitClose, cmd

runwait, %CheckItOut%
;FileDelete, %OutputFolder%\output-moshed.avi

run, %A_ScriptDir%\%DirName%\%whichCodec%
Return

PlsBakeMP4:
;Usually works, if not then select the YUV option and convert that to mp4 with FFmpeg yourself.
;I originally added noskip by default to make the output more smooth, but this is optional via the GUI now.
Gui, 3:Destroy
FileDelete, ImBaked.mp4

gosub, OutputLocation ;Get the foldername the Datamoshed avi is in.

BakedFilename := "ImBaked.mp4"
inputFile := OutputFolder . "\output-moshed.avi "

gosub, CustomCodecShit
MP4Bake := ComSpec . " /c " . "mencoder " . CustomCodecFix . " " . inputFile . " -sws 4 " . DecodeReversibleFilterVal . MP4BakeOptions " -o " . OutputFolder . BakedOutputFolder . "\" . BakedFilename . " -of lavf" ;Default
gosub, CustomCodecShit ;Temporary fix for HEVC/H265 decoding.


if (BatchBake = 1) {
	inputFile := " " . ConcatString . " "
	BakedOutputFolder := OutputFolder
	OutputFolder := ""
}

if (ForcedBake = 1) {
	inputFile := InputFolder . "\output.avi "
	
}

if RegExMatch(DecodeReversibleFilterVal,"(-vf hue=:)") {
	DecodeReversibleFilterVal := "" ;clear the var, Temporary bug fix.
}

;msgbox, %MP4Bake%

runwait, %MP4Bake%
sleep, 20
WinWaitClose, cmd
LetseeIt := "cmd.exe /c ffplay -i " . OutputFolder . BakedOutputFolder . "\ImBaked.mp4 -loop 0"
runwait, %LetseeIt%
;FileDelete, %OutputFolder%\output-moshed.avi

;Clear the concat string.
ConcatString := ""

if (ForcedBake = 0) && (NoGetDiffPls = 0) { 
	gosub, EnableGetDifference
}
Return

PlsBakeYUV:
;This Method reduces/elimanates duplicate/frozen frames, which also speeds up video.
;Currently doesn't work for batch file input, as MPlayer overwrites the output stream.yuv with each video.
;Gonna have to concatenate them all at some point.
Gui, 3:Destroy
FileDelete, %OutputFolder%\ImBaked.yuv

gosub, OutputLocation ;Get the foldername the Datamoshed avi is in.
inputFile := OutputFolder . "\output-moshed.avi "
YUVBake := "mplayer " . CustomCodecFix . " -sws 4 " . DecodeReversibleFilterVal . " " . " -vo yuv4mpeg " . inputFile

;Temporary fix for HEVC/H265 decoding.
gosub, CustomCodecShit

if (BatchBake = 1) {
	inputFile := " " . ConcatString . " "
	OutputFolder := ""
}

if (ForcedBake = 1) {
	inputFile := InputFolder . "\output.avi "
	
}

;msgbox, %YUVBake%

runwait, %YUVBake%
sleep, 20
WinWaitClose, cmd
FileMove, stream.yuv,  %OutputFolder%\ImBaked.yuv
runwait, cmd.exe /c ffplay -i  %OutputFolder%\ImBaked.yuv -loop 0
;FileDelete, %OutputFolder%\output-moshed.avi

BakedFilename := "ImBaked.yuv"
gosub, UnReverseVideo

if (ForcedBake = 0) && (NoGetDiffPls = 0) { 
	gosub, EnableGetDifference
}
Return



;Wao now we can transfer datamoshed artifacts from MEncoder to FFmpeg, via baking since FFMpeg doesnt enjoy Tomatoes.
ForceBake:
msgbox, This is useful for transfering an datamoshed avi to FFmpeg.`nTo do so after this, select the codec and hit Recompress`n`nOtherwise just do as you were.
NoGetDiffPls := 1
ForcedBake := 1
BakeGUI()

WinWaitClose, Shall We Bake Some More???
gosub, OutputLocation

SourceFile := OutputFolder . "\" . BakedFilename
NoGetDiffPls := 0
Return

NoReBake:
Gui, 3:Destroy
Return

;Press Escape to kill GUI.
GuiEscape:
GuiClose:
ExitApp
