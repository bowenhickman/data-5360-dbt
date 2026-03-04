{{ config(
    materialized = 'table',
    schema = 'dw_oliver'
    )
}}

select
  STORE_ID as store_key,
  STORE_ID,
  STORE_NAME,
  STREET,
  CITY,
  STATE
from {{ source('oliver','store') }}