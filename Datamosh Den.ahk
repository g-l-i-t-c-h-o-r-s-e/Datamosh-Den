;Datamosh ToolKit AHk Edition
;Joining the powers of FFmpeg, MEncoder and Tomato into one <3
;Thrown together by yours Truly
#SingleInstance Force
#NoEnv
SetWorkingDir %A_ScriptDir%
SetBatchLines -1


;Populate FFmpeg Codecs List!!! Thank you so much Salz
;I couldn't have done the regex and object handling without u <3
GibCodecs := "ffmpeg.exe -codecs"
List := ComObjCreate("WScript.Shell").Exec(GibCodecs).StdOut.ReadAll()
text := List
texts := StrSplit(text, "`n", "`r")

decoders := array()
encoders := array()

for i, thisText in texts {
	RegExMatch(thisText, "O)^\h*((?:(?<decodes>D)|\.)(?:(?<encodes>E)|\.)(?:(?<video>V)|(?<audio>A)|(?<subtitles>S)|\.)(?:(?<intraframe>I)|\.)(?:(?<lossy>L)|\.)(?:(?<lossless>S)|\.))\h+(?<name>\w+)\h+(?<description>(?:(?:\(\h*decoders\h*:\h*(?<decoders>(?:\h*[\w-]+)+)\h*\))|(?:\(\h*encoders\h*:\h*(?<encoders>(?:\h*[\w-]+)+)\h*\))|.)+)$", thisMatch)
	if (thisMatch.encodes) {
		encoders.push(thisMatch.name)
		if (thisMatch.encoders)
			for i, name in strSplit(thisMatch.encoders, A_Space)
				encoders.push(name)
	}
}
Loop, % encoders.Length() {
	FFEncoderList .= encoders[A_Index] . "|"
}
;;;;;;Omited Decoder List;;;;;;
;  if (thisMatch.decodes) {
;    decoders.push(thisMatch.name)
;    if (thisMatch.decoders)
;      for i, name in strSplit(thisMatch.decoders, A_Space)
;        decoders.push(name)
;  }
;
;Loop, % decoders.Length() {
;	FFDecoderList .= decoders[A_Index] . "|"
;}
;;;;;;Omited Decoder List;;;;;;

;Purge audio and subtitle codecs from Video Encoder list!!!
Needle := "aac"
FFEncoderList := SubStr(FFEncoderList, 1, InStr(FFEncoderList, Needle)-1) . "|"


;Populate MEncoder Codecs list.
codecs := A_ScriptDir . "/codecs/*.dll"
loop, files, %codecs%
{
	CodecList .= A_LoopFileName  . "|"
}

;Custom GUI for baking yo files.
BakeGUI() {
	WinWaitClose, cmd
	Gui, 3:Add, Button, x10 y66 w35 h24 gPlsBakeYUV, YUV
	Gui, 3:Add, Button, x46 y66 w35 h24 gPlsBakeMP4, MP4
	Gui, 3:Add, Button, x82 y66 w35 h24 gPlsBakePNG, PNG
	Gui, 3:Add, Button, x118 y66 w35 h24 Default gNoReBake, Nah
	Gui, 3:Add, Text, x2 y2 w162 h63, `n      Would ulike to ReBake? `n(Makes the Video compatible with       FFmpeg, and maybe larger.)
	Gui, 3:Show, w162 h100,Shall We Bake Some More???
	Gui, 3:-Sysmenu
	WinWaitClose, Shall We Bake Some More???	
}

