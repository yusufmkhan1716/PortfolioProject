Select *
From PortfolioProject..CovidDeaths
Where continent is not null
order by 3,4


Select *
From PortfolioProject..CovidVaccination
order by 3,4


--Select Data that we are going to be using

Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
Where continent is not null
order by 1,2


-- Looking at Total Cases vs Total Deaths
-- Shows the likelihood of dying if you contract covid in your country
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where continent is not null
order by 1,2


--Looking at the Total Cases vs Population
--Shows what percentage of population got covid within the United States
Select location, date, total_cases, population, (total_cases/population)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where location like '%states%'
order by 1,2


--Looking at countries with Highest Infection Rate compared to population. 
Select location, MAX(total_cases) as Highest_Infection_Count, population, MAX((total_cases/population))*100 as Percentage_Population_Infected
From PortfolioProject..CovidDeaths
--Where location like '%canada%'
Group by location, population
Order by Percentage_Population_Infected desc


--Showing countries with Highest Death Count per Population
Select location, MAX(cast(total_deaths as int)) as total_death_count
From PortfolioProject..CovidDeaths
Where continent is not null
--Where location like '%states%'
Group by location
Order by total_death_count desc


--Breaking things down by continent 
Select continent, MAX(cast(total_deaths as int)) as total_death_count
From PortfolioProject..CovidDeaths
Where continent is not null
--Where location like '%states%'
Group by continent
Order by total_death_count desc


--Getting a different view of the data: 
Select location, MAX(cast(total_deaths as int)) as total_death_count
From PortfolioProject..CovidDeaths
Where continent is null
Group by location
Order by total_death_count desc



--Calculating death percentage on global scale
Select date, SUM(new_cases) as New_Cases, SUM(cast(new_deaths as int)) as New_Deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as Death_Percentage
From PortfolioProject..CovidDeaths
Where continent is not null
group by date
order by 1,2



--total number of cases and deaths (GLOBAL LEVEL) 
Select SUM(new_cases) as New_Cases, SUM(cast(new_deaths as int)) as New_Deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as Death_Percentage
From PortfolioProject..CovidDeaths
Where continent is not null
order by 1,2


--Covid Vaccinations and join CovidDeaths together with it
Select *
From PortfolioProject..CovidDeaths death
Join PortfolioProject..CovidVaccination vaccination
	on death.location = vaccination.location
	and death.date = vaccination.date


--Looking at relationship between Total Population vs Vaccinations
Select death.continent, death.location, death.date, death.population, vaccination.new_vaccinations, SUM(convert(int,vaccination.new_vaccinations)) OVER (Partition by death.location order by death.location, death.date) as Rolling_People_vaccination, --(Rolling_People_vaccination/population)*100
From PortfolioProject..CovidDeaths death
Join PortfolioProject..CovidVaccination vaccination
	on death.location = vaccination.location
	and death.date = vaccination.date
where death.continent is not null
order by 2,3


--CTE

With PopvsVac (continent, location, date, population, new_vaccinations, Rolling_People_vaccination)
as
(
Select death.continent, death.location, death.date, death.population, vaccination.new_vaccinations, SUM(convert(int,vaccination.new_vaccinations)) OVER (Partition by death.location order by death.location, death.date) as Rolling_People_vaccination
From PortfolioProject..CovidDeaths death
Join PortfolioProject..CovidVaccination vaccination
	on death.location = vaccination.location
	and death.date = vaccination.date
where death.continent is not null
--order by 2,3
)
Select *, (Rolling_People_vaccination/Population)*100 as Vaccination_Rate
From PopvsVac


--TEMP TABLE

Drop table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
Date datetime, 
Population numeric,
new_vaccinations numeric,
Rolling_People_vaccination numeric,
)

Insert into #PercentPopulationVaccinated
Select death.continent, death.location, death.date, death.population, vaccination.new_vaccinations, SUM(convert(int,vaccination.new_vaccinations)) OVER (Partition by death.location order by death.location, death.date) as Rolling_People_vaccination
From PortfolioProject..CovidDeaths death
Join PortfolioProject..CovidVaccination vaccination
	on death.location = vaccination.location
	and death.date = vaccination.date
--where death.continent is not null
--order by 2,3

Select *, (Rolling_People_vaccination/Population)*100 as Vaccination_Rate
From #PercentPopulationVaccinated



--Creating view to store data for later visualizations
Create View PercentPopulationVaccinated as
Select death.continent, death.location, death.date, death.population, vaccination.new_vaccinations, SUM(convert(int,vaccination.new_vaccinations)) OVER (Partition by death.location order by death.location, death.date) as Rolling_People_vaccination
From PortfolioProject..CovidDeaths death
Join PortfolioProject..CovidVaccination vaccination
	on death.location = vaccination.location
	and death.date = vaccination.date
where death.continent is not null
--order by 2,3

Select *
From PercentPopulationVaccinated