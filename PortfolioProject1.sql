
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

select continent, max(cast(total_deaths as signed)) as TotalDeathCount
from portfolio.coviddeaths
where continent = ""
group by location
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

-- Looking at total population vs Vaccination

select * 
from portfolio.coviddeaths dea
join portfolio.covidvaccinations vac
on dea.location=vac.location and dea.date=vac.date


select dea.continent,dea.location,dea.date,dea.population,cast(vac.new_vaccinations as signed) as NewVaccinations
from portfolio.coviddeaths dea
join portfolio.covidvaccinations vac 
on dea.location=vac.location and dea.date=vac.date
where dea.continent is not null
order by 2,3 


-- creating view 

create view PercentPopulationVaccinated as 
select dea.continent,dea.location,dea.date,dea.population,cast(vac.new_vaccinations as signed) as NewVaccinations
from portfolio.coviddeaths dea
join portfolio.covidvaccinations vac 
on dea.location=vac.location and dea.date=vac.date
where dea.continent is not null

select * 
from PercentPopulationVaccinated


