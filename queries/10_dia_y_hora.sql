-- titulo: ¿Qué días y franjas horarias concentran las compras?
-- tecnica: extracción de partes de fecha, pivot condicional con FILTER
-- hallazgo: Las compras se concentran de lunes a miércoles por la tarde y la noche; el fin de semana cae alrededor de un 25%. Es el horario para campañas y soporte.
select
    isodow(order_purchase_timestamp) || '. ' || ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'][isodow(order_purchase_timestamp)] as dia,
    count(*) as ordenes,
    count(*) filter (where hour(order_purchase_timestamp) between 0 and 5)   as madrugada,
    count(*) filter (where hour(order_purchase_timestamp) between 6 and 11)  as manana,
    count(*) filter (where hour(order_purchase_timestamp) between 12 and 17) as tarde,
    count(*) filter (where hour(order_purchase_timestamp) between 18 and 23) as noche
from orders
group by 1
order by 1
