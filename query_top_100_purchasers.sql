/*  Create a PostgreSQL query that calculates the top 100 purchasers, 
    by the average purchased amount and the number of searches each one of them made,  
    in the last week.*/

\c events_db 

SELECT DISTINCT l.device_id, 
    (
        SELECT AVG(l2.event_value)
        FROM events_logs l2 JOIN events e2 ON l2.event_id = e2.event_id
        WHERE e2.event_name = 'purchase' AND l2.device_id = l.device_id
            AND l2.event_date >= NOW()::DATE-EXTRACT(DOW FROM NOW())::INTEGER-7
            AND l2.event_date <  NOW()::DATE-EXTRACT(DOW FROM NOW())::INTEGER
    ) AS avg_purchased_amount_in_last_week,
    (
        SELECT COUNT(*)
        FROM events_logs l3 JOIN events e3 ON l3.event_id = e3.event_id
        WHERE e3.event_name = 'search' AND l3.device_id = l.device_id
            AND l3.event_date >= NOW()::DATE-EXTRACT(DOW FROM NOW())::INTEGER-7
            AND l3.event_date <  NOW()::DATE-EXTRACT(DOW FROM NOW())::INTEGER
    ) AS number_of_searches_in_last_week
FROM events_logs l
ORDER BY 2 DESC NULLS LAST, 3 DESC NULLS LAST
LIMIT 100
