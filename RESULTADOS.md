# Resultados

Generado por `python src/build.py`. Cada sección es una consulta de `queries/`.

## ¿Cómo evoluciona la facturación mes a mes?

`01_facturacion_mensual.sql` · CTE, LAG para crecimiento contra el mes anterior

> La facturación se multiplicó por 9 entre enero y noviembre de 2017; el pico de noviembre es Black Friday (+54% contra octubre) y 2018 se estabiliza en torno a R$ 1 M por mes.

| mes | ordenes | facturacion | crecimiento_pct |
|---|---|---|---|
| 2017-01 | 750 | 127482.37 |  |
| 2017-02 | 1653 | 271239.32 | 112.8 |
| 2017-03 | 2546 | 414330.95 | 52.8 |
| 2017-04 | 2303 | 390812.4 | -5.7 |
| 2017-05 | 3546 | 566851.4 | 45.0 |
| 2017-06 | 3135 | 490050.37 | -13.5 |
| 2017-07 | 3872 | 566299.08 | 15.6 |
| 2017-08 | 4193 | 645915.12 | 14.1 |
| 2017-09 | 4150 | 701077.49 | 8.5 |
| 2017-10 | 4478 | 751222.13 | 7.2 |
| 2017-11 | 7289 | 1154559.53 | 53.7 |
| 2017-12 | 5513 | 843851.21 | -26.9 |
| 2018-01 | 7069 | 1078442.72 | 27.8 |
| 2018-02 | 6555 | 966836.85 | -10.3 |
| 2018-03 | 7003 | 1120726.7 | 15.9 |
| 2018-04 | 6798 | 1133264.96 | 1.1 |
| 2018-05 | 6749 | 1129246.12 | -0.4 |
| 2018-06 | 6099 | 1012202.49 | -10.4 |
| 2018-07 | 6159 | 1027840.54 | 1.5 |
| 2018-08 | 6351 | 985558.16 | -4.1 |

## ¿El ticket promedio sube o la empresa crece solo por volumen?

`02_ticket_promedio.sql` · agregación en dos niveles (orden y trimestre)

> El ticket promedio se mueve poco (R$ 153 a 167) y la mediana ronda R$ 105: el crecimiento viene del volumen de órdenes, no de vender más caro.

| trimestre | ordenes | ticket_promedio | ticket_mediano |
|---|---|---|---|
| 2017-T1 | 4949 | 164.29 | 103.11 |
| 2017-T2 | 8984 | 161.14 | 102.5 |
| 2017-T3 | 12215 | 156.63 | 102.03 |
| 2017-T4 | 17280 | 159.12 | 105.28 |
| 2018-T1 | 20627 | 153.49 | 104.61 |
| 2018-T2 | 19523 | 166.79 | 109.67 |

## ¿Qué categorías explican la mayor parte de las ventas?

`03_top_categorias.sql` · SUM() OVER () para participación sobre el total, LEFT JOIN a la tabla de traducción

> Ninguna categoría pasa del 10%: las 10 primeras juntan el 62% de las ventas. Es un catálogo diversificado, sin dependencia de un rubro.

| categoria | facturacion | participacion_pct | acumulado_pct |
|---|---|---|---|
| health_beauty | 1233131.72 | 9.3 | 9.3 |
| watches_gifts | 1166176.98 | 8.8 | 18.1 |
| bed_bath_table | 1023434.76 | 7.7 | 25.9 |
| sports_leisure | 954852.55 | 7.2 | 33.1 |
| computers_accessories | 888724.61 | 6.7 | 39.8 |
| furniture_decor | 711927.69 | 5.4 | 45.2 |
| housewares | 615628.69 | 4.7 | 49.9 |
| cool_stuff | 610204.1 | 4.6 | 54.5 |
| auto | 578966.65 | 4.4 | 58.9 |
| toys | 471286.48 | 3.6 | 62.4 |

## ¿Qué porcentaje de vendedores genera el 80% de la facturación?

`04_pareto_vendedores.sql` · suma acumulada con ventana, ROW_NUMBER y conteo condicional

> El 18% de los vendedores genera el 80% de la facturación. Cuidar a ese grupo (unos 530) protege la mayor parte del negocio.

| vendedores_totales | vendedores_para_80pct | pct_vendedores_para_80pct | share_top_10 |
|---|---|---|---|
| 2970 | 533 | 17.9 | 13.3 |

## ¿Cuál es la categoría más vendida en cada uno de los 10 estados más grandes?

`05_categoria_lider_por_estado.sql` · ROW_NUMBER particionado (top-N por grupo) y QUALIFY

