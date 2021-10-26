/*  Create a PostgreSQL query that calculates the average time delta between
    an app_open event and a purchase event where there is no more than 30 minutes
    difference between the app_open and all the events that were generated until the purchase. */

\c events_db 

WITH time_delta AS (
    SELECT l2.event_date - 
    (
        SELECT l3.event_date
        FROM events_logs l3 JOIN events e3 ON l3.event_id = e3.event_id
        WHERE e3.event_name = 'app_open' 
            AND l3.device_id = l2.device_id 
            AND EXTRACT(EPOCH FROM (l2.event_date - l3.event_date)) / 60 <= 30 
    ) AS time_delta_column
    FROM events_logs l2 JOIN events e2 ON l2.event_id = e2.event_id
    WHERE e2.event_name = 'purchase' 
)

SELECT AVG(time_delta_column) AS avg_time_delta
FROM time_delta
