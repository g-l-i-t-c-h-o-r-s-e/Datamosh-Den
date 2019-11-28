#SingleInstance Force
GetFFMPEG()
{
	global FFMPegVersion
	Gui, 14:Add, Button, x68 y65 w70 h24 gPrefer, Preferred
	Gui, 14:Add, Button, x247 y65 w54 h24 gRecent, Latest
	Gui, 14:Add, Text, x5 y5 w358 h27, `n           It looks like you dont have ffmpeg, pls select a version bb <3
	Gui, 14:Show, w368 h96,START YOUR ENGINES!!!
	Gui, 14:-Sysmenu
	return
	
	Prefer:
	Gui, 14:Destroy
	FFMPegVersion := "https://ffmpeg.zeranoe.com/builds/win32/static/ffmpeg-3.3.2-win32-static.zip"
	return
	
	Recent:
	Gui, 14:Destroy
	FFMPegVersion := "https://ffmpeg.zeranoe.com/builds/win64/static/ffmpeg-latest-win64-static.zip"
	return
}


IfNotExist, ffmpeg.exe
{
	GetFFMPEG()
	WinWaitClose, START YOUR ENGINES!!!
	url := FFMPegVersion
	SplitPath, url, name, dir, ext, name_no_ext, drive
	F1 := A_ScriptDir . "\" . name_no_ext . "." . ext
	SplashTextOn, 400, 40, ,Now downloading`n%name_no_ext%
	urldownloadtofile,%url%,%f1%
	SplashTextOff
	msgbox, 262208,Download ,Download Complete...
	
	#Include config\unzip.ahk
	gosub, StartUnzip
}
