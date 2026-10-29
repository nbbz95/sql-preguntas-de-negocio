-- titulo: ¿En qué estados se entrega tarde con más frecuencia?
-- tecnica: tasa con AVG de un booleano, filtro de volumen mínimo con HAVING
-- hallazgo: El Nordeste concentra los peores atrasos (Maranhão casi 1 de cada 5 órdenes) y Río de Janeiro aparece con 13,5% pese a su volumen.
select
    c.customer_state as estado,
    count(*) as ordenes,
    round(100.0 * avg((o.order_delivered_customer_date > o.order_estimated_delivery_date)::int), 1) as tarde_pct,
    round(avg(date_diff('day', o.order_purchase_timestamp, o.order_delivered_customer_date)), 1) as dias_entrega_prom
from orders o
join customers c using (customer_id)
where o.order_status = 'delivered'
  and o.order_delivered_customer_date is not null
group by 1
having count(*) >= 500
order by tarde_pct desc
limit 10
