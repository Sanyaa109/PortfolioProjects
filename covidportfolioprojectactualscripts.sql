--SELECT * FROM ..CovidDeaths
--ORDER BY 3,4

--SELECT * FROM ..CovidVaccinations
--ORDER BY 3,4

--SELECT location,date,total_cases,new_cases,total_deaths, population FROM ..CovidDeaths
--ORDER BY 1,2

----looking at total cases vs total deaths
--SELECT location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 AS DeathPercentage
--FROM CovidDeaths 
--WHERE location LIKE '%states'
--ORDER BY 1,2

----looking at total cases vs total population
--SELECT location,date,total_cases,population,(total_cases/population)*100 AS CovidCasePercentage
--FROM CovidDeaths 
--WHERE location LIKE '%states'
--ORDER BY 1,2

--countries with highest infection rates
--SELECT location, MAX(total_cases) AS highestinfection,population,max((total_cases/population))*100 AS PercentagePopInfected
--FROM PortfolioProject..CovidDeaths 
--GROUP BY location,population
--ORDER BY PercentagePopInfected DESC

---shwoing countries with highest death count per population
--SELECT location,max(cast(total_deaths as int)) AS Totaldeathcount
----,population,max((total_deaths/total_cases))*100 AS DeathPercentage
--FROM PortfolioProject..CovidDeaths 
--WHERE continent is NOT NULL
--GROUP BY location
--ORDER BY Totaldeathcount desc

-----break down by continent
--SELECT continent,max(cast(total_deaths as int)) AS Totaldeathcount
----,population,max((total_deaths/total_cases))*100 AS DeathPercentage
--FROM PortfolioProject..CovidDeaths 
--WHERE continent is NOT NULL
--GROUP BY continent
--ORDER BY Totaldeathcount desc

-- GLOBAL NUMBERS
--SELECT location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 AS DeathPercentage
--FROM PortfolioProject..CovidDeaths   
----WHERE location LIKE '%states'
--WHERE continent IS NOT NULL
--ORDER BY 1,2

--SELECT SUM(new_cases) as new_cases_total, sum(cast(new_deaths as int)) as new_deaths_total,SUM(cast(new_deaths as int))/SUM(new_cases)*100 AS DeathPercentage
--FROM PortfolioProject..CovidDeaths   
----WHERE location LIKE '%states'
--WHERE continent IS NOT NULL
----GROUP BY date 
--ORDER BY 1,2
 
 --looking at total pop vs vaccinatinations
SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,sum(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location ORDER BY dea.location,dea.date) as RollingPeopleVaccinated,
(RollingPeopleVaccinated/dea.population)*100
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
ON dea.location=vac.location
and dea.date=vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3

---TEMP TABLE
CREATE TABLE #percentPopulationVaccinated
(Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric)

INSERT INTO #percentPopulationVaccinated
SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,sum(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location ORDER BY dea.location,dea.date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
ON dea.location=vac.location
and dea.date=vac.date
--WHERE dea.continent IS NOT NULL
--ORDER BY 2,3

SELECT *,(rollingpeoplevaccinated/population)*100
FROM #percentPopulationVaccinated


-- creating view to store data for later vis

CREATE VIEW PercentPopulationVaccined_ as
SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,sum(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location ORDER BY dea.location,dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/dea.population)*100
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
ON dea.location=vac.location
and dea.date=vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2,3