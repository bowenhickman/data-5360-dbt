{{ config(
    materialized = 'table',
    schema = 'dw_oliver'
) }}

with stg_employee_certifications as (

    select *
    from {{ ref('stg_employee_certifications') }}

),

oliver_dim_employee as (

    select *
    from {{ ref('oliver_dim_employee') }}

),

oliver_dim_date as (

    select *
    from {{ ref('oliver_dim_date') }}

)

select
    d.date_key,
    e.employee_key,
    s.certification_name,
    s.certification_cost
from stg_employee_certifications s
join oliver_dim_employee e
    on s.employee_id = e.employee_id
join oliver_dim_date d
    on s.certification_awarded_date = d.date_day