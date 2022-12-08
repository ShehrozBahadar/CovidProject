select *
from coviddeaths
where continent is not null
order by 3,4;

-- Select Data that we are giving to be using

select location, date, total_cases, new_cases, total_deaths, population
from coviddeaths
where continent is not null
order by 1, 2;

-- Looking at total cases vs total deaths
-- Shows likelihood of dying if you contract covid in your country

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from coviddeaths
where location like "Pakistan"
and continent is not null
order by 1, 2;

-- Looking at total cases vs population
-- Shows what percentage of population got covid

select location, date, total_cases, population, (total_cases/population)*100 as PercentPoulationInfected
from coviddeaths
where location like "Pakistan"
order by 1, 2;

-- Looking at countries with heighest infection rate compared to population

select location, Population, max(total_cases) as HighestInfectionCount, max((total_cases/population))*100 as PercentPoulationInfected
from coviddeaths
group by location, Population
order by PercentPoulationInfected desc;

-- Showing countries with Heighest Death count per population

select location, max(total_deaths) as TotalDeathCount
from coviddeaths
where continent is not null
group by location
order by TotalDeathCount desc;

-- Break things down by continent
-- Showing continent with the highest death count per population

select continent, max(total_deaths) as TotalDeathCount
from coviddeaths
where continent is not null
group by continent
order by TotalDeathCount desc;

-- Global Numbers

select sum(new_cases) as TotalCases, sum(new_deaths) as TotalDeaths, sum(new_deaths)/sum(new_cases)*100 as DeathPercentage
from coviddeaths
-- where location like "Pakistan"
where continent is not null
-- group by date
order by 1, 2;

-- Looking at total poupulation vs vaccinations

select d.continent, d.location, d.date, d.population, v.new_vaccinations, sum(v.new_vaccinations) 
over (partition by d.location order by d.location, d.date) as RollingPeopleVaccinated
from coviddeaths d
join covidvaccinations v
on d.location = v.location
and d.date = v.date
where d.continent is not null
order by 2, 3;

-- Use CTE

with PopVsVac (continent, location, date, population, new_vaccination, RollingPeopleVaccinated)
as
(
select d.continent, d.location, d.date, d.population, v.new_vaccinations, sum(v.new_vaccinations) 
over (partition by d.location order by d.location, d.date) as RollingPeopleVaccinated
from coviddeaths d
join covidvaccinations v
on d.location = v.location
and d.date = v.date
where d.continent is not null
-- order by 2, 3
)
select *, (RollingPeopleVaccinated/population)*100
from popvsvac;

-- Temp Table

create temporary table PercentPopulationVaccinated
select d.continent, d.location, d.date, d.population, v.new_vaccinations, sum(v.new_vaccinations) 
over (partition by d.location order by d.location, d.date) as RollingPeopleVaccinated
from coviddeaths d
join covidvaccinations v
on d.location = v.location
and d.date = v.date
where d.continent is not null;
-- order by 2, 3

select *, (RollingPeopleVaccinated/population)*100
from PercentPopulationVaccinated;

-- Creating view to store data for later visualizations

create view PercentPopulationVaccinated as
select d.continent, d.location, d.date, d.population, v.new_vaccinations, sum(v.new_vaccinations) 
over (partition by d.location order by d.location, d.date) as RollingPeopleVaccinated
from coviddeaths d
join covidvaccinations v
on d.location = v.location
and d.date = v.date
where d.continent is not null
order by 2, 3; 





















