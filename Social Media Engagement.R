install.packages(c("ggplot2","DBI","RSQLite","lme4","lmerTest"))no
# ggplot2 for graph plots, DBI for database commms, RSQlite to allow coding in SQL and lme4 for
# linear mixed effects
library(ggplot2)
library(DBI)
library(RSQLite)
library(lme4)
library(lmerTest)
con <- dbConnect(RSQLite::SQLite(), dbname = 'sqlite.db')  # Replace with actual driver & creds
#dbDisconnect()



'''
This part of the code grabs data on impressions given campgain and campaign phase to assess 
whether differences in launch stage impressions / post are due to chance 
'''

brand_reception <- dbGetQuery(con,'SELECT campaign_name,campaign_phase,impressions,brand_name
FROM SocialMediaEngagementDataset;
')
brand_reception
plot <-ggplot(data = brand_reception,aes(campaign_phase,impressions)) + geom_point() + 
  aes(colour = brand_name) 
plot

model <- lm(impressions~campaign_phase, data = brand_reception)
model
anova(model)
'''
 I have realised that some of these belong to the same campaign - I can use this library to control 
 data that comes from the same campaign to improve statistical power and control for depencence
'''
model2 <- lmer(impressions ~ campaign_phase + (1 |campaign_name), data = brand_reception)
anova(model2)
anova(model)

# This code looks at campaign phase controlling for the brand 

model3 <-lmer(data = brand_reception, impressions ~ campaign_phase * brand_name + (1 | campaign_name) )

model3
summary(model3)
anova(model3)
isSingular(model3, tol = 1e-4)
model4 <- lm(data = brand_reception, impressions ~ campaign_phase * brand_name)
summary(model4)
anova(model4)
model5 <- lm(data = brand_reception, impressions ~ campaign_phase * brand_name * campaign_name)
summary(model5)
anova(model5)
'''
 p-value is 0.0682 there is marginal significance. Based on this there is a possible correlation between campaign phase and 
 impressions. Based on our plot this difference is most likely explained by different 
 campaign phases

Returns true - this means that there is a big risk that my model is too complex detracting from 
statistical power
I will deal with this by taking out terms based on p values(?) so that it is no longer singular - in doing this I got to 0.0682
'''

getwd()







