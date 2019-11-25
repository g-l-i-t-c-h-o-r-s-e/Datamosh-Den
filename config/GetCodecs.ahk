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

;Purge Video and Subtitle codecs from Audio Encoder list!!!
;I know its legacy syntax but hey, thats how I roll sometimes.
Needle1 := "zmbv"
Needle2 := "ass"
FFAEncoderList := SubStr(FFEncoderList, InStr(FFEncoderList, Needle1)+1) . "|"
FFAEncoderList := SubStr(FFAEncoderList, 1, InStr(FFAEncoderList, Needle2)-1) . "|"
FFAEncoderList := StrReplace(FFAEncoderList, "mbv|", "") ;idk what I did wrong but I had to remove this broken encoder name.

;Purge Audio and Subtitle Codecs from Video Codec list!!!
Needle3 := "aac"
FFEncoderList := SubStr(FFEncoderList, 1, InStr(FFEncoderList, Needle3)-1) . "|"