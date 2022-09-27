#  Análise de uso de bicicletas compartilhadas

Neste projeto Trabalhei com a base de dados de viagens da Empresa Citibike.
 - [Link da Base de Dados]()


 - [Link do Dashboard]()


## Objetivos
- Estruturar uma analise exploratória abordando:
    - Métricas de uso em um dia;
    - Métricas históricas;
    - Comportamento dos usuários.


## Metodologia

Durante a análise exploratória não foram identificados outliers nem maiores inconsistências nos registros que necessitaram de limpeza.
Importando as tabelas para o projeto:

```
CREATE TABLE `mockinterviewibm.dataset.1-0-stations`
AS
SELECT station_id, name, latitude, longitude
FROM `bigquery-public-data.new_york_citibike.citibike_stations`
```

Limpeza dos dados: adiciona a coluna data e remove colunas desnecessárias e valores nulos

```
CREATE OR REPLACE TABLE `mockinterviewibm.dataset.2-0-trips`
AS
SELECT * except (customer_plan, end_station_latitude,end_station_longitude, end_station_name, start_station_latitude, start_station_longitude, start_station_name),
CAST (starttime AS DATE) AS tripdate,
extract(year FROM starttime) AS tripyear,
FROM `bigquery-public-data.new_york_citibike.citibike_trips`
WHERE  tripduration > 0
```

## Visualização
Escolha de visualização

![Métricas de uso em um dia]()

-viagens em um dia


![Métricas Históricas]()
- Total de viagens


![Comportamento dos usuários por tipo de usuário - em breve]()
- Em todos os cargos os funcionários neutros, de acordo com a metodologia eNPS, são maioria.



