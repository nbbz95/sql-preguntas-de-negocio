-- titulo: ¿Cómo pagan los clientes y en cuántas cuotas?
-- tecnica: participación con ventana, promedio ponderado
-- hallazgo: La tarjeta de crédito mueve el 78% del monto con un promedio ponderado de 5 cuotas: la financiación es parte de la propuesta de valor.
select
    payment_type as medio,
    count(distinct order_id) as ordenes,
    round(100.0 * sum(payment_value) / sum(sum(payment_value)) over (), 1) as share_monto_pct,
    round(sum(payment_installments * payment_value) / sum(payment_value), 1) as cuotas_ponderadas,
    round(avg(payment_value), 2) as monto_promedio
from payments
where payment_type <> 'not_defined'
group by 1
order by share_monto_pct desc
