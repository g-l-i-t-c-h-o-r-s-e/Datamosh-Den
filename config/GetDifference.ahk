SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
;This Script takes the baked video and then calls ffprobe to get the duration
;So that we can then divide the glitched videos duration with the original duration to get the difference between the two
;That way we can sync the glitched video back to the original videos duration, and optionally add the audio back.

RemovedAudio := InputFolder . "\ExtractedAudio.avi"
FileDelete, %RemovedAudio%
sleep, 10

EnableGetDifference:
if (DisableGetDifferencePls = 1) {
	Return
}

Gui Difference:Add, Text, x6 y5 w191 h16 +0x200, Sync Video Back To Original Duration?
Gui Difference:Add, Button, x18 y24 w80 h23 gCommenceGetDifference, hell yes
Gui Difference:Add, Button, x98 y24 w80 h23 gNoGetDifference, no pls
Gui Difference:Add, CheckBox, x37 y55 w120 h23 gDisableGetDifference, ok but dont ask again
Gui Difference:Show, w199 h88, Difference
Return

CommenceGetDifference:
gosub, OutputLocation
Gui, Difference:Destroy

SeekVar := ""
EndVar := ""
sourceFile1 := DefaultSourceFile
sourceFile2 := InputFolder . "\Moshed\" . BakedFilename


Test1 := !RegExMatch(MEncoderOptions,"( -ss )") ;Temp Fix
Test2 := !RegExMatch(FFmpegOptions,"( -ss )") ;Temp Fix

if (Test1 = 1) && (Test2 = 1) {

     OriginalVideo := ComSpec . " /c ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 " . chr(0x22) . sourceFile1 . chr(0x22)
	GetDuration1 := ComObjCreate("WScript.Shell").Exec(OriginalVideo).StdOut.ReadAll() ;Calculate output from FFprobe and save stdout to variable!
	OriginalDuration := GetDuration1
	StringTrimRight, OriginalDuration, OriginalDuration, 5 ;Remove extra unneeded numbers
	
	;msgbox, %OriginalDuration%
	
	
	GlitchedVideo := ComSpec . " /c ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 " . chr(0x22) . sourceFile2 . chr(0x22)
	GetDuration2 := ComObjCreate("WScript.Shell").Exec(GlitchedVideo).StdOut.ReadAll() ;Calculate output from FFprobe and save stdout to variable!
	GlitchedDuration := GetDuration2
	StringTrimRight, GlitchedDuration, GlitchedDuration, 5 ;Remove extra unneeded numbers
	
	;msgbox, %GlitchedDuration%
	
	
	Workaround := ComSpec . " /c echo (" . OriginalDuration . "/" . GlitchedDuration . ") | bc -l "
	Calculate := ComObjCreate("WScript.Shell").Exec(Workaround).StdOut.ReadAll() ;Calculate output from FFprobe and save stdout to variable!
	Difference := Calculate
	Difference := StrReplace(Difference, "`r`n", "") ;Removes linebreak and shit.
	
	
	Haystack := Difference
	Needle := "."
	StringGetPos, pos, Haystack, %Needle%
	if (pos = 0) {
	;MsgBox, Adding a "0" to the beginning of string.
		Difference := "0" . Calculate ; Places a 0 at the beginning of string for FFmpeg's sake.
		Difference := StrReplace(Difference, "`r`n", "") ;Removes linebreak and shit.
		
		ApplyDifference := ComSpec . " /c " . " ffmpeg -i " . chr(0x22) . sourceFile2 . chr(0x22) . " -c:v huffyuv -vf setpts=" . Difference . "*PTS " . OutputFolder . "\output-moshed-synced.avi -y"
		ViewDifference := ComSpec . " /c " . " ffplay -i " . OutputFolder . "\output-moshed-synced.avi"
		
		runwait, %ApplyDifference%
		runwait, %ViewDifference%
		
		if (DisableMixAudioPls = 1) {
			Return
		}
		
		WinWaitClose, cmd
		Gui Difference4:Add, Text, x13 y7 w178 h16, Mix Original Audio Back Into Video?
		Gui Difference4:Add, Button, x18 y24 w80 h23 gMixAudioPles, hell yes
		Gui Difference4:Add, Button, x98 y24 w80 h23 gNoGetDifference, no pls
		Gui Difference4:Add, CheckBox, x37 y55 w120 h23 gDisableMixAudio, ok but dont ask again
		
		Gui Difference4:Show, w199 h88, Window
		
		Return
	}
}


