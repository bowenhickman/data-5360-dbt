{{ config(
    materialized='table',
    schema='DW_ECOESSENTIALS'
) }}

with transactional_customers as (
    select
        CUSTOMER_ID,
        CUSTOMER_FIRST_NAME,
        CUSTOMER_LAST_NAME,
        CUSTOMER_EMAIL,
        CUSTOMER_PHONE,
        CUSTOMER_ADDRESS,
        CUSTOMER_CITY,
        CUSTOMER_STATE,
        CUSTOMER_ZIP,
        CUSTOMER_COUNTRY
    from {{ source('eco_landing1', 'CUSTOMER') }}
),

marketing_customers as (
    select distinct
        SUBSCRIBERID,
        SUBSCRIBERFIRSTNAME,
        SUBSCRIBERLASTNAME,
        SUBSCRIBEREMAIL
    from {{ source('eco_landing2', 'MARKETINGEMAILS') }}
)

select distinct
    {{ dbt_utils.generate_surrogate_key([
        "coalesce(cast(t.CUSTOMER_ID as varchar), cast(m.SUBSCRIBERID as varchar))",
        "coalesce(t.CUSTOMER_EMAIL, m.SUBSCRIBEREMAIL)",
        "coalesce(t.CUSTOMER_FIRST_NAME, m.SUBSCRIBERFIRSTNAME)",
        "coalesce(t.CUSTOMER_LAST_NAME, m.SUBSCRIBERLASTNAME)"
    ]) }} as customer_key,
    t.CUSTOMER_ID as customer_id,
    m.SUBSCRIBERID as subscriber_id,
    coalesce(t.CUSTOMER_FIRST_NAME, m.SUBSCRIBERFIRSTNAME) as customer_first_name,
    coalesce(t.CUSTOMER_LAST_NAME, m.SUBSCRIBERLASTNAME) as customer_last_name,
    coalesce(t.CUSTOMER_EMAIL, m.SUBSCRIBEREMAIL) as customer_email,
    t.CUSTOMER_PHONE as customer_phone,
    t.CUSTOMER_ADDRESS as customer_address,
    t.CUSTOMER_CITY as customer_city,
    t.CUSTOMER_STATE as customer_state,
    t.CUSTOMER_ZIP as customer_zip,
    t.CUSTOMER_COUNTRY as customer_country
from transactional_customers t
full outer join marketing_customers m
    on upper(trim(t.CUSTOMER_EMAIL)) = upper(trim(m.SUBSCRIBEREMAIL))
where coalesce(t.CUSTOMER_EMAIL, m.SUBSCRIBEREMAIL) is not null