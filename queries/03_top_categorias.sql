-- titulo: ¿Qué categorías explican la mayor parte de las ventas?
-- tecnica: SUM() OVER () para participación sobre el total, LEFT JOIN a la tabla de traducción
-- hallazgo: Ninguna categoría pasa del 10%: las 10 primeras juntan el 62% de las ventas. Es un catálogo diversificado, sin dependencia de un rubro.
-- grafico: bars categoria facturacion
with por_categoria as (
    select
        coalesce(t.product_category_name_english, p.product_category_name, 'unknown') as categoria,
        sum(i.price) as facturacion
    from order_items i
    join orders o using (order_id)
    join products p using (product_id)
    left join category_translation t using (product_category_name)
    where o.order_status = 'delivered'
    group by 1
)
select
    categoria,
    round(facturacion, 2) as facturacion,
    round(100.0 * facturacion / sum(facturacion) over (), 1) as participacion_pct,
    round(100.0 * sum(facturacion) over (order by facturacion desc) / sum(facturacion) over (), 1) as acumulado_pct
from por_categoria
order by facturacion desc
limit 10