;Checks if user trimmed the source file to a specific duration.
;If so, replace that with original duration for calculations.
if RegExMatch(MEncoderOptions,"( -endpos )") else if RegExMatch(FFmpegOptions,"( -t )") {
	
	if (RecompressVar = "MEncoder") {
		OptionArray := StrSplit(MEncoderOptions, "-")
	}
	
	if (RecompressVar = "FFmpeg") {
		OptionArray := StrSplit(FFmpegOptions, "-")
	}
	
	Loop % OptionArray.MaxIndex()
	{
		this_option := " -" . OptionArray[A_Index]
		if RegExMatch(this_option, "-ss") {
			SeekVar := this_option
			SeekVar := RegExReplace(SeekVar, "-ss", "")
		}
		
		if RegExMatch(this_option, "-endpos") or RegExMatch(this_option, "-t") {
			EndVar := this_option
			EndVar := RegExReplace(EndVar, "-endpos", "")
			EndVar := RegExReplace(EndVar, "-t", "")
			
			
			;Get Glitched video duration
			GlitchedVideo := ComSpec . " /c ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 " . chr(0x22) . sourceFile2 . chr(0x22)
			GetDuration2 := ComObjCreate("WScript.Shell").Exec(GlitchedVideo).StdOut.ReadAll() ;Calculate output from FFprobe and save stdout to variable!
			GlitchedDuration := GetDuration2
			StringTrimRight, GlitchedDuration, GlitchedDuration, 5 ;Remove extra unneeded numbers
			
			
		     ;Get Difference, using the trimmed amount as the duration
			Workaround := ComSpec . " /c echo (" . EndVar . "/" . GlitchedDuration . ") | bc -l "
			Calculate := ComObjCreate("WScript.Shell").Exec(Workaround).StdOut.ReadAll() ;Calculate output from FFprobe and save stdout to variable!
			Difference := Calculate
			Difference := StrReplace(Difference, "`r`n", "") ;Removes linebreak and shit.
			
			;if (RecompressVar = "MEncoder") && RegExMatch(MEncoderOptions,"( -ss )") {
				
			;Extract Audio via MEncoder, since the seeking seems to snap to keyframes in contrast to FFmpegs frame accurate seeking.
			;	ExtractAudio := ComSpec . " /k mencoder -ss " . SeekVar . " -endpos " . EndVar . " " . chr(0x22) . sourceFile1 . chr(0x22) . " -oac mp3lame -ovc frameno -o " . InputFolder . "\ExtractedAudio.avi "
			;	msgbox, %ExtractAudio%
			;	runwait, %ExtractAudio%
			;	msgbox, done
			;	NewAudioFile :=  InputFolder . "\ExtractedAudio.avi "
			;}
			
			Haystack := Difference
			Needle := "."
			StringGetPos, pos, Haystack, %Needle%
			if (pos = 0) {
	               ;MsgBox, Adding a "0" to the beginning of string.
				Difference := "0" . Calculate ; Places a 0 at the beginning of string for FFmpeg's sake.
				Difference := StrReplace(Difference, "`r`n", "") ;Removes linebreak and shit.
				
				ApplyDifference := ComSpec . " /c " . " ffmpeg -i " . chr(0x22) . sourceFile2 . chr(0x22) . " -c:v huffyuv -vf setpts=" . Difference . "*PTS " . OutputFolder . "\output-moshed-synced.avi -y"
				ViewDifference := ComSpec . " /c " . " ffplay -i " . OutputFolder . "\output-moshed-synced.avi"
				
				runwait, %ApplyDifference%
				runwait, %ViewDifference%
				
				if (DisableMixAudioPls = 1) {
					Return
				}
				
				WinWaitClose, cmd
				Gui Difference4:Add, Text, x13 y7 w178 h16, Mix Original Audio Back Into Video?
				Gui Difference4:Add, Button, x18 y24 w80 h23 gMixAudioPles, hell yes
				Gui Difference4:Add, Button, x98 y24 w80 h23 gNoGetDifference, no pls
				Gui Difference4:Add, CheckBox, x37 y55 w120 h23 gDisableMixAudio, ok but dont ask again
				
				Gui Difference4:Show, w199 h88, Window
				
				Return
				
			}
		}
		
	}
}

