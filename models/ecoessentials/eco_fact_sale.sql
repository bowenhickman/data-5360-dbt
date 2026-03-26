{{ config(
    materialized='table',
    schema='DW_ECOESSENTIALS'
) }}

select
    d.date_key,
    t.time_key,
    p.product_key,
    c.customer_key,
    camp.campaign_key,
    o.ORDER_ID as order_id,
    ol.ORDER_LINE_ID as order_line_id,
    ol.QUANTITY as quantity,
    ol.DISCOUNT as discount,
    ol.PRICE_AFTER_DISCOUNT as price_after_discount
from {{ source('eco_landing1', 'ORDER') }} o
join {{ source('eco_landing1', 'ORDER_LINE') }} ol
    on o.ORDER_ID = ol.ORDER_ID
left join {{ ref('eco_dim_campaign') }} camp
    on ol.CAMPAIGN_ID = camp.campaign_id
join {{ ref('eco_dim_customer') }} c
    on o.CUSTOMER_ID = c.customer_id
join {{ ref('eco_dim_product') }} p
    on ol.PRODUCT_ID = p.product_id
join {{ ref('eco_dim_date') }} d
    on cast(o.ORDER_TIMESTAMP as date) = d.date_day
join {{ ref('eco_dim_time') }} t
    on date_part(hour, o.ORDER_TIMESTAMP) = t.hour_number
   and date_part(minute, o.ORDER_TIMESTAMP) = t.minute_number