AMV2GUI() {
	WinWaitClose, cmd
	Gui, 3:Add, Button, x10 y66 w35 h24 gAMV2Preset640, 640
	Gui, 3:Add, Button, x46 y66 w35 h24 gAMV2Preset1280, 1280
	Gui, 3:Add, Button, x82 y66 w35 h24 gOption4k, 4K
	Gui, 3:Add, Button, x118 y66 w35 h24 Default gOptionNone, Nah
	Gui, 3:Add, Text, x2 y-2 w162 h66, `n        Would ulike to Remove                       The Watermark? `n  (In case ur cheap like me and        don't wanna pay for this codec.)
	Gui, 3:Show, w162 h100,AMV2 Watermark Removal Hack
	Gui, 3:-Sysmenu
	WinWaitClose, AMV2 Watermark Removal Hack	
}

Gui Add, GroupBox, x134 y10 w216 h76, Input Options
Gui Add, Button, x148 y28 w44 h43 gSelectSource, Source
Gui Add, Edit, x203 y44 w63 h21 +Center vResolutionVar, 640x360
Gui Add, Text, x208 y28 w56 h14 +0x200, Resolution
Gui Add, Edit, x279 y44 w30 h21 +Center vFrameRateVar, 60
Gui Add, Text, x269 y28 w56 h14 +0x200, Frame Rate
Gui Add, CheckBox, x227 y69 w10 h12 gEnableForceRes vForceRes, CheckBox
Gui Add, CheckBox, x289 y68 w10 h12 gEnableForceRate vForceRate, CheckBox

Gui Add, ComboBox, x37 y184 w120 vMencoderCodecs Choose8, %CodecList%
Gui Add, GroupBox, x17 y97 w168 h125, MEncoder Codecs
Gui Add, Edit, x610 y208 w120 h21
Gui Add, CheckBox, x47 y159 w104 h23 vRescaleMEncoderCodec, Attempt Rescale?
Gui Add, GroupBox, x17 y226 w168 h125, FFmpeg Codecs
Gui Add, ComboBox, x39 y314 w120 vFFmpegCodecs, %FFEncoderList%

Gui Add, GroupBox, x219 y97 w270 h253, Tomato Datamoshing
Gui Add, ComboBox, x286 y170 w120 Choose6 vTomatoMode, irep|ikill|iswap|bloom|pulse|shuffle|overlapped|jiggle|reverse|invert
Gui Add, Edit, x325 y217 w41 h21 vTomatoFrameCount +Center, 4
Gui Add, Edit, x325 y264 w41 h21 vTomatoFramePosition +Center, 2
Gui Add, Text, x314 y194 w62 h23 +0x200, Frame Count
Gui Add, Text, x309 y241 w71 h23 +0x200, Frame Position
Gui Add, Text, x305 y147 w81 h23 +0x200, Datamosh Mode
Gui Add, Button, x290 y288 w110 h46 vTomatoMOSHIT gCommenceTomatoDatamosh, DATAMOSH IT
Gui Add, Button, x455 y109 w23 h23 gTomatoHalp, ?

Gui Add, Radio, x165 y106 w16 h22 gEnableME vEnableMEncoderCodec Checked
Gui Add, Radio, x167 y235 w16 h22 gEnableFF vEnableFFmpegCodec

Gui Add, Button, x408 y288 w65 h46 vReCompress gReCompressMoshedOutput, Recompress
Gui Add, Button, x235 y288 w48 h46 vTomatoRecycle gRecycleTomatoOutput, Remosh

Gui Add, Button, x158 y183 w22 h23 vMEncoderCompression gMEncoderCompression, GO
Gui Add, Button, x159 y313 w22 h23 vFFmpegCompression gFFmpegCompression, GO
Gui Add, Edit, x37 y136 w120 h21 vMEncoderOptions, -nosound
Gui Add, Text, x66 y120 w71 h15 +0x200, Codec Options
Gui Add, Edit, x38 y266 w120 h21 vFFmpegOptions, -bf 0 -g 999999 -an
Gui Add, Text, x63 y250 w71 h15 +0x200, Codec Options

;Disable some stuff by default.
GuiControl, 1:Disable, FFmpegCodecs
GuiControl, 1:Disable, FFmpegOptions
GuiControl, 1:Disable, FFmpegCompression
GuiControl, 1:Disable, TomatoMode
GuiControl, 1:Disable, TomatoFrameCount
GuiControl, 1:Disable, TomatoFramePosition
GuiControl, 1:Disable, TomatoMOSHIT
GuiControl, 1:Disable, TomatoRecycle
GuiControl, 1:Disable, ResolutionVar
GuiControl, 1:Disable, FrameRateVar
GuiControl, 1:Disable, Recompress

;Default Compressor.
RecompressVar := "MEncoder"

Gui Show, w504 h363, Datamosh Den - Ver 1.1
Return

SelectSource:
FileSelectFile, SourceFile,,,Select Source For Datamoshing......................................
if errorlevel {
	msgbox, You Didnt Select Anything lol
	return
}



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
	
	GuiControl, 1:Disable, TomatoMode
	GuiControl, 1:Disable, TomatoFrameCount
	GuiControl, 1:Disable, TomatoFramePosition
	GuiControl, 1:Disable, TomatoMOSHIT
	GuiControl, 1:Disable, TomatoRecycle
	
	;GuiControl, 1:Disable, Recompress
	RecompressVar := "MEncoder"
}
return

