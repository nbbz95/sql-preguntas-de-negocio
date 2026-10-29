-- titulo: ¿Qué porcentaje de vendedores genera el 80% de la facturación?
-- tecnica: suma acumulada con ventana, ROW_NUMBER y conteo condicional
-- hallazgo: El 18% de los vendedores genera el 80% de la facturación. Cuidar a ese grupo (unos 530) protege la mayor parte del negocio.
with por_vendedor as (
    select seller_id, sum(price) as facturacion
    from order_items i
    join orders o using (order_id)
    where o.order_status = 'delivered'
    group by 1
),
acumulado as (
    select
        seller_id,
        facturacion,
        row_number() over (order by facturacion desc) as puesto,
        sum(facturacion) over (order by facturacion desc rows unbounded preceding)
            / sum(facturacion) over () as share_acumulado
    from por_vendedor
)
select
    count(*)                                                         as vendedores_totales,
    min(puesto) filter (where share_acumulado >= 0.8)                as vendedores_para_80pct,
    round(100.0 * min(puesto) filter (where share_acumulado >= 0.8) / count(*), 1) as pct_vendedores_para_80pct,
    round(100.0 * max(share_acumulado) filter (where puesto <= 10), 1) as share_top_10
from acumulado
