select *
from PORTFOLIOPROJECT..CovidDeaths$
WHERE continent is Not Null
ORDER BY 3,4

select *
from PORTFOLIOPROJECT..CovidVaccinations$

Select location, date, total_cases, new_cases, total_deaths, population
FROM  PORTFOLIOPROJECT..CovidDeaths$
order by 1,2

--Looking at total_cases vs total_death

Select location, date, total_cases, total_deaths, (total_cases/total_deaths)*100 DeathPercentage
FROM   PORTFOLIOPROJECT..CovidDeaths$
Where location like '%states%'
order by 1,2


---Looking at Total Cases vs Population
---Show Percentage Of Population got Covid

Select Location, date, population, total_cases, (total_cases/population)*100 DeathPercentage
FROM   PORTFOLIOPROJECT..CovidDeaths$
--Where location like '%states%'
order by 1,2



--Looking at the countries with highest Infection Rate Compared to Population

Select Location,  population, MAX(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as
 PercentPopulationInfected
FROM   PORTFOLIOPROJECT..CovidDeaths$
--Where location like '%states%'
Group by Location,  population
order by PercentPopulationInfected desc


--showing Countries With the highest Death Count per populatin

Select Location, date, total_cases, new_cases, total_death, population
FROM  PORTFOLIOPROJECT..CovidDeaths$



--LET'S BREAK THINGS DOWN BY CONTINENT

Select continent,  Max(Cast(total_deaths as int)) as TotalDeathCount
FROM   PORTFOLIOPROJECT..CovidDeaths$
--Where location like '%states%'
WHERE Continent is not  Null
Group by Continent 
order by TotalDeathCount desc


-- Showing Continents With the highest Death Count per population


Select continent,  Max(Cast(total_deaths as int)) as TotalDeathCount
FROM   PORTFOLIOPROJECT..CovidDeaths$
--Where location like '%states%'
WHERE Continent is not  Null
Group by Continent 
order by TotalDeathCount desc


--Global Numbers

Select  SUM(new_cases)as total_cases, sum(cast(new_deaths as int)) as total_death, sum(cast(new_deaths as int))/sum(New_cases)*100 as DeathPercentage
FROM  PORTFOLIOPROJECT..CovidDeaths$
--Where location like '%states%'
where continent is not null
--Group By date
order by 1,2


--looking at the total population vs vaccinations

With PopvsVac (continent,Location,Date,Poplulatin, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Convert(int,vac.new_vaccinations )) Over (partition by dea.Location Order by dea.Location, dea.date) as Rollingpeoplevaccinated
--, (RollingPeopleVaccinated/population)*100 
FROM Portfolioproject..CovidDeaths$ dea
join Portfolioproject..CovidVaccinations$ vac
  On dea.location = Vac.location
   and dea.date = vac.date
Where dea. continent is not null
--order by 2,3
)
Select*
From PopvsVac 


  --Temp Table

 Create Table #PercentPopulationVaccinated
 (
 Continent nvarchar(255),
 Location nvarchar(255),
 Date datetime,
 Population numeric,
 New_Vaccination numeric,
 RollingPeopleVaccinated numeric
 )
 Insert into #PercentPopulationVaccinated 
 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Convert(int,vac.new_vaccinations )) Over (partition by dea.Location Order by dea.Location, dea.date) as Rollingpeoplevaccinated
--, (RollingPeopleVaccinated/population)*100 
FROM Portfolioproject..CovidDeaths$ dea
join Portfolioproject..CovidVaccinations$ vac
  On dea.location = Vac.location
   and dea.date = vac.date
Where dea. continent is not null
--order by 2,3

Select *, (RollingPeopleVaccinated/population)*100
From  #PercentPopulationVaccinated










