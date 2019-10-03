dl_locs <-  matrix(c(
  'https://fe1d2f5ab2.site.internapcdn.net/lbg49g5gF4d2/smil:4779349C6F_MP4_311057_1.smil/chunklist_b1920000.m3u8?md=311057&ts=20170818T000821Z&tn=06c8df1510339aa31731036c72d2d5aee00b67ea',
  'Summers_Charlotte_Schuylkill_MPOOL.mp4',
  'https://fe1d2f5ab2.site.internapcdn.net/lbg49g5gF4d2/smil:AEDA4A3B28_MP4_310910.smil/chunklist_b1951744.m3u8?md=310910&ts=20170818T001016Z&tn=c8d621bf9e4832f647c1842ac01d2bd8c8842355',
  'McCandless_Chicago_SantaMonica_MPOOL.mp4',
  'https://fe1d2f5ab2.site.internapcdn.net/lbg49g5gF4d2/smil:717CDFC6DE_MP4_311008.smil/chunklist_b1947648.m3u8?md=311008&ts=20170818T001149Z&tn=010773f28f0eca806dc43b209eeb572dd6948518',
  'Lopez_Chicago_LifeWest_M7th.mp4',
  'https://fe1d2f5ab2.site.internapcdn.net/lbg49g5gF4d2/smil:5A8812E020_MP4_311140_1.smil/chunklist_b1927168.m3u8?md=311140&ts=20170818T001236Z&tn=74cf8dbda02ed3354ff73a7039b0f6fd682efe33',
  'Johnson_Chicago_Optimus_MPOOL.mp4',
  'https://fe1d2f5ab2.site.internapcdn.net/lbg49g5gF4d2/smil:36BC8BB6D7_MP4_310913.smil/chunklist_b1950720.m3u8?md=310913&ts=20170818T001402Z&tn=3d5240d2c107a0999bec5fbec54a4471cdfd4f5e',
  'Johnson_LifeWest_Optimus_MPOOL.mp4',
  'https://fe1d2f5ab2.site.internapcdn.net/lbg49g5gF4d2/smil:BCCD7014EB_MP4_311143_1.smil/chunklist_b1922048.m3u8?md=311143&ts=20170818T001516Z&tn=7791316caa09e031d4cc480a0b1dac1048a3c1b3',
  'Summers_LifeWest_SantaMonica_MPOOL.mp4',
  'https://fe1d2f5ab2.site.internapcdn.net/lbg49g5gF4d2/smil:CB42A108AE_MP4_311056_1.smil/chunklist_b1908736.m3u8?md=311056&ts=20170818T001708Z&tn=2d77eb0a2477118e0d7bb2e32824dc89de75bedc',
  'McCandless_SantaMonica_Optimus_MPOOL.mp4'
  ), ncol = 2, byrow = T)

input <- paste('-thread_queue_size 512 -i', shQuote(dl_locs[, 1]),
               '-c copy -bsf:a aac_adtstoasc',
               shQuote(paste0('c:/users/secor/desktop/club 7s/', dl_locs[,2])),
               sep = ' ')
ffmpeg_loc <- Sys.which('ffmpeg')


sapply(input, function(x) system2(command = ffmpeg_loc, args = x, wait = T))
