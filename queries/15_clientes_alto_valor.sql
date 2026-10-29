-- titulo: ¿Cuánto pesan los clientes de mayor valor?
-- tecnica: NTILE para percentiles, participación por segmento
-- hallazgo: El 10% de los clientes de mayor valor genera el 38% de la facturación, y el 1% superior gasta 27 veces más que la mitad inferior.
-- grafico: bars segmento share_facturacion_pct
with por_cliente as (
    select c.customer_unique_id as cliente, sum(i.price + i.freight_value) as valor
    from orders o
    join customers c using (customer_id)
    join order_items i using (order_id)
    where o.order_status = 'delivered'
    group by 1
),
segmentado as (
    select *, ntile(100) over (order by valor desc) as percentil
    from por_cliente
)
select
    case when percentil = 1 then '1. Top 1%' when percentil <= 10 then '2. Top 2-10%' when percentil <= 50 then '3. Top 11-50%' else '4. Resto (50%)' end as segmento,
    count(*) as clientes,
    round(avg(valor), 2) as valor_promedio,
    round(100.0 * sum(valor) / sum(sum(valor)) over (), 1) as share_facturacion_pct
from segmentado
group by 1
order by 1
