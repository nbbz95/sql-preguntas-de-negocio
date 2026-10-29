-- titulo: ¿Cuánto cae la satisfacción según los días de atraso?
-- tecnica: buckets con CASE, deduplicación de reseñas con QUALIFY
-- hallazgo: Un atraso de más de 3 días baja la nota de 4,2 a menos de 2 y dispara las reseñas malas del 11% al 72-79%. Llegar a tiempo vale más que llegar antes.
-- grafico: bars entrega nota_promedio
with resenas as (
    select order_id, review_score
    from reviews
    qualify row_number() over (partition by order_id order by review_answer_timestamp desc) = 1
),
entregas as (
    select
        o.order_id,
        date_diff('day', o.order_estimated_delivery_date, o.order_delivered_customer_date) as dias_vs_estimado
    from orders o
    where o.order_status = 'delivered' and o.order_delivered_customer_date is not null
)
select
    case
        when dias_vs_estimado <= -7 then '1. Una semana antes o más'
        when dias_vs_estimado <= 0  then '2. A tiempo'
        when dias_vs_estimado <= 3  then '3. Hasta 3 días tarde'
        when dias_vs_estimado <= 10 then '4. De 4 a 10 días tarde'
        else '5. Más de 10 días tarde'
    end as entrega,
    count(*) as ordenes,
    round(avg(r.review_score), 2) as nota_promedio,
    round(100.0 * avg((r.review_score <= 2)::int), 1) as notas_malas_pct
from entregas e
join resenas r using (order_id)
group by 1
order by 1
