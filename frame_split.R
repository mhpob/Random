# Install FFmpeg on your computer http://www.wikihow.com/Install-FFmpeg-on-Windows

frame_split <- function(video, ff.loc = NULL, prefix = 'img'){
  if(is.null(ff.loc)){
    mpeg <- Sys.which('ffmpeg')
    probe <- Sys.which('ffprobe')
  } else if(substr(ff.loc, nchar(ff.loc), nchar(ff.loc)) == '/'){
    probe <- paste(ff.loc, 'ffprobe.exe', sep = '')
    mpeg <-  paste(ff.loc, 'ffmpeg.exe', sep = '')
  } else{
    probe <- paste(ff.loc, 'ffprobe.exe', sep = '/')
    mpeg <- paste(ff.loc, 'ffmpeg.exe', sep = '/')
  }

  if(mpeg == "") warning('Cannot find FFmpeg!!')
  if(probe == "") waring('Cannot find FFprobe!!')

  # Retrieve number of frames for naming
  frames <- system2(probe, paste(video, '-show_entries stream=nb_frames',
                           '-of default=nokey=1:noprint_wrappers=1 -v warning'),
                    stdout = T)
  frames <- nchar(frames)

  # Define FFmpeg input string
  input <-  paste('-i ', video, ' -f image2 ', prefix, '-%', frames,
                  'd.jpeg -v warning', sep = '')

  # Call system command prompt. If there's a warning message, something is wrong.
  system2(mpeg, input)
}

## Example
# frame_split(video = 'p:/obrien/aris/2014-07-16_214123_1_495.mp4',
#             ff.loc = 'c:/ffmpeg/bin',
#             prefix = 'aris')
#
# frame_split(video = 'p:/obrien/aris/2014-07-16_214123_1_495.mp4',
#             prefix = 'aris')