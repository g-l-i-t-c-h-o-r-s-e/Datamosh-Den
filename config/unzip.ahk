;Borrowed and modified from Reddit: https://www.reddit.com/r/AutoHotkey/comments/6apkou/extract_last_downloaded_file_with_7z_ahk/
;SetWorkingDir %A_ScriptDir%
#SingleInstance Force

StartUnzip:

if FileExist("C:\Program Files (x86)\7-Zip\7z.exe") {
	
	7z := "C:\Program Files (x86)\7-Zip\7z.exe"
	
}

if FileExist("C:\Program Files\7-Zip\7z.exe") {
	
	7z := "C:\Program Files\7-Zip\7z.exe"
	
}

if !FileExist("C:\Program Files (x86)\7-Zip\7z.exe") {
    msgbox, It looks like you might not have 7zip installed...`nLet me check another directory.	
	
}

if !FileExist("C:\Program Files\7-Zip\7z.exe") {
    msgbox, It looks like you still dont have 7zip installed...`nGo grab a copy and install it on your c drive pls!
    Return
	
}


IfNotExist, ffmpeg.exe
{
	gosub, unzipFF
     return
}
Return

unzipME:

IfExist, new-mplayer.exe
return
else
msgbox, oh shit theres no newer MEncoder...`nThis is needed for HEVC/H265 Decoding.

;specify the downloads folder location below
Folder := A_ScriptDir

File := "mplayer-svn-38151.7z"

FullPath=%Folder%\%File%
SplitPath, File, OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
ExtractedPath=%Folder%\%OutNameNoExt%

msgbox, Extracting %File%

;extracts to folder named after original zip file in download folder
RunWait, %7z% x `"%FullPath%`" -o`"%ExtractedPath%`"

FileMove, %ExtractedPath%\%OutNameNoExt%\mplayer.exe, new-mplayer.exe
sleep, 500
FileMove, %ExtractedPath%\%OutNameNoExt%\mencoder.exe, new-mencoder.exe
sleep, 200
FileRemoveDir, %ExtractedPath%, 1

;open explorer after extracted in downloads folder.
;Run, explorer `"%ExtractedPath%`"
Return


unzipFF:

IfExist, ffmpeg.exe
return

;specify the downloads folder location below
SplitPath, FFMPegVersion, OutFileNameFF, OutDir, OutExtension, OutNameNoExt, OutDrive

Folder := A_ScriptDir
File := OutFileNameFF

FullPath=%Folder%\%File%
SplitPath, File, OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
ExtractedPath=%Folder%\%OutNameNoExt%

;extracts to folder named after original zip file in download folder
;run7z := ComSpec . " /k " 7z . " x " . FullPath . " -o" . chr(0x22) . ExtractedPath . chr(0x22)
RunWait, %7z% x `"%FullPath%`" -o`"%ExtractedPath%`"

FileMove, %ExtractedPath%\%OutNameNoExt%\bin\ffmpeg.exe, ffmpeg.exe
sleep, 500
FileMove, %ExtractedPath%\%OutNameNoExt%\bin\ffplay.exe, ffplay.exe
sleep, 500
FileMove, %ExtractedPath%\%OutNameNoExt%\bin\ffprobe.exe, ffprobe.exe
sleep, 500
FileRemoveDir,%OutNameNoExt%, 1
sleep, 100
FileDelete, %OutFileName%
;open explorer after extracted in downloads folder.
;Run, explorer `"%ExtractedPath%`"
IfExist, ffmpeg.exe
{
	WinWaitClose, cmd.exe
	gosub, unzipME
     Reload ;Restarts script after FFmpeg and is done extracting.
}
else
Return
