
# BIG UPDATE SOON, STANDBY
TEMP PATCH, POSSIBLY STABLE:
                                                                                                                                                                                 https://drive.google.com/file/d/1eM2XjjPxwYxxCrrtP8vVApOD8ZxxyU7q/view?usp=sharing
# HOPEFULLY THIS WORKS FOR EVERYONE, IF SO BEHOLD THE ALMOST OFFICIAL BUILD



# Please Read All Of This In Detail.
YOU NEED AUTOHOTKEY INSTALLED: [grab a copy here](https://www.autohotkey.com/download/ahk-install.exe)                          
You will still need to grab 7zip from https://www.7-zip.org/ i. e [here](https://www.7-zip.org/a/7z1900.exe)                            
as well as Python 2.7.16   [found here](https://www.python.org/downloads/release/python-2716/)                                                   
Read [the wiki](https://github.com/g-l-i-t-c-h-o-r-s-e/Datamosh-Den/wiki/Halp) if you need help, or PM me :>                       
If this doesn't work check out the other branches and let me know my code sucks pls.


Ohey me again with another wacky script i conjured up in AutoHotkey Version 1.1.30.03 :b             
Hopefully this will make Datamoshing more accesible to people on Windows who aren't familiar with the command line.

![img1](https://i.imgur.com/oPh1l76.png)

# Features 
• Quick video playback of the datamoshed avi

• Use of many Video For Windows codecs, some seen nowhere else

• Ability to add custom codecs via adding dll to codec folder and codecs.conf

• Fast EZ Baking options ranging from raw yuv4mpeg, mp4 and png frame output!

• Repeatedly iterate different datamosh settings on the same file via Remosh 

• Compress the datamoshed avi again with a new codec to stack compression artifacts!

• Reversible filters you can apply via Encode and or Decode (hue, transpose, flip, reverse, etc).

• Sync Datamoshed Video back to the original duration and optionally mix the original audio back in!

• Apply numerous Hex Edits to the Compressed or Datamoshed AVI! (i.e Before Datamosh or After Datamosh)

• Probably more I haven't mentioned idk


# B̶e̶c̶a̶u̶s̶e̶ ̶g̶i̶t̶h̶u̶b̶ ̶w̶o̶n̶'̶t̶ ̶l̶e̶t̶ ̶m̶e̶ ̶u̶p̶l̶o̶a̶d̶ ̶b̶i̶g̶ ̶a̶s̶s̶ ̶f̶i̶l̶e̶s̶,̶ ̶y̶o̶u̶'̶l̶l̶ ̶n̶e̶e̶d̶ ̶t̶o̶ ̶g̶r̶a̶b̶ ̶a̶ ̶c̶o̶p̶y̶ ̶o̶f̶ ̶F̶F̶m̶p̶e̶g̶ ̶a̶n̶d̶ ̶F̶F̶p̶l̶a̶y̶ ̶y̶o̶u̶r̶s̶e̶l̶f̶ ̶f̶r̶o̶m̶ [h̶e̶r̶e̶]( https://ffmpeg.zeranoe.com/builds/win64/static/ffmpeg-4.2.1-win64-static.zip)
YOU DONT NEED TO DO THE ABOVE ANYMORE SINCE MY SCRIPT DOWNLOADS FFMPEG FOR YOU.                  
Version 3.3.2 has some codecs and filters the newest one doesnt have anymore (libxavs, frei0r, etc) might wanna [try that out too.]( https://ffmpeg.zeranoe.com/builds/win64/static/ffmpeg-3.3.2-win64-static.zip)                            
This GUI lists whatever codecs the FFmpeg build you have can encode with; put _ffmpeg.exe_ and _ffplay.exe_ in the same folder as the script please.

I included a build of MEncoder, MPlayer and more. The MPlayer devs at some point changed how MEncoder/MPlayer handles vfw(Video For Windows) video codecs; but I found a [forum post]( https://spreadys.wordpress.com/2013/03/29/imm4-codec-and-mencoder/) that explains this and links a working MEncoder build compatible with vfw codecs. I already provided that MEncoder build in this repository but if you want to see it for yourself the link is in [here]( https://app.box.com/v/Spreadys), password is: validate


# Tomato also requires python version 2.7.16, [found here]( https://www.python.org/downloads/release/python-2716/)

You can optionally grab a copy of it from [here.]( https://github.com/itsKaspar/tomato) Thank you Kaspar <333

# YOU NEED 7-ZIP INSTALLED FOR THE SCRIPT TO EXTRACT FFMPEG https://www.7-zip.org/

# TODO

• Auto-Download and Extract FFmpeg and the MPlayer version for HEVC [✔]

• Segment video into multiple files and apply random Tomato settings to each one [✖]

• Option to hex edit the avi to force glitches and compression artifacts [✔]

• Add Force Frame Rate(FPS) to RetryScale function [✔]

• Add bypass compression for pre-encoded files [✖]

• Add Webcam input and device list [✔]

• FFmpeg Video Quality Slider [✔]

• Clean up FFmpeg Codecs List [✔]

• AMV Watermark Cropping [✔]

• Fix HEVC/H265 decode [✔] (Almost done, so far only x265vfw.dll with [these](https://i.imgur.com/f7R4bVN.png) settings; works for encoding).

• Batch file input [✔] (Almost done! It concats all the videos for now.)

• Option to save the output files to the folder where the video source is [✖]

• More codecs [✖]

# If you would like to help the cause; our wallet: `17YcpEtKybVHAoTgirJy94p1Hygtbvh21p`
