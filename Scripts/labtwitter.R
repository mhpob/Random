### Lab Twitter Project
### Setup info is found on https://github.com/geoffjentry/twitteR
devtools::install_github("geoffjentry/twitteR", username="geoffjentry")
library(twitteR)

## Load authentication
setup_twitter_oauth("MWotZCRiNUhTYr7zgtqAvA", "KNM5BtGUjriOjKEIJzdWlnQ7ECWtIS4PL4PoJRLXo68", "1286466858-EuhllEScXToOMlMsycAhCEKdDo4NSGFnwvCYowD", "gApus2FO3pV6mniZWBJy8WM6lhxlENfSPxuCK3Ii74Erh")

lab <- userTimeline('secorlab', n = 500, includeRts = T)
lab <- twListToDF(lab)
temp <- do.call(rbind, strsplit(lab$text,'http'))
lab$text <- temp[, 1]

library(wordcloud)

wordcloud(lab$text, colors = brewer.pal(9, "Blues"), random.order = F)