EnableFF:
GuiControlGet, EnableFFmpegCodec
if (EnableFFmpegCodec = 1) {
	GuiControl, 1:Enable, FFmpegCodecs
	GuiControl, 1:Enable, FFmpegOptions
	GuiControl, 1:Enable, FFmpegCompression
	GuiControl, 1:Disable, MencoderCodecs
	GuiControl, 1:Disable, MEncoderOptions
	GuiControl, 1:Disable, RescaleMEncoderCodec
	GuiControl, 1:Disable, MEncoderCompression
	
	GuiControl, 1:Disable, TomatoMode
	GuiControl, 1:Disable, TomatoFrameCount
	GuiControl, 1:Disable, TomatoFramePosition
	GuiControl, 1:Disable, TomatoMOSHIT
	GuiControl, 1:Disable, TomatoRecycle
   	
	;GuiControl, 1:Disable, Recompress
	RecompressVar := "FFmpeg"
}
return



EnableForceRes:
Gui, Submit, NoHide
GuiControlGet, ForceRes

if (ForceRes = 1) && (RecompressVar = "FFmpeg") {
	GuiControl, 1:Enable, ResolutionVar
	ResolutionVar := " -vf scale=" . ResolutionVar
}

if (ForceRes = 1) && (RecompressVar = "MEncoder") {
	GuiControl, 1:Enable, ResolutionVar
	ResolutionVar := " -vf scale=" . ResolutionVar
	ResolutionVar := StrReplace(ResolutionVar, "x", ":")
	
}

if (ForceRes = 0) {
	GuiControl, 1:Disable, ResolutionVar
	ResolutionVar := ""
}

if (ForceRate = 1) && (ForceRes = 1) && (RecompressVar = "FFmpeg") {
	ResolutionVar := ""
}

