/*
JOTSTAR & LIOCINEMA - SQL ANALYSIS
MySQL 8+
Source databases: LioCinema_db and Jotstar_db
*/

-- 1. TOTAL USERS BY PLATFORM
SELECT 'LioCinema' AS platform, COUNT(DISTINCT user_id) AS total_users
FROM LioCinema_db.subscribers
UNION ALL
SELECT 'Jotstar', COUNT(DISTINCT user_id)
FROM Jotstar_db.subscribers;


-- 2. TOTAL CONTENT ITEMS BY PLATFORM
SELECT 'LioCinema' AS platform, COUNT(DISTINCT content_id) AS total_content_items
FROM LioCinema_db.contents
UNION ALL
SELECT 'Jotstar', COUNT(DISTINCT content_id)
FROM Jotstar_db.contents;


-- 3. USERS BY SUBSCRIPTION PLAN
SELECT 'LioCinema' AS platform, subscription_plan,
       COUNT(DISTINCT user_id) AS total_users
FROM LioCinema_db.subscribers
GROUP BY subscription_plan
UNION ALL
SELECT 'Jotstar', subscription_plan,
       COUNT(DISTINCT user_id)
FROM Jotstar_db.subscribers
GROUP BY subscription_plan
ORDER BY platform, total_users DESC;


-- 4. PAID USERS BY PLATFORM
SELECT 'LioCinema' AS platform, COUNT(DISTINCT user_id) AS paid_users
FROM LioCinema_db.subscribers
WHERE subscription_plan IN ('Basic','Premium','VIP')
UNION ALL
SELECT 'Jotstar', COUNT(DISTINCT user_id)
FROM Jotstar_db.subscribers
WHERE subscription_plan IN ('Basic','Premium','VIP');


-- 5. USERS BY CITY TIER
SELECT 'LioCinema' AS platform, city_tier,
       COUNT(DISTINCT user_id) AS total_users
FROM LioCinema_db.subscribers
GROUP BY city_tier
UNION ALL
SELECT 'Jotstar', city_tier,
       COUNT(DISTINCT user_id)
FROM Jotstar_db.subscribers
GROUP BY city_tier
ORDER BY platform, city_tier;


-- 6. USERS BY AGE GROUP
SELECT 'LioCinema' AS platform, age_group,
       COUNT(DISTINCT user_id) AS total_users
FROM LioCinema_db.subscribers
GROUP BY age_group
UNION ALL
SELECT 'Jotstar', age_group,
       COUNT(DISTINCT user_id)
FROM Jotstar_db.subscribers
GROUP BY age_group
ORDER BY platform, age_group;


-- 7. ACTIVE VS INACTIVE USERS
-- Project definition: NULL last_active_date = Active
SELECT 'LioCinema' AS platform,
       CASE WHEN last_active_date IS NULL THEN 'Active'
            ELSE 'Inactive' END AS user_status,
       COUNT(DISTINCT user_id) AS users
FROM LioCinema_db.subscribers
GROUP BY user_status
UNION ALL
SELECT 'Jotstar',
       CASE WHEN last_active_date IS NULL THEN 'Active'
            ELSE 'Inactive' END AS user_status,
       COUNT(DISTINCT user_id)
FROM Jotstar_db.subscribers
GROUP BY user_status
ORDER BY platform, user_status;


-- 8. ACTIVE RATE BY SUBSCRIPTION PLAN
SELECT 'LioCinema' AS platform, subscription_plan,
       COUNT(DISTINCT CASE WHEN last_active_date IS NULL THEN user_id END) AS active_users,
       COUNT(DISTINCT user_id) AS total_users,
       ROUND(100.0 * COUNT(DISTINCT CASE WHEN last_active_date IS NULL THEN user_id END)
             / NULLIF(COUNT(DISTINCT user_id),0), 2) AS active_rate_pct
FROM LioCinema_db.subscribers
GROUP BY subscription_plan
UNION ALL
SELECT 'Jotstar', subscription_plan,
       COUNT(DISTINCT CASE WHEN last_active_date IS NULL THEN user_id END),
       COUNT(DISTINCT user_id),
       ROUND(100.0 * COUNT(DISTINCT CASE WHEN last_active_date IS NULL THEN user_id END)
             / NULLIF(COUNT(DISTINCT user_id),0), 2)
