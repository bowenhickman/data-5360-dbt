{{ config(
    materialized='table',
    schema='DW_ECOESSENTIALS'
) }}

select distinct
    {{ dbt_utils.generate_surrogate_key(['EVENTTYPE']) }} as eventtype_key,
    EVENTTYPE as eventtype
from {{ source('eco_landing2', 'MARKETINGEMAILS') }}
where EVENTTYPE is not null