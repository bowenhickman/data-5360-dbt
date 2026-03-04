{{ config(
    materialized = 'table',
    schema = 'dw_oliver'
    )
}}

select
  CUSTOMER_ID as cust_key,
  CUSTOMER_ID,
  FIRST_NAME,
  LAST_NAME,
  EMAIL,
  PHONE_NUMBER,
  STATE
from {{ source('oliver','customer') }}