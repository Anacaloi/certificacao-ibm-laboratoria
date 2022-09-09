## Importa tabelas para o projeto
CREATE TABLE `mockinterviewibm.dataset.1-0-stations`
AS
SELECT *,
FROM `bigquery-public-data.new_york_citibike.citibike_stations`

CREATE TABLE `mockinterviewibm.dataset.2-0-trips`
AS
SELECT *,
FROM `bigquery-public-data.new_york_citibike.citibike_trips`