;This Checks if the user skipped into the video, if so it subtracts that amount from the original duration
;And does all the calculations to get the correct difference
if RegExMatch(MEncoderOptions,"( -ss )") or RegExMatch(FFmpegOptions,"( -ss )") {
	
	if (RecompressVar = "MEncoder") {
		OptionArray := StrSplit(MEncoderOptions, "-")
	}
	
	if (RecompressVar = "FFmpeg") {
		OptionArray := StrSplit(FFmpegOptions, "-")			
	}
	
	Loop % OptionArray.MaxIndex()
	{
		this_option := " -" . OptionArray[A_Index]
		
		if RegExMatch(this_option, " -ss ") {
			SeekVar := this_option
			SeekVar := RegExReplace(SeekVar, "-ss", "")
			
			if (RecompressVar = "FFmpeg") {
				;OptionArray := StrSplit(FFmpegOptions, "-")
								
				
			;Get Original Video Duration
				OriginalVideo := ComSpec . " /c ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 " . chr(0x22) . sourceFile1 . chr(0x22)
				GetDuration1 := ComObjCreate("WScript.Shell").Exec(OriginalVideo).StdOut.ReadAll() ;Calculate output from FFprobe and save stdout to variable!
				OriginalDuration := GetDuration1
				StringTrimRight, OriginalDuration, OriginalDuration, 5 ;Remove extra unneeded numbers
			;msgbox, %OriginalDuration%
				
				
			;Get Glitched video duration
				GlitchedVideo := ComSpec . " /c ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 " . chr(0x22) . sourceFile2 . chr(0x22)
				GetDuration2 := ComObjCreate("WScript.Shell").Exec(GlitchedVideo).StdOut.ReadAll() ;Calculate output from FFprobe and save stdout to variable!
				GlitchedDuration := GetDuration2
				StringTrimRight, GlitchedDuration, GlitchedDuration, 5 ;Remove extra unneeded numbers
			;msgbox, %GlitchedDuration%
				
				
			;Subtract how far you seeked into the video. from the original duration.
				Workaround1 := ComSpec . " /c echo (" . OriginalDuration . "-" . SeekVar . ") | bc -l "
				Calculate1 := ComObjCreate("WScript.Shell").Exec(Workaround1).StdOut.ReadAll() ;Calculate output from FFprobe and save stdout to variable!
				Difference1 := Calculate1
				NewDuration := StrReplace(Difference1, "`r`n", "") ;Removes linebreak and shit.
			;msgbox, %NewDuration%
				
				
				
			;Perform difference calculations
				Workaround2 := ComSpec . " /c echo (" . NewDuration . "/" . GlitchedDuration . ") | bc -l "
				Calculate2 := ComObjCreate("WScript.Shell").Exec(Workaround2).StdOut.ReadAll() ;Calculate output from FFprobe and save stdout to variable!
				Difference2 := Calculate2
				Difference2 := StrReplace(Difference2, "`r`n", "") ;Removes linebreak and shit.
				
				Haystack := Difference2
				Needle := "."
				StringGetPos, pos, Haystack, %Needle%
				if (pos = 0) {
	               ;MsgBox, Adding a "0" to the beginning of string.
					Difference2 := "0" . Difference2 ; Places a 0 at the beginning of string for FFmpeg's sake.
					Difference2 := StrReplace(Difference2, "`r`n", "") ;Removes linebreak and shit.
					
					ApplyDifference := ComSpec . " /c " . " ffmpeg -i " . chr(0x22) . sourceFile2 . chr(0x22) . " -c:v huffyuv -vf setpts=" . Difference2 . "*PTS " . OutputFolder . "\output-moshed-synced.avi -y"
					ViewDifference := ComSpec . " /c " . " ffplay -i " . OutputFolder . "\output-moshed-synced.avi"
					
					runwait, %ApplyDifference%
					runwait, %ViewDifference%
					
					
					if (DisableMixAudioPls = 1) {
						Return
					}
					
					WinWaitClose, cmd
					Gui Difference4:Add, Text, x13 y7 w178 h16, Mix Original Audio Back Into Video?
					Gui Difference4:Add, Button, x18 y24 w80 h23 gMixAudioPles, hell yes
					Gui Difference4:Add, Button, x98 y24 w80 h23 gNoGetDifference, no pls
					Gui Difference4:Add, CheckBox, x37 y55 w120 h23 gDisableMixAudio, ok but dont ask again
					Gui Difference4:Show, w199 h88, Window
					
					Return	
				}
				
			}
			
			;If you're using MEncoder for this we have to use a different approach.
			if (RecompressVar = "MEncoder") {
				
			;Extract Audio via MEncoder, since the seeking seems to snap to keyframes in contrast to FFmpegs frame accurate seeking.
				ExtractAudio := ComSpec . " /k mencoder -ss " . SeekVar . " " . chr(0x22) . sourceFile1 . chr(0x22) . " -oac mp3lame -ovc frameno -o " . InputFolder . "\ExtractedAudio.avi "
				runwait, %ExtractAudio%
				sleep, 10
				NewAudioFile :=  InputFolder . "\ExtractedAudio.avi "
				;msgbox, %NewAudioFile%
				
				
			;Get Original Video Duration
				OriginalVideo := ComSpec . " /c ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 " . chr(0x22) . NewAudioFile . chr(0x22)
				GetDuration1 := ComObjCreate("WScript.Shell").Exec(OriginalVideo).StdOut.ReadAll() ;Calculate output from FFprobe and save stdout to variable!
				OriginalDuration := GetDuration1
				StringTrimRight, OriginalDuration, OriginalDuration, 5 ;Remove extra unneeded numbers
				;msgbox, %OriginalDuration%
				
				
			;Get Glitched video duration
				GlitchedVideo := ComSpec . " /c ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 " . chr(0x22) . sourceFile2 . chr(0x22)
				GetDuration2 := ComObjCreate("WScript.Shell").Exec(GlitchedVideo).StdOut.ReadAll() ;Calculate output from FFprobe and save stdout to variable!
				GlitchedDuration := GetDuration2
				StringTrimRight, GlitchedDuration, GlitchedDuration, 5 ;Remove extra unneeded numbers
				;msgbox, %GlitchedDuration%
				
			;I Dont think this is needed for the MEncoder syncing method.	
			;Subtract how far you seeked into the video. from the original duration.
			;	Workaround1 := ComSpec . " /c echo (" . OriginalDuration . "-" . SeekVar . ") | bc -l "
			;	Calculate1 := ComObjCreate("WScript.Shell").Exec(Workaround1).StdOut.ReadAll() ;Calculate output from FFprobe and save stdout to variable!
			;	Difference1 := Calculate1
			;	NewDuration := StrReplace(Difference1, "`r`n", "") ;Removes linebreak and shit.
			;msgbox, %NewDuration%
				
				
				
			;Perform difference calculations
				Workaround2 := ComSpec . " /c echo (" . OriginalDuration . "/" . GlitchedDuration . ") | bc -l "
				Calculate2 := ComObjCreate("WScript.Shell").Exec(Workaround2).StdOut.ReadAll() ;Calculate output from FFprobe and save stdout to variable!
				Difference2 := Calculate2
				Difference2 := StrReplace(Difference2, "`r`n", "") ;Removes linebreak and shit.
				;msgbox, %Difference2%
				
				Haystack := Difference2
				Needle := "."
				StringGetPos, pos, Haystack, %Needle%
				if (pos = 0) {
	               ;MsgBox, Adding a "0" to the beginning of string.
					Difference2 := "0" . Difference2 ; Places a 0 at the beginning of string for FFmpeg's sake.
					Difference2 := StrReplace(Difference2, "`r`n", "") ;Removes linebreak and shit.
					
					ApplyDifference := ComSpec . " /c " . " ffmpeg -i " . chr(0x22) . sourceFile2 . chr(0x22) . " -c:v huffyuv -vf setpts=" . Difference2 . "*PTS " . OutputFolder . "\output-moshed-synced.avi -y"
					ViewDifference := ComSpec . " /c " . " ffplay -i " . OutputFolder . "\output-moshed-synced.avi"
					
					runwait, %ApplyDifference%
					runwait, %ViewDifference%
					
					
					if (DisableMixAudioPls = 1) {
						Return
					}
					
					WinWaitClose, cmd
					Gui Difference4:Add, Text, x13 y7 w178 h16, Mix Original Audio Back Into Video?
					Gui Difference4:Add, Button, x18 y24 w80 h23 gMixAudioPles, hell yes
					Gui Difference4:Add, Button, x98 y24 w80 h23 gNoGetDifference, no pls
					Gui Difference4:Add, CheckBox, x37 y55 w120 h23 gDisableMixAudio, ok but dont ask again
					Gui Difference4:Show, w199 h88, Window
					
					Return	
				}
				
			}
			
		}
		
	}
	
}

