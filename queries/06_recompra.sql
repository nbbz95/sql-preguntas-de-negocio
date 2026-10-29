-- titulo: ¿Cuántos clientes vuelven a comprar y cuánto tardan?
-- tecnica: LEAD para la compra siguiente, clave de cliente real (customer_unique_id)
-- hallazgo: Solo el 3% de los clientes vuelve a comprar, y los que vuelven tardan una mediana de 69 días. La retención es la mayor oportunidad del negocio.
with compras as (
    select
        c.customer_unique_id as cliente,
        o.order_purchase_timestamp as fecha,
        lead(o.order_purchase_timestamp) over (
            partition by c.customer_unique_id order by o.order_purchase_timestamp
        ) as siguiente
    from orders o
    join customers c using (customer_id)
    where o.order_status = 'delivered'
),
por_cliente as (
    select
        cliente,
        count(*) as compras,
        min(date_diff('day', fecha, siguiente)) as dias_a_segunda
    from compras
    group by 1
)
select
    count(*)                                             as clientes,
    count(*) filter (where compras > 1)                  as recompran,
    round(100.0 * count(*) filter (where compras > 1) / count(*), 2) as tasa_recompra_pct,
    median(dias_a_segunda) filter (where dias_a_segunda > 0) as mediana_dias_a_segunda
from por_cliente
