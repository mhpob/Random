# I'm going to use "tidyverse" packages because they tend to have straightforward
# language, are well-documented, and are widely-used.
# googledrive documentation is here: http://googledrive.tidyverse.org/
# readxl documentation is here: http://readxl.tidyverse.org/

# Install and load googledrive package ----

install.packages('googledrive')
library(googledrive)

# Authorize googledrive to access and edit your Google Drive ----
# This will open a browser that will have you log into your account and grant
# "tidyverse api packages" access. When you grant access, it will create a file
# called ".httr-oath" in your working directory. You won't have to go through
# this step again as long as this file remains in your working directory.

drive_auth()

# If you know the name of the file, use drive_download() to download it to your
# working directory. If it's in a subfolder, you can specify it in the optional
# "path" argument.
# Note that this uses regex, so it's case sensitive unless you tell it otherwise.

drive_download(file = 'Toms Faculty Data.xlsx', path = 'Data folder/')

# Install and load readxl package ----

install.packages('readxl')
library(readxl)

# Import Excel document ----
# If you have data in different sheets, you should specify the sheet explicitly.

toms.data <- read_excel(path = 'Toms Faculty Data.xlsx', sheet = 'finances')

# Plotting ----
# Create and save the plot.

jpeg(filename = 'money_over_time.jpg')
plot(data = toms.data, money ~ time)
dev.off()

# Upload to Google Drive. "media" refers to the location/name on your computer.
# If you want to save it in a subfolder, you can specify an optional "path"
# argument. Note that this is case-sensitive.

drive_upload(media = 'money_over_time.jpg', path = 'Figures/')
