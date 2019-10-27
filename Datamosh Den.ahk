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
;
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

;Strip non-glitching codecs from the FFmpeg video codec list, mostly done.
Strip := ["amv|" , "asv1|" , "asv2|" , "cavs|" , "a64_multi|" , "a64multi|" , "a64_multi5|" , "a64multi5|" , "alias_pix|" , "apng|" , "avrp|" , "avui|" , "ayuv|" , "bmp|" , "cljr|" , "dpx|" , "h264_nvenc|" , "h264_qsv|" , "nvenc_hevc|" , "hevc_nvenc|" , "hevc_qsv|" , "nvenc|" , "nvenc_h264|" , "huffyuv|" , "jpegls|" , "ljpeg|" , "mjpeg|" , "mpeg2_qsv|" , "pam|" , "pbm|" , "pcx|" , "pgm|" , "pgmyuv|" , "png|" , "ppm|" , "r10k|", "r210|" , "v210|" , "v308|" , "v310|" , "v408|" , "v410|" , "sgi|" , "sunrast|" , "targa|" , "tiff|" , "rv10|" , "rv20|" , "rawvideo|" , "libwebp|" , "webp|" , "wrapped_avframe|" , "xbm|" , "xface|" , "xwd|" , "y41p|" , "yuv4|"]
for _, val in Strip {
	FFEncoderList := StrReplace(FFEncoderList, val)
}

