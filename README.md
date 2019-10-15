
# OwO 
Ohey me again with another wacky script i conjured up in AutoHotkey Version 1.1.30.03 :b             
Hopefully this will make Datamoshing more accesible to people on Windows who aren't familiar with the command line.

![img1](https://i.imgur.com/lSErFpU.png)

# Features 
• Quick video playback of the datamoshed avi

• Use of many Video For Windows codecs, some seen nowhere else

• Ability to add custom codecs via adding dll to codec folder and codecs.conf

• Fast EZ Baking options ranging from raw yuv4mpeg, mp4 and png frame output!

• Repeatedly iterate different datamosh settings on the same file via Remosh 

• Compress the datamoshed avi again with a new codec to stack compression artifacts!

# Because github won't let me upload big ass files, you'll need to grab a copy of FFmpeg and FFplay yourself from [here]( https://ffmpeg.zeranoe.com/builds/win64/static/ffmpeg-4.2.1-win64-static.zip)
Version 3.3.2 has some codecs and filters the newest one doesnt have anymore (libxavs, frei0r, etc) might wanna [try that out too.]( https://ffmpeg.zeranoe.com/builds/win64/static/ffmpeg-3.3.2-win64-static.zip)                            
This GUI lists whatever codecs the FFmpeg build you have can encode with; put _ffmpeg.exe_ and _ffplay.exe_ in the same folder as the script please.

I included a build of MEncoder, MPlayer and more. The MPlayer devs at some point changed how MEncoder/MPlayer handles vfw(Video For Windows) video codecs; but I found a [forum post]( https://spreadys.wordpress.com/2013/03/29/imm4-codec-and-mencoder/) that explains this and links a working MEncoder build compatible with vfw codecs. I already provided that MEncoder build in this repository but if you want to see it for yourself the link is in [here]( https://app.box.com/v/Spreadys), password is: validate

Tomato can be found [here.]( https://github.com/itsKaspar/tomato) Thank you Kaspar <333

# Tomato also requires python version 2.7.16, [found here]( https://www.python.org/downloads/release/python-2716/)
