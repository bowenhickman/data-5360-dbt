{{ config(
    materialized = 'table',
    schema = 'dw_oliver'
    )
}}

select
  EMPLOYEE_ID as employee_key,
  EMPLOYEE_ID,
  FIRST_NAME,
  LAST_NAME,
  EMAIL,
  PHONE_NUMBER,
  HIRE_DATE,
  POSITION
from {{ source('oliver','employee') }}