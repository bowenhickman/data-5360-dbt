{{ config(
    materialized='table',
    schema='DW_ECOESSENTIALS'
) }}

select
    e.email_key,
    camp.campaign_key,
    c.customer_key,
    send_d.date_key as send_date_key,
    event_d.date_key as event_date_key,
    send_t.time_key as send_time_key,
    event_t.time_key as event_time_key,
    et.eventtype_key
from {{ source('eco_landing2', 'MARKETINGEMAILS') }} m
left join {{ ref('eco_dim_email') }} e
    on m.EMAILID = e.email_id
left join {{ ref('eco_dim_campaign') }} camp
    on m.CAMPAIGNID = camp.campaign_id
left join {{ ref('eco_dim_customer') }} c
    on upper(trim(m.SUBSCRIBEREMAIL)) = upper(trim(c.customer_email))
left join {{ ref('eco_dim_date') }} send_d
    on cast(m.SENDTIMESTAMP as date) = send_d.date_day
left join {{ ref('eco_dim_date') }} event_d
    on cast(m.EVENTTIMESTAMP as date) = event_d.date_day
left join {{ ref('eco_dim_time') }} send_t
    on date_part(hour, m.SENDTIMESTAMP) = send_t.hour_number
   and date_part(minute, m.SENDTIMESTAMP) = send_t.minute_number
left join {{ ref('eco_dim_time') }} event_t
    on date_part(hour, m.EVENTTIMESTAMP) = event_t.hour_number
   and date_part(minute, m.EVENTTIMESTAMP) = event_t.minute_number
left join {{ ref('eco_dim_eventtype') }} et
    on m.EVENTTYPE = et.eventtype
where m.EMAILID is not null