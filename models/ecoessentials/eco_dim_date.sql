{{ config(
    materialized='table',
    schema='DW_ECOESSENTIALS'
) }}

with recursive dates as (
    select to_date('1990-01-01') as date_day
    union all
    select dateadd(day, 1, date_day)
    from dates
    where date_day < to_date('2050-12-31')
)

select
    date_day as date_key,
    date_day,
    dayofweek(date_day) as day_of_week,
    dayname(date_day) as day_name,
    dayofmonth(date_day) as day_of_month,
    dayofyear(date_day) as day_of_year,
    week(date_day) as week_of_year,
    month(date_day) as month_of_year,
    monthname(date_day) as month_name,
    quarter(date_day) as quarter_of_year,
    year(date_day) as year_number
from dates