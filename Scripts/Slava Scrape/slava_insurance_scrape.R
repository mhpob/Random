library(RCurl)




curl  <-  getCurlHandle()
curlSetOpt(cookiejar = 'ASP.NET_SessionId=2w11fuf0flglw03g4o0edgj3', followlocation = TRUE, autoreferer = TRUE, curl = curl)
html <- getURL('https://nask.fno.no/default.aspx',.opts = list(ssl.verifypeer = FALSE))
viewstate <- as.character(sub('.*id="__VIEWSTATE" value="([0-9a-zA-Z+/=]*).*', '\\1', html))
evval <- as.character(sub('.*id="__EVENTVALIDATION" value="([0-9a-zA-Z+/=]*).*', '\\1', html))

pars <- list('ctl00$Innhold$ddlRad' = 1,
              'ctl00$Innhold$ddlKolonne' = 7,
              'ctl00$Innhold$rblVerdi' = 1,
              'ctl00$Innhold$rblBeregning' = 1,
              'ctl00$Innhold$lbType'='',
              'ctl00$Innhold$lbÅr'='',
              'ctl00$Innhold$lbKvartal'='',
              'ctl00$Innhold$lbMåned'='',
              'ctl00$Innhold$lbDag'='',
              'ctl00$Innhold$lbUkedag'='',
              'ctl00$Innhold$lbFylke'='',
             '__VIEWSTATE' = viewstate,
             '__EVENTVALIDATION' = evval,
             '__VIEWSTATEGENERATOR'='CA0B0334',
             '__SCROLLPOSITIONX'=0,
             '__SCROLLPOSITIONY'=340,
             '__EVENTTARGET'='',
             '__EVENTARGUMENT'='',
             '__LASTFOCUS'='')

url <- 'https://nask.fno.no'
agent <- 'Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/44.0.2403.18 Safari/537.36'

curl <- getCurlHandle()
curl <- curlSetOpt(cookiejar = 'ASP.NET_SessionId=2w11fuf0flglw03g4o0edgj3', useragent = agent, followlocation = T, curl = curl)
html <- postForm(url, .params = pars, curl = curl, .opts = list(ssl.verifypeer = FALSE))



# html <- postForm('https://nask.fno.no', .params = pars,.opts = list(ssl.verifypeer = FALSE), curl = curl)
# test <- getForm('https://nask.fno.no/WebResource.axd?d=WyPRicP9b2a-uSDhMAdKIx9YwUNokJllIvWDQeKsLtar3Vtb9OntiKDp6DMClJMN3yV8UJgafwzD60j9kYHkmt2zxlmu8syCDgHw02l869A1&t=635589471571259667',
                )



# j <- getURL(url, .opts = list(ssl.verifypeer = FALSE))
# ff <-grep('ct100_Innhold_lblResultat',html)
# 
# # library(httr)
# url  <- "http://www.investing.com/instruments/HistoricalDataAjax"
# # 
# test <- POST(url, 
#   body = pars,
#   set_cookies(ASP.NET_SessionId='zbfa3gixldfeyouurykag51a',
#               "_ga"='GA1.2.1636856434.1432836119')
# )
# head(test$request$opts)
# 
# 
# 
# urls <- c('https://nask.fno.no/WebResource.axd?d=WyPRicP9b2a-uSDhMAdKIx9YwUNokJllIvWDQeKsLtar3Vtb9OntiKDp6DMClJMN3yV8UJgafwzD60j9kYHkmt2zxlmu8syCDgHw02l869A1&t=635589471571259667',
# 'https://nask.fno.no/ScriptResource.axd?d=0qvBTa09kPqD4xILFUmkiyMqTWH83gSF2g4ZRpMEZi2b43ArEshOI_tb2CsabC4Br1_VMj1wPL_XUpF4uwP2ufERE8INK8dbgZhj8Pvb0N5mSQyfZ23q4NnMcesoIJnlc5cx87MlypN2bTnRMHvGEMaJIUJQCQYXZ832WZySCKE6Y_QnQqM1hgvaH-zgwb870&t=ffffffff805766b3',
# 'https://nask.fno.no/ScriptResource.axd?d=H0Lx0uSK0z1rDExlY1_EjydI7TPwcCCSh9xs7uUzMVOLZe6ezlrWQNLgEINILfcsrjR_BkierIkaZJWDpf_rx7QENzfGprD8eyY5BALsZi-Vb9meiQiDv1vGP0IAkIrenRcrZhs8hMCO905ALA7BBuu1C5ytYPx_-77R24u6srg6UQm08NQK7ITWC_VUyEhq0&t=ffffffff805766b3',
# 'https://nask.fno.no')
# 
# k <- getURIAsynchronous(urls, .opts = list(ssl.verifypeer = FALSE))
# 
# 
# 
# 
# 
# 
# 
# 
# 
# Other
# # query <- list('__EVENTTARGET'='',
#               '__EVENTARGUMENT'='',
#               '__LASTFOCUS'='',
#               '__VIEWSTATE' = viewstate,
#               '__VIEWSTATEGENERATOR'='CA0B0334',
#               '__SCROLLPOSITIONX'= '0',
#               '__SCROLLPOSITIONY'= '0',
#               '__EVENTVALIDATION' = evval,
#              'ctl00%24Innhold%24ddlRad' = '1',
#              'ctl00%24Innhold%24ddlKolonne' = '7',
#              'ctl00%24Innhold%24rblVerdi' = '1',
#              'ctl00%24Innhold%24rblBeregning' = '1',
#              'ctl00%24Innhold%24lbType' = '1',
#              'ctl00%24Innhold%24lb%C3%85r' = '2013',
#              'ctl00%24Innhold%24lbKvartal' = '3',
#              'ctl00%24Innhold%24lbM%C3%A5ned' = '7',
#              'ctl00%24Innhold%24lbDag' = '2',
#              'ctl00%24Innhold%24lbUkedag' = '3',
#              'ctl00%24Innhold%24lbFylke' = '2',
#              'ctl00%24Innhold%24btnKj%C3%B8r' = 'Lag+tabell'
#              )
# 
# html <- postForm(url, .params = query, curl = curl, .opts = list(ssl.verifypeer = FALSE))
# 
# j <- POST(url, body = query,
#           user_agent(agent), encode = 'form',
#           set_cookies(ASP.NET_SessionId = 'q2i1lqibp4j5ocfpzq3a1gwh'),
#           add_headers(Accept = 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
#                       'Accept-Encoding' = 'gzip, deflate',
#                       'Accept-Language' = 'en-US,en;q=0.8',
#                       'Cache-Control' = 'max-age=0',
#                       Connection = 'keep-alive',
#                       Origin = 'https://nask.fno.no',
#                       Referer = 'https://nask.fno.no/default.aspx'),
#           verbose())
