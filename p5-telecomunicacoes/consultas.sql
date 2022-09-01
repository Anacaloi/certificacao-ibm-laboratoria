## Faz o join dos datasets distintos e cria a tabela master churn
CREATE TABLE `projeto5-358114.dataset.1-0_master_churn`  AS (
SELECT a.* EXCEPT(Zip_Code),
        b.Gender,b.Age,b.Under_30,b.Senior_Citizen,
        b.Married,b.Dependents,b.Number_of_Dependents,
        c.Quarter,c.Referred_a_Friend,c.Number_of_Referrals,
        c.Tenure_in_Months,c.Offer,c.Phone_Service,
        c.Avg_Monthly_Long_Distance_Charges,c.Multiple_Lines,
        c.Internet_Service,c.Internet_Type,c.Avg_Monthly_GB_Download,
        c.Online_Security,c.Online_Backup,c.Device_Protection_Plan,
        c.Premium_Tech_Support,c.Streaming_TV,c.Streaming_Movies,
        c.Streaming_Music,c.Unlimited_Data,c.Contract,c.Paperless_Billing,
        c.Payment_Method,c.Monthly_Charge,c.Total_Charges,c.Total_Refunds,
        c.Total_Extra_Data_Charges,c.Total_Long_Distance_Charges,c.Total_Revenue,
        d.Customer_Status,d.Churn_Label,d.Churn_Value,
        d.Churn_Category,d.Churn_Reason 
FROM `projeto5-358114.dataset.0-2_churn_location` a
LEFT JOIN `projeto5-358114.dataset.0-1_churn_demographics` b
ON a.Customer_ID=b.Customer_ID
LEFT JOIN `projeto5-358114.dataset.0-4_churn_services` c
ON b.Customer_ID=c.Customer_ID
LEFT JOIN `projeto5-358114.dataset.0-5_churn_status` d
ON c.Customer_ID=d.Customer_ID
)

## Faz a limpeza do dataset
CREATE OR REPLACE TABLE `projeto5-358114.dataset.1-0_master_churn` AS
(
SELECT * EXCEPT(gender),
CASE
WHEN gender = 'M' THEN 'Male'
WHEN gender = 'F' THEN 'Female'
ELSE gender END as gender
FROM `projeto5-358114.dataset.1-0_master_churn`
WHERE Age<=80
AND Monthly_Charge > 0
)

## Cria a coluna age_range
CREATE OR REPLACE TABLE `projeto5-358114.dataset.2-0_age_range` 
AS
 SELECT *,
    CASE 
    WHEN Age < 41 THEN '1. 0 a 40 anos'
    WHEN Age BETWEEN 41 AND 60 THEN '2. 41 a 60 anos' 
    ELSE '3. Mais de 60 anos' 
    END AS range_age
    FROM `projeto5-358114.dataset.1-0_master_churn`

## Cria a coluna referrals_range
CREATE OR REPLACE TABLE `projeto5-358114.dataset.3-0_referrals_range` 
AS
 SELECT *,
    CASE 
    WHEN Number_of_referrals = 0 THEN '1. 0 referências'
    WHEN Number_of_referrals BETWEEN 1 AND 4 THEN '2. 1 a 4 referências' 
    WHEN Number_of_referrals BETWEEN 5 AND 8 THEN '3. 5 a 8 referências'
    ELSE '4. Mais de 8 referências' 
    END AS range_referrals
    FROM `projeto5-358114.dataset.2-0_age_range`

## Cria a coluna range_tenure_months
CREATE OR REPLACE TABLE `projeto5-358114.dataset.4-0_tenure_months_range` 
AS
 SELECT *,
    CASE 
    WHEN Tenure_in_Months BETWEEN 1 AND 12 THEN '1. 1 a 12 meses' 
    WHEN Tenure_in_Months BETWEEN 13 AND 24 THEN '2. 13 a 24 meses'
    WHEN Tenure_in_Months BETWEEN 25 AND 36 THEN '3. 25 a 36 meses'
    WHEN Tenure_in_Months BETWEEN 37 AND 48 THEN '4. 37 a 48 meses'
    WHEN Tenure_in_Months BETWEEN 49 AND 60 THEN '5. 49 a 60 meses'
    WHEN Tenure_in_Months BETWEEN 61 AND 72 THEN '6. 61 a 72 meses'
    ELSE '7. Sem categoria' 
    END AS range_tenure_months
    FROM `projeto5-358114.dataset.3-0_referrals_range` 

## Segmenta em Grupos de risco
CREATE OR REPLACE  TABLE `projeto5-358114.dataset.5-0_risk_group` AS (
SELECT *,
  CASE
    WHEN Contract = 'Month-to-Month' AND Age > 64 THEN 'G1'
    WHEN Contract = 'Month-to-Month' AND Age < 64 AND Number_of_Referrals <= 1 THEN 'G2'
    WHEN Contract != 'Month-to-Month' AND Age > 64 AND Number_of_Referrals <= 1 THEN 'G3'
    WHEN Contract != 'Month-to-Month' AND Tenure_in_Months < 40 THEN 'G4'
    ELSE 'Sem Grupo'
END AS risk_group
FROM `projeto5-358114.dataset.4-0_tenure_months_range`
)

CREATE OR REPLACE  TABLE `projeto5-358114.dataset.5-1_media_antiguidade`
AS
SELECT Contract,AVG(Tenure_in_Months) AS media_antiguidade
FROM `projeto5-358114.dataset.5-0_risk_group`
GROUP BY 1

## Calcular o valor dos clientes
CREATE OR REPLACE  TABLE `projeto5-358114.dataset.6-0_tabela_final`
AS(
WITH base_tenure_prom AS (
        SELECT Contract,AVG(Tenure_in_Months) AS media_tenure
        FROM `projeto5-358114.dataset.5-0_risk_group`
        GROUP BY 1
)
SELECT a.*,
        b.media_tenure
FROM `projeto5-358114.dataset.5-0_risk_group` a
LEFT JOIN base_tenure_prom b
ON a.Contract = b.Contract
)

CREATE OR REPLACE  TABLE `projeto5-358114.dataset.6-0_tabela_final` AS(
SELECT *,
    media_tenure*Total_Revenue/3 AS renda_estimada
FROM `projeto5-358114.dataset.6-0_tabela_final` a
)

CREATE OR REPLACE  TABLE `projeto5-358114.dataset.6-0_tabela_final` AS (
SELECT *,
  CASE
    WHEN risk_group = "G2" AND Quarter = 'Q3' THEN 'Alto Valor'
    WHEN risk_group = "G2" AND Quarter = 'Q4' THEN 'Alto Valor'

    ELSE 'Sem categoria'
END AS range_valor_monetario
FROM `projeto5-358114.dataset.6-0_tabela_final`
)