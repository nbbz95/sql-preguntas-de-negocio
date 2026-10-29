-- titulo: ¿Qué vendedores grandes cayeron fuerte el último trimestre?
-- tecnica: agregación condicional con FILTER para comparar períodos en una sola pasada
-- hallazgo: Varios vendedores relevantes cayeron más de 40% de un trimestre al siguiente. Esta consulta sirve como alerta temprana para el equipo comercial.
with por_vendedor as (
    select
        i.seller_id,
        s.seller_state as estado,
        sum(i.price) filter (where o.order_purchase_timestamp >= '2018-01-01' and o.order_purchase_timestamp < '2018-04-01') as t1_2018,
        sum(i.price) filter (where o.order_purchase_timestamp >= '2018-04-01' and o.order_purchase_timestamp < '2018-07-01') as t2_2018
    from order_items i
    join orders o using (order_id)
    join sellers s using (seller_id)
    where o.order_status = 'delivered'
    group by 1, 2
)
select
    left(seller_id, 8) as vendedor,
    estado,
    round(t1_2018, 2) as t1_2018,
    round(coalesce(t2_2018, 0), 2) as t2_2018,
    round(100.0 * (coalesce(t2_2018, 0) / t1_2018 - 1), 1) as variacion_pct
from por_vendedor
where t1_2018 >= 20000
order by variacion_pct
limit 10
