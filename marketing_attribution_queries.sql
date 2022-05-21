--get familiar with the data

--how many campaigns are used?
  SELECT COUNT(DISTINCT utm_campaign) FROM page_visits;
--how many sources are used?
  SELECT COUNT(DISTINCT utm_source) FROM page_visits;
--which source is used for each campaign?
  SELECT DISTINCT utm_campaign,
    utm_source
  FROM page_visits;

--what pages are on the website?
  SELECT DISTINCT page_name
  FROM page_visits;

--how many first touches is each campaign responsible for?
  WITH first_touch AS (
    SELECT user_id,
        MIN(timestamp) AS 'first_touch_at'
    FROM page_visits
    GROUP BY user_id)
  SELECT ft.user_id,
    ft.first_touch_at,
    pv.utm_source,
    pv.utm_campaign,
    COUNT(utm_campaign)
  FROM first_touch AS 'ft'
  JOIN page_visits AS 'pv'
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp
  GROUP BY utm_campaign
  ORDER BY 5 DESC;

--how many last touches is each campaign responsible for?
  WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) AS 'last_touch_at'
    FROM page_visits
    GROUP BY user_id)
  SELECT lt.user_id,
    lt.last_touch_at,
    pv.utm_source,
    pv.utm_campaign,
    COUNT(utm_campaign)
  FROM last_touch AS 'lt'
  JOIN page_visits AS 'pv'
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
  GROUP BY utm_campaign
  ORDER BY 5 DESC;

--how many visitors make a purchase?
  SELECT COUNT(DISTINCT user_id)
  FROM page_visits
  WHERE page_name = '4 - purchase';

--how many last touches on the purchase page is each campaign responsible for?
  WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) AS 'last_touch_at'
    FROM page_visits
    WHERE page_name = '4 - purchase'
    GROUP BY user_id)
  SELECT lt.user_id,
    lt.last_touch_at,
    pv.utm_source,
    pv.utm_campaign,
    COUNT(utm_campaign)
  FROM last_touch AS 'lt'
  JOIN page_visits AS 'pv'
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
  GROUP BY utm_campaign
  ORDER BY 5 DESC;
