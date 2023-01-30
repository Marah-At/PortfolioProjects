
-- # Let's Show all the data in the CovidDeaths Table (till December 6th, 2022)

Select * 
From PortfolioProject..CovidDeaths
Where continent is not NULL
order by 3,4


--# Let's Show all the data in the CovidVaccinations Table (till December 6th, 2022)

Select * 
From PortfolioProject..CovidVaccinations
order by 3,4


-- Select The Data That we are going to using (till December 6th, 2022)

Select continent, location, date, population, total_cases, new_cases, total_deaths
From PortfolioProject..CovidDeaths
Where continent is not NULL
order by 2,3


-- The percentage of Total Deaths (Total Deaths vs Total Cases)

Select continent, location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 AS DeathPercentage
From PortfolioProject..CovidDeaths
order by 2,3


-- The percentage of Total Deaths in United Arab Emarites
-- Show likelihood of dying if you contract covid in your country
Select continent, location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 AS DeathPercentage
From PortfolioProject..CovidDeaths
Where location like '%Emirates%'
and continent is not NULL
order by 2,3


-- Looking at total Cases vs Populations 

Select continent, location, date, population, total_cases, (total_cases/population)*100 AS PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%Emirates%'
order by 2,3


--Looking at the Countries with the Highest Infection Rate Compared to Population

Select location, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population))*100 AS PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%Emirates%'
Group by location, population
order by PercentPopulationInfected desc


-- looking at Countries with the Highest Death Count per Population

Select location, MAX(cast(total_deaths as int)) AS HighestDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%Emirates%'
Where continent is not NULL
Group by location
order by HighestDeathCount desc


-- We want to Break things Down by Continent 

Select continent, MAX(cast(total_deaths as int)) AS HighestDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%Emirates%'
Where continent is not NULL
Group by continent
--order by HighestDeathCount desc


--looking at the continents with the highest death Count per population

Select continent, MAX(cast(total_deaths as int)) AS HighestDeathCount 
From PortfolioProject..CovidDeaths
--Where location like '%Emirates%'
Where continent is not NULL
Group by continent
order by HighestDeathCount desc

-- Looking at the Total New Deaths vs Total New cases in United Arab Emirates 

Select SUM(new_cases) AS TotalNewCases, SUM(cast(new_deaths as int)) AS TotalNewDeaths, (SUM(cast(new_deaths as int))/SUM(new_cases))*100 AS DeathPercentage
From PortfolioProject..CovidDeaths
Where location like '%Emirates%'
and continent is not NULL
--Group by date
order by 1,2


-- Global Numbers

Select SUM(new_cases) AS TotalNewCases, SUM(cast(new_deaths as int)) AS TotalNewDeaths, (SUM(cast(new_deaths as int))/SUM(new_cases))*100 AS DeathPercentage
From PortfolioProject..CovidDeaths
--Where location like '%Emirates%'
Where continent is not NULL
--Group by date
order by 1,2


-- Looking at Total Population vs Vaccinations

Select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
SUM(cast(cv.new_vaccinations as bigint)) OVER (Partition by cd.location order by cd.location, cd.date) AS NumberOfPeopleVaccinated
From PortfolioProject..CovidDeaths cd
join PortfolioProject..CovidVaccinations cv
     on cd.location = cv.location
     and cd.date = cv.date
Where cd.continent is not NULL
order by 2,3


-- Let's use CTE ( Common Table Expression)

with PopvsVac (continent, location, date, population, new_vaccinations, NumberOfPeopleVaccinated)
as
(
Select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
SUM(cast(cv.new_vaccinations as bigint)) OVER (Partition by cd.location order by cd.location, cd.date) AS NumberOfPeopleVaccinated
--(NumberOfPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths cd
join PortfolioProject..CovidVaccinations cv
     on cd.location = cv.location
     and cd.date = cv.date
Where cd.continent is not NULL
-- order by 2,3
)
select *, (NumberOfPeopleVaccinated/population)*100 AS PercentofPeopleVaccinated
From PopvsVac 


-- Use Temporary Table 

Drop table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
NumberOfPeopleVaccinated numeric 
)

Insert into #PercentPopulationVaccinated
Select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
SUM(CONVERT(bigint,cv.new_vaccinations)) OVER (Partition by cd.location order by cd.location, cd.date) AS NumberOfPeopleVaccinated
--(NumberOfPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths cd
join PortfolioProject..CovidVaccinations cv
     on cd.location = cv.location
     and cd.date = cv.date
--Where cd.continent is not NULL
-- order by 2,3

select *,(NumberOfPeopleVaccinated/population)*100 As PercentofPeopleVaccinated
From #PercentPopulationVaccinated 


-- Let's Create View to store Data for later Visualizations

Create View PercentPopulationVaccinated as 
Select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
SUM(CONVERT(bigint,cv.new_vaccinations)) OVER (Partition by cd.location order by cd.location, cd.date) AS NumberOfPeopleVaccinated
--(NumberOfPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths cd
join PortfolioProject..CovidVaccinations cv
     on cd.location = cv.location
     and cd.date = cv.date
Where cd.continent is not NULL
--order by 2,3

Select * 
From PercentPopulationVaccinated