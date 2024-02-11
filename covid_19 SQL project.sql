## Covid 19 Data Exploration 
## Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

## Select data we are going to use
SELECT 
location, date, total_cases, new_cases, total_deaths, 
FROM
centering-sweep-399611.portfolio_project.covid_deaths
ORDER BY 1,2;

## Looking at Total Cases vs Total Deaths
SELECT 
location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS death_percentage
FROM
centering-sweep-399611.portfolio_project.covid_deaths
WHERE
location = 'Pakistan'
ORDER BY 1,2;

## Looking at Total Cases vs Population
## Shows what percentage of population got covid
SELECT 
location, date, total_cases, population, (total_cases/population)*100 AS percent_population_infected
centering-sweep-399611.portfolio_project.covid_deaths
WHERE
location = 'Pakistan'
ORDER BY 1,2;

## Countries with Highest Infection Rate compared to Population
SELECT 
location, population, MAX(total_cases) as highest_infection_count, MAX((total_cases/population))*100 AS percent_population_infected
FROM
centering-sweep-399611.portfolio_project.covid_deaths
GROUP BY location, population
ORDER BY percent_population_infected DESC;

##  Countries with Lowest Death Rate compared to Population
SELECT 
location, population, MIN(total_deaths) as lowest_death_count, MIN((total_deaths/population))*100 AS percent_population_death
FROM
centering-sweep-399611.portfolio_project.covid_deaths
GROUP BY location, population
ORDER BY percent_population_death DESC;

## Countries with Highest Death Count per Population
SELECT location, MAX(cast(total_deaths as int)) as total_death_count
FROM
centering-sweep-399611.portfolio_project.covid_deaths
WHERE continent is not null 
GROUP BY location
ORDER BY total_death_count DESC;

## BREAKING THINGS DOWN BY CONTINENT
## Showing contintents with the highest death count per population
SELECT continent, MAX(CAST(total_deaths as int)) as total_death_count
FROM
centering-sweep-399611.portfolio_project.covid_deaths
WHERE continent is not null 
GROUP BY continent
ORDER BY total_death_count DESC;

## GLOBAL NUMBERS
SELECT 
SUM(new_cases) as total_cases, SUM(CAST(new_deaths as int)) as total_deaths, SUM(CAST(new_deaths as int))/SUM(new_cases)*100 AS death_percentage
FROM
centering-sweep-399611.portfolio_project.covid_deaths
WHERE continent is not null 
-- GROUP BY date
ORDER BY 1,2;

## Total Population vs Vaccinations
## Shows Percentage of Population that has recieved at least one Covid Vaccine
SELECT 
deaths.continent, deaths.location, deaths.date, deaths.population, vaccinations.new_vaccinations,
SUM(CAST(vaccinations.new_vaccinations AS int64)) OVER (Partition by deaths.location ORDER BY deaths.location, deaths.date) AS rolling_people_vaccinated
## (rolling_people_vaccinated/population)*100
FROM
centering-sweep-399611.portfolio_project.covid_deaths AS deaths
JOIN 
centering-sweep-399611.portfolio_project.covid_vaccinations AS vaccinations
ON deaths.location = vaccinations.location
AND deaths.date = vaccinations.date
WHERE deaths.continent is not null
ORDER BY 2,3;

-- Using CTE to perform Calculation on Partition By in previous query
WITH pop_vs_vac(continent, location, date, population, new_vaccinations, rolling_people_vaccinated) AS
(
SELECT 
deaths.continent, deaths.location, deaths.date, deaths.population, vaccinations.new_vaccinations,
SUM(CAST(vaccinations.new_vaccinations AS int64)) OVER (PARTITION BY deaths.location ORDER BY deaths.date) AS rolling_people_vaccinated
FROM
centering-sweep-399611.portfolio_project.covid_deaths AS deaths
JOIN centering-sweep-399611.portfolio_project.covid_vaccinations AS vaccinations
ON deaths.location = vaccinations.location
AND deaths.date = vaccinations.date
WHERE deaths.continent IS NOT NULL
ORDER BY 2, 3 
)
SELECT *, (SUM(rolling_people_vaccinated) OVER (PARTITION BY location ORDER BY date) / population) * 100 AS percentage_vaccinated
FROM pop_vs_vac;

-- Using Temp Table to perform Calculation on Partition By in previous query
WITH percent_population_vaccinated AS (
SELECT 
deaths.continent, 
deaths.location, 
deaths.date, 
deaths.population, 
vaccinations.new_vaccinations,
SUM(CAST(vaccinations.new_vaccinations AS int64)) OVER (PARTITION BY deaths.location ORDER BY deaths.date) AS rolling_people_vaccinated
FROM
centering-sweep-399611.portfolio_project.covid_deaths AS deaths
JOIN 
centering-sweep-399611.portfolio_project.covid_vaccinations AS vaccinations
ON 
deaths.location = vaccinations.location
AND deaths.date = vaccinations.date
WHERE deaths.continent IS NOT NULL
)
-- Perform final calculation
SELECT 
*, 
(rolling_people_vaccinated / population) * 100 AS percent_population_vaccinated
FROM 
percent_population_vaccinated;