FROM Jotstar_db.subscribers
GROUP BY subscription_plan
ORDER BY platform, subscription_plan;


-- 9. CONTENT BY CONTENT TYPE
SELECT 'LioCinema' AS platform, content_type,
       COUNT(DISTINCT content_id) AS content_items
FROM LioCinema_db.contents
GROUP BY content_type
UNION ALL
SELECT 'Jotstar', content_type, COUNT(DISTINCT content_id)
FROM Jotstar_db.contents
GROUP BY content_type
ORDER BY platform, content_items DESC;


-- 10. CONTENT BY GENRE
SELECT 'LioCinema' AS platform, genre,
       COUNT(DISTINCT content_id) AS content_items
FROM LioCinema_db.contents
GROUP BY genre
UNION ALL
SELECT 'Jotstar', genre, COUNT(DISTINCT content_id)
FROM Jotstar_db.contents
GROUP BY genre
ORDER BY platform, content_items DESC;


-- 11. CONTENT BY LANGUAGE
SELECT 'LioCinema' AS platform, language,
       COUNT(DISTINCT content_id) AS content_items
FROM LioCinema_db.contents
GROUP BY language
UNION ALL
SELECT 'Jotstar', language, COUNT(DISTINCT content_id)
FROM Jotstar_db.contents
GROUP BY language
ORDER BY platform, content_items DESC;


-- 12. CONTENT RUNTIME BY CONTENT TYPE
SELECT 'LioCinema' AS platform, content_type,
       COUNT(DISTINCT content_id) AS content_items,
       ROUND(AVG(run_time),2) AS avg_runtime_mins,
       ROUND(SUM(run_time),2) AS total_runtime_mins
FROM LioCinema_db.contents
GROUP BY content_type
UNION ALL
SELECT 'Jotstar', content_type, COUNT(DISTINCT content_id),
       ROUND(AVG(run_time),2), ROUND(SUM(run_time),2)
FROM Jotstar_db.contents
GROUP BY content_type
ORDER BY platform, total_runtime_mins DESC;


-- 13. TOTAL WATCH TIME BY PLATFORM

SELECT 'LioCinema' AS platform,
       ROUND(SUM(`total_watch_time_mins`),2) AS total_watch_time_mins
FROM LioCinema_db.content_consumption
UNION ALL
SELECT 'Jotstar',
       ROUND(SUM(`total_watch_time_mins`),2)
FROM Jotstar_db.content_consumption;


-- 14. WATCH TIME BY DEVICE TYPE
SELECT 'LioCinema' AS platform, device_type,
       ROUND(SUM(`total_watch_time_mins`),2) AS watch_time_mins
FROM LioCinema_db.content_consumption
GROUP BY device_type
UNION ALL
SELECT 'Jotstar', device_type,
       ROUND(SUM(`total_watch_time_mins`),2)
FROM Jotstar_db.content_consumption
GROUP BY device_type
ORDER BY platform, watch_time_mins DESC;


-- 15. AVERAGE WATCH TIME PER USER
SELECT 'LioCinema' AS platform,
       ROUND(SUM(`total_watch_time_mins`) /
             NULLIF(COUNT(DISTINCT user_id),0),2) AS avg_watch_time_per_user_mins
FROM LioCinema_db.content_consumption
UNION ALL
SELECT 'Jotstar',
       ROUND(SUM(`total_watch_time_mins`) /
             NULLIF(COUNT(DISTINCT user_id),0),2)
FROM Jotstar_db.content_consumption;


-- 16. WATCH TIME BY AGE GROUP
SELECT 'LioCinema' AS platform, s.age_group,
       ROUND(SUM(c.`total_watch_time_mins`),2) AS watch_time_mins
FROM LioCinema_db.subscribers s
JOIN LioCinema_db.content_consumption c ON s.user_id = c.user_id
GROUP BY s.age_group
UNION ALL
SELECT 'Jotstar', s.age_group,
       ROUND(SUM(c.`total_watch_time_mins`),2)
FROM Jotstar_db.subscribers s
JOIN Jotstar_db.content_consumption c ON s.user_id = c.user_id
GROUP BY s.age_group
ORDER BY platform, watch_time_mins DESC;


