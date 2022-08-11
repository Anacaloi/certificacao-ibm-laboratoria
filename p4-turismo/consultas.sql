## Concatena a data de chegada
CREATE OR REPLACE TABLE `projeto-4-ana-caloi.hotel_bookings.02_arrival_date`
AS
SELECT *,
CONCAT(arrival_date_year,'-', arrival_date_month, '-', arrival_date_day_of_month) AS arrival_date
FROM `projeto-4-ana-caloi.hotel_bookings.dataset`
## Segmenta as estações do ano
CREATE OR REPLACE TABLE `projeto-4-ana-caloi.hotel_bookings.03_seasons`
AS
SELECT *,
    CASE
        WHEN arrival_date_month = 'January' THEN 'Verão'
        WHEN arrival_date_month = 'February' THEN 'Verão'
        WHEN arrival_date_month = 'March' THEN 'Verão'
        WHEN arrival_date_month = 'April' THEN 'Outono'
        WHEN arrival_date_month = 'May' THEN 'Outono'
        WHEN arrival_date_month = 'June' THEN 'Outono'
        WHEN arrival_date_month = 'July' THEN 'Inverno'
        WHEN arrival_date_month = 'August' THEN 'Inverno'
        WHEN arrival_date_month = 'September' THEN 'Inverno'
        WHEN arrival_date_month = 'October' THEN 'Primavera'
        WHEN arrival_date_month = 'November' THEN 'Primavera'
        WHEN arrival_date_month = 'December' THEN 'Primavera'
    END AS arrival_season
  FROM `projeto-4-ana-caloi.hotel_bookings.02_arrival_date`
CREATE OR REPLACE TABLE `projeto-4-ana-caloi.hotel_bookings.04_segmento_leadtime`
AS
SELECT *,
CASE
  WHEN lead_time BETWEEN 0 AND 29 THEN "Curto"
  WHEN lead_time BETWEEN 29 AND 90 THEN "Médio"
  WHEN lead_time > 90 THEN "Longo"
  END AS lead_time_segment
 FROM `projeto-4-ana-caloi.hotel_bookings.03_seasons`


 ## Transforma a variável arrival_date para o formato DATE YYYY-MM-DD
CREATE OR REPLACE TABLE `projeto-4-ana-caloi.hotel_bookings.05-1_arrival_month_number`
AS
 SELECT *,
 CASE
  WHEN arrival_date_month IN ('January') THEN "01"
  WHEN arrival_date_month IN ('February') THEN "02"
  WHEN arrival_date_month IN ('March') THEN "03"
  WHEN arrival_date_month IN ('April') THEN "04"
  WHEN arrival_date_month IN ('May') THEN "05"
  WHEN arrival_date_month IN ('June') THEN "06"
  WHEN arrival_date_month IN ('July') THEN "07"
  WHEN arrival_date_month IN ('August') THEN "08"
  WHEN arrival_date_month IN ('September') THEN "09"
  WHEN arrival_date_month IN ('October') THEN "10"
  WHEN arrival_date_month IN ('November') THEN "11"
  WHEN arrival_date_month IN ('December') THEN "12"
  END AS arrival_month_number
 FROM `projeto-4-ana-caloi.hotel_bookings.04_segmento_leadtime` 

CREATE OR REPLACE TABLE `projeto-4-ana-caloi.hotel_bookings.05-2_arrival_month_number`
AS
 SELECT *, CONCAT(arrival_date_year,'-', arrival_month_number, '-', arrival_date_day_of_month) AS arrival_date_2
  FROM `projeto-4-ana-caloi.hotel_bookings.05-1_arrival_month_number` 

CREATE OR REPLACE TABLE `projeto-4-ana-caloi.hotel_bookings.05-3_arrival_date_v2`
AS
SELECT *,
 CAST (arrival_date_2 AS DATE) AS arrival_date_v2 
 FROM `projeto-4-ana-caloi.hotel_bookings.05-2_arrival_month_number`


 ## Cria coluna booking_date
CREATE OR REPLACE TABLE `projeto-4-ana-caloi.hotel_bookings.06_booking_date`
AS
SELECT *,
date_sub(arrival_date_v2, INTERVAL lead_time day) AS booking_date
 FROM `projeto-4-ana-caloi.hotel_bookings.05-3_arrival_date_v2` 
 

 ## Calcula o Adr médio por tipo de hotel
CREATE OR REPLACE TABLE `projeto-4-ana-caloi.hotel_bookings.07_pag_medio_por_noite_by_hotel`
AS
SELECT hotel, AVG(adr) AS pag_medio_por_noite
FROM `projeto-4-ana-caloi.hotel_bookings.06_booking_date`
GROUP BY hotel


 ## Calcula o número de reservas por segmento de lead time 
