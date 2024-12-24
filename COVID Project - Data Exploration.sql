/*
Covid 19 Data Exploration 

Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

*/

Select 
	*
From 
	PortfolioProject.dbo.Covid_Deaths
Where 
	continent IS NOT NULL AND total_cases!=0 AND population IS NOT NULL
order by country,date;


-------------------------------------------------------------------------------------------------------------

-- Data to be starting with

SELECT 
	country, date, total_cases, new_cases, total_deaths, population
FROM 
	PortfolioProject.dbo.Covid_Deaths
Where 
	continent IS NOT NULL AND total_cases!=0 AND population IS NOT NULL
order by country,date;


-------------------------------------------------------------------------------------------------------------

-- Total Cases VS Total deaths for India, 
-- Shows likelihood of dying if you contract COVID in India

SELECT 
	country,date,total_cases,total_deaths,
	CONCAT(ROUND((total_deaths/total_cases)*100,2),'%') AS DeathPercent
FROM 
	PortfolioProject.dbo.Covid_Deaths
WHERE 
	continent IS NOT NULL AND total_cases!=0 AND population IS NOT NULL AND country = 'India'
ORDER BY 
	country,date;


-------------------------------------------------------------------------------------------------------------

-- Total Cases VS Population, 
-- Shows percentage of population infected with COVID 

SELECT 
	country,date, population,total_cases, 
	CONCAT(ROUND((total_cases/population)*100,2),'%') AS PercentagePopInfected 
FROM 
	PortfolioProject.dbo.Covid_Deaths
WHERE 
	continent IS NOT NULL AND total_cases!=0 AND population!=0 
ORDER BY 
	country,date;


-------------------------------------------------------------------------------------------------------------

-- Countries and their Highest Infection Rate compared to Population

SELECT 
	country, population, 
	MAX(total_cases) AS TotalCases,
	CONCAT(MAX(ROUND((total_cases/population)*100,2)),'%') AS MaxPercentagePopInfected
FROM 
	PortfolioProject.dbo.Covid_Deaths
WHERE 
	continent IS NOT NULL AND total_cases!=0 AND population!=0 
GROUP BY 
	country, population
ORDER BY 
	MAX(ROUND((total_cases/population)*100,2)) DESC
	;


-------------------------------------------------------------------------------------------------------------

-- Countries and their Highest Death Count

SELECT 
	country, population, MAX(total_deaths) AS TotalDeathCount
FROM 
	PortfolioProject.dbo.Covid_Deaths
WHERE 
	continent IS NOT NULL AND total_cases!=0 AND population!=0 
GROUP BY 
	country, population
ORDER BY 
	TotalDeathCount DESC
	;


-------------------------------------------------------------------------------------------------------------

-- DATA BY CONTINENT
-- Countries and their Highest Death Count

SELECT 
	continent, SUM(population), SUM(TotalDeathCount) AS ContTotalDeathCount
FROM
	(
	SELECT 
		continent, country, population, MAX(total_deaths) AS TotalDeathCount
	FROM 
		PortfolioProject.dbo.Covid_Deaths
	WHERE 
		continent IS NOT NULL AND total_cases!=0 AND population!=0 
	GROUP BY 
		continent, country, population
	) AS CntDat
GROUP BY 
	continent
ORDER BY 
	ContTotalDeathCount DESC
	;


-------------------------------------------------------------------------------------------------------------

-- GLOBAL NUMBERS

SELECT
	SUM(new_cases) AS GlobalTotalCases, 
	SUM(new_deaths) AS GlobalDeaths, 
	CONCAT(ROUND(SUM(new_deaths)/SUM(new_cases)*100,2),'%') AS DeathPercent
FROM
	PortfolioProject.dbo.Covid_Deaths
WHERE 
	continent IS NOT NULL AND total_cases!=0 AND population!=0
--GROUP BY YEAR(date)
	;


-------------------------------------------------------------------------------------------------------------

-- Total Population vs Vaccinations
-- Shows No of Population that has recieved at least one Covid Vaccine

SELECT 
	CD.continent, CD.country,CD.date,CD.population,CV.new_vaccinations,
	SUM(ROUND(CONVERT(float, CV.new_vaccinations),0)) OVER(PARTITION BY CD.country ORDER BY CD.country,CD.date) AS RollingPeopleVaccinated
FROM 
	PortfolioProject.dbo.Covid_Deaths AS CD
	INNER JOIN 
	PortfolioProject.dbo.Covid_Vaccinations AS CV
	ON CD.country=CV.country AND CD.date=CV.date
WHERE 
	CD.continent IS NOT NULL AND CD.total_cases!=0 AND CD.population!=0 
ORDER BY 
	CD.country,CD.date
	;


