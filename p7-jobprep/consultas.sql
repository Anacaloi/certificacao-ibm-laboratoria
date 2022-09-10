## Importa as tabelas para o projeto
CREATE TABLE `mockinterviewibm.dataset.1-0-stations`
AS
FROM `bigquery-public-data.new_york_citibike.citibike_stations`


## Limpeza dos dados: adiciona a coluna data e remove colunas desnecessárias
CREATE or replace TABLE `mockinterviewibm.dataset.2-0-trips`
as
SELECT * except (customer_plan, end_station_latitude,end_station_longitude, end_station_name, start_station_latitude, start_station_longitude, start_station_name),
CAST (starttime AS DATE) AS date,
2022 - birth_year  AS age,
FROM `bigquery-public-data.new_york_citibike.citibike_trips`


## Calcula metricas de uso por dia 
CREATE or replace TABLE `mockinterviewibm.dataset.3-0-daily_stats`
as
SELECT date, usertype, gender, age,
COUNT (bikeid) AS count_bikes,
COUNT (starttime) AS count_trips,
(SUM (tripduration)) / 3600 AS sum_trip_duration_hours,
(MAX (tripduration)) / 3600 AS max_trip_duration_hours,
(MIN (tripduration)) AS min_trip_duration_secs,
(AVG (tripduration)) / 60 AS avg_trip_duration_minutes
FROM `mockinterviewibm.dataset.2-0-trips`
where age between 20 and 80
GROUP BY date, usertype, gender,age 



## Calcula comportamento dos usuarios
CREATE or replace table `mockinterviewibm.dataset.4-0-comportamento_usuarios`
as
SELECT date, usertype,
COUNT (starttime) AS count_trips,
(SUM (tripduration)) / 3600 AS sum_trip_duration_hours,
(MAX (tripduration)) / 3600 AS max_trip_duration_hours,
(MIN (tripduration)) AS min_trip_duration_secs,
(AVG (tripduration)) / 60 AS avg_trip_duration_minutes

FROM `mockinterviewibm.dataset.2-0-trips`
where age between 20 and 80
GROUP BY date, usertype

## Segmenta rotas por tipo de usuario
CREATE or replace TABLE `mockinterviewibm.dataset.5-0-rotas`
as
SELECT usertype, start_station_id, end_station_id,
COUNT (starttime) AS count_trips,
(SUM (tripduration)) / 3600 AS sum_trip_duration_hours,
(AVG (tripduration)) / 60 AS avg_trip_duration_minutes
FROM `mockinterviewibm.dataset.2-0-trips`
where age between 20 and 80
GROUP BY usertype, start_station_id, end_station_id