msgbox, wot I dont think I programmed this yet... but we'll give it a shot.`nIf you're seeing this you might want to make sure`n the datamoshed video is longer in duration than the original
Difference := Calculate
Difference := StrReplace(Difference, "`r`n", "") ;Removes linebreak and shit.

ApplyDifference := ComSpec . " /c " . " ffmpeg -i " . chr(0x22) . sourceFile2 . chr(0x22) . " -c:v huffyuv -vf setpts=" . Difference . "*PTS " . OutputFolder . "\output-moshed-synced.avi -y"
ViewDifference := ComSpec . " /c " . " ffplay -i " . OutputFolder . "\output-moshed-synced.avi"

msgbox, %ApplyDifference%
runwait, %ApplyDifference%
runwait, %ViewDifference%
Return



MixAudioPles:
Gui, Difference4:Destroy

SeekVar := ""
EndVar := ""
	
	if (RecompressVar = "MEncoder") {
		OptionArray := StrSplit(MEncoderOptions, "-")
	}
	
	if (RecompressVar = "FFmpeg") {
		OptionArray := StrSplit(FFmpegOptions, "-")	
	}
	
	Loop % OptionArray.MaxIndex()
	{
		this_option := " -" . OptionArray[A_Index]
		CurrentOption := this_option
		CurrentOption := RegExReplace(CurrentOption, "-endpos", "-t")
		
		if RegExMatch(CurrentOption, " -t ") {
			EndVar := CurrentOption
		}
		
		if RegExMatch(CurrentOption, " -ss ") {
			SeekVar := CurrentOption
		}
	}

;If we're using FFmpeg codecs theres no additional need to mix the extracted audio
;Instead we use FFmpegs frame accurate seeking and just mix the audio from the original video.
if (RecompressVar = "FFmpeg") {

AudioMix := ComSpec . " /c " . " ffmpeg -i " . chr(0x22) . OutputFolder . "\output-moshed-synced.avi" . chr(0x22) . " " . SeekVar . " " . EndVar . " -i " . chr(0x22) . DefaultSourceFile .  chr(0x22) . " -map 0:v -map 1:a -c:v copy -c:a mp3 -q:a 0 " . OutputFolder . "\output-moshed-audio-synced.avi -y"
ShowSyncedVideo := ComSpec . " /c " . " ffplay -i " . chr(0x22) . OutputFolder . "\output-moshed-audio-synced.avi"

runwait, %AudioMix%
runwait, %ShowSyncedVideo%
Return

}

;If the seek flag is used with MEncoder, mix the extracted audio into the datamoshed avi instead.
;We have to do this because of what I believe MEncoder to be "snapping" to keyframes in a video instead of frame accurate seeking.
if (RecompressVar = "MEncoder") && RegExMatch(SeekVar, " -ss ") {
	EndVar := RegExReplace(EndVar, "-t", "-endpos")
	
	
	;Extract Audio via MEncoder, since the seeking seems to snap to keyframes in contrast to FFmpegs frame accurate seeking.
	ExtractAudio := ComSpec . " /c mencoder " . SeekVar . " " . EndVar . " " . chr(0x22) . sourceFile1 . chr(0x22) . " -oac mp3lame -ovc frameno -o " . InputFolder . "\ExtractedAudio.avi "
	runwait, %ExtractAudio%
	NewAudioFile :=  InputFolder . "\ExtractedAudio.avi "
	
	NewAudioFile :=  InputFolder . "\ExtractedAudio.avi "
	EndVar := RegExReplace(EndVar, "-endpos", "-t")
	
	
	AudioMix := ComSpec . " /c " . " ffmpeg -i " . chr(0x22) . OutputFolder . "\output-moshed-synced.avi" . chr(0x22) . EndVar . " -i " . chr(0x22) . NewAudioFile .  chr(0x22) . " -map 0:v -map 1:a -c:v copy -c:a mp3 -q:a 0 " . OutputFolder . "\output-moshed-audio-synced.avi -y"
	ShowSyncedVideo := ComSpec . " /c " . " ffplay -i " . chr(0x22) . OutputFolder . "\output-moshed-audio-synced.avi"
	
	runwait, %AudioMix%
	runwait, %ShowSyncedVideo%
	NewAudioFile := ""
	Return
	
}

;If there is no seek flag used, we can instead use the original audio source and just cut it where we need to.
if (RecompressVar = "MEncoder") && !RegExMatch(SeekVar, " -ss ") {
	;NewAudioFile :=  InputFolder . "\ExtractedAudio.avi "
	
	AudioMix := ComSpec . " /c " . " ffmpeg -i " . chr(0x22) . OutputFolder . "\output-moshed-synced.avi" . chr(0x22) . EndVar . " -i " . chr(0x22) . DefaultSourceFile .  chr(0x22) . " -map 0:v -map 1:a -c:v copy -c:a mp3 -q:a 0 " . OutputFolder . "\output-moshed-audio-synced.avi -y"
	ShowSyncedVideo := ComSpec . " /c " . " ffplay -i " . chr(0x22) . OutputFolder . "\output-moshed-audio-synced.avi"
	
	runwait, %AudioMix%
	runwait, %ShowSyncedVideo%
	NewAudioFile := ""
	Return
	
}



NoGetDifference:
Gui, Difference:Destroy
Gui, Difference2:Destroy
Gui, Difference3:Destroy
Gui, Difference4:Destroy
Return

DisableGetDifference:
DisableGetDifferencePls := 1
Return

DisableMixAudio:
DisableMixAudioPls := 1
Return
