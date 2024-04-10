/*
Sheets(1-6) are for Tableau Visualizations

*/

----Death Analysis

SELECT *
FROM Portfolio..CovidDeaths


-- 1. Global numbers (Sheet 1)
SELECT 
    date,
	population,
    SUM(CAST(new_cases AS float)) AS total_cases,
    SUM(CAST(new_deaths AS float)) AS total_deaths,
    ROUND(SUM(CAST(new_deaths AS float)) / NULLIF(SUM(CAST(new_cases AS float)), 0) * 100,2) AS DeathPercentage
FROM 
    Portfolio..CovidDeaths
	WHERE continent IS NOT NULL
--WHERE location LIKE '%states%' 
GROUP BY 
    date,
	population
ORDER BY 
    date;





-- 2. Total deaths per continent (Sheet 2)
SELECT *
FROM Portfolio..CovidDeaths

Select date, location, SUM(cast(new_deaths as int)) as TotalDeathCount
From Portfolio..CovidDeaths
--Where location like '%South Africa%'
Where continent is null 
and location not in ('World', 'European Union', 'International', 'High income', 'Upper middle income', 'Lower middle income', 'Low income')
Group by date, location
order by date 


-- 3.Global infection counts( Sheet 3)
Select date, Location, Population, MAX(total_cases) as HighestInfectionCount,  ROUND(Max((total_cases/population))*100,2) as PercentPopulationInfected
From Portfolio..CovidDeaths
Where location not in ('World', 'European Union', 'International', 'High income', 'Upper middle income', 
'Lower middle income', 'Low income', 'Africa', 'Asia', 'North America', 'South America', 'Europe', 'Oceania')
--Where location like '%South Africa%'
Group by date, Location, Population
order by date

SELECT *
FROM Portfolio.dbo.CovidDeaths

-- 4. Global infection counts per year
Select date, Location, Population, MAX(total_cases) as HighestInfectionCount,  ROUND(Max((total_cases/population))*100,2) as PercentPopulationInfected
From Portfolio..CovidDeaths
--Where location like '%states%'
Group by date, Location, Population
order by date






-----Death and Vaccinations Analysis
SELECT *
FROM Portfolio.dbo.CovidVaccinations

-- 5. Total number of new vaccinations overtime(sheet 5)
SELECT date, COUNT(new_vaccinations) AS "Total number of new vaccinations"
FROM Portfolio.dbo.CovidVaccinations
GROUP BY date
ORDER BY date


--6. Number of vaccinated people
SELECT date, continent, SUM(CAST(people_vaccinated as float)) AS "Total number of people vaccinated"
FROM Portfolio.dbo.CovidVaccinations
WHERE continent IS NOT NULL
GROUP BY date, continent
ORDER BY date


-- 7. Vaccination percentage
Select dea.continent, dea.location, dea.date, dea.population
, ROUND((MAX(vac.total_vaccinations)/dea.population) * 100,2) as "Vaccination percentage"
From Portfolio..CovidDeaths dea
Join Portfolio..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
group by dea.continent, dea.location, dea.date, dea.population
order by 1,2,3































--With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
--as
--(
--Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
--, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
----, (RollingPeopleVaccinated/population)*100
--From Portfolio..CovidDeaths dea
--Join Portfolio..CovidVaccinations vac
--	On dea.location = vac.location
--	and dea.date = vac.date
--where dea.continent is not null 
----order by 2,3
--)
--Select *, (RollingPeopleVaccinated/Population)*100 as PercentPeopleVaccinated
--From PopvsVac