CREATE OR REPLACE TABLE `projeto-4-ana-caloi.hotel_bookings.08_reservations_by_leadtime`
AS
SELECT lead_time_segment,
  COUNT (arrival_date_v2) AS reservations_leadtime_segment
  FROM `projeto-4-ana-caloi.hotel_bookings.06_booking_date`
 GROUP BY lead_time_segment

 ## Calcula o número de reservas por tipo de hotel 
CREATE OR REPLACE TABLE `projeto-4-ana-caloi.hotel_bookings.09_reservations_by_hotel_2015_2016`
AS
SELECT hotel,
  COUNT (arrival_date_v2) AS bookings_per_hotel_2015_2016
  FROM `projeto-4-ana-caloi.hotel_bookings.06_booking_date` WHERE arrival_date_year BETWEEN 2015 AND 2016
 GROUP BY hotel

 ## Calcula o número de reservas que existe para cada ano e para cada tipo de hotel
CREATE OR REPLACE TABLE `projeto-4-ana-caloi.hotel_bookings.10_reservations_by_hotel_year`
AS
 SELECT hotel, arrival_date_year,
  COUNT (arrival_date_v2) AS bookings_per_hotel_year
  FROM `projeto-4-ana-caloi.hotel_bookings.6_booking_date` 
 GROUP BY hotel, arrival_date_year

 ## Calcula o número de reservas que existe para cada ano-mês e para cada tipo de hotel
CREATE OR REPLACE TABLE `projeto-4-ana-caloi.hotel_bookings.11-1_year_month`
AS
SELECT *, CONCAT(arrival_date_year,'-', arrival_month_number) AS arrival_date_year_month
  FROM `projeto-4-ana-caloi.hotel_bookings.06_booking_date` 

CREATE OR REPLACE TABLE `projeto-4-ana-caloi.hotel_bookings.11-2_reservations_by_hotel_year_month`
AS
 SELECT hotel, arrival_date_year_month,
  COUNT (arrival_date) AS bookings_per_hotel_year_month
  FROM `projeto-4-ana-caloi.hotel_bookings.11-1_year_month`
 GROUP BY hotel, arrival_date_year_month


## Calcula o número de reservas que existe para cada ano-mês e para cada tipo de hotel em que foram feitas mais de 3.500 reservas
CREATE OR REPLACE TABLE `projeto-4-ana-caloi.hotel_bookings.12_over_3500_reservations_by_hotel_year_month`
AS
 SELECT hotel, arrival_date_year_month,
  COUNT (arrival_date) AS bookings_per_hotel_year_month
  FROM `projeto-4-ana-caloi.hotel_bookings.11-1_year_month`
 GROUP BY hotel, arrival_date_year_month HAVING bookings_per_hotel_year_month > 3500


## Agrupa o número de reservas feitas por tipo de hotel e por data e compara com os cancelamentos
CREATE OR REPLACE TABLE `projeto-4-ana-caloi.hotel_bookings.13_reservations_cancelations_by_hotel_arrival_date`
AS
 SELECT hotel, arrival_date_v2,
  COUNT (arrival_date) AS bookings_per_hotel_date,
  SUM(is_canceled) AS num_canceled
  FROM `projeto-4-ana-caloi.hotel_bookings.5-3_arrival_date_v2` 
 GROUP BY arrival_date_v2, hotel
 ORDER BY hotel, arrival_date_v2


## Calcula o impacto de um cancelamento devido ao pagamento de comissão de MKT
CREATE OR REPLACE TABLE `projeto-4-ana-caloi.hotel_bookings.14-1_mkt_payment_by_booking_date`
AS
SELECT booking_date,
SUM(is_canceled) AS canceled_bookings,
COUNT(*) - SUM(is_canceled)  AS not_canceled_bookings,
SUM(is_canceled)*1.5 AS canceled_bookings_payment,
(COUNT(*) - SUM(is_canceled))*1.5  AS not_canceled_bookings_payment,
FROM `projeto-4-ana-caloi.hotel_bookings.6_booking_date` 
GROUP BY booking_date
ORDER BY booking_date


## Calcula o impacto de um cancelamento feito com menos de 3 dias de antecedência
CREATE OR REPLACE TABLE `projeto-4-ana-caloi.hotel_bookings.14-2_canceled_bookings_days_diff`
AS
SELECT *,
DATE_DIFF(arrival_date_v2, reservation_status_date, DAY) AS days_between_cancelation_and_arrival
FROM `projeto-4-ana-caloi.hotel_bookings.6_booking_date` WHERE is_canceled=1


