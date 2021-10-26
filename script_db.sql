/*  Create a PostgreSQL script that creates the events_logs and events tables
    and populates them with sample data. */

/* DB: "events_db" */

DROP DATABASE IF EXISTS events_db;

CREATE DATABASE events_db;
\c events_db 

/* Tables: "events_logs", "events" */

CREATE TABLE events(
    event_id int NOT NULL,
    event_name varchar(25) NOT NULL,
    event_description varchar(250) NULL,
    CONSTRAINT pk_events PRIMARY KEY (event_id));

CREATE TABLE events_logs(
    event_date timestamp NOT NULL default current_timestamp,
    device_id varchar(25) NOT NULL,
    event_id int NOT NULL,
    event_value decimal NULL,
    params jsonb,
    CONSTRAINT pk_events_logs PRIMARY KEY (event_date, device_id, event_id),
    CONSTRAINT fk_events_logs__event_id FOREIGN KEY (event_id) REFERENCES events (event_id));

CREATE INDEX events_1 ON events(event_id);
CREATE INDEX events_logs_1 ON events_logs(event_date);
CREATE INDEX events_logs_2 ON events_logs(device_id);
CREATE INDEX events_logs_3 ON events_logs(event_id);
CREATE INDEX events_logs_4 ON events_logs(event_id, event_value);
CREATE INDEX events_logs_5 ON events_logs(event_date, device_id, event_id);

/* Sample data population */

INSERT INTO events (event_id, event_name, event_description) VALUES (1, 'purchase', 'item purchased');
INSERT INTO events (event_id, event_name, event_description) VALUES (2, 'search', 'item searched');
INSERT INTO events (event_id, event_name, event_description) VALUES (3, 'app_open', 'application opened');

INSERT INTO events_logs (event_date, device_id, event_id, event_value, params) 
    VALUES (TIMESTAMP '2017-09-13 12:01:00', 'aed-355-dg25', 3, NULL, NULL);
INSERT INTO events_logs (event_date, device_id, event_id, event_value, params) 
    VALUES (TIMESTAMP '2017-09-13 12:05:00', 'aed-355-dg25', 2, NULL, '{"term": ["lamp", "blue"]}');
INSERT INTO events_logs (event_date, device_id, event_id, event_value, params) 
    VALUES (TIMESTAMP '2017-09-13 12:06:00', 'ryf-734-em0', 3, NULL, NULL);
INSERT INTO events_logs (event_date, device_id, event_id, event_value, params) 
    VALUES (TIMESTAMP '2017-09-13 12:08:00', 'ryf-734-em0', 2, NULL, '{"term": "rug"}');
INSERT INTO events_logs (event_date, device_id, event_id, event_value, params) 
    VALUES (TIMESTAMP '2017-09-13 12:09:00', 'ryf-734-em0', 2, NULL, '{"term": "table"}');
INSERT INTO events_logs (event_date, device_id, event_id, event_value, params) 
    VALUES (TIMESTAMP '2017-09-13 12:15:00', 'aed-355-dg25', 1, 2.01, '{"item_name": "TABLE"}');

DO $$
BEGIN
   FOR counter IN 1..10000 LOOP
    INSERT INTO events_logs (event_date, device_id, event_id, event_value, params) 
        VALUES (timestamp '2017-09-13 12:00:00' + random() * (timestamp '2017-09-13 14:00:00' - timestamp '2017-09-13 12:00:00'), 
                substring(md5(random()::text) from 1 for 12), floor(random() * 3 + 1)::int, TRUNC((random() * 10)::decimal, 2)::decimal, NULL);
    INSERT INTO events_logs (event_date, device_id, event_id, event_value, params) 
        VALUES (timestamp '2019-01-15 12:00:00' + random() * (timestamp '2019-01-31 12:00:00' - timestamp '2019-01-15 12:00:00'), 
                substring(md5(random()::text) from 1 for 12), floor(random() * 3 + 1)::int, TRUNC((random() * 50)::decimal, 2)::decimal, NULL);
   END LOOP;
END; $$