-- 17. WATCH TIME BY SUBSCRIPTION PLAN
SELECT 'LioCinema' AS platform, s.subscription_plan,
       ROUND(SUM(c.`total_watch_time_mins`),2) AS watch_time_mins
FROM LioCinema_db.subscribers s
JOIN LioCinema_db.content_consumption c ON s.user_id = c.user_id
GROUP BY s.subscription_plan
UNION ALL
SELECT 'Jotstar', s.subscription_plan,
       ROUND(SUM(c.`total_watch_time_mins`),2)
FROM Jotstar_db.subscribers s
JOIN Jotstar_db.content_consumption c ON s.user_id = c.user_id
GROUP BY s.subscription_plan
ORDER BY platform, watch_time_mins DESC;


-- 18. UPGRADE / DOWNGRADE MOVEMENTS
SELECT 'LioCinema' AS platform,
       subscription_plan AS old_plan,
       new_subscription_plan AS new_plan,
       COUNT(DISTINCT user_id) AS users
FROM LioCinema_db.subscribers
WHERE new_subscription_plan IS NOT NULL
  AND subscription_plan <> new_subscription_plan
GROUP BY subscription_plan, new_subscription_plan
UNION ALL
SELECT 'Jotstar', subscription_plan, new_subscription_plan,
       COUNT(DISTINCT user_id)
FROM Jotstar_db.subscribers
WHERE new_subscription_plan IS NOT NULL
  AND subscription_plan <> new_subscription_plan
GROUP BY subscription_plan, new_subscription_plan
ORDER BY platform, users DESC;


-- 19. UPGRADED USERS
SELECT 'LioCinema' AS platform, COUNT(DISTINCT user_id) AS upgraded_users
FROM LioCinema_db.subscribers
WHERE (subscription_plan='Free' AND new_subscription_plan IN ('Basic','Premium','VIP'))
   OR (subscription_plan='Basic' AND new_subscription_plan IN ('Premium','VIP'))
   OR (subscription_plan='Premium' AND new_subscription_plan='VIP')
UNION ALL
SELECT 'Jotstar', COUNT(DISTINCT user_id)
FROM Jotstar_db.subscribers
WHERE (subscription_plan='Free' AND new_subscription_plan IN ('Basic','Premium','VIP'))
   OR (subscription_plan='Basic' AND new_subscription_plan IN ('Premium','VIP'))
   OR (subscription_plan='Premium' AND new_subscription_plan='VIP');


-- 20. DOWNGRADED USERS
SELECT 'LioCinema' AS platform, COUNT(DISTINCT user_id) AS downgraded_users
FROM LioCinema_db.subscribers
WHERE (subscription_plan='Basic' AND new_subscription_plan='Free')
   OR (subscription_plan='Premium' AND new_subscription_plan IN ('Basic','Free'))
   OR (subscription_plan='VIP' AND new_subscription_plan IN ('Premium','Basic','Free'))
UNION ALL
SELECT 'Jotstar', COUNT(DISTINCT user_id)
FROM Jotstar_db.subscribers
WHERE (subscription_plan='Basic' AND new_subscription_plan='Free')
   OR (subscription_plan='Premium' AND new_subscription_plan IN ('Basic','Free'))
   OR (subscription_plan='VIP' AND new_subscription_plan IN ('Premium','Basic','Free'));


