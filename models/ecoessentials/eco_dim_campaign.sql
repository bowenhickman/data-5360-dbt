{{ config(
    materialized='table',
    schema='DW_ECOESSENTIALS'
) }}

select
    {{ dbt_utils.generate_surrogate_key(['CAMPAIGN_ID']) }} as campaign_key,
    CAMPAIGN_ID as campaign_id,
    CAMPAIGN_NAME as campaign_name,
    CAMPAIGN_DISCOUNT as campaign_discount
from {{ source('eco_landing1', 'PROMOTIONAL_CAMPAIGN') }}