CREATE OR REPLACE TABLE `projeto-4-ana-caloi.hotel_bookings.14-3_canceled_bookings_3days_by_booking_date`
AS
SELECT
  booking_date,
  COUNT(days_between_cancelation_and_arrival) AS number_cancellations_less_3_days,
  COUNT(days_between_cancelation_and_arrival) * 120 AS financial_impact
FROM
  `projeto-4-ana-caloi.hotel_bookings.14-2_canceled_bookings_days_diff`
WHERE
  days_between_cancelation_and_arrival < 3
GROUP BY
  booking_date

## Adiciona colunas que calculam o impacto dos cancelamentos à tabela principal
CREATE OR REPLACE TABLE `projeto-4-ana-caloi.hotel_bookings.21-1_canceled_bookings_MKT_pay`
AS
SELECT *,
CASE
WHEN is_canceled = 1 THEN 1.5
ELSE 0
    END AS canceled_bookings_MKT_pay
FROM `projeto-4-ana-caloi.hotel_bookings.19-1_adr_category` 

## Cancelamento < 3dias
CREATE OR REPLACE TABLE `projeto-4-ana-caloi.hotel_bookings.21-2_days_between_cancelation_and_arrival`
AS
SELECT *,
CASE
WHEN is_canceled = 1 THEN DATE_DIFF(arrival_date_v2, reservation_status_date, DAY)
ELSE 0
    END AS days_between_cancelation_and_arrival
FROM `projeto-4-ana-caloi.hotel_bookings.21-1_canceled_bookings_MKT_pay`

CREATE OR REPLACE TABLE `projeto-4-ana-caloi.hotel_bookings.22_cancellations_less_3_days_pay`
AS
SELECT *,
CASE
WHEN days_between_cancelation_and_arrival <= 3 THEN 120 
ELSE 0
    END AS cancellations_less_3_days_pay
FROM `projeto-4-ana-caloi.hotel_bookings.21-2_days_between_cancelation_and_arrival`

CREATE OR REPLACE TABLE `projeto-4-ana-caloi.hotel_bookings.23_cancellations_total_impact`
AS
SELECT *,
cancellations_less_3_days_pay + canceled_bookings_MKT_pay
AS cancellations_total_impact
FROM `projeto-4-ana-caloi.hotel_bookings.22_cancellations_less_3_days_pay`

## Hipótese 1: Reservas feitas com antecedência correm alto risco de cancelamento
  ## Categorias de lead time
CREATE OR REPLACE TABLE `projeto-4-ana-caloi.hotel_bookings.15-1_leadtime_category`
  AS
  SELECT *,
  CASE
    WHEN lead_time BETWEEN 0 AND 14 THEN "1. Entre 0 e 15"
    WHEN lead_time BETWEEN 15 AND 29 THEN "2. Entre 15 e 30"
    WHEN lead_time BETWEEN 30 AND 59 THEN "3. Entre 30 e 60"
    WHEN lead_time BETWEEN 60 AND 89 THEN "4. Entre 60 e 90"
    WHEN lead_time BETWEEN 90 AND 179 THEN "5. Entre 90 e 180"
    WHEN lead_time BETWEEN 180 AND 360 THEN "6. Entre 180 e 360"
    WHEN lead_time > 360 THEN "Maior que 360"
    END AS lead_time_category
  FROM `projeto-4-ana-caloi.hotel_bookings.11-1_year_month`

  ## Calcula a taxa de cancelamento por categoria 
  CREATE OR REPLACE TABLE `projeto-4-ana-caloi.hotel_bookings.15-2_hipotese1`
  AS
  SELECT
  AVG(is_canceled) AS taxa_cancelamentos_hipotese1,
  lead_time_category
  FROM `projeto-4-ana-caloi.hotel_bookings.15-1_leadtime_category`
  GROUP BY lead_time_category
## Hipótese 2: As reservas que incluem crianças têm menor risco de cancelamento
CREATE OR REPLACE TABLE `projeto-4-ana-caloi.hotel_bookings.16-1_children_category`
  AS
  SELECT *,
  CASE
    WHEN children >0 THEN 1
    WHEN babies >0 THEN 1
    ELSE 0
    END AS children_category
  FROM `projeto-4-ana-caloi.hotel_bookings.15-1_leadtime_category`

CREATE OR REPLACE TABLE `projeto-4-ana-caloi.hotel_bookings.16-2_hipotese2-1`
  AS
  SELECT
  AVG(is_canceled) AS taxa_cancelamentos_hipotese2,
  children_category
  FROM `projeto-4-ana-caloi.hotel_bookings.16-1_children_category`
  GROUP BY children_category

  
