{{ config(
    materialized='table',
    schema='DW_ECOESSENTIALS'
) }}

select distinct
    {{ dbt_utils.generate_surrogate_key(['EMAILID']) }} as email_key,
    EMAILID as email_id,
    EMAILNAME as email_name
from {{ source('eco_landing2', 'MARKETINGEMAILS') }}
where EMAILID is not null