if (ForceRate = 1) && (ForceRes = 1) && (RecompressVar = "MEncoder") {
	ResolutionVar := StrReplace(ResolutionVar, "x", ":")
	;ResolutionVar := ""
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

if (ForceRate = 1) && (ForceRes = 1) && (RecompressVar = "FFmpeg") {
	FrameRate := " -vf fps=" . FrameRateVar . "," . "scale=" . ResolutionVar
	ResolutionVar2 := ResolutionVar
	ResolutionVar := ""
}

if (ForceRate = 1) && (ForceRes = 1) && (RecompressVar = "MEncoder") {
	GuiControl, 1:Enable, FrameRateVar
	ResolutionVar := " -vf scale=" . StrReplace(ResolutionVar, "x", ":")
	FrameRate := " -fps " . FrameRateVar
}
Return
;WIP


MEncoderCompression:
Gui, Submit, Nohide
GuiControlGet, ForceRes
GuiControl, 1:Disable, TomatoMode
GuiControl, 1:Disable, TomatoFrameCount
GuiControl, 1:Disable, TomatoFramePosition
GuiControl, 1:Disable, TomatoMOSHIT
GuiControl, 1:Disable, TomatoRecycle
GuiControl, 1:Disable, Recompress

RecompressVar := "MEncoder"
config = ":compdata=dialog"

if (MencoderCodecs = "vp31vfw.dll") {
	config = ""
	;Configure dialog is broken for vp3.
}


gosub, EnableForceRate
gosub, EnableForceRes

if (MencoderCodecs = "Amv2Codec.dll") {
	gosub, CustomAMV2Compression
	Return
	;Configure dialog is broken for vp3.
}

if (SourceFile = "") {
	msgbox, Select Something Yo.
	return
}

MECommand := cmd.exe /k "mencoder " . chr(0x22) . SourceFile . chr(0x22) . ResolutionVar . FrameRate . " -of avi -o output.avi -ovc vfw -xvfwopts codec=" . MencoderCodecs . config . " -nosub -nosound"
  ;msgbox, %MECommand% ;Used for checking of the command syntax is correct.

  ;Execute MEncoder Here, also reads Standard Error Output.
MEoutput := ComObjCreate("WScript.Shell").Exec(MECommand).StdErr.ReadAll()

If RegExMatch(MEoutput,"(Compressor doesn't have a configure dialog)") else IF RegExMatch(MEoutput,"(Compressor configure dialog failed!)")  {
	msgbox, Looks like the compressor lacks a configuration dialog or it failed, disabling.
	config := ""
	MECommand := cmd.exe /k "mencoder " . chr(0x22) SourceFile . chr(0x22) . ResolutionVar . " -of avi -o output.avi -ovc vfw -xvfwopts codec=" . MencoderCodecs . config . " -nosub -nosound"
	MEoutput := ComObjCreate("WScript.Shell").Exec(MECommand).StdErr.ReadAll()
	
	
	;return
	
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
msgbox, You may now use the Tomato window to Datamosh!
GuiControl, 1:Enable, TomatoMode
GuiControl, 1:Enable, TomatoFrameCount
GuiControl, 1:Enable, TomatoFramePosition
GuiControl, 1:Enable, TomatoMOSHIT
Return

CustomAMV2Compression:
Gui, Submit, NoHide
if (SourceFile = "") {
	msgbox, Select Something Yo.
	return
}

RecompressVar := "AMV2"
config = ":compdata=dialog"
RecompressVar := "MEncoder"
whichPreset := ""

;Places black bar at the bottom of the video, isolating the watermark, -sws 4 helps with quality loss upon scaling.
AMV2BufferWatermark1 := " -sws 4 -vf scale=640:360,expand=0:-70:0:0,scale=640:360" 
AMV2BufferWatermark2 := " -sws 4 -vf scale=1280:720,expand=0:-170:0:0,scale=1280:720"
AMV2BufferWatermark3 := " -sws 4 -vf scale=3840:2160,expand=0:-330:0:0,scale=3840:2160"


;Crops out the isolated watermark
;AMV2RemoveWatermark1 := "-vf crop=640:300:0:60"
;AMV2RemoveWatermark2 := "-vf crop=1280:580:0:140"
;AMV2RemoveWatermark3 := " -vf crop=3840:1860:0:290"


gosub, EnableForceRate
gosub, EnableForceRes

msgbox, Testing Custom amv2 compression, removing watermark, etc.
;Select Preset for now.
AMV2GUI()

MECommand := cmd.exe /k "mencoder " . chr(0x22) . SourceFile . chr(0x22) . whichPreset . FrameRate . " -of avi -o output.avi -ovc vfw -xvfwopts codec=" . MencoderCodecs . config . " -nosub -nosound"

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


;wao now we got all the FFmpeg codecs too lol
FFmpegCompression:
Gui, Submit, Nohide
GuiControl, 1:Disable, TomatoMode
GuiControl, 1:Disable, TomatoFrameCount
GuiControl, 1:Disable, TomatoFramePosition
GuiControl, 1:Disable, TomatoMOSHIT
GuiControl, 1:Disable, TomatoRecycle

RecompressVar := "FFmpeg"

gosub, EnableForceRate
gosub, EnableForceRes

if (SourceFile = "") {
	msgbox, Select Something Yo.
	return
}

FFCommand := cmd.exe /k "ffmpeg " . InputFrameRate . " -i " . chr(0x22) . SourceFile . chr(0x22) . ResolutionVar . FrameRate . " -f avi -c:v " . FFmpegCodecs . " " . FFmpegOptions . " output.avi -y"
  ;MsgBox, %FFCommand%

  ;Execute FFmpeg Here, also reads Standard Error Output.
FFoutput := ComObjCreate("WScript.Shell").Exec(FFCommand).StdErr.ReadAll()

;This trims all the extra bullshit the FFmpeg devs didnt omit from Standard Error Output(STDERR).
StartingPos := InStr(FFoutput, "[")
FFoutput := SubStr(FFoutput, StartingPos + 25)

IF RegExMatch(FFoutput,"(The specified picture size)") else IF RegExMatch(FFoutput,"(maybe incorrect parameters)") {
	msgbox, oshit an error, my first guess is video resolution is probably wrong.`n%FFoutput%
	gosub, FFRetryScale
}

;Gonna add an MPlayer workaround here soon?
IF RegExMatch(FFoutput,"(Invalid data found)") {
	msgbox, now u done it, FFmpeg can't decode this video codec probably.
	return
}

;Keep Tomato disabled until a compression is achieved.
if (NoTomato4U = 1) {
	msgbox, Tomato is disabled still :(
	return
}

msgbox, You may now use the Tomato window to Datamosh!
GuiControl, 1:Enable, TomatoMode
GuiControl, 1:Enable, TomatoFrameCount
GuiControl, 1:Enable, TomatoFramePosition
GuiControl, 1:Enable, TomatoMOSHIT
Return



FFRetryScale:
config := ""
NoTomato4U := 0
TryRes +=1
ResArray := ["16:16", "352:288" , "120:90" , "128:128" , "256:256" , "320:200" , "320:240" , "400:240" , "480:576" , "500:500" , "512:256" , "640:320" , "640:360" , "640:480" , "720:480" , "1280:720" , "1366:768" , "1440:1080" , "1920:1080" , "3840:2160" , "7680:4320" , "15360:8640"]
ResolutionVar := " -vf scale=" . ResArray[TryRes]

;if (MencoderCodecs = "smv2.dll") {
;	config := ":compdata=dialog "
;	;Forces Compression Dialog on ReScale, since this codec NEEDS it in order to compress lolol.
;}

if (ResolutionVar = " -vf scale=") {
	msgbox, WTF NOTHING WORKED?!? Sorry.
	NoTomato4U := 1 ;Keep Tomato disabled until a compression is achieved.
	TryRes := "" ;Reset the array counter, again.
	return
}

FFCommand := cmd.exe /k "ffmpeg -i " . chr(0x22) . SourceFile . chr(0x22) . ResolutionVar . " -f avi -c:v " . FFmpegCodecs . " " . FFmpegOptions . " output.avi -y"
   ;MsgBox, %FFCommand%

  ;Execute MEncoder Here, also reads Standard Error Output.
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

MECommand := cmd.exe /c "mencoder " . chr(0x22) . SourceFile . chr(0x22) . ResolutionVar . FrameRate . " -of avi -o output.avi -ovc vfw -xvfwopts codec=" . MencoderCodecs . config . " -nosub -nosound"
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



TomatoHalp:
msgbox, 
(
COMPRESS A SOURCE WITH EITHER OF THE "GO" BUTTONS, FIRST!

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


)
Return

CustomCodecShit:
GuiControlGet, MencoderCodecs
CustomCodecFix := ""
LemmeSeeIt := "cmd.exe /c mplayer " . CustomCodecFix . " output-moshed.avi -loop 0"

if (MencoderCodecs = "smv2.dll") {
	
	CustomCodecFix := "-vc smv2Old"
	;Forces the custom decoder I added to the codecs.config
}

;Removes the watermark burnt into the video by AMV2
if (MencoderCodecs = "Amv2Codec.dll") {
	;msgbox, Using Custom AMV2 Watermark Removal.
    ;Crops out the isolated watermark
	AMV2RemoveWatermark1 := " -sws 4 -vf crop=640:300:0:60,scale=640:360"
	AMV2RemoveWatermark2 := " -sws 4 -vf crop=1280:580:0:140,scale=1280:720"
	AMV2RemoveWatermark3 := " -sws 4 -vf crop=3840:1860:0:290,scale=3840:2160"
	
	
	if (Sel = 1) {
		CustomCodecFix := AMV2RemoveWatermark1
		LemmeSeeIt := "cmd.exe /c mplayer " . CustomCodecFix . " output-moshed.avi -loop 0"
	}
	if (sel = 2) {
		CustomCodecFix := AMV2RemoveWatermark2
		LemmeSeeIt := "cmd.exe /c mplayer " . CustomCodecFix . " output-moshed.avi -loop 0"
	}
	if (sel = 3) {
		CustomCodecFix := AMV2RemoveWatermark3
		LemmeSeeIt := "cmd.exe /c mplayer " . CustomCodecFix . " output-moshed.avi -loop 0 -fs"
	}
	
	Return
	
}
Return

CommenceTomatoDatamosh:
;Destroy AVI Index via Tomato for Datamoshed Goodness!
Gui, Submit, Nohide

gosub, CustomCodecShit

runwait, %ComSpec% /c python tomato.py -i output.avi -m %TomatoMode% -c %TomatoFrameCount% -n %TomatoFramePosition% output-moshed.avi
runwait, %LemmeSeeIt%
;open custom baking menu afterwards
BakeGUI()

GuiControl, 1:Enable, TomatoRecycle
GuiControl, 1:Enable, Recompress
Return


RecycleTomatoOutput:
;Destroy AVI Index of the Previous file via Tomato for even more Datamoshed Goodness!!!
Gui, Submit, Nohide

gosub, CustomCodecShit
LemmeSeeIt := "mplayer " . CustomCodecFix . " output-moshed2.avi -loop 0"

runwait, %ComSpec% /c python tomato.py -i output-moshed.avi -m %TomatoMode% -c %TomatoFrameCount% -n %TomatoFramePosition% output-moshed2.avi
runwait, %LemmeSeeIt%
;Rename File back to original.
FileDelete, output-moshed.avi
FileMove, output-moshed2.avi, output-moshed.avi
;open custom baking menu afterwards 
BakeGUI()
Return


ReCompressMoshedOutput:
SourceFile := "output-moshed.avi"

if (RecompressVar = "MEncoder") {
	msgbox, Compressing the moshed file,`nwith the current MEncoder vfw codec selected!
	gosub, MEncoderCompression
	return
}

if (RecompressVar = "FFmpeg") {
	msgbox, Compressing the moshed file, `nwith the current FFmpeg codec selected!
	gosub, FFmpegCompression
	return
}

if (RecompressVar = "AMV2") {
	msgbox, Compressing the moshed file,`nwith the beta AMV2 Watermark removal!
	gosub, CustomAMV2Compression
	return
}
Return

PlsBakePNG:
;Dat image output tho
Gui, 3:Destroy
CheckItOut := "ffplay -i FRAMES/%08d.png -loop 0"
ReBake := "mplayer " . CustomCodecFix . " output-moshed.avi -vo png:outdir=FRAMES -cache 1024"
runwait, %ReBake%
sleep, 20
WinWaitClose, cmd
runwait, cmd.exe /c %CheckItOut%
FileDelete, output-moshed.avi
run, %A_ScriptDir%/FRAMES
Return

PlsBakeMP4:
;Usually works, if not then select the YUV option and convert that to mp4 with FFmpeg yourself.
;I added noskip to make the output more smooth.
Gui, 3:Destroy
FileDelete, ReBaked.mp4
ReBake := "mencoder " . CustomCodecFix . " output-moshed.avi -ovc x264 -x264encopts crf=1.0 -noskip -o ReBaked.mp4 -of lavf"
runwait, %ReBake%
sleep, 20
WinWaitClose, cmd
runwait, cmd.exe /c ffplay -i ReBaked.mp4 -loop 0
FileDelete, output-moshed.avi
Return

PlsBakeYUV:
;This Method reduces/elimanates duplicate/frozen frames, which also speeds up video.
Gui, 3:Destroy
FileDelete, ReBaked.yuv
ReBake := "mplayer " . CustomCodecFix . " -vo yuv4mpeg output-moshed.avi"
runwait, %ReBake%
sleep, 20
WinWaitClose, cmd
FileMove, stream.yuv, ReBaked.yuv
runwait, cmd.exe /c ffplay -i ReBaked.yuv -loop 0
FileDelete, output-moshed.avi
Return

NoReBake:
Gui, 3:Destroy
Return


GuiEscape:
GuiClose:
ExitApp


