# COVID-DATA-ANALYTICS
COVID-19 Data Exploration Repository


Overview:

This repository contains SQL scripts for analyzing COVID-19 data, utilizing techniques such as joins, common table expressions (CTEs), temporary tables, window functions, aggregate functions, and data type conversions. The analysis includes comparisons of total cases, deaths, vaccinations, and population impacts to gain insights into the effects of COVID-19 globally and within specific countries.


Key Features:

Data Filtering and Transformation:

Filter data by valid records (e.g., non-null continents and non-zero cases).
Convert and format data for meaningful presentation (e.g., percentages of population infected or vaccinated).


Country-Level Analysis:

India Example: Likelihood of death upon infection and population percentage infected.
Highest infection and death rates by country.
Dynamic percentage metrics using aggregate and window functions.


Continental Insights:
Summarize data by continent, showing cumulative deaths and populations.
Enable region-level perspectives on the pandemic’s impacts.


Global Metrics:
Calculate overall global cases, deaths, and fatality rates.
Monitor vaccination rollouts compared to the global population.


Advanced SQL Techniques:

CTEs and Temp Tables: Analyze vaccination progression dynamically for India and globally.
View Creation: Persistent views to simplify visualization tasks in tools like Power BI or Tableau.


Vaccination Analysis:

Track total vaccinations and percentages of vaccinated and fully vaccinated populations for individual countries and continents.


Skills Used:

SQL Techniques: Joins, Common Table Expressions (CTEs), Window Functions, Temporary Tables.
Data Wrangling: Aggregate functions, data type conversions, percentage calculations.
View Creation: This is for optimized and reusable data visualization preparation.


Dataset:

The dataset used for analysis includes:
COVID-19 deaths and case counts.
Vaccination data per country over time.
Population metrics.

https://docs.owid.io/projects/etl/api/covid/
https://ourworldindata.org/covid-deaths
