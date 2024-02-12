-- Select data we are going to use
SELECT 
*
FROM 
centering-sweep-399611.youtube_data.youtube_trending_videos;

-- Videos with the most and average views overall, regardless of publish date.
SELECT 
video_id, title, AVG(views) AS avg_views, MAX(views) AS peak_views
FROM 
centering-sweep-399611.youtube_data.youtube_trending_videos
GROUP BY video_id, title
ORDER BY peak_views DESC
LIMIT 10;

-- Find the total number of videos in each category
SELECT
category_id, COUNT(*) AS total_videos
FROM 
centering-sweep-399611.youtube_data.youtube_trending_videos
GROUP BY category_id;

-- List the videos with the highest number of views
SELECT
video_id,title, views
FROM 
centering-sweep-399611.youtube_data.youtube_trending_videos
ORDER BY views DESC
LIMIT 5;

-- Calculate the percentage of likes to total reactions for each video
SELECT
title, likes, dislikes, comment_count, 
  CASE 
    WHEN (likes + dislikes + comment_count) = 0 THEN NULL
    ELSE (likes / NULLIF((likes + dislikes + comment_count), 0)) * 100
  END AS like_percentage
FROM 
centering-sweep-399611.youtube_data.youtube_trending_videos
ORDER BY like_percentage DESC
LIMIT 10;

-- Identify videos with the highest comment count on weekends
SELECT
video_id, title, comment_count, published_day_of_week
FROM 
centering-sweep-399611.youtube_data.youtube_trending_videos
WHERE
published_day_of_week IN ('Saturday', 'Sunday')
ORDER BY comment_count DESC
LIMIT 5;

-- Create a view to show the total views, likes, and dislikes for each channel
CREATE VIEW youtube_data.channel_stats AS
SELECT 
channel_title, 
SUM(views) AS total_views, 
SUM(likes) AS total_likes, 
SUM(dislikes) AS total_dislikes
FROM 
centering-sweep-399611.youtube_data.youtube_trending_videos
GROUP BY channel_title;

-- Start a SQL script
DECLARE temp_table_data ARRAY<STRUCT<video_id STRING, title STRING, publish_date DATE, views INT64>>;

-- Create a temporary table with selected columns
CREATE TEMP TABLE temp_video_data AS
SELECT 
  video_id, 
  title, 
  CAST(publish_date AS DATE) AS publish_date, 
  views
FROM 
centering-sweep-399611.youtube_data.youtube_trending_videos`

-- Query the temporary table
SELECT 
* 
FROM 
temp_video_data;
-- End the script
