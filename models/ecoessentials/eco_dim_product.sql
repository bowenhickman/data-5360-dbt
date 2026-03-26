{{ config(
    materialized='table',
    schema='DW_ECOESSENTIALS'
) }}

select
    {{ dbt_utils.generate_surrogate_key(['PRODUCT_ID']) }} as product_key,
    PRODUCT_ID as product_id,
    PRODUCT_NAME as product_name,
    PRODUCT_TYPE as product_type
from {{ source('eco_landing1', 'PRODUCT') }}