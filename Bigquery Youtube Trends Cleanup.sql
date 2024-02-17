-- Handling Missing Values
SELECT video_id, trending_date, title, channel_title, category_id, publish_date, time_frame, published_day_of_week, publish_country, tags,
       IFNULL(views, 0) AS views,
       IFNULL(likes, 0) AS likes,
       IFNULL(dislikes, 0) AS dislikes,
       IFNULL(comment_count, 0) AS comment_count
FROM centering-sweep-399611.youtube_data.youtube_trending_videos;

-- Remove duplicates from video_id column
SELECT DISTINCT video_id
FROM centering-sweep-399611.youtube_data.youtube_trending_videos;

-- Check the length of titles
SELECT
  title,
  LENGTH(title) AS title_length
FROM centering-sweep-399611.youtube_data.youtube_trending_videos;

-- Extract the first 10 characters of titles
SELECT
  title,
  SUBSTR(title, 1, 10) AS short_title
FROM centering-sweep-399611.youtube_data.youtube_trending_videos;

-- Trim leading and trailing whitespace from channel titles
SELECT
  channel_title,
  TRIM(channel_title) AS trimmed_channel_title
FROM centering-sweep-399611.youtube_data.youtube_trending_videos;

-- Convert category_id to integer
SELECT
  category_id,
  CAST(category_id AS INT64) AS category_id_int
FROM centering-sweep-399611.youtube_data.youtube_trending_videos;

-- Concatenate title and channel_title
SELECT
  title,
  channel_title,
  CONCAT(title, ' - ', channel_title) AS concatenated_title
FROM centering-sweep-399611.youtube_data.youtube_trending_videos;


