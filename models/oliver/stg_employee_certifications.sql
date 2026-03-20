{{ config(
    materialized = 'table',
    schema = 'dw_oliver'
) }}

with source_data as (

    select *
    from {{ source('oliver', 'employee_certifications') }}

),

parsed_data as (

    select
        employee_id,
        parse_json(certification_json):certification_name::string as certification_name,
        parse_json(certification_json):certification_cost::number(10,2) as certification_cost,
        parse_json(certification_json):certification_awarded_date::date as certification_awarded_date
    from source_data

)

select *
from parsed_data