> El líder cambia según el estado (cama y baño en SP y RS, relojes en RJ y el Centro-Oeste) y nunca supera el 11%: conviene segmentar campañas por estado.

| estado | categoria_lider | facturacion | share_en_estado_pct |
|---|---|---|---|
| SP | bed_bath_table | 472238.07 | 9.3 |
| RJ | watches_gifts | 174895.01 | 9.9 |
| MG | health_beauty | 154324.15 | 9.9 |
| RS | bed_bath_table | 60040.95 | 8.2 |
| PR | sports_leisure | 57653.3 | 8.7 |
| BA | health_beauty | 49955.12 | 10.1 |
| SC | sports_leisure | 41579.03 | 8.2 |
| DF | watches_gifts | 32292.27 | 10.9 |
| GO | watches_gifts | 31486.93 | 11.1 |
| ES | watches_gifts | 28074.0 | 10.5 |

## ¿Cuántos clientes vuelven a comprar y cuánto tardan?

`06_recompra.sql` · LEAD para la compra siguiente, clave de cliente real (customer_unique_id)

> Solo el 3% de los clientes vuelve a comprar, y los que vuelven tardan una mediana de 69 días. La retención es la mayor oportunidad del negocio.

| clientes | recompran | tasa_recompra_pct | mediana_dias_a_segunda |
|---|---|---|---|
| 93358 | 2801 | 3.0 | 69.0 |

## ¿En qué estados se entrega tarde con más frecuencia?

`07_atraso_por_estado.sql` · tasa con AVG de un booleano, filtro de volumen mínimo con HAVING

> El Nordeste concentra los peores atrasos (Maranhão casi 1 de cada 5 órdenes) y Río de Janeiro aparece con 13,5% pese a su volumen.

| estado | ordenes | tarde_pct | dias_entrega_prom |
|---|---|---|---|
| MA | 717 | 19.7 | 21.5 |
| CE | 1279 | 15.3 | 21.2 |
| BA | 3256 | 14.0 | 19.3 |
| RJ | 12350 | 13.5 | 15.2 |
| PA | 946 | 12.4 | 23.7 |
| ES | 1995 | 12.2 | 15.7 |
| MS | 701 | 11.6 | 15.5 |
| PB | 517 | 11.0 | 20.4 |
| PE | 1593 | 10.8 | 18.4 |
| SC | 3546 | 9.8 | 14.9 |

## ¿Cuánto cae la satisfacción según los días de atraso?

`08_atraso_vs_resena.sql` · buckets con CASE, deduplicación de reseñas con QUALIFY

> Un atraso de más de 3 días baja la nota de 4,2 a menos de 2 y dispara las reseñas malas del 11% al 72-79%. Llegar a tiempo vale más que llegar antes.

| entrega | ordenes | nota_promedio | notas_malas_pct |
|---|---|---|---|
| 1. Una semana antes o más | 75744 | 4.31 | 9.0 |
| 2. A tiempo | 13699 | 4.17 | 10.8 |
| 3. Hasta 3 días tarde | 1852 | 3.29 | 32.1 |
| 4. De 4 a 10 días tarde | 2504 | 1.97 | 71.5 |
| 5. Más de 10 días tarde | 2025 | 1.71 | 78.9 |

## ¿Cómo pagan los clientes y en cuántas cuotas?

`09_medios_de_pago.sql` · participación con ventana, promedio ponderado

> La tarjeta de crédito mueve el 78% del monto con un promedio ponderado de 5 cuotas: la financiación es parte de la propuesta de valor.

| medio | ordenes | share_monto_pct | cuotas_ponderadas | monto_promedio |
|---|---|---|---|---|
| credit_card | 76505 | 78.3 | 5.0 | 163.32 |
| boleto | 19784 | 17.9 | 1.0 | 145.03 |
| voucher | 3866 | 2.4 | 1.0 | 65.7 |
| debit_card | 1528 | 1.4 | 1.0 | 142.57 |

## ¿Qué días y franjas horarias concentran las compras?

`10_dia_y_hora.sql` · extracción de partes de fecha, pivot condicional con FILTER

> Las compras se concentran de lunes a miércoles por la tarde y la noche; el fin de semana cae alrededor de un 25%. Es el horario para campañas y soporte.

| dia | ordenes | madrugada | manana | tarde | noche |
|---|---|---|---|---|---|
| 1. Lunes | 16196 | 607 | 3604 | 6259 | 5726 |
| 2. Martes | 15963 | 625 | 3703 | 6162 | 5473 |
| 3. Miércoles | 15552 | 750 | 3754 | 5988 | 5060 |
| 4. Jueves | 14761 | 695 | 3509 | 5860 | 4697 |
| 5. Viernes | 14122 | 839 | 3510 | 5588 | 4185 |
| 6. Sábado | 10887 | 649 | 2215 | 4194 | 3829 |
| 7. Domingo | 11960 | 575 | 1945 | 4310 | 5130 |

