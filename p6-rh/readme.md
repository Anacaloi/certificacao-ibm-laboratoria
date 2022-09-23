
# Projeto 6 - Análise de Satisfação dos Funcionários

Neste projetos foram analisados dados históricos de uma empresa de telecomunicações. Trabalho Final da Certificação em Análise de Dados - IBM|Laboratória em desenvolvimento em Setempro de 2022.

## Objetivos
Consultas SQL e vizualizações no power BI
Análise de satisfação e outras métricas de RH
## Metodologia
Para caracterizar os funcionários segmentei a coluna idade em intervalos.
```
SELECT *,
 CASE 
    WHEN Age BETWEEN 18 AND 25 THEN '1. Entre 18 e 25 anos' 
    WHEN Age BETWEEN 26 AND 35 THEN '2. Entre 26 e 35 anos' 
    WHEN Age BETWEEN 36 AND 50 THEN '3. Entre 36 e 50 anos' 
    ELSE '4. Mais de 50 anos' 
    END AS range_age
FROM `projeto-6-funcionarios.dataset.1-0-satisfacao_funcionarios` 
```


## Visualização



 - [Link da Base de Dados](https://www.kaggle.com/datasets/pavansubhasht/ibm-hr-analytics-attrition-dataset)
 - [Link do Dashboard](https://app.powerbi.com/reportEmbed?reportId=073ab56f-945d-413f-90ed-ad460c31600a&autoAuth=true&ctid=7829281c-161b-472f-871d-d276668eae0e)

