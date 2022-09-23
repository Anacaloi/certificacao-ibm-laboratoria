
# Projeto 6 - Análise de Satisfação dos Funcionários

Neste projeto decidi trabalhar com a base de dados fictícia dos funcionários da IBM. Elaborei uma análise descritiva caracterizando os funcionários e diagnosticando a satisfação com o trabalho, ambiente e relacionamentos. Utilizei métricas como ESI (Employee Satisfaction Index) e eNPS (Employee Net Promoter Score) para complementar minha análise.

## Objetivos
- Estruturar uma analise do zero:
  - 1 Fazendo as perguntas de negócios para entender os objetivos e avaliar a situação atual;
  - 2 Entendendo a base e o que os registros significam;
  - 3 Fazendo a limpeza e preparação dos dados;
  - 4 Análise dos dados de acordo com as métricas escolhidas;
  - 5 Comunicar as descobertas através de um Dashboard no Power Bi.
 - Diagnosticar a satisfação dos funcionários;
 - Aplicar as métricas ESI e eNPS para 
- Gerar visualizações com Power BI;

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

