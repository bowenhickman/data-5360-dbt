{{ config(
    materialized = 'table',
    schema = 'dw_oliver'
    )
}}

select
    c.FIRST_NAME as customer_first_name,
    c.LAST_NAME as customer_last_name,
    d.date_day,
    d.month_name,
    d.year_number,
    st.STORE_NAME,
    st.CITY as store_city,
    st.STATE as store_state,
    p.PRODUCT_NAME,
    e.FIRST_NAME as employee_first_name,
    e.LAST_NAME as employee_last_name,
    e.POSITION,
    f.QUANTITY,
    f.UNIT_PRICE,
    f.DOLLARS_SOLD
from {{ ref('fact_sales') }} f

left join {{ ref('oliver_dim_customer') }} c
    on f.cust_key = c.cust_key

left join {{ ref('oliver_dim_store') }} st
    on f.store_key = st.store_key

left join {{ ref('oliver_dim_product') }} p
    on f.product_key = p.product_key

left join {{ ref('oliver_dim_employee') }} e
    on f.employee_key = e.employee_key

left join {{ ref('oliver_dim_date') }} d
    on f.date_key = d.date_key