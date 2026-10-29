-- titulo: ¿Cuál es la categoría más vendida en cada uno de los 10 estados más grandes?
-- tecnica: ROW_NUMBER particionado (top-N por grupo) y QUALIFY
-- hallazgo: El líder cambia según el estado (cama y baño en SP y RS, relojes en RJ y el Centro-Oeste) y nunca supera el 11%: conviene segmentar campañas por estado.
with ventas as (
    select
        c.customer_state as estado,
        coalesce(t.product_category_name_english, 'unknown') as categoria,
        sum(i.price) as facturacion
    from order_items i
    join orders o using (order_id)
    join customers c using (customer_id)
    join products p using (product_id)
    left join category_translation t using (product_category_name)
    where o.order_status = 'delivered'
    group by 1, 2
),
estados_top as (
    select estado from ventas group by 1 order by sum(facturacion) desc limit 10
)
select
    estado,
    categoria as categoria_lider,
    round(facturacion, 2) as facturacion,
    round(100.0 * facturacion / sum(facturacion) over (partition by estado), 1) as share_en_estado_pct
from ventas
where estado in (select estado from estados_top)
qualify row_number() over (partition by estado order by facturacion desc) = 1
order by facturacion desc
