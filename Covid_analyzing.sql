select * from death


                total deaths vs. total cases
select 
	location,
	sum(new_cases) as total_cases,
	sum(new_deaths) as total_deaths,
	round(
		(cast(sum(new_deaths) as numeric)) /
		 nullif(sum(new_cases),0)*100
		,2) as death_rate
from death
where continent is not null
		and total_deaths is not null
group by location
order by total_deaths desc

                 total cases vs. population

select 
	location,
	population,
	sum(new_cases) as total_cases,
	round((cast(sum(new_cases) as numeric) /
	population)*100, 3) as infected_rate
from death
where continent is not null
group by location,population
having
		round((cast(sum(new_cases) as numeric) /
		population)*100, 3) is not null
		and
		sum(new_cases) != 0
order by total_cases desc

			--let's check it out by continent
select 
	continent,location,population,
	sum(new_cases) as total_cases,
	sum(new_deaths) as total_deaths

from death
where continent is not null and total_deaths != 0
group by continent,location,population

order by continent desc	

			vaccination trends in Canada

select  death.location,
		death.date,
		vaccination.new_vaccinations,
		sum(vaccination.new_vaccinations) over 
		(partition by death.location order by death.location,death.date) as Total_vaccination
from death
join vaccination
on death.location = vaccination.location
	and death.date = vaccination.date
where 
		 death.continent is not null
		 and death.location = 'Canada'
group by death.date,death.location,vaccination.new_vaccinations
order by 1,2 

create view Vaccination_trend as

select  death.location,
		death.date,
		vaccination.new_vaccinations,
		sum(vaccination.new_vaccinations) over 
		(partition by death.location order by death.location,death.date) as Total_vaccination
from death
join vaccination
on death.location = vaccination.location
	and death.date = vaccination.date
where 
		 death.continent is not null
		 and death.location = 'Canada'
group by death.date,death.location,vaccination.new_vaccinations
order by 1,2 
