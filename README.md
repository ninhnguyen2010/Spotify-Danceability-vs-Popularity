# Relationship Between Danceability and Number of Weeks on Chart

# Introduction 
What is the similarity between “The Next Episode” by Dr Dre and “Every Breath You Take” by The Police? Both songs have a danceability score of 0.8/1 and above. According to Spotify, danceability is defined as “how suitable a track is for dancing based on a combination of musical elements including tempo, rhythm stability, beat strength, and overall regularity.” With the rise of TikTok, the danceability of a song became more evident when it is featured in a myriad of short videos, often associated with trends or dance challenges. For example, HUMBLE. by Kendrick Lamar, has a danceability score of 0.9/1 and is featured 761,000 times on TikTok videos; with a peak rank of 1 on Spotify and stayed on the charts for 96 weeks. Parallely, we question whether the danceability of the song contributes to its popularity, which in turn impacts the length of time the song stays on the chart. Hence, we seek to answer the question, “Is there a relationship between danceability and the length of time a song spends on chart?”.
	
# Approach 
What makes a song successful on the charts is difficult to predict. Music is collective, and often listened to in a social context, so individual taste will not always align with the most popular songs of the moment. Additionally, there are many well documented outliers to songs that top the charts; one hit wonders often take the music industry by surprise. In this way, data can help. By assessing each song at a more granular level by musicality, we can assess if there is something specific to each song that enables its popularity. We predict danceability influences the length of time a song stays on the charts because a danceable song is often listened to in a social context: on TikTok, on the radio, in clubs and bars. However, there are many other outcomes that could come from the data. The best predictor for songs staying on the charts the longest could simply be if the song is from a popular artist that has previously had top charting songs. Another option is that social media sites, namely TikTok, are informing the charts themselves, and the songs that are staying on the charts the longest are the songs that TikTok made popular first. Additionally, seasonality could also play an important role in which songs are popular at each time of the year. A data driven approach will allow us to take many variables into account and assess which ones are actually driving song popularity.



# Ideal Experiment
We will use between-subjects (independent measures) design where songs are randomly assigned a level of danceability (none, low, or high), follow that level of danceability throughout the experiment, and observe how it will impact the weeks a song spends on chart. In reality, this experiment is difficult to conduct as a song often consists of multiple attributes which are intertwined.

# Data Exploration & Preparation
To inform our analysis, we have obtained two datasets from Kaggle, sourced from Spotify and one from Github, sourced from TikTok. The first dataset contains information about global top charted songs from 2022 with various attributes given to each song. The following dataset with information about Spotify artists and details such as numbers of streams, etc, which provides an overview to how popular each artist is; as popularity of an artist may potentially affect how long a song stays on the chart. Finally, to further explore how tiktok trends may affect popularity of a song, the last dataset includes information of songs which appeared on TikTok. 

Thus, we have merged the datasets by using artist names and song names as the identifiers. To prepare the data, we first created a dummy variable for TikTok. If there is a match of a track’s name between datasets, it will return 1 for a song that appears on TikTok; 0 otherwise. We removed extreme outliers (values above 95th percentile and 5th percentile) and transformed the data which are right-skewed by logging the variables. The final dataset has 447 rows in total and contains columns like artist name, number of streams, track name, log(number of weeks on chart), log(danceability), log(energy), appearance on TikTok, etc. Additionally, each row represents individual songs with unique attributes. However, songs from the same artist will share the same artist details. Finally, the outcome variable of interest for this analysis would be the log of number of weeks on the chart. 

# Descriptive Analytics
![Screen Shot 2022-12-06 at 1 41 52 AM](https://user-images.githubusercontent.com/114648243/205875784-929d9446-f856-40c7-911c-3f18705ebdf2.png)

Figure 1: Descriptive Statistics Table

There are extreme outliers in our dataset. The maximum value for Streams and Weeks On Chart is significantly far from the mean. They validated our decision of removing outliers and transforming the data to better prepare our model. Moreover, it is evident that it is impossible to have 0 danceability in a song as the minimum value is 0.398. This emphasizes the fact that our ideal experiment with random assignment of danceability is unrealistic. 

# Model Explanation

![Screen Shot 2022-12-06 at 1 43 35 AM](https://user-images.githubusercontent.com/114648243/205876150-f254c56c-c33f-4fb8-a5b1-a71683dd1e88.png)

Figure 2: Preliminary Model: log(weeks_on_chart) = b0 + b1log(danceability) + b2(tiktok) + b3(streams) + b4(loudness) + b5log(energy)

![Screen Shot 2022-12-06 at 1 43 56 AM](https://user-images.githubusercontent.com/114648243/205876234-d909cbde-0e36-40fb-89d0-70437d7ab90b.png)

Figure 3: Correlation Table

We included all variables in our preliminary model; however, after we ran a correlation, we found that Loudness and Energy were highly correlated at 0.713. Given this is significantly higher than the correlation between Log Weeks on Chart and Log Danceability (0.017), we removed Energy to avoid any issues with collinearity since it was the less significant variable. Once Energy was removed, Loudness became slightly more significant, and the R-squared value remained the same as 0.16, indicating the strength of the model had not changed.

![Screen Shot 2022-12-06 at 1 44 58 AM](https://user-images.githubusercontent.com/114648243/205876453-1405d7d7-27fb-4db1-8093-6bd423d3d26b.png)

Figure 4: Final Model: log(weeks_on_chart) = b0 + b1log(danceability) + b2(tiktok) + b3(streams) + b4(loudness) 

In the final model with Energy removed, our primary variable, Log Danceability, was not significant with a p-value of 0.56. Additionally, Log Danceability had only a  very minor effect on weeks on chart, with a 1% increase in Log Danceability corresponding with a 0.18% decrease in Log Weeks on Chart. This was an expected result given the two variables did not show a linear relationship during our exploratory data analysis. Although Log Danceability was not a significant variable, our three control variables all ended up being significant in terms of p-value, but also in their effect on Log Weeks on Chart. After taking the log transformation of the coefficients, the model showed if a song was on TikTok (value of 1), it corresponded to a 295% increase in Log Weeks on Chart. If there was a 1% increase in Streams it would correspond to a 1.47% increase in Log Weeks on Chart. And finally, if there was a 1% increase in Loudness there would be a 12.2% increase in Log Weeks on Chart.

# Conclusion & Limitations
Therefore, we fail to reject the null hypothesis that there is no relationship between danceability and number of weeks on chart at a significance level of 0.05 and p-value of 0.5650. Additionally, our control variables, TikTok, Streams and Loudness, are observed to be a more significant predictor of weeks of chart, compared to the main variable, danceability. We have assumed that danceable songs will lead to popularity on TikTok due to dance trends, however, the low R-squared value of 0.16 indicates that there are many impactful elements outside of our model. While there may be a potential relationship between interaction between TikTok and weeks spent on chart, other elements such as seasonality, movies and tv, radio play, artist news could also be a potential influence factor. Overall, although danceability is not a primary factor in music popularity, music popularity is tough to predict in general. As music is often enjoyed in a social context and subjected to individual taste, the joy of music can be vested in its unpredictability. 
