library(RCurl)
curl  <-  getCurlHandle()
curlSetOpt(cookiejar = 'ASP.NET_SessionId=vva12xn4z4fvbol0wnszfiqb',
           followlocation = TRUE, autoreferer = TRUE, curl = curl)
html <- getURLContent('http://sdat.dat.maryland.gov/RealProperty/Pages/default.aspx')
viewstate <- as.character(sub('.*id="__VIEWSTATE" value="([0-9a-zA-Z+/=]*).*',
                              '\\1', html))
evval <- as.character(sub('.*id="__EVENTVALIDATION" value="([0-9a-zA-Z+/=]*).*',
                          '\\1', html))

pars <- list('ctl00%24ctl00%24ctl00%24ToolkitScriptManager1'='ctl00%24ctl00%24ctl00%24MainContent%24MainContent%24cphMainContentArea%24ucSearchType%24updatePanel1%7Cctl00%24ctl00%24ctl00%24MainContent%24MainContent%24cphMainContentArea%24ucSearchType%24wzrdRealPropertySearch%24StepNavigationTemplateContainerID%24btnStepNextButton&ctl00%24ctl00%24ctl00%24MainContent%24MainContent%24cphMainContentArea%24ucSearchType%24hideBanner=false&ctl00%24ctl00%24ctl00%24MainContent%24MainContent%24cphMainContentArea%24ucSearchType%24wzrdRealPropertySearch%24ucEnterData%24ddTransferMonth1=01&ctl00%24ctl00%24ctl00%24MainContent%24MainContent%24cphMainContentArea%24ucSearchType%24wzrdRealPropertySearch%24ucEnterData%24ddTransferDay1=01&ctl00%24ctl00%24ctl00%24MainContent%24MainContent%24cphMainContentArea%24ucSearchType%24wzrdRealPropertySearch%24ucEnterData%24txtTransferYear1=2016&ctl00%24ctl00%24ctl00%24MainContent%24MainContent%24cphMainContentArea%24ucSearchType%24wzrdRealPropertySearch%24ucEnterData%24ddTransferMonth2=04&ctl00%24ctl00%24ctl00%24MainContent%24MainContent%24cphMainContentArea%24ucSearchType%24wzrdRealPropertySearch%24ucEnterData%24ddTransferDay2=11&ctl00%24ctl00%24ctl00%24MainContent%24MainContent%24cphMainContentArea%24ucSearchType%24wzrdRealPropertySearch%24ucEnterData%24txtTransferYear2=2016&ctl00%24ctl00%24ctl00%24MainContent%24MainContent%24cphMainContentArea%24ucSearchType%24wzrdRealPropertySearch%24ucEnterData%24rdblLandUse=Residential&ctl00%24ctl00%24ctl00%24MainContent%24MainContent%24cphMainContentArea%24ucSearchType%24wzrdRealPropertySearch%24ucEnterData%24chkInclude%240=Improved&ctl00%24ctl00%24ctl00%24MainContent%24MainContent%24cphMainContentArea%24ucSearchType%24wzrdRealPropertySearch%24ucEnterData%24txtSaleDistric=&ctl00%24ctl00%24ctl00%24MainContent%24MainContent%24cphMainContentArea%24ucSearchType%24wzrdRealPropertySearch%24ucEnterData%24txtSaleMap=&ctl00%24ctl00%24ctl00%24MainContent%24MainContent%24cphMainContentArea%24ucSearchType%24wzrdRealPropertySearch%24ucEnterData%24txtSaleSubDiv=&ctl00%24ctl00%24ctl00%24MainContent%24MainContent%24cphMainContentArea%24ucSearchType%24wzrdRealPropertySearch%24ucEnterData%24txtBPRUC=&ctl00%24ctl00%24ctl00%24MainContent%24MainContent%24cphMainContentArea%24ucSearchType%24wzrdRealPropertySearch%24ucEnterData%24txtSaleStNum=&ctl00%24ctl00%24ctl00%24MainContent%24MainContent%24cphMainContentArea%24ucSearchType%24wzrdRealPropertySearch%24ucEnterData%24txtSaleStName=&ctl00%24ctl00%24ctl00%24MainContent%24MainContent%24cphMainContentArea%24ucSearchType%24wzrdRealPropertySearch%24ucEnterData%24chkConveyance%240=Arms-Length%20Improved&ctl00%24ctl00%24ctl00%24MainContent%24MainContent%24cphMainContentArea%24ucSearchType%24wzrdRealPropertySearch%24ucEnterData%24chkConveyance%243=Non-Arms%20Length%20Other',
             '__EVENTTARGET'='',
             '__EVENTARGUMENT' = '',
             '__LASTFOCUS' = '',
             '__VIEWSTATE' = viewstate,
             '__EVENTVALIDATION' = evval,
             '__VIEWSTATEGENERATOR'='67B65B95',
             '__ASYNCPOST' = 'true')

url <- 'http://sdat.dat.maryland.gov/RealProperty/Pages/default.aspx'
agent <- 'Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.66 Safari/537.36'

curl <- getCurlHandle()
curl <- curlSetOpt(cookiejar = 'ASP.NET_SessionId=vva12xn4z4fvbol0wnszfiqb', useragent = agent, followlocation = T, curl = curl)
html <- postForm(url, .params = pars, curl = curl)
