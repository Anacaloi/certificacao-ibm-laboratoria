# Segmenta a idade
CREATE OR REPLACE TABLE `projeto-6-funcionarios.dataset.2-0-intervalo_idades`
AS 
SELECT *,
 CASE 
    WHEN Age BETWEEN 18 AND 25 THEN '1. Entre 18 e 25 anos' 
    WHEN Age BETWEEN 26 AND 35 THEN '2. Entre 26 e 35 anos' 
    WHEN Age BETWEEN 36 AND 50 THEN '3. Entre 36 e 50 anos' 
    ELSE '4. Mais de 50 anos' 
    END AS range_age
FROM `projeto-6-funcionarios.dataset.1-0-satisfacao_funcionarios` 
# Segmenta a distância do trabalho
# Segmenta a  renda mensal
# Segmenta o tempo de companhia