;Populate MEncoder Codecs list.
codecs := A_ScriptDir . "/codecs/*.dll"
loop, files, %codecs%
{
	CodecList .= A_LoopFileName  . "|"
	CodecList := StrReplace(CodecList, "msvcr70.dll")
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
	Gui, 3:Add, Text, x2 y-2 w162 h66, `n        Would ulike to Remove                       The Watermark? `n  (In case ur cheap like me and        don't wanna pay for this codec.) ;yet
	Gui, 3:Show, w162 h100,AMV2 Watermark Removal Hack
	Gui, 3:-Sysmenu
	WinWaitClose, AMV2 Watermark Removal Hack	
}

Gui Add, GroupBox, x154 y10 w252 h83, File Input && Forced Options
Gui Add, Button, x165 y34 w44 h43 gSelectSource, Source
Gui Add, Edit, x285 y45 w63 h21 +Center vResolutionVar, 640x360
Gui Add, Text, x291 y29 w49 h14 +0x200, Resolution
Gui Add, Edit, x361 y45 w30 h21 +Center vFrameRateVar, 60
Gui Add, Text, x366 y29 w22 h14 +0x200, FPS
Gui Add, CheckBox, x311 y70 w10 h12 gEnableForceRes vForceRes, CheckBox
Gui Add, CheckBox, x371 y70 w10 h12 gEnableForceRate vForceRate, CheckBox
Gui Add, CheckBox, x237 y43 w10 h12 gBatchInputMessage vIsBatchInput, CheckBox
Gui Add, Text, x216 y28 w55 h14, Batch Input
;REVERSE VIDEO BEFORE DATAMOSH AND THEN BACK, COMING SOON.
Gui Add, CheckBox, x237 y70 w10 h12 +Disabled, CheckBox
Gui Add, Text, x222 y56 w47 h14 gEnableReverseVideo vIsReversed, Reverse?

Gui Add, ComboBox, x37 y184 w120 vMencoderCodecs Choose8, %CodecList%
Gui Add, GroupBox, x17 y97 w168 h125, MEncoder Codecs
Gui Add, Edit, x610 y208 w120 h21
Gui Add, CheckBox, x47 y159 w104 h23 vRescaleMEncoderCodec, Attempt Rescale?
Gui Add, GroupBox, x17 y226 w168 h125, FFmpeg Codecs
Gui Add, ComboBox, x39 y314 w120 vFFmpegCodecs, %FFEncoderList%

Gui Add, GroupBox, x219 y97 w270 h253, Tomato Datamoshing
Gui Add, ComboBox, x286 y170 w120 Choose7 vTomatoMode, irep|ikill|iswap|bloom|pulse|shuffle|overlapped|jiggle|reverse|invert
Gui Add, Edit, x325 y217 w41 h21 vTomatoFrameCount +Center, 4
Gui Add, Edit, x325 y264 w41 h21 vTomatoFramePosition +Center, 2
Gui Add, Text, x314 y194 w62 h23 +0x200, Frame Count
Gui Add, Text, x309 y241 w71 h23 +0x200, Frame Position
Gui Add, Text, x305 y147 w81 h23 +0x200, Datamosh Mode
Gui Add, Button, x290 y288 w110 h46 vTomatoMOSHIT gCommenceTomatoDatamosh, DATAMOSH IT
Gui Add, Button, x455 y109 w23 h23 gTomatoHalp, ?

Gui Add, Button, x407 y63 w96 h30 gForcePythonLocation, Force Python Path

Gui Add, Radio, x165 y106 w16 h22 gEnableME vEnableMEncoderCodec Checked
Gui Add, Radio, x167 y235 w16 h22 gEnableFF vEnableFFmpegCodec

Gui Add, Button, x408 y288 w65 h46 vReCompress gReCompressMoshedOutput, Recompress
Gui Add, Button, x235 y288 w48 h46 vTomatoRecycle gRecycleTomatoOutput, Remosh

Gui Add, Button, x158 y183 w22 h23 vMEncoderCompression gPreMEncoderCompression, GO
Gui Add, Button, x159 y313 w22 h23 vFFmpegCompression gPreFFmpegCompression, GO
Gui Add, Edit, x37 y136 w120 h21 vMEncoderOptions, -nosound -noskip
Gui Add, Text, x66 y120 w71 h15 +0x200, Codec Options
Gui Add, Edit, x38 y266 w120 h21 vFFmpegOptions, -bf 0 -g 999999 -an
Gui Add, Text, x63 y250 w71 h15 +0x200, Codec Options
Gui Add, Button, x158 y265 w22 h23 vFFGetOptions gListCodecOptions, ?


Gui Add, Text, x63 y250 w71 h15, Codec Options
Gui Add, GroupBox, x17 y10 w127 h83, Webcam Input
Gui Add, ComboBox, x22 y28 w117 vWebCamName, %DeviceList%
Gui Add, Button, x21 y55 w50 h31 gGetDevices, List Devices
Gui Add, Button, x90 y55 w50 h31 gSelectWebcam, Use Device

Gui Add, Slider, x19 y289 w164 h18 Range0-1000 vVideoQuality gVideoQualitySlider AltSubmit, 10

;Disable some stuff by default.
GuiControl, 1:Disable, FFmpegCodecs
GuiControl, 1:Disable, FFmpegOptions
GuiControl, 1:Disable, FFGetOptions
GuiControl, 1:Disable, FFmpegCompression
GuiControl, 1:Disable, TomatoMode
GuiControl, 1:Disable, TomatoFrameCount
GuiControl, 1:Disable, TomatoFramePosition
GuiControl, 1:Disable, TomatoMOSHIT
GuiControl, 1:Disable, TomatoRecycle
GuiControl, 1:Disable, ResolutionVar
GuiControl, 1:Disable, FrameRateVar
GuiControl, 1:Disable, Recompress
WebcamSource := ""
isBatchFilename := 0

;Default Compressor.
RecompressVar := "MEncoder"
;Display help msg once once every startup.
BatchInputHelpMsg := 1

Gui Show, w504 h363, Datamosh Den - Ver 1.7.8 (Debug)

;Check if newer MEncoder package is in folder, if so extract it.
#Include config/GetFFmpeg.ahk
#Include config/unzip.ahk
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


VideoQualitySlider:
;Gui,Submit,NoHide
int := VideoQuality/10
fra := Mod(int, 10)
fra := SubStr(fra, InStr(fra,".")+1, 1 )
val :=  Floor(int) "." fra
VideoQuality := val
tooltip % VideoQuality
SetTimer, RemoveToolTip1, 500
return

RemoveToolTip1:
SetTimer, RemoveToolTip1, Off
ToolTip
return

GetDevices:
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
   WebCam := " -f dshow -i video=" . chr(0x22) . WebCamName . chr(0x22) . " "
   WebcamCompression := "1"
  msgbox, %WebCamName% selected as input device.`n   Hit this button every time before "GO"`n       if you want to record a new video.`n`n                 Press Q to stop Webcam.
Return

WebCamCompression:
;Gui, Submit, NoHide
gosub, EnableForceRate
gosub, EnableForceRes

if (WebcamCompression = 1) {
	FFWebcamCompress := cmd.exe /k "ffmpeg " . InputFrameRate . WebCam . ResolutionVar . FrameRate . " -f avi -c:v huffyuv webcam-output.avi -y"
	;msgbox, %FFWebcamCompress%
	runwait, %FFWebcamCompress%	
	SourceFile := "webcam-output.avi"
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
	GuiControl, 1:Enable, FFGetOptions	
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


EnableReverseVideo:
Return

PreMEncoderCompression:
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

if (MencoderCodecs = "vp31vfw.dll") {
	config = "" ;Configure dialog is broken for vp3.	
}

gosub, WebCamCompression
gosub, EnableForceRate
gosub, EnableForceRes

if (MencoderCodecs = "Amv2Codec.dll") else if (MencoderCodecs = "Amv2mtCodec.dll") else if (MencoderCodecs = "Amv3Codec.dll") {
	gosub, CustomAMVCompression ;Remove Watermark.
	Return
}

if (SourceFile = "") {
	msgbox, Select Something Yo.
	return
}

if (isBatchFilename = 1) { ; This is where the Batch output stuff happens.
	fileVal +=1
	Pack := "0000"
	zeropad := (SubStr(Pack, 1, StrLen(Pack) - StrLen(fileVal)) . fileVal) ;ZeroPadding for filenames
	OutputFilename := "./Batch-Output/output_" . zeropad . ".avi"	
}

MECommand := cmd.exe /k "mencoder " . chr(0x22) . SourceFile . chr(0x22) . ResolutionVar . FrameRate . " -of avi -o " . OutputFilename . " -ovc vfw -xvfwopts codec=" . MencoderCodecs . config . " -nosub -nosound"
  ;msgbox, %MECommand% ;Used for checking of the command syntax is correct.

  ;Execute MEncoder Here, also reads Standard Error Output.
MEoutput := ComObjCreate("WScript.Shell").Exec(MECommand).StdErr.ReadAll()

If RegExMatch(MEoutput,"(Compressor doesn't have a configure dialog)") else IF RegExMatch(MEoutput,"(Compressor configure dialog failed!)")  {
	msgbox, Looks like the compressor lacks a configuration dialog or it failed, disabling.
	config := ""
	MECommand := cmd.exe /k "mencoder " . chr(0x22) SourceFile . chr(0x22) . ResolutionVar . " -of avi -o output.avi -ovc vfw -xvfwopts codec=" . MencoderCodecs . config . " -nosub -nosound"
	MEoutput := ComObjCreate("WScript.Shell").Exec(MECommand).StdErr.ReadAll()
	
	
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


;Crops out the isolated watermark
;AMV2RemoveWatermark1 := "-vf crop=640:300:0:60"
;AMV2RemoveWatermark2 := "-vf crop=1280:580:0:140"
;AMV2RemoveWatermark3 := " -vf crop=3840:1860:0:290"


gosub, EnableForceRate
gosub, EnableForceRes

msgbox, Testing Custom AMV compression, removing watermark, etc.
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


ListCodecOptions:
Gui, Submit, NoHide
msgbox, Here's the options you can use for the %FFmpegCodecs% codec.
GetOptions := "ffmpeg -h encoder=" . FFmpegCodecs
runwait, cmd.exe /k %GetOptions%
Return

PreFFmpegCompression:
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

gosub, WebCamCompression
gosub, EnableForceRate
gosub, EnableForceRes
gosub, VideoQualitySlider ; For some reason I had to place this here or else the VideoQuality var lost its decimal.
;msgbox, %VideoQuality%

if (SourceFile = "") {
	msgbox, Select Something Yo.
	return
}

if (isBatchFilename = 1) {
	fileVal +=1
	Pack := "0000"
	zeropad := (SubStr(Pack, 1, StrLen(Pack) - StrLen(fileVal)) . fileVal) ;ZeroPadding for filenames.
	OutputFilename := "./Batch-Output/output_" . zeropad . ".avi"
}


FFCommand := ComSpec . " /c " . " ffmpeg " . InputFrameRate . " -i " . chr(0x22) . SourceFile . chr(0x22) . ResolutionVar . FrameRate . " -f avi -strict -2 -c:v " . FFmpegCodecs . " -q:v " . VideoQuality . " " . FFmpegOptions . " " . OutputFilename . " -y"
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

if (isBatchFilename = 0) {
	msgbox, You may now use the Tomato window to Datamosh!	
}
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


if (ResolutionVar = " -vf scale=") {
	msgbox, WTF NOTHING WORKED?!? Sorry.
	NoTomato4U := 1 ;Keep Tomato disabled until a compression is achieved.
	TryRes := "" ;Reset the array counter, again.
	return
}

FFCommand := cmd.exe /k "ffmpeg -i " . chr(0x22) . SourceFile . chr(0x22) . ResolutionVar . " -f avi -strict -2 -c:v " . FFmpegCodecs . " -q:v " . VideoQuality . " " . FFmpegOptions . " output.avi -y"
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


BatchME:
;Gui, Submit, NoHide
FileCreateDir, %A_ScriptDir%\Batch-Output
;FileSelectFolder,leFolder, *%A_ScriptDir%,3,Select The Input Folder.....................
;if errorlevel {
;	msgbox, You Didnt Select Anything lol
;	return
;}  

extensions := "mp4,webm,avi,mkv,yuv"

Loop,%leFolder%\*
{  ; count the amount of target files in folder so we can stop loop properly.
	if A_LoopFileExt in %extensions%		
	     countfiles += 1
	stoploop := countfiles
}

;msgbox, %stoploop%

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
	;	gosub, ConcatenateMe
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
;FileSelectFolder,leFolder, *%A_ScriptDir%,3,Select The Input Folder.....................
;if errorlevel {
;	msgbox, You Didnt Select Anything lol
;	return
;}  

extensions := "mp4,webm,avi,mkv,yuv"

Loop,%leFolder%\*
{  ; count the amount of target files in folder so we can stop loop properly.
	if A_LoopFileExt in %extensions%		
		countfiles += 1
	stoploop := countfiles
}


;msgbox, %stoploop%


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
	;	gosub, ConcatenateMe
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
CustomCodecFix := ""
LemmeSeeIt := "cmd.exe /c mplayer " . CustomCodecFix . " output-moshed.avi -loop 0"

if (MencoderCodecs = "x265vfw.dll") {
	
	CustomCodecFix := ""
	LemmeSeeIt := "cmd.exe /c new-mplayer " . CustomCodecFix . " output-moshed.avi -loop 0"
	PNGBake := "new-mplayer " . CustomCodecFix . " output-moshed.avi -vo png:outdir=FRAMES -cache 1024"
	MP4Bake := "new-mencoder " . CustomCodecFix . " output-moshed.avi -ovc x264 -x264encopts crf=1.0 " . MEncoderOptions " -o ImBaked.mp4 -of lavf"
	YUVBake := "new-mplayer " . CustomCodecFix . " -vo yuv4mpeg output-moshed.avi"	
}


if (MencoderCodecs = "smv2.dll") {
	
	CustomCodecFix := "-vc smv2Old"
	;Forces the custom decoder I added to the codecs.config
}

;Removes the watermark burnt into the video by AMV2
if (MencoderCodecs = "Amv2Codec.dll") else if (MencoderCodecs = "Amv2mtCodec.dll") else if (MencoderCodecs = "Amv3Codec.dll") {
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



TestPython:
if (WeGotPython = 1) {
	return
}

regread, python, HKLM, SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\python.exe
if (python = "") else if !RegExMatch(python,"(Python27)")  {
	msgbox, Enter your Python27 Path/Folder.`n`nIts usually like "C:\Python27"
	Gui 10:Add, Edit, x0 y8 w120 h21 vCustomPythonPath,
	Gui 10:Add, Button, x0 y50 w120 h21 gSubmitPythonLocation, ok
	Gui 10:-sysmenu	
	Gui 10:Show, w120 h100, Paste le Path Here
	WeGotPython := ""
	WinWaitClose, Paste le Path Here
	return
	
}

If RegExMatch(python,"(Python27)")
{
	return
}
Return

ForcePythonLocation:
msgbox, Enter your Python27 Path/Folder.`n`nIts usually like "C:\Python27"
Gui 10:Add, Edit, x0 y8 w120 h21 vCustomPythonPath,
Gui 10:Add, Button, x0 y50 w120 h21 gSubmitPythonLocation, ok
Gui 10:-sysmenu
Gui 10:Show, w120 h100, Paste le Path Here
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



OutputLocation:
if (RecompressVar = "FFmpeg") {
	InputFolder := RecompressVar . "-Output\" . FFmpegCodecs
	OutputFolder := RecompressVar . "-Output\" . FFmpegCodecs . "\Moshed"
	FileCreateDir, %OutputFolder%
	;msgbox, %OutputFolder%
}

if (RecompressVar = "MEncoder") {
	SplitPath, MencoderCodecs,,,, codecname,	
	InputFolder := RecompressVar . "-Output\" . codecname
	OutputFolder := RecompressVar . "-Output\" . codecname . "\Moshed"
	FileCreateDir, %OutputFolder%
	;msgbox, %OutputFolder%
}

if (RecompressVar = "FFmpeg") && if (isBatchInput = 1) {
	InputFolder := "Batch-Output\" . FFmpegCodecs
	OutputFolder := "Batch-Output-Moshed\" . FFmpegCodecs
	FileCreateDir, %OutputFolder%
	;msgbox, %OutputFolder%
}

if (RecompressVar = "MEncoder") && if (isBatchInput = 1) {
	SplitPath, MencoderCodecs,,,, codecname,	
	InputFolder := "Batch-Output\" . codecname
	OutputFolder := "Batch-Output-Moshed\" . codecname
	FileCreateDir, %OutputFolder%
	;msgbox, %OutputFolder%
}

Return



CommenceTomatoDatamosh:
;Destroy AVI Index via Tomato for Datamoshed Goodness!
Gui, Submit, Nohide

gosub, CustomCodecShit
gosub, TestPython
gosub, OutputLocation

LemmeSeeIt := "mplayer " . CustomCodecFix . " " . OutputFolder . "/output-moshed.avi -loop 0"

runwait, %ComSpec% /c %python% tomato.py -i %InputFolder%/output.avi -m %TomatoMode% -c %TomatoFrameCount% -n %TomatoFramePosition% ./%OutputFolder%/output-moshed.avi
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
			
			LemmeSeeItBatch := "mplayer " . ConcatString
		     runwait, %LemmeSeeItBatch%
			
			BakeGUI()
			WinWaitClose, Shall We Bake Some More???
			GuiControl, 1:Enable, TomatoRecycle
			GuiControl, 1:Enable, Recompress
			break
		}
	}
	if ErrorLevel {
		msgbox, FUCK you did it now, didn't you?
	}
}
Return

ReCompressMoshedOutput:
SourceFile := OutputFolder . "\output-moshed.avi"

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

if (RecompressVar = "AMV") {
	msgbox, Compressing the moshed file,`nwith the beta AMV2 Watermark removal!
	gosub, CustomAMVCompression
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


CheckItOut := "ffplay -i " . DirName . "\" . whichCodec . "\%08d.png -loop 0"
PNGBake := "mplayer -vo png:outdir=PNG-Output\" . whichCodec . " -cache 1024 " . CustomCodecFix . OutputFolder . inputFile

runwait, %PNGBake%
sleep, 20
WinWaitClose, cmd

runwait, cmd.exe /c %CheckItOut%
;FileDelete, %OutputFolder%\output-moshed.avi

run, %A_ScriptDir%\%DirName%\%whichCodec%
Return

PlsBakeMP4:
;Usually works, if not then select the YUV option and convert that to mp4 with FFmpeg yourself.
;I originally added noskip by default to make the output more smooth, but this is optional via the GUI now.
Gui, 3:Destroy
FileDelete, ImBaked.mp4

gosub, CustomCodecShit ;Temporary fix for HEVC/H265 decoding.
gosub, OutputLocation ;Get the foldername the Datamoshed avi is in.

inputFile := "\output-moshed.avi "
if (BatchBake = 1) {
	inputFile := " " . ConcatString . " "
	BakedOutputFolder := OutputFolder
	OutputFolder := ""
}

MP4Bake := "mencoder " . CustomCodecFix . " " . OutputFolder . inputFile " -ovc x264 -x264encopts crf=1.0 " . MEncoderOptions " -o " . OutputFolder . BakedOutputFolder . "\ImBaked.mp4 -of lavf"
;msgbox, %MP4Bake%

runwait, %MP4Bake%
sleep, 20
WinWaitClose, cmd
LetseeIt := "cmd.exe /c ffplay -i " . OutputFolder . BakedOutputFolder . "\ImBaked.mp4 -loop 0"
runwait, %LetseeIt%
;FileDelete, %OutputFolder%\output-moshed.avi

;Clear the concat string.
ConcatString := ""
Return

PlsBakeYUV:
;This Method reduces/elimanates duplicate/frozen frames, which also speeds up video.
;Currently doesn't work for batch file input, as MPlayer overwrites the output stream.yuv with each video.
;Gonna have to concatenate them all at some point.
Gui, 3:Destroy
FileDelete, %OutputFolder%\ImBaked.yuv

;Temporary fix for HEVC/H265 decoding.
gosub, CustomCodecShit
gosub, OutputLocation ;Get the foldername the Datamoshed avi is in.

inputFile := "\output-moshed.avi "
if (BatchBake = 1) {
	inputFile := " " . ConcatString . " "
	OutputFolder := ""
}

YUVBake := "mplayer " . CustomCodecFix . " -vo yuv4mpeg " . OutputFolder . inputFile
msgbox, %YUVBake%
runwait, %YUVBake%
sleep, 20
WinWaitClose, cmd
FileMove, stream.yuv,  %OutputFolder%\ImBaked.yuv
runwait, cmd.exe /c ffplay -i  %OutputFolder%\ImBaked.yuv -loop 0
;FileDelete, %OutputFolder%\output-moshed.avi
Return


NoReBake:
Gui, 3:Destroy
Return



GuiEscape:
GuiClose:
ExitApp