CREATE OR REPLACE TABLE `projeto-4-ana-caloi.hotel_bookings.16-2_hipotese2-2`
  AS
  SELECT
  AVG(is_canceled) AS taxa_cancelamentos_hipotese2,
  children_category, hotel
  FROM `projeto-4-ana-caloi.hotel_bookings.16-1_children_category`
  GROUP BY children_category,hotel

## Hipótese 3: Os usuários que fizeram uma alteração em sua reserva têm menor risco de cancelamento
CREATE OR REPLACE TABLE `projeto-4-ana-caloi.hotel_bookings.17-1_booking_changes_category`
  AS
  SELECT *,
  CASE
    WHEN booking_changes = 0 THEN "1. Sem alterações"
    WHEN booking_changes BETWEEN 1 AND 10 THEN "2. Entre 1 e 10 alterações"
    WHEN booking_changes >= 10 THEN "3. 10 alterações ou mais"
    END AS booking_changes_category
  FROM `projeto-4-ana-caloi.hotel_bookings.16-1_children_category`

CREATE OR REPLACE TABLE `projeto-4-ana-caloi.hotel_bookings.17-2_hipotese3-1`
  AS
  SELECT
  AVG(is_canceled) AS taxa_cancelamentos_hipotese3,
  booking_changes_category
  FROM `projeto-4-ana-caloi.hotel_bookings.17-1_booking_changes_category`
  GROUP BY booking_changes_category


## Hipótese 4: Quando o usuário fez uma solicitação especial, o risco de cancelamento é menor
CREATE OR REPLACE TABLE `projeto-4-ana-caloi.hotel_bookings.18-1_total_of_special_requests_category`
  AS
  SELECT *,
  CASE
    WHEN total_of_special_requests = 0 THEN "1. Sem solicitações"
    WHEN total_of_special_requests BETWEEN 1 AND 2 THEN "2. Entre 1 e 2 solicitações"
    WHEN total_of_special_requests >= 3 THEN "3. 3 solicitações ou mais"
    END AS total_of_special_requests_category
  FROM `projeto-4-ana-caloi.hotel_bookings.17-1_booking_changes_category`

CREATE OR REPLACE TABLE `projeto-4-ana-caloi.hotel_bookings.18-2_hipotese4-1`
  AS
  SELECT
  AVG(is_canceled) AS taxa_cancelamentos_hipotese4,
  total_of_special_requests_category
  FROM `projeto-4-ana-caloi.hotel_bookings.18-1_total_of_special_requests_category`
  GROUP BY total_of_special_requests_category

CREATE OR REPLACE TABLE `projeto-4-ana-caloi.hotel_bookings.18-2_hipotese4-2`
  AS
  SELECT
  AVG(is_canceled) AS taxa_cancelamentos_hipotese4,
  total_of_special_requests_category, hotel
  FROM `projeto-4-ana-caloi.hotel_bookings.18-1_total_of_special_requests_category`
  GROUP BY total_of_special_requests_category, hotel

## Hipótese 5: As reservas que possuem um baixo "adr" o risco é menor
CREATE OR REPLACE TABLE `projeto-4-ana-caloi.hotel_bookings.19-1_adr_category`
  AS
  SELECT *,
  CASE
    WHEN adr BETWEEN 0 AND 99 THEN "1. Até R$100"
    WHEN adr BETWEEN 100 AND 199 THEN "2. Entre R$100 e R$200"
    WHEN adr BETWEEN 200 AND 299 THEN "3. Entre R$200 e R$300"
    WHEN adr BETWEEN 300 AND 399 THEN "4. Entre R$300 e R$400"
    WHEN adr > 400 THEN "5. Maior que R$400"
    END AS adr_category
  FROM `projeto-4-ana-caloi.hotel_bookings.18-1_total_of_special_requests_category`

CREATE OR REPLACE TABLE `projeto-4-ana-caloi.hotel_bookings.20-2_hipotese5-1`
  AS
  SELECT
  AVG(is_canceled) AS taxa_cancelamentos_hipotese5,
  adr_category
  FROM `projeto-4-ana-caloi.hotel_bookings.19-1_adr_category`
  GROUP BY adr_category

CREATE OR REPLACE TABLE `projeto-4-ana-caloi.hotel_bookings.20-2_hipotese5-2`
  AS
  SELECT
  AVG(is_canceled) AS taxa_cancelamentos_hipotese5,
  adr_category, hotel
  FROM `projeto-4-ana-caloi.hotel_bookings.19-1_adr_category`
  GROUP BY adr_category, hotel
