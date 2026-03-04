{{ config(
    materialized = 'table',
    schema = 'dw_oliver'
    )
}}

select
  PRODUCT_ID as product_key,
  PRODUCT_ID,
  PRODUCT_NAME,
  DESCRIPTION
from {{ source('oliver','product') }}