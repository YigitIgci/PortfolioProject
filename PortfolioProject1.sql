COVID 19 Data Exploration

-- Looking at Total Cases vs Total Deaths 
-- Shows likelihood of dying if you contract covid in your country
select location,date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage  from portfolio.coviddeaths
where location like '%states%'
order by 1,2

-- Looking at Total Cases vs Population

select location,date,population,total_cases,(total_cases/population)*100 as PercentPopulationInfected 
from portfolio.coviddeaths
-- where location like '%states%'
order by 1,2 

-- Looking at coutries with Highest Infection Rate compared to population

select location,population,max(total_cases) as HighestInfectionCount,max((total_cases/population))*100 as PercentPopulationInfected 
from portfolio.coviddeaths
group by location,population
order by PercentPopulationInfected desc

-- Showing countries Highest Death Count per Population

select location,max(cast(total_deaths as signed)) as TotalDeathCount 
from portfolio.coviddeaths
where continent != ""
group by location
order by TotalDeathCount  desc 

-- Breaking down things by continent 

Select continent, MAX(cast(Total_deaths as unsigned)) as TotalDeathCount
From portfolio.covidDeaths
-- Where location like '%states%'
Where continent is not null 
Group by continent
order by TotalDeathCount desc 

-- showing the continent with the highest death count per population

select continent, max(cast(total_deaths as signed)) as TotalDeathCount
from portfolio.coviddeaths
where continent != ""
group by continent
order by TotalDeathCount desc

-- global Numbers

select date,sum(new_cases)as TotalNewCases,sum(cast(new_deaths as signed)) as NewDeaths,sum(cast(new_Deaths as signed)) /sum(new_cases)*100 as DeathPercentage
from portfolio.coviddeaths
where continent !=""
group by date
order by 1,2


-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine


Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(vac.new_vaccinations,signed)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
-- (RollingPeopleVaccinated/population)*100
From portfolio.CovidDeaths dea
Join Portfolio.CovidVaccinations vac
On dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null 
order by 2,3 

-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(vac.new_vaccinations,signed)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
-- (RollingPeopleVaccinated/population)*100
From Portfolio.CovidDeaths dea
Join Portfolio.CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
-- order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac


-- Using Temp Table to perform Calculation on Partition By in previous query

Create Table PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

-- creating view 

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(vac.new_vaccinations,signed integer)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
-- , (RollingPeopleVaccinated/population)*100
From Portfolio.CovidDeaths dea
Join Portfolio.CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 

