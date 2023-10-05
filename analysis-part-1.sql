
--PREPARE DATA:

--Data from https://ourworldindata.org/life-expectancy:

create table life_expectancy as select * from read_csv_auto('/Users/jamie.mcilveen/Data/Compass/life-expectancy.csv');

select * from life_expectancy;

--Rename columns to lower snake case.

alter table life_expectancy rename "Entity" to entity;
alter table life_expectancy rename "Code" to code;
alter table life_expectancy rename "Year" to "year";
alter table life_expectancy rename "Life expectancy at birth (historical)" to life_expectancy;

select * from life_expectancy;

--Data ready. 


--QUESTION:

--Please write down a SQL query that identifies the country that experienced the lengthiest continuous period 
--of declining life expectancy, year after year. The output of the sql should be the name of the country, the 
--year where the period has begun and the year where the period ended.


--EDA:

select 
	distinct 
	entity
	, code 
from life_expectancy
order by entity asc;

--Only interested in countries, not continents/regions. Therefore only include entities where code is not null. 

select 
	entity 
	, count(*) as records
	, count(distinct year) as unique_years
	, min(year) as period_start 
	, max(year) as period_end
	, max(year) - min(year) + 1 as years_in_period
	, case when count(*) = max(year) - min(year) + 1 then true else false end as is_always_continuous
from life_expectancy
where code is not null 
group by entity 
order by entity asc 

--All countries have data up to 2021.
--Period per entity is not always continuous, data is missing for some years. 
--Bare this in mind when doing year after year analysis!


--SOLUTION:

with a as (

	select 
		entity 
		, year 
		, life_expectancy 
		, lag(year, 1) over(partition by entity order by year asc) as prev_year
		, lag(life_expectancy, 1) over(partition by entity order by year asc) as prev_life_expectancy
	from life_expectancy 
	where code is not null
	order by entity, year asc

)

,b as ( 

	select 
		*
		, case when life_expectancy - prev_life_expectancy < 0 then 1 else 0 end as is_declining
		, case when year - prev_year = 1 then 1 else 0 end as is_continuous 
	from a 
	order by entity, year asc 

) 

,c as (

	select 
		* 
		, case when lag(is_declining, 1) over(partition by entity order by year asc) = 0 and is_declining = 1 then 1 else 0 end as is_start_of_decline
	from b 
	order by entity, year asc 

) 

,d as (

	select 
		*
		, sum(is_start_of_decline) over(partition by entity order by year asc) as period_group
	from c 

) select * from d 

,e as (

	select 
		entity 
		, min(year) as period_start
		, max(year) as period_end 
		, count(*) as years_of_decline
	from d 
	where 
		is_declining = 1
		and is_continuous = 1
	group by entity, period_group 
	order by years_of_decline desc 

) 

	select 
		entity as country
		, period_start 
		, period_end
	from e 
	order by years_of_decline desc 
	limit 1;

--(Result: Zambia, 1978, 1998)