-- 21. NET UPGRADE / DOWNGRADE RATE BY PLATFORM
WITH movement AS (
    SELECT 'LioCinema' AS platform,
           COUNT(DISTINCT CASE
             WHEN (subscription_plan='Free' AND new_subscription_plan IN ('Basic','Premium','VIP'))
               OR (subscription_plan='Basic' AND new_subscription_plan IN ('Premium','VIP'))
               OR (subscription_plan='Premium' AND new_subscription_plan='VIP')
             THEN user_id END) AS upgraded_users,
           COUNT(DISTINCT CASE
             WHEN (subscription_plan='Basic' AND new_subscription_plan='Free')
               OR (subscription_plan='Premium' AND new_subscription_plan IN ('Basic','Free'))
               OR (subscription_plan='VIP' AND new_subscription_plan IN ('Premium','Basic','Free'))
             THEN user_id END) AS downgraded_users,
           COUNT(DISTINCT user_id) AS total_users
    FROM LioCinema_db.subscribers
    UNION ALL
    SELECT 'Jotstar',
           COUNT(DISTINCT CASE
             WHEN (subscription_plan='Free' AND new_subscription_plan IN ('Basic','Premium','VIP'))
               OR (subscription_plan='Basic' AND new_subscription_plan IN ('Premium','VIP'))
               OR (subscription_plan='Premium' AND new_subscription_plan='VIP')
             THEN user_id END),
           COUNT(DISTINCT CASE
             WHEN (subscription_plan='Basic' AND new_subscription_plan='Free')
               OR (subscription_plan='Premium' AND new_subscription_plan IN ('Basic','Free'))
               OR (subscription_plan='VIP' AND new_subscription_plan IN ('Premium','Basic','Free'))
             THEN user_id END),
           COUNT(DISTINCT user_id)
    FROM Jotstar_db.subscribers
)
SELECT platform, upgraded_users, downgraded_users, total_users,
       ROUND(100.0*(upgraded_users-downgraded_users)/NULLIF(total_users,0),2)
       AS upgrade_downgrade_rate_pct
FROM movement;


-- 22. MONTHLY SUBSCRIBER ACQUISITION
SELECT 'LioCinema' AS platform,
       DATE_FORMAT(subscription_date,'%Y-%m') AS subscription_month,
       COUNT(DISTINCT user_id) AS new_users
FROM LioCinema_db.subscribers
GROUP BY DATE_FORMAT(subscription_date,'%Y-%m')
UNION ALL
SELECT 'Jotstar',
       DATE_FORMAT(subscription_date,'%Y-%m'),
       COUNT(DISTINCT user_id)
FROM Jotstar_db.subscribers
GROUP BY DATE_FORMAT(subscription_date,'%Y-%m')
ORDER BY subscription_month, platform;


-- 23. MONTHLY PLAN CHANGES
SELECT 'LioCinema' AS platform,
       DATE_FORMAT(plan_change_date,'%Y-%m') AS change_month,
       COUNT(DISTINCT user_id) AS users_with_plan_change
FROM LioCinema_db.subscribers
WHERE plan_change_date IS NOT NULL
GROUP BY DATE_FORMAT(plan_change_date,'%Y-%m')
UNION ALL
SELECT 'Jotstar',
       DATE_FORMAT(plan_change_date,'%Y-%m'),
       COUNT(DISTINCT user_id)
FROM Jotstar_db.subscribers
WHERE plan_change_date IS NOT NULL
GROUP BY DATE_FORMAT(plan_change_date,'%Y-%m')
ORDER BY change_month, platform;


-- 24. TOP 5 GENRES BY PLATFORM
WITH genre_rank AS (
    SELECT 'LioCinema' AS platform, genre,
           COUNT(DISTINCT content_id) AS content_items,
           DENSE_RANK() OVER (ORDER BY COUNT(DISTINCT content_id) DESC) AS rnk
    FROM LioCinema_db.contents
    GROUP BY genre
    UNION ALL
    SELECT 'Jotstar', genre,
           COUNT(DISTINCT content_id),
           DENSE_RANK() OVER (ORDER BY COUNT(DISTINCT content_id) DESC)
    FROM Jotstar_db.contents
    GROUP BY genre
)
SELECT platform, genre, content_items
FROM genre_rank
WHERE rnk <= 5
ORDER BY platform, content_items DESC;


-- 25. DEVICE SHARE OF WATCH TIME
SELECT platform, device_type, watch_time_mins,
       ROUND(100.0 * watch_time_mins /
             SUM(watch_time_mins) OVER (PARTITION BY platform),2)
       AS watch_time_share_pct
FROM (
    SELECT 'LioCinema' AS platform, device_type,
           SUM(`total_watch_time_mins`) AS watch_time_mins
    FROM LioCinema_db.content_consumption
    GROUP BY device_type
    UNION ALL
    SELECT 'Jotstar', device_type,
           SUM(`total_watch_time_mins`)
    FROM Jotstar_db.content_consumption
    GROUP BY device_type
) x
ORDER BY platform, watch_time_share_pct DESC;

