-- titulo: ¿El ticket promedio sube o la empresa crece solo por volumen?
-- tecnica: agregación en dos niveles (orden y trimestre)
-- hallazgo: El ticket promedio se mueve poco (R$ 153 a 167) y la mediana ronda R$ 105: el crecimiento viene del volumen de órdenes, no de vender más caro.
with por_orden as (
    select
        o.order_id,
        date_trunc('quarter', o.order_purchase_timestamp)::date as trimestre,
        sum(i.price + i.freight_value) as valor
    from orders o
    join order_items i using (order_id)
    where o.order_status = 'delivered'
      and o.order_purchase_timestamp between '2017-01-01' and '2018-06-30'
    group by 1, 2
)
select
    year(trimestre) || '-T' || quarter(trimestre) as trimestre,
    count(*)                       as ordenes,
    round(avg(valor), 2)           as ticket_promedio,
    round(median(valor), 2)        as ticket_mediano
from por_orden
group by trimestre
order by trimestre
