
-- Initial query to determine the most impressions by month --
WITH cte AS (
SELECT  strftime('%m',timestamp) AS month FROM SocialMediaEngagementDataset
  )
  SELECT month,count(month) AS posts FROM cte
  GROUP by month
  ORDER BY posts DESC;

--- This query determines the positive to negative ratio of user sentiment grouped by platform
SELECT platform, ROUND(
  COUNT(sentiment_label) FILTER(WHERE sentiment_label = 'Positive') * 1.0 / 
COUNT(sentiment_label) FILTER(WHERE sentiment_label = 'Negative'),2) AS positivity_rating FROM SocialMediaEngagementDataset
GROUP BY platform;


---
This query returns the number campaign_phase that had the most impressions grouped by platform. 
This infromation can be used for insights about the best phase for user_engagement
---
  
WITH cte AS (
SELECT  brand_name,campaign_phase,SUM(impressions) AS impression_count FROM SocialMediaEngagementDataset
GROUP by brand_name,campaign_phase
ORDER BY brand_name,impression_count DESC
),
cte2 AS (
SELECT brand_name,campaign_phase 
FROM cte
GROUP BY brand_name
HAVING impression_count = MAX(impression_count)
)
SELECT campaign_phase,COUNT(campaign_phase) FROM cte2
GROUP BY campaign_phase;

--- 
This code can be run substituting impressions for engagement rate to determine the best campaign phase / platform fro getting feedback from audiences
---

 