## ¿Cuánto pesa el flete sobre el precio según la región del cliente?

`11_flete_por_region.sql` · CASE para mapear estados a regiones, ratio de sumas (no promedio de ratios)

> En el Norte y Nordeste el flete representa 22-23% del precio contra 15% en el Sudeste: ahí está el freno logístico al crecimiento regional.

| region | lineas | flete_promedio | flete_sobre_precio_pct |
|---|---|---|---|
| Norte | 2018 | 36.8 | 22.7 |
| Nordeste | 10087 | 32.34 | 21.8 |
| Centro-Oeste | 6480 | 23.11 | 17.7 |
| Sur | 15880 | 21.21 | 17.7 |
| Sudeste | 75732 | 17.38 | 15.2 |

## ¿Qué vendedores grandes cayeron fuerte el último trimestre?

`12_vendedores_en_caida.sql` · agregación condicional con FILTER para comparar períodos en una sola pasada

> Varios vendedores relevantes cayeron más de 40% de un trimestre al siguiente. Esta consulta sirve como alerta temprana para el equipo comercial.

| vendedor | estado | t1_2018 | t2_2018 | variacion_pct |
|---|---|---|---|---|
| c826c40d | SP | 27015.72 | 4456.25 | -83.5 |
| 04308b1e | SC | 21087.4 | 4839.4 | -77.1 |
| 3d871de0 | SP | 25416.2 | 9609.7 | -62.2 |
| 7a67c85e | SP | 25757.81 | 13891.17 | -46.1 |
| 7c67e144 | SP | 52472.16 | 30479.26 | -41.9 |
| a1043baf | MG | 31559.85 | 21271.6 | -32.6 |
| 5dceca12 | SP | 31634.8 | 22690.32 | -28.3 |
| 4a3ca931 | SP | 34811.49 | 25040.06 | -28.1 |
| 620c87c1 | RJ | 21246.7 | 16528.7 | -22.2 |
| 4869f7a5 | SP | 63272.0 | 50183.2 | -20.7 |

## ¿Cuánto creció 2018 contra el mismo período de 2017?

`13_ytd_interanual.sql` · comparación year-to-date sobre meses equivalentes, pivot con FILTER

> Entre enero y agosto, 2018 facturó 2,4 veces lo de 2017 (+143%) con 2,4 veces más órdenes: crecimiento puro de volumen.

| periodo | facturacion_2017 | facturacion_2018 | crecimiento_pct | ordenes_2017 | ordenes_2018 |
|---|---|---|---|---|---|
| Enero a agosto | 3472981.01 | 8454118.54 | 143.4 | 21998 | 52783 |

## ¿Quiénes son los 3 mejores vendedores de las 3 categorías principales?

`14_top_vendedores_por_categoria.sql` · DENSE_RANK particionado, CTE encadenadas

> En cama y baño y en relojes, dos vendedores se quedan con más del 30% de la categoría; en belleza el liderazgo está repartido.

| categoria | puesto | vendedor | facturacion | share_categoria_pct |
|---|---|---|---|---|
| bed_bath_table | 1 | 4a3ca931 | 162206.95 | 15.8 |
| bed_bath_table | 2 | da8622b1 | 151888.1 | 14.8 |
| bed_bath_table | 3 | 37be5a7c | 53937.57 | 5.3 |
| health_beauty | 1 | edb1ef5e | 79144.9 | 6.4 |
| health_beauty | 2 | ccc4bbb5 | 71393.83 | 5.8 |
| health_beauty | 3 | f7ba60f8 | 65492.0 | 5.3 |
| watches_gifts | 1 | 4869f7a5 | 198822.03 | 17.0 |
| watches_gifts | 2 | fa1c13f2 | 188967.85 | 16.2 |
| watches_gifts | 3 | 7e93a43e | 160087.66 | 13.7 |

## ¿Cuánto pesan los clientes de mayor valor?

`15_clientes_alto_valor.sql` · NTILE para percentiles, participación por segmento

> El 10% de los clientes de mayor valor genera el 38% de la facturación, y el 1% superior gasta 27 veces más que la mitad inferior.

| segmento | clientes | valor_promedio | share_facturacion_pct |
|---|---|---|---|
| 1. Top 1% | 934 | 1708.88 | 10.3 |
| 2. Top 2-10% | 8406 | 512.24 | 27.9 |
| 3. Top 11-50% | 37360 | 175.52 | 42.5 |
| 4. Resto (50%) | 46658 | 63.55 | 19.2 |
