select *
from PortfolioProject..CovidDeaths
order by 3,4

--select *
--from PortfolioProject..CovidVaccinations
--order by 3,4

select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths
order by 1,2

-- Total cases vs total deaths
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where continent is not null and location = 'Egypt'
order by 1,2

-- Total cases vs total population
select location, date, population, total_cases, (total_cases/population)*100 as CasesPercentage
from PortfolioProject..CovidDeaths
where continent is null
--where location like '%states%'
order by 1,2

-- Countries with high infection rate compare to population
select location, population, max(total_cases) as HighestInfectionCount, max((total_cases/population)*100) as CasesPercentage
from PortfolioProject..CovidDeaths
where continent is null
group by location, population
order by 4 desc

-- Countries with high death rate compare to population
select location, population, max(total_deaths) as HighestDeathCount, max((total_deaths/population)*100) as DeathPercentage
from PortfolioProject..CovidDeaths
where continent is null
group by location, population
order by 3 desc

-- Continent with highest death count compare to population
select continent, max(total_deaths) as HighestDeathCount
from PortfolioProject..CovidDeaths
where continent is not null
group by continent
order by 2 desc

-- Global numbers

select sum(new_cases) as TotalCases, sum(new_deaths) as TotalDeaths, 
			isnull(sum(new_deaths)/nullif(sum(new_cases),0),0)*100  as DeathPercentage
from PortfolioProject..CovidDeaths
where continent is not null -- and location = 'Egypt'
--group by date
order by 1,2

-- Total population vs total vaccenation
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) as TotalVaccenation
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2, 3

-- Use CTE
with PopvsVac (Continent, Location, Date, Population, New_vaccinations, TotalVaccenation)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) as TotalVaccenation
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2, 3
)
select *, (TotalVaccenation/Population)*100
from PopvsVac

-- Temp Table
drop table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
population numeric,
New_vaccinations numeric,
TotalVaccenation numeric
)

insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) as TotalVaccenation
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null
--order by 2, 3

select *, (TotalVaccenation/Population)*100
from #PercentPopulationVaccinated

-- Create view to store data for later visualization 
create view PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) as TotalVaccenation
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2, 3

select *
from PercentPopulationVaccinated



-- Random functions------------------------------------
SELECT DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'CovidDeaths' AND COLUMN_NAME = 'new_cases' 

SELECT DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'CovidVaccinations' AND COLUMN_NAME = 'new_vaccinations'

Select *  
From CovidDeaths  
Where Try_Cast(total_cases As bigint) Is Null And total_cases Is Not Null 

Select *  
From CovidDeaths  
Where Try_Cast(total_deaths As bigint) Is Null And total_deaths Is Not Null


Alter Table CovidDeaths Alter Column total_cases float
Alter Table CovidVaccinations Alter Column new_vaccinations float