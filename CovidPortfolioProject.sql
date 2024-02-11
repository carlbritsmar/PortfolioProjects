SELECT location, date, total_cases, new_cases, total_deaths,population
FROM PortfolioProject.CovidDeaths
ORDER BY 1, 2;

-- Looking at Total Cases VS Total Deaths
-- Shows likelihood of survival if you contract covid

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 AS DeathPercentage
FROM PortfolioProject.CovidDeaths
WHERE location = 'Sweden'
ORDER BY 1, 2;


-- Looking at total cases vs population
-- Shows what percentage of population got covid
SELECT location, date, total_cases, total_deaths, population, (total_cases/population) * 100 AS percentageOfPopulationWithCovid
FROM PortfolioProject.CovidDeaths
WHERE location = 'Sweden'
ORDER BY 1, 2;

-- Looking at countries with highest infection rate compared to population

SELECT location,population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population)) * 100 AS MaxPercentPopulationInfected
FROM PortfolioProject.CovidDeaths
WHERE continent IS NOT NULL
GROUP BY  location, population
ORDER BY MaxPercentPopulationInfected DESC;

-- Showing countries with highest death count per capita

SELECT location, MAX(total_deaths) AS TotalDeaths
FROM PortfolioProject.CovidDeaths
WHERE continent IS NOT NULL
GROUP BY  location
ORDER BY TotalDeaths desc;

-- Showing continents with the highest death count per capita
SELECT location, MAX(total_deaths) AS TotalDeaths
FROM PortfolioProject.CovidDeaths
WHERE continent IS NULL
GROUP BY  location
ORDER BY TotalDeaths desc;

-- Global numbers by date
SELECT date, SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_deaths, SUM(new_deaths)/ SUM(new_cases)* 100 AS DeathPercentage
FROM PortfolioProject.CovidDeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1, 2;

-- Global numbers in total
SELECT SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_deaths, SUM(new_deaths)/ SUM(new_cases)* 100 AS DeathPercentage
FROM PortfolioProject.CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1, 2;

-- Looking at total population vs vaccinations using CTE


WITH PopulationVsVaccinated (continent, location, date, population, new_vaccinations, CumulativePeopleVaccinated)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS CumulativePeopleVaccinated
FROM PortfolioProject.CovidDeaths dea
JOIN PortfolioProject.CovidVaccinations vac
ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
)
SELECT *, (CumulativePeopleVaccinated/population) * 100 FROM PopulationVsVaccinated;



-- DROP Table IF EXISTS PercentPopulationVaccinated; TODO temptable

-- Creating View to store data for later visualizations
CREATE VIEW PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date)
AS CumulativePeopleVaccinated
FROM PortfolioProject.CovidDeaths dea
JOIN PortfolioProject.CovidVaccinations vac
ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent IS NOT NULL;

SELECT * FROM PercentPopulationVaccinated