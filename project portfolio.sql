--select *from ['Covid Deaths$']
--order by 3,4

--select * from ['Covid Vaccinations$']
--order by 3,4


select location, date, total_cases, new_cases, total_deaths, population
from ['Covid Deaths$']
order by 1,2

--Total cases vs Total Deaths

select location, date, total_cases,total_deaths, (cast(total_deaths as int) / cast(total_cases as int) )*100 as DeathPercentage
from ['Covid Deaths$']
where location like '%states%'
order by 1,2


Select Location, date, Population, total_cases,  (total_cases/population)*100 as PercentPopulationInfected
From ['Covid Deaths$']
Where location like '%Nigeria%'
order by 1,2


Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From ['Covid Deaths$']
where location like '%nigeria%'
Group by Location, Population
order by PercentPopulationInfected desc


-- Countries with Highest Infection Rate compared to Population


Select location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From ['Covid Deaths$']
--Where location like '%states%'
Where continent is not null 
Group by location
order by TotalDeathCount desc


--BREAKING THINGS DOWN BY CONTINENT

-- Showing contintents with the highest death count per population

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From ['Covid Deaths$']
--Where location like '%states%'
Where continent is not null 
Group by continent
order by TotalDeathCount desc


-- GLOBAL NUMBERS


select sum(new_cases) as total_cases, sum(new_deaths) total_cases, sum(new_deaths)  /sum(new_cases)*100 as DeathPercentage
from ['Covid Deaths$']
where continent is not null
--group by date
order by 1, 2


--Looking at Total Population vs Vaccination

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as rollingpeoplevaccinated
from ['Covid Deaths$'] dea
join ['Covid Vaccinations$'] vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3


--Using CTE


With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From ['Covid Deaths$'] dea
Join ['Covid Vaccinations$'] vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac


--Temp table


DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From ['Covid Deaths$'] dea
Join ['Covid Vaccinations$'] vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated





Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From ['Covid Deaths$'] dea
Join ['Covid Vaccinations$'] vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 


