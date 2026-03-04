{{ config(
    materialized = 'table',
    schema = 'dw_oliver'
) }}

select
    p.product_key,
    cu.cust_key,
    s.store_key,
    e.employee_key,
    d.date_key,
    ol.QUANTITY,
    (ol.QUANTITY * ol.UNIT_PRICE) as DOLLARS_SOLD,
    ol.UNIT_PRICE
from {{ source('oliver','orderline') }} ol

inner join {{ source('oliver','orders') }} o
    on ol.ORDER_ID = o.ORDER_ID

inner join {{ ref('oliver_dim_product') }} p
    on ol.PRODUCT_ID = p.PRODUCT_ID

inner join {{ ref('oliver_dim_customer') }} cu
    on o.CUSTOMER_ID = cu.CUSTOMER_ID

inner join {{ ref('oliver_dim_store') }} s
    on o.STORE_ID = s.STORE_ID

inner join {{ ref('oliver_dim_employee') }} e
    on o.EMPLOYEE_ID = e.EMPLOYEE_ID

inner join {{ ref('oliver_dim_date') }} d
    on d.date_day = cast(o.ORDER_DATE as date)