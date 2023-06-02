SELECT * FROM PortfolioProject..NewCovidDeaths$

SELECT * FROM PortfolioProject..NewCovidDeaths$
WHERE continent is not null
order by 3,4

--SELECT * FROM PortfolioProject..NewCovidVaccinations$
--order by 3,4

SELECT Location, date, total_cases,new_cases, total_deaths, population 
From PortfolioProject..NewCovidDeaths$ 
WHERE continent is not null
order by 1,2

SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)* 100 as Deathpercentage
From PortfolioProject..NewCovidDeaths$ 
WHERE Location like '%Nigeria%'
order by 1,2

SELECT Location, date, population, total_cases,  (total_cases/population)* 100 as Deathpercentage
From PortfolioProject..NewCovidDeaths$ 
WHERE Location like '%Nigeria%'
order by 1,2

SELECT location, population, MAX(total_cases) as HighestInfectionCount,  MAX(total_cases/population)* 100 
as PercentPopulationInfected
From PortfolioProject..NewCovidDeaths$ 
WHERE continent is not null
Group by location, population
order by PercentPopulationInfected desc


SELECT location,MAX(cast(total_deaths as int)) as TotalDeathCount 
From PortfolioProject..NewCovidDeaths$ 
--where location like '%Nigeria%'
WHERE continent is not null
Group by location
order by TotalDeathCount desc


SELECT continent,MAX(cast(total_deaths as int)) as TotalDeathCount 
From PortfolioProject..NewCovidDeaths$ 
--where location like '%Nigeria%'
WHERE continent is not null
Group by continent
order by TotalDeathCount desc



SELECT date, SUM(new_cases) as total_cases, SUM(CAST(new_deaths as int)) as total_deaths, SUM(CAST(new_deaths as int))/SUM(new_cases)*100
as DeathPercentage
from PortfolioProject..NewCovidDeaths$
--WHERE Location like '%Nigeria%'
WHERE continent is not null
group by date
order by 1,2

SELECT dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location)
FROM 
PortfolioProject..NewCovidDeaths$ as dea
join PortfolioProject..NewCovidVaccinations$  as vac 
on	dea.location = vac.location
and dea.date = vac.date
WHERE dea.continent is not null
order by 1,2,3

SELECT dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated
FROM 
PortfolioProject..NewCovidDeaths$ as dea
join PortfolioProject..NewCovidVaccinations$  as vac 
on	dea.location = vac.location
and dea.date = vac.date
WHERE dea.continent is not null
order by 1,2,3

With PopvsVac (Continent, Location, Date, Population, new_vaccinations, RollingPeopleVaccinated)
as
(SELECT dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated
FROM 
PortfolioProject..NewCovidDeaths$ as dea
join PortfolioProject..NewCovidVaccinations$  as vac 
on	dea.location = vac.location
and dea.date = vac.date
WHERE dea.continent is not null
--order by 1,2,3
)
SELECT *, (RollingPeopleVaccinated/Population)*100 
FROM PopvsVac

drop table if exists #PercentPopulationVaccinated

CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)
INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated
FROM 
PortfolioProject..NewCovidDeaths$ as dea
join PortfolioProject..NewCovidVaccinations$  as vac 
on	dea.location = vac.location
and dea.date = vac.date
WHERE dea.continent is not null
--order by 1,2,3
SELECT *, (RollingPeopleVaccinated/Population)*100 
FROM #PercentPopulationVaccinated

Create view PercentPopulationVaccinated as
SELECT dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated
FROM 
PortfolioProject..NewCovidDeaths$ as dea
join PortfolioProject..NewCovidVaccinations$  as vac 
on	dea.location = vac.location
and dea.date = vac.date
WHERE dea.continent is not null
--order by 2,3

SELECT * FROM PercentPopulationVaccinated