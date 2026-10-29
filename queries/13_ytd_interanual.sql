-- titulo: ¿Cuánto creció 2018 contra el mismo período de 2017?
-- tecnica: comparación year-to-date sobre meses equivalentes, pivot con FILTER
-- hallazgo: Entre enero y agosto, 2018 facturó 2,4 veces lo de 2017 (+143%) con 2,4 veces más órdenes: crecimiento puro de volumen.
with mensual as (
    select
        year(o.order_purchase_timestamp)  as anio,
        month(o.order_purchase_timestamp) as mes,
        sum(i.price + i.freight_value)    as facturacion,
        count(distinct o.order_id)        as ordenes
    from orders o
    join order_items i using (order_id)
    where o.order_status = 'delivered'
      and month(o.order_purchase_timestamp) <= 8
      and year(o.order_purchase_timestamp) in (2017, 2018)
    group by 1, 2
)
select
    'Enero a agosto' as periodo,
    round(sum(facturacion) filter (where anio = 2017), 2) as facturacion_2017,
    round(sum(facturacion) filter (where anio = 2018), 2) as facturacion_2018,
    round(100.0 * (sum(facturacion) filter (where anio = 2018) / sum(facturacion) filter (where anio = 2017) - 1), 1) as crecimiento_pct,
    sum(ordenes) filter (where anio = 2017) as ordenes_2017,
    sum(ordenes) filter (where anio = 2018) as ordenes_2018
from mensual
