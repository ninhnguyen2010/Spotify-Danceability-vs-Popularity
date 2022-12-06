install.packages("dplyr")
library(dplyr)
install.packages("forecast")
library(forecast)
install.packages("ggplot2")
library("ggplot2")
options(scipen = 200)

# reading the csv file
spotifydf <- read.csv("Final_Spotify.csv", sep=",", header=T)
# dropping the first duplicated order column
spotifydf <- select(spotifydf, -X)

# change the unit of number of streams to billion
spotifydf$streams <- spotifydf$streams/1000000000

## Y Variable: Number of Weeks on Chart
# the distribution of weeks_on_chart is right-skewed
hist(spotifydf$weeks_on_chart, main = "Histogram for Weeks on Chart",
     xlab = "Weeks", col = "darkgreen")

# there are outliers for weeks_on_chart  variable
boxplot(spotifydf$weeks_on_chart, main = "weeks_on_chart",
        xlab = "Weeks", col = "darkgreen")

# drop the extreme values --> more than 95th percentile
val_95 = quantile(spotifydf$weeks_on_chart, probs = 0.95, na.rm = TRUE)
# there are 25 outliers
outlier_ID <- which(spotifydf$weeks_on_chart > val_95)
# from 496 rows to 471 rows
spotifydf <- spotifydf[-outlier_ID, ] 

boxplot(spotifydf$weeks_on_chart, main = "weeks_on_chart",
        xlab = "Weeks", col = "darkgreen")
# substantial right skewed
hist(spotifydf$weeks_on_chart, col = "darkgreen")

#Creating a new column with transformed weeks_on_charts in the dataframe
spotifydf$LOG.weeks_on_chart <- log(spotifydf$weeks_on_chart)
# Histogram of Log number of weeks on chart
hist(spotifydf$LOG.weeks_on_chart, freq = FALSE, main = "Density curve",
     xlab = "Log of Number of Weeks on Chart", col = "darkgreen")
lines(density(spotifydf$LOG.weeks_on_chart), lwd = 2, col = 'red')

plot(spotifydf$LOG.weeks_on_chart, col = "darkgreen")

## X Variable: Danceability
# the distribution of danceability is pretty normal
hist(spotifydf$danceability, main = "Histogram for Danceability",
     xlab = "Danceability", col = "darkgreen")

# there are outliers for danceability variable
boxplot(spotifydf$danceability, main = "Boxplot for Danceability",
        xlab = "Danceability", col = "darkgreen")
# drop the extreme values --> less than 5th percentile
val_5 = quantile(spotifydf$danceability, probs = 0.05, na.rm = TRUE)
# there are 24 outliers
outlier_ID_2 <- which(spotifydf$danceability < val_5)
# from 471 rows to 447 rows
spotifydf <- spotifydf[-outlier_ID_2, ] 

## Y Variable: Tiktok?
hist(spotifydf$tiktok, main = "Histogram for Tiktok", col = "darkgreen")
plot(spotifydf$tiktok, main = "TikTok",col = "darkgreen")

## Y Variable: streams
hist(spotifydf$streams)
# no outliers for number of streams for each artists
boxplot(spotifydf$streams)

## Summary Statistics
summary(spotifydf) 
##Distribution for main variables
plot(spotifydf$LOG.weeks_on_chart)
hist(spotifydf$LOG.weeks_on_chart)
plot(spotifydf$danceability)
hist(spotifydf$danceability)
plot(spotifydf$tiktok)
hist(spotifydf$tiktok)
plot(spotifydf$streams)
hist(spotifydf$streams)

cor(spotifydf[,c("LOG.weeks_on_chart", "danceability", "tiktok", "streams",
                 "loudness")])

## Linear Model 
index_vec <- 1:nrow(spotifydf)
# randomized the songs into two datasets of train and valid
ntrain <- round(0.5 * nrow(spotifydf),0)
set.seed(500)
train_index <- sample(index_vec, size = ntrain, replace = F)
train_set <- spotifydf[train_index, ]
valid_set <- spotifydf[-train_index, ]          
dim(train_set)   #224 rows
dim(valid_set)  # 223 rows

## This is what I like
model1 <- lm(LOG.weeks_on_chart ~ danceability + tiktok + streams + loudness, 
             data = spotifydf)
summary(model1)

# Checking the overfitting
VALUE_hat0_valid <- predict(model1, valid_set)
accuracy(VALUE_hat0_valid, valid_set$LOG.weeks_on_chart)  
VALUE_hat1_valid <- predict(model1, train_set)
accuracy(VALUE_hat1_valid, train_set$LOG.weeks_on_chart)  

