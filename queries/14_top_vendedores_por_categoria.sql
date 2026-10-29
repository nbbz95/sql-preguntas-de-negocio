-- titulo: ¿Quiénes son los 3 mejores vendedores de las 3 categorías principales?
-- tecnica: DENSE_RANK particionado, CTE encadenadas
-- hallazgo: En cama y baño y en relojes, dos vendedores se quedan con más del 30% de la categoría; en belleza el liderazgo está repartido.
with ventas as (
    select
        coalesce(t.product_category_name_english, 'unknown') as categoria,
        i.seller_id,
        sum(i.price) as facturacion
    from order_items i
    join orders o using (order_id)
    join products p using (product_id)
    left join category_translation t using (product_category_name)
    where o.order_status = 'delivered'
    group by 1, 2
),
categorias_top as (
    select categoria from ventas group by 1 order by sum(facturacion) desc limit 3
),
rankeado as (
    select
        categoria,
        seller_id,
        facturacion,
        dense_rank() over (partition by categoria order by facturacion desc) as puesto,
        facturacion / sum(facturacion) over (partition by categoria) as share
    from ventas
    where categoria in (select categoria from categorias_top)
)
select categoria, puesto, left(seller_id, 8) as vendedor, round(facturacion, 2) as facturacion, round(100.0 * share, 1) as share_categoria_pct
from rankeado
where puesto <= 3
order by categoria, puesto
