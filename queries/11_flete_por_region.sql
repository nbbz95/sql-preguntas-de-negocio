-- titulo: ¿Cuánto pesa el flete sobre el precio según la región del cliente?
-- tecnica: CASE para mapear estados a regiones, ratio de sumas (no promedio de ratios)
-- hallazgo: En el Norte y Nordeste el flete representa 22-23% del precio contra 15% en el Sudeste: ahí está el freno logístico al crecimiento regional.
-- grafico: bars region flete_sobre_precio_pct
with lineas as (
    select
        case
            when c.customer_state in ('SP', 'RJ', 'MG', 'ES') then 'Sudeste'
            when c.customer_state in ('PR', 'SC', 'RS') then 'Sur'
            when c.customer_state in ('DF', 'GO', 'MT', 'MS') then 'Centro-Oeste'
            when c.customer_state in ('BA', 'SE', 'AL', 'PE', 'PB', 'RN', 'CE', 'PI', 'MA') then 'Nordeste'
            else 'Norte'
        end as region,
        i.price,
        i.freight_value
    from order_items i
    join orders o using (order_id)
    join customers c using (customer_id)
    where o.order_status = 'delivered'
)
select
    region,
    count(*) as lineas,
    round(avg(freight_value), 2) as flete_promedio,
    round(100.0 * sum(freight_value) / sum(price), 1) as flete_sobre_precio_pct
from lineas
group by 1
order by flete_sobre_precio_pct desc
