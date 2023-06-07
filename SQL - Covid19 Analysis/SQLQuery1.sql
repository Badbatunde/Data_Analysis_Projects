--Temp Table

DROP TABLE IF EXISTS #vaccinatedPopulationPercent
CREATE TABLE #vaccinatedPopulationPercent
(
continent VARCHAR(255),
location VARCHAR(255),
date datetime,
population numeric,
new_vaccinations numeric,
locationVaccineSum numeric
)

INSERT INTO #vaccinatedPopulationPercent
SELECT dth.continent, dth.location, dth.date, dth.population, vcn.new_vaccinations,
	SUM(CONVERT(int, vcn.new_vaccinations)) OVER (
												PARTITION BY dth.location
												ORDER BY dth.location, dth.date
												) AS locationVaccineSum
FROM PortfolioProject..CovidDeaths dth
	JOIN PortfolioProject..CovidVaccinations vcn
		ON dth.location = vcn.location
		AND dth.date = vcn.date
WHERE dth.continent IS NOT NULL;

SELECT *, (locationVaccineSum/population)*100
FROM #vaccinatedPopulationPercent;


SELECT *
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 3, 4;

--SELECT *
--FROM PortfolioProject..CovidVaccinations
--ORDER BY 3, 4;

--Selecting Data
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1,2

--Total Cases vs Total Deaths

SELECT location, date, total_cases, total_deaths, ROUND(((total_deaths/total_cases)*100), 2) AS death_percent
FROM PortfolioProject..CovidDeaths
WHERE location = 'Nigeria'
AND continent IS NOT NULL
ORDER BY 1,2;


--Total Cases vs Population

SELECT location, date, population, total_cases, ROUND(((total_cases/population)*100), 2) AS cases_percent
FROM PortfolioProject..CovidDeaths
WHERE location = 'Nigeria'
AND continent IS NOT NULL
ORDER BY 1,2;


--Countries with highest Covid case vs Population

SELECT location, population, MAX(total_cases) AS highestCases, MAX((total_cases/population)*100) AS highest_cases_percent
FROM PortfolioProject..CovidDeaths
--WHERE location = 'Nigeria'
GROUP BY location, population
ORDER BY 4 DESC;


--Countries with highest Covid death vs Population

SELECT location, MAX(CAST(total_deaths AS int)) AS totalDeath
FROM PortfolioProject..CovidDeaths
--WHERE location = 'Nigeria'
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY totalDeath DESC;


--BY CONTINENT
--Continents with highest deaths

SELECT continent, MAX(CAST(total_deaths AS int)) AS totalDeath
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY totalDeath DESC;


--Deaths per day accross the world

SELECT date, SUM(new_cases) as totalCase, SUM(CAST(total_deaths AS int)) AS totalDeath, SUM(CAST(new_deaths AS int))/SUM(new_cases)*100 AS deathPercent
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1,2;


--Percentage of new cases to total deaths
SELECT SUM(new_cases) as totalCase, SUM(CAST(total_deaths AS int)) AS totalDeath, SUM(CAST(new_deaths AS int))/SUM(new_cases)*100 AS deathPercent
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1,2;


--JOINING TABLES

SELECT *
FROM PortfolioProject..CovidDeaths dth
	JOIN PortfolioProject..CovidVaccinations vcn
		ON dth.location = vcn.location
		AND dth.date = vcn.date;


--Total Population vs Vaccination

SELECT dth.continent, dth.location, dth.date, dth.population, vcn.new_vaccinations
FROM PortfolioProject..CovidDeaths dth
	JOIN PortfolioProject..CovidVaccinations vcn
		ON dth.location = vcn.location
		AND dth.date = vcn.date
WHERE dth.continent IS NOT NULL
ORDER BY 2, 3;


--Total Population vs Vaccination by location

SELECT dth.continent, dth.location, dth.date, dth.population, vcn.new_vaccinations,
	SUM(CONVERT(int, vcn.new_vaccinations)) OVER (
												PARTITION BY dth.location
												ORDER BY dth.location, dth.date
												) AS locationVaccineSum
FROM PortfolioProject..CovidDeaths dth
	JOIN PortfolioProject..CovidVaccinations vcn
		ON dth.location = vcn.location
		AND dth.date = vcn.date
WHERE dth.continent IS NOT NULL
ORDER BY 2, 3;


--Using CTE

WITH popVsVac (continent, location, date, population, new_vaccinations, locationVaccineSum) AS (
	SELECT dth.continent, dth.location, dth.date, dth.population, vcn.new_vaccinations,
	SUM(CONVERT(int, vcn.new_vaccinations)) OVER (
												PARTITION BY dth.location
												ORDER BY dth.location, dth.date
												) AS locationVaccineSum
FROM PortfolioProject..CovidDeaths dth
	JOIN PortfolioProject..CovidVaccinations vcn
		ON dth.location = vcn.location
		AND dth.date = vcn.date
WHERE dth.continent IS NOT NULL
)
SELECT *, (locationVaccineSum/population)*100
FROM popVsVac;


--Temp Table

DROP TABLE IF EXISTS #vaccinatedPopulationPercent
CREATE TABLE #vaccinatedPopulationPercent
(
continent VARCHAR(255),
location VARCHAR(255),
date datetime,
population numeric,
new_vaccinations numeric,
locationVaccineSum numeric
)

INSERT INTO #vaccinatedPopulationPercent
SELECT dth.continent, dth.location, dth.date, dth.population, vcn.new_vaccinations,
	SUM(CONVERT(int, vcn.new_vaccinations)) OVER (
												PARTITION BY dth.location
												ORDER BY dth.location, dth.date
												) AS locationVaccineSum
FROM PortfolioProject..CovidDeaths dth
	JOIN PortfolioProject..CovidVaccinations vcn
		ON dth.location = vcn.location
		AND dth.date = vcn.date
WHERE dth.continent IS NOT NULL;

SELECT *, (locationVaccineSum/population)*100 AS populationVcnPercent
FROM #vaccinatedPopulationPercent;


--Create view for visualization

CREATE VIEW vaccinatedPopuPercent AS
SELECT dth.continent, dth.location, dth.date, dth.population, vcn.new_vaccinations,
	SUM(CONVERT(int, vcn.new_vaccinations)) OVER (
												PARTITION BY dth.location
												ORDER BY dth.location, dth.date
												) AS locationVaccineSum
FROM PortfolioProject..CovidDeaths dth
	JOIN PortfolioProject..CovidVaccinations vcn
		ON dth.location = vcn.location
		AND dth.date = vcn.date
WHERE dth.continent IS NOT NULL;

SELECT *
FROM vaccinatedPopuPercent;