-------------------------------------------------------------------------------------------------------------

-- Using CTE to perform to Show Total Vaccinations VS Population 

WITH CTE_PopVSVac(Continent, Country, Date,Population, New_Vac, RollingVaccinations ) AS 
(
SELECT 
	CD.continent, CD.country ,CD.date ,CD.population ,CV.new_vaccinations ,
	SUM(ROUND(CONVERT(float, CV.new_vaccinations),0)) OVER(PARTITION BY CD.country ORDER BY CD.country,CD.date) 
FROM 
	PortfolioProject.dbo.Covid_Deaths AS CD
	INNER JOIN 
	PortfolioProject.dbo.Covid_Vaccinations AS CV
	ON CD.country=CV.country AND CD.date=CV.date
WHERE 
	CD.continent IS NOT NULL AND CD.total_cases!=0 AND CD.population!=0 
)
SELECT Continent, Country, Date, Population, New_Vac, RollingVaccinations, 
	CASE WHEN RollingVaccinations IS NULL OR RollingVaccinations=0 THEN '0%' ELSE CONCAT(ROUND((RollingVaccinations/Population)*100,2),'%') END AS VaccbyPop
FROM 
	CTE_PopVSVac
	;


-------------------------------------------------------------------------------------------------------------

-- Temp Table to show percentage of Indian population vaccinncated and fully vaccinated over time

IF OBJECT_ID('tempdb..#PercPopVacc') IS NOT NULL
    DROP TABLE #PercPopVacc;
CREATE TABLE #PercPopVacc
(
Continent nvarchar(255),
Country nvarchar(255),
Date datetime,
Population numeric,
PeopleVaccinated INT,
RollingPeopleVaccinated INT,
PeopleFullyVaccinated INT,
RollingPeopleFullyVaccinated INT
)

INSERT INTO #PercPopVacc
SELECT 
	CD.continent, CD.country ,CD.date ,
	CONVERT(int,CD.population) , 
	CONVERT(int,CV.people_vaccinated),
	MAX(ROUND(CONVERT(float, CV.people_vaccinated),0)) OVER(PARTITION BY CD.country ORDER BY CD.country,CD.date) AS RollingPeopleVaccinated,
	CV.people_fully_vaccinated,
	MAX(ROUND(CONVERT(float, CV.people_fully_vaccinated),0)) OVER(PARTITION BY CD.country ORDER BY CD.country,CD.date) AS RollingPeopleFullyVaccinated
FROM 
	PortfolioProject.dbo.Covid_Deaths AS CD
	INNER JOIN 
	PortfolioProject.dbo.Covid_Vaccinations AS CV
	ON CD.country=CV.country AND CD.date=CV.date
WHERE 
	CD.continent IS NOT NULL AND CD.total_cases!=0 AND CD.population!=0 AND CD.country='India'

SELECT *, 
	CASE WHEN RollingPeopleVaccinated IS NOT NULL OR RollingPeopleVaccinated!=0 THEN CONCAT(CONVERT(Float,ROUND((RollingPeopleVaccinated/Population)*100,2)),'%') ELSE '0%' END AS PerPopVac,
	CASE WHEN RollingPeopleFullyVaccinated IS NOT NULL OR RollingPeopleFullyVaccinated!=0 THEN CONCAT(CONVERT(Float,ROUND((RollingPeopleFullyVaccinated/Population)*100,2)),'%') ELSE '0%' END AS PerPopFulVac
FROM 
	#PercPopVacc;

-------------------------------------------------------------------------------------------------------------

-- Creating View to store data for later visualizations

IF OBJECT_ID('PercentPopulationVaccinated', 'V') IS NOT NULL
    DROP VIEW PercentPopulationVaccinated;
CREATE VIEW PercentPopulationVaccinated AS
SELECT 
	CD.continent AS Continent, CD.country AS Country,CD.date AS Date,
	CONVERT(int,CD.population) AS Population, 
	MAX(ROUND(CONVERT(float, CV.people_vaccinated),0)) OVER(PARTITION BY CD.country ORDER BY CD.country,CD.date) AS RollingPeopleVaccinated,
	MAX(ROUND(CONVERT(float, CV.people_fully_vaccinated),0)) OVER(PARTITION BY CD.country ORDER BY CD.country,CD.date) AS RollingPeopleFullyVaccinated
FROM 
	PortfolioProject.dbo.Covid_Deaths AS CD
	INNER JOIN 
	PortfolioProject.dbo.Covid_Vaccinations AS CV
	ON CD.country=CV.country AND CD.date=CV.date
WHERE 
	CD.continent IS NOT NULL AND CD.total_cases!=0 AND CD.population!=0
