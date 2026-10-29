-- titulo: ¿Cómo evoluciona la facturación mes a mes?
-- tecnica: CTE, LAG para crecimiento contra el mes anterior
-- hallazgo: La facturación se multiplicó por 9 entre enero y noviembre de 2017; el pico de noviembre es Black Friday (+54% contra octubre) y 2018 se estabiliza en torno a R$ 1 M por mes.
-- grafico: line mes facturacion
with mensual as (
    select
        date_trunc('month', o.order_purchase_timestamp)::date as mes,
        count(distinct o.order_id)                             as ordenes,
        round(sum(i.price + i.freight_value), 2)               as facturacion
    from orders o
    join order_items i using (order_id)
    where o.order_status = 'delivered'
      and o.order_purchase_timestamp between '2017-01-01' and '2018-08-31'
    group by 1
)
select
    strftime(mes, '%Y-%m') as mes,
    ordenes,
    facturacion,
    round(100.0 * (facturacion / lag(facturacion) over (order by mes) - 1), 1) as crecimiento_pct
from mensual
order by mes
