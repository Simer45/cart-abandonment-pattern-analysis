CREATE DATABASE cart_abandonment_db;
USE cart_abandonment_db;

CREATE TABLE funnel_events (
    timestamp_ms BIGINT,
    visitorid BIGINT,
    event VARCHAR(20),
    itemid BIGINT,
    transactionid BIGINT,
    event_time DATETIME
);

LOAD DATA LOCAL INFILE 'C:/Projects/Cart-Abandoment-Pattern-Analysis/exports/funnel_events_clean.csv'
INTO TABLE funnel_events
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(timestamp_ms, visitorid, event, itemid, @transactionid, event_time)
SET transactionid = NULLIF(@transactionid, '');

SELECT COUNT(*) FROM funnel_events;

SELECT * FROM funnel_events LIMIT 5;

SELECT
    visitor_status,
    COUNT(*) AS num_visitors
FROM (
    SELECT
        visitorid,
        CASE
            WHEN MAX(CASE WHEN event='addtocart' THEN 1 ELSE 0 END)=1
                 AND MAX(CASE WHEN event='transaction' THEN 1 ELSE 0 END)=1 THEN 'Added to Cart + Purchased'
            WHEN MAX(CASE WHEN event='addtocart' THEN 1 ELSE 0 END)=1
                 AND MAX(CASE WHEN event='transaction' THEN 1 ELSE 0 END)=0 THEN 'Added to Cart Only (Abandoned)'
            WHEN MAX(CASE WHEN event='addtocart' THEN 1 ELSE 0 END)=0
                 AND MAX(CASE WHEN event='transaction' THEN 1 ELSE 0 END)=1 THEN 'Purchased, no Cart event'
        END AS visitor_status
    FROM funnel_events
    GROUP BY visitorid
) AS visitor_summary
GROUP BY visitor_status;

SELECT
    HOUR(f.event_time) AS hour_of_day,
    COUNT(*) AS addtocart_events,
    SUM(CASE WHEN v.has_purchase = 0 THEN 1 ELSE 0 END) AS abandoned_events,
    ROUND(SUM(CASE WHEN v.has_purchase = 0 THEN 1 ELSE 0 END) / COUNT(*) * 100, 1) AS abandonment_rate_pct
FROM funnel_events f
JOIN (
    SELECT visitorid, MAX(CASE WHEN event='transaction' THEN 1 ELSE 0 END) AS has_purchase
    FROM funnel_events
    GROUP BY visitorid
) v ON f.visitorid = v.visitorid
WHERE f.event = 'addtocart'
GROUP BY HOUR(f.event_time)
ORDER BY hour_of_day;


CREATE TABLE visitor_summary AS
SELECT
    visitorid,
    MAX(CASE WHEN event='addtocart' THEN 1 ELSE 0 END) AS has_cart,
    MAX(CASE WHEN event='transaction' THEN 1 ELSE 0 END) AS has_purchase,
    CASE
        WHEN MAX(CASE WHEN event='addtocart' THEN 1 ELSE 0 END)=1
             AND MAX(CASE WHEN event='transaction' THEN 1 ELSE 0 END)=1 THEN 'Added to Cart + Purchased'
        WHEN MAX(CASE WHEN event='addtocart' THEN 1 ELSE 0 END)=1
             AND MAX(CASE WHEN event='transaction' THEN 1 ELSE 0 END)=0 THEN 'Added to Cart Only (Abandoned)'
        WHEN MAX(CASE WHEN event='addtocart' THEN 1 ELSE 0 END)=0
             AND MAX(CASE WHEN event='transaction' THEN 1 ELSE 0 END)=1 THEN 'Purchased, no Cart event'
    END AS visitor_status
FROM funnel_events
GROUP BY visitorid;

SELECT COUNT(*) FROM visitor_summary;