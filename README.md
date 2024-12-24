# COVID-DATA-ANALYTICS
## Overview
This repository contains SQL scripts for exploring and analyzing COVID-19 data. Key techniques include joins, common table expressions (CTEs), temporary tables, window functions, aggregate functions, and data type conversions. The analysis focuses on understanding the global and country-specific impacts of COVID-19, covering cases, deaths, vaccinations, and population metrics.

---

## Key Features

### 1. **Data Filtering and Transformation**
- Filtered out invalid or incomplete data (e.g., records with null continents or zero cases).
- Standardized and formatted metrics, such as calculating percentages of the population infected or vaccinated.

### 2. **Country-Level Analysis**
- **India**: Examined the likelihood of death upon infection and the percentage of the population infected.
- Identified countries with the highest infection and death rates.
- Computed dynamic metrics using aggregate and window functions.

### 3. **Continental Insights**
- Summarized cumulative deaths and populations by continent.
- Provided a region-based perspective on the pandemic’s impact.

### 4. **Global Metrics**
- Calculated total global cases, deaths, and fatality rates.
- Monitored worldwide vaccination rollouts and their relationship to population metrics.

### 5. **Vaccination Analysis**
- Tracked vaccination progress by country and continent.
- Calculated percentages of vaccinated and fully vaccinated populations over time.

### 6. **Advanced SQL Techniques**
- **CTEs and Temporary Tables**: Analyzed vaccination progression dynamically for India and global metrics.
- **View Creation**: Built persistent views to facilitate visualization in tools like Power BI or Tableau.

---

## Skills Demonstrated
- **SQL Techniques**: Joins, Common Table Expressions (CTEs), Temporary Tables, and Window Functions.
- **Data Wrangling**: Aggregation, data type conversions, and percentage calculations.
- **Visualization Preparation**: Created reusable views for downstream analytics.

---

## Dataset Information
The analysis relies on COVID-19 data sourced from:
- [Our World in Data (OWID) COVID-19 Deaths](https://ourworldindata.org/covid-deaths)
- [OWID COVID-19 ETL API](https://docs.owid.io/projects/etl/api/covid/)

This dataset includes:
- Daily COVID-19 case and death counts.
- Vaccination data for each country over time.
- Population metrics for comparative analysis.

---

## How to Use
1. Clone this repository:
   ```bash
   git clone https://github.com/your-username/covid-data-analytics.git
