# Eco Essentials End-to-End Cloud Data Warehouse & Marketing Attribution Analytics

## Project Overview

This project demonstrates the design and implementation of a modern cloud data warehouse for Eco Essentials, an eco-friendly cookware company. The objective was to transform raw operational data from multiple source systems into a scalable dimensional warehouse that supports executive reporting, marketing attribution analysis, and business decision-making.

The project followed the full data warehousing lifecycle:

- Enterprise dimensional modeling
- ELT pipeline development
- Cloud warehouse implementation
- Data quality testing
- Automated scheduling and refresh
- Live business intelligence dashboard development
- Executive presentation and stakeholder communication

This project was completed as a two-person consulting team using Snowflake, dbt Cloud, Fivetran, Tableau, AWS, and GitHub.

---

## Business Problem

Eco Essentials needed improved visibility into two critical business processes:

### 1. Sales Performance

Leadership wanted to track:

- Revenue trends over time
- Product-level sales performance
- Top customers by total spend
- Promotion and discount effectiveness

### 2. Marketing Email Conversion

Leadership also needed to understand:

- Which marketing campaigns generated the most engagement
- Which campaigns converted into actual sales
- Revenue performance compared to email activity
- Marketing attribution across promotional campaigns

The goal was to create a single source of truth for both operational sales and marketing conversion reporting.

---

## Data Sources

### Source System 1: Transactional Sales Database

**Platform:** AWS RDS PostgreSQL  
**Access Tool:** DBeaver + Fivetran

Core tables included:

- customer
- order
- order_line
- product
- promotional_campaign

This system supported all online purchase activity.

---

### Source System 2: Salesforce Marketing Cloud Email Events

**Platform:** AWS S3 Bucket  
**Access Tool:** Fivetran

CSV source:

- marketing_emails.csv

This dataset included:

- sends
- opens
- clicks
- subscribers
- campaigns
- event timestamps

This system supported marketing attribution analysis.

---

## Architecture Overview

AWS RDS PostgreSQL + AWS S3  
↓  
Fivetran  
↓  
Snowflake Landing  
↓  
dbt Cloud  
↓  
Dimensional Warehouse (Dimensions + Fact Tables)  
↓  
Tableau Live Dashboard  
↓  
Executive Decision Making

---

## Dimensional Warehouse Design

We designed a star-schema-based enterprise warehouse using Kimball dimensional modeling principles.

### Business Processes

### Sales Fact

**Grain:** One row per product per order (order-line level)

### Email Engagement Fact

**Grain:** One row per email event per subscriber

---

## Core Fact Tables

### eco_fact_sale

Measures:

- quantity
- unit_price
- discount_amount
- total_price
- price_after_discount

---

### eco_fact_emailevent

Factless fact structure used to track:

- send events
- open events
- click events

This supports campaign attribution and conversion analysis.

---

## Core Dimension Tables

- eco_dim_customer
- eco_dim_product
- eco_dim_campaign
- eco_dim_date
- eco_dim_time
- eco_dim_email
- eco_dim_eventtype

Conformed dimensions were used across both business processes to maintain reporting consistency.

---

## Key Design Improvements

During model refinement, we improved the warehouse design by:

- Removing the unnecessary dim_order table and storing order_id directly in fact_sale
- Removing dim_geography and embedding geography fields directly into dim_customer
- Converting dim_time into a conformed dimension across both fact tables

This improved simplicity, performance, and maintainability while preserving analytical flexibility.

---

## ELT Development with dbt

Using dbt Cloud, we transformed raw landing tables into production-ready dimensional models.

### Key dbt Features Used

- staging models
- dimension models
- fact models
- surrogate key generation
- schema testing
- dependency management
- model scheduling

### Example Surrogate Key Logic

```sql
{{ dbt_utils.generate_surrogate_key([
    'customer_id',
    'subscriber_id'
]) }}

This ensured consistent joins between dimensions and facts while preserving warehouse integrity.

---

## Data Quality Testing

To improve warehouse reliability, dbt tests were implemented across all models.

### Tests Used

- unique
- not_null
- accepted_values
- relationships

These tests ensured:

- primary key integrity
- referential integrity
- valid categorical values
- production-safe model refreshes

This mirrors real-world production analytics engineering workflows.

---

## Scheduling & Automation

Production-style automation was implemented using both Fivetran and dbt Cloud.

### Fivetran

Both source connectors were scheduled to refresh every 24 hours.

### dbt Cloud

A scheduled job was created to:

- rebuild all dimensions
- rebuild all fact tables
- execute all dbt tests

This created a fully refreshed reporting environment daily without manual intervention.

---

## Tableau Dashboard

A live Tableau dashboard was connected directly to Snowflake for executive reporting.

### Dashboard Focus Areas

### Revenue Compared to Emails Sent

This visual compared marketing email activity against generated revenue over time to identify campaign performance patterns.

### Top Campaigns by Revenue

This visualization identified which promotional campaigns generated the highest revenue contribution.

Highlighted campaigns included:

- Newsletter Subscriber Special
- New Customer Welcome
- Kitchen Essentials
- Holiday Gift Collection
- Father’s Day
- Seasonal Clearance

This allowed leadership to quickly identify high-performing campaigns and improve future marketing investment decisions.

---

## Business Questions Answered

### 1. Who are the top customers by total spend?

We identified the top 10 customers by total dollars spent using aggregated `price_after_discount`.

This helps leadership prioritize retention and loyalty strategies.

### 2. Which promotional campaign generated the highest quantity of sales?

Campaign performance was analyzed using total product quantity sold.

Top performers included:

- Eco Chef Starter Kit
- Holiday Gift Collection
- New Customer Welcome
- Newsletter Subscriber Special

This improved promotion strategy and campaign prioritization.

### 3. Which products generated the most revenue after discounts?

Top revenue-generating products included:

- Bamboo Handle Ceramic Dutch Oven – 5 qt
- Handcrafted Copper Sauté Pan
- Ceramic Slow Cooker with Bamboo Exterior
- Solar-Forged Cast Iron Paella Pan

This supports inventory planning and product investment decisions.

---

## Technical Challenges Solved

Several realistic engineering issues were resolved during development:

- duplicate dbt YAML model conflicts
- relationship test failures
- Snowflake schema mismatches
- fact/dimension join issues
- unnecessary dimension design complexity
- conformed dimension restructuring
- validation of surrogate key consistency

These were some of the most valuable parts of the project because they mirrored actual production analytics engineering work.

---

## Repository Structure

```text
data-5360-dbt/
│
├── analyses/
├── macros/
├── models/
│   └── ecoessentials/
│       ├── dimensions
│       ├── facts
│       ├── staging
│       └── schema.yml
│
├── seeds/
├── snapshots/
├── tests/
│
├── dbt_project.yml
├── packages.yml
└── README.md
