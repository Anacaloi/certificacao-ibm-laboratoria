## Importa as tabelas para o projeto
CREATE OR REPLACE TABLE `mockinterviewibm.dataset.1-0-stations`
AS
SELECT station_id, name, latitude, longitude
FROM `bigquery-public-data.new_york_citibike.citibike_stations`


## Limpeza dos dados: adiciona a coluna data e remove colunas desnecessárias e valores nulos
CREATE OR REPLACE TABLE `mockinterviewibm.dataset.2-0-trips`
AS
SELECT * except (customer_plan, end_station_latitude,end_station_longitude, end_station_name, start_station_latitude, start_station_longitude, start_station_name),
CAST (starttime AS DATE) AS tripdate,
extract(year FROM starttime) AS tripyear,
FROM `bigquery-public-data.new_york_citibike.citibike_trips`
WHERE  tripduration > 0
## Calcula idade
CREATE OR REPLACE TABLE `mockinterviewibm.dataset.2-1-trips`
AS
WITH `bigquery-public-data.new_york_citibike.citibike_trips` AS
(SELECT * except (customer_plan, end_station_latitude,end_station_longitude, end_station_name, start_station_latitude, start_station_longitude, start_station_name),
CAST (starttime AS DATE) AS tripdate,
extract(year FROM starttime) AS tripyear,
FROM `bigquery-public-data.new_york_citibike.citibike_trips`
WHERE  tripduration > 0)
SELECT *,
tripyear  - birth_year  AS age,
FROM `bigquery-public-data.new_york_citibike.citibike_trips`

## Tabela métricas históricas
CREATE OR REPLACE TABLE `mockinterviewibm.dataset.3-0-metricas_historicas`
AS
SELECT tripdate, gender, 
COUNT (starttime) AS count_trips,
CASE
  WHEN age BETWEEN 15 AND 25 THEN "1-Entre 15 e 25"
  WHEN age BETWEEN 25 AND 35 THEN "2-Entre 25 e 35"
  WHEN age BETWEEN 35 AND 45 THEN "3-Entre 35 e 45"
  WHEN age BETWEEN 45 AND 60 THEN "4-Entre 45 e 60"
  else "5-Mais de 60"
END AS agerange
FROM `mockinterviewibm.dataset.2-1-trips`
Where age BETWEEN 1 and 80
GROUP BY tripdate, gender, agerange 


## Calcula metricas de uso por dia 
CREATE or replace TABLE `mockinterviewibm.dataset.3-1-daily_stats`
as
SELECT tripyear,
COUNT (distinct bikeid) AS count_bikes,
COUNT (starttime)  AS count_trips,
(MAX (tripduration)) / 3600 AS max_trip_duration_hours,
(MIN (tripduration)) AS min_trip_duration_secs,
(AVG (tripduration)) / 60 AS avg_trip_duration_minutes,
STDDEV (tripduration) / 3600 AS desviotrip_duration_hours,
FROM `mockinterviewibm.dataset.2-1-trips`
WHERE age BETWEEN 15 and 80
GROUP BY  tripyear



## Calcula comportamento dos usuarios
CREATE or replace table `mockinterviewibm.dataset.4-0-comportamento_usuarios`
as
SELECT tripdate, usertype, tripyear,
COUNT (starttime) AS count_trips,
(SUM (tripduration)) / 3600 AS sum_trip_duration_hours,
(MAX (tripduration)) / 3600 AS max_trip_duration_hours,
(MIN (tripduration)) AS min_trip_duration_secs,
(AVG (tripduration)) / 60 AS avg_trip_duration_minutes
FROM `mockinterviewibm.dataset.2-1-trips`
where age between 15 and 80
GROUP BY tripdate, usertype, tripyear

CREATE or replace table `mockinterviewibm.dataset.4-1-duracao_datas`
as
SELECT tripdate, tripduration, 
FROM `mockinterviewibm.dataset.2-1-trips`
where age between 15 and 80

CREATE or replace TABLE `mockinterviewibm.dataset.5-0-top-5-rotas`
as
with concatrotas AS
(select
CONCAT(start_station_id, " - ", end_station_id) as rotas
from `mockinterviewibm.dataset.2-1-trips`)
select rotas,
COUNT(rotas) as totalrotas
from `concatrotas`
group by rotas
order by totalrotas desc
limit 5

CREATE or replace TABLE `mockinterviewibm.dataset.5-1-top-5-estacoes-partida`
as
select 
start_station_id,
COUNT(start_station_id) as totalpartidas
from `mockinterviewibm.dataset.2-1-trips`
group by start_station_id
order by totalpartidas desc
limit 5

CREATE or replace TABLE `mockinterviewibm.dataset.5-2-top-5-estacoes-chegada`
as
select 
end_station_id,
COUNT(end_station_id) as totalchegadas
from `mockinterviewibm.dataset.2-1-trips`
group by end_station_id
order by totalchegadas desc
limit 5




