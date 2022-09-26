#  Análise de Satisfação dos Funcionários

Neste projeto decidi trabalhar com a base de dados fictícia dos funcionários da IBM. Elaborei uma análise descritiva caracterizando os funcionários e diagnosticando a satisfação com o trabalho, ambiente e relacionamentos. Utilizei métricas como ESI (Employee Satisfaction Index) e eNPS (Employee Net Promoter Score) para complementar minha análise.
 - [Link da Base de Dados](https://www.kaggle.com/datasets/pavansubhasht/ibm-hr-analytics-attrition-dataset)

![Capa da apresentação do projeto](https://github.com/Anacaloi/certificacao-ibm-laboratoria/blob/main/p6-rh/img/capa.png)


 - [Link do Dashboard](https://app.powerbi.com/reportEmbed?reportId=073ab56f-945d-413f-90ed-ad460c31600a&autoAuth=true&ctid=7829281c-161b-472f-871d-d276668eae0e)


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

Durante a análise exploratória não foram identificados outliers nem maiores inconsistências nos registros que necessitaram de limpeza.
Para caracterizar os funcionários segmentei a coluna idade em intervalos utilizando a query:

```
SELECT *,
 CASE 
    WHEN Age BETWEEN 18 AND 25 THEN '1. Entre 18 e 25 anos' 
    WHEN Age BETWEEN 26 AND 35 THEN '2. Entre 26 e 35 anos' 
    WHEN Age BETWEEN 36 AND 50 THEN '3. Entre 36 e 50 anos' 
    ELSE '4. Mais de 50 anos' 
    END AS range_age
FROM `projeto-6-funcionarios.dataset.satisfacao_funcionarios` 
```

Procurando métricas para complementar minha análise encontrei o eNPS. Esta métrica procura entender a satisfação dos colaboradores, verificando se eles estariam dispostos a recomendar a empresa para terceiros de confiança. Normalmente são atribuídas notas de 0 a 10. Sendo considerados: detratores de 0 a 6, neutros de 7 a 8 e promotores de 9 a 10. 

No entanto como a pesquisa utilizou notas de 1 a 4, os clientes foram categorizados da seguinte forma:

```
SELECT *,
 CASE 
    WHEN JobSatisfaction BETWEEN 0 AND 2 THEN 'Detratores' 
    WHEN JobSatisfaction = 3 THEN 'Neutros' 
    WHEN JobSatisfaction = 4 THEN 'Promotores' 
    ELSE 'Sem Categoria' 
    END AS eNPS
FROM `projeto-6-funcionarios.dataset.satisfacao_funcionarios` 
```
Por fim, o Employee Net Promoter Score é obtido através da diferença entre o percentual de promotores e detratores.Nas avaliações do eNPS, um resultado acima de 70% costuma ser considerado bom ou muito bom.<br>

No Índice de Satisfação dos Colaboradores (ESI) o colaborador atribui notas também de 0 a 10 spbre sua relação como local de trabalho. O indice é calculado da seguinte maneira:
- ESI = (média das 3 satisfações – 1) ÷ 9<br>

O resultado poderia ser considerado um pouco acima da média, considerando 0% o pior desempenho possível e 100% o melhor. Novamente, durante a pesquisa utilizada na análise foram atribuidas notas de apenas 1 a 4, então durante o calculo foram guardadas as devidas proporções.


## Visualização
Para a visualização da análise escolhi 3 painéis: um primeiro com a visão geral dos funcionários, o segundo diagnosticando a satisfação e o terceiro com os insights e conclusões.

![Página do Dashboard com a Visão Geral dos Funcionários](https://github.com/Anacaloi/certificacao-ibm-laboratoria/blob/main/p6-rh/img/1-visao-geral.png)

- Os 3 cargos com maior número de funcionários são respectivamente Executivo de Venda (326), Cientista Pesquisador (292) e Tecnico de Laboratório;
- Homens correnpondem a 60% do quadro de funcionarios, são maioria em todos os departamentos;
- Quanto maior o nível de Educação (1-Sem Graduação, 2-Graduação, 3-Mestrado e 5-Doutorado) maior a média salarial;
- Quanto a distribuição de salário por gênero é bem equilibrada exceto nos cargos de gerente e diretor de pesquisa.


![Página do Dashboard com a Satisfação dos Funcionários](https://github.com/Anacaloi/certificacao-ibm-laboratoria/blob/main/p6-rh/img/2-satisfacao.png)
- Numa escala de 1 a 4 a média de satisfação 

![Página de conclusões](https://github.com/Anacaloi/certificacao-ibm-laboratoria/blob/main/p6-rh/img/3-conclusoes.png)<br>


 - [Link do Dashboard](https://app.powerbi.com/reportEmbed?reportId=073ab56f-945d-413f-90ed-ad460c31600a&autoAuth=true&ctid=7829281c-161b-472f-871d-d276668eae0e)

