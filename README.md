# 15 preguntas de negocio respondidas con SQL

**Sitio:** https://nbbz95.github.io/sql-preguntas-de-negocio/ · **Resultados en texto:** [RESULTADOS.md](RESULTADOS.md)

Las preguntas que un gerente le hace a un analista sobre un e-commerce real (Olist, 100 mil órdenes, 2016-2018), cada una respondida con una consulta SQL, su resultado y la conclusión de negocio.

| # | Pregunta | Técnica |
|---|---|---|
| 1 | ¿Cómo evoluciona la facturación mes a mes? | CTE, `LAG` |
| 2 | ¿El ticket promedio sube o se crece solo por volumen? | agregación en dos niveles, `MEDIAN` |
| 3 | ¿Qué categorías explican la mayor parte de las ventas? | `SUM() OVER ()`, acumulado |
| 4 | ¿Qué % de vendedores genera el 80% de la facturación? | Pareto con suma acumulada |
| 5 | ¿Cuál es la categoría líder en cada estado? | top-N por grupo con `ROW_NUMBER` + `QUALIFY` |
| 6 | ¿Cuántos clientes vuelven y cuánto tardan? | `LEAD` |
| 7 | ¿Dónde se entrega tarde con más frecuencia? | tasas con `AVG` de booleanos, `HAVING` |
| 8 | ¿Cuánto cae la satisfacción según el atraso? | buckets con `CASE`, deduplicación |
| 9 | ¿Cómo pagan los clientes y en cuántas cuotas? | participación, promedio ponderado |
| 10 | ¿Qué días y horarios concentran las compras? | pivot con `FILTER` |
| 11 | ¿Cuánto pesa el flete según la región? | ratio de sumas (no promedio de ratios) |
| 12 | ¿Qué vendedores grandes cayeron el último trimestre? | comparación de períodos en una pasada |
| 13 | ¿Cuánto creció 2018 contra el mismo período de 2017? | year-to-date interanual |
| 14 | ¿Quiénes lideran las 3 categorías principales? | `DENSE_RANK` particionado |
| 15 | ¿Cuánto pesan los clientes de mayor valor? | `NTILE` |

## Algunos hallazgos

- **La retención es la gran oportunidad:** solo el 3% de los clientes vuelve a comprar.
- **La logística define la satisfacción:** más de 3 días de atraso bajan la nota de 4,2 a menos de 2.
- **Concentración:** el 18% de los vendedores genera el 80% de la facturación; el 10% de los clientes, el 38%.
- **El crecimiento es de volumen:** el ticket promedio casi no se movió mientras las órdenes se multiplicaron.

## Cómo está armado

```
queries/NN_nombre.sql   una pregunta por archivo; la cabecera tiene título, técnica, hallazgo y gráfico
src/cargar.py           carga los CSV en DuckDB
src/build.py            corre todas las consultas y genera site/data.json y RESULTADOS.md
tests/                  pytest: cada consulta corre, está documentada y sus resultados son coherentes
```

Para agregar una pregunta alcanza con sumar un `.sql` a `queries/`: el sitio, el markdown y los tests la levantan solos.

```bash
pip install -r requirements.txt
./scripts/descargar_datos.sh
python -m pytest -q
python src/build.py
python -m http.server -d site
```

**Datos:** [Olist, Brazilian E-Commerce Public Dataset](https://github.com/olist/work-at-olist-data), licencia CC BY-NC-SA 4.0.
