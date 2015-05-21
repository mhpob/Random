# Install FFmpeg on your computer http://www.wikihow.com/Install-FFmpeg-on-Windows
# ffmpeg code
# Location of ffmpeg on computer
ff.loc <- 'c:/ffmpeg/bin/ffmpeg.exe'

# Call system command prompt. If there's a warning message, something is wrong.
system2(ff.loc, '-i p:/obrien/aris/2014-07-16_214123_1_495.mp4 -f image2 aris-%03d.jpeg -v warning')

# Retrieve FPS
fps <- system2('c:/ffmpeg/bin/ffprobe.exe', 'p:/obrien/aris/2014-07-16_214123_1_495.mp4 -show_entries stream=r_frame_rate -of default=nokey=1:noprint_wrappers=1 -v warning',
             stdout=T)
fps <- as.numeric(strsplit(fps, '/')[[1]][1])
