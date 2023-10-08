---
title: Life expectancy trends for countries in different income bands
---

_Author: Jamie McIlveen_

## Notes on data source

The raw data for this analysis comes from `life-expectancy.csv` in the /sources folder for this project and can be found online at https://ourworldindata.org/life-expectancy. 

Light transformations have been applied to the raw data for the purpose of this analysis and can be viewed by expanding the below SQL cell:

```sql life_expectancy_by_income_band
select 
    "Entity" as income_band 
    , "Year" as year 
    , "Life expectancy at birth (historical)" as life_expectancy
from 'sources/life-expectancy.csv'
where 
     "Entity" in (
                    'High-income countries'
                    ,'Upper-middle-income countries'
                    ,'Lower-middle-income countries'
                    ,'Low-income countries' 
                )
```

### Data Preview

<DataTable data={life_expectancy_by_income_band} rows=5/>

The 4 income bands, based on gross national income per capita (GNI), are: 
- High-income countries
- Upper-middle-income countries
- Lower-middle-income countries
- Low-income countries

For more information on how these income bands are calculated and which countries fall into each one, the following links are helpful:

https://ourworldindata.org/grapher/world-banks-income-groups
https://www.un.org/en/development/desa/policy/wesp/wesp_current/2014wesp_country_classification.pdf

# Insights

### Life expectancy is directly proportional to countries' income

<BarChart
    data="{life_expectancy_by_income_band_2021}"
    title="Life expectancy by income band, 2021"
    x="income_band"
    xAxisTitle="Income Band"
    y="life_expectancy"
    yAxisTitle='Life Expectancy (years)'
    series="income_band"
    sort=true
/>

- In 2021, life expectancy was 80.3, 75.3, 66.4 and 62.5 years for high, upper-middle, lower-middle and low income countries respectively.  

### This has (almost) always been the case, though the gap in life expectancy between high and low income countries is closing 

<LineChart
    data="{life_expectancy_by_income_band}"
    title="Life expectancy by income band, 1950 to 2021"
    x="year"
    xAxisTitle="Year"
    y="life_expectancy"
    yAxisTitle='Life Expectancy (years)'
    series="income_band"
    sort=true
/>

- In 1950, the life expectancy gap between high and low income countries was 29.9 years. Fast forward to 2021 and the gap reduced to 17.8 years.
- From 1950 to 2021, life expectancy in low income countries has almost doubled, from 31.6 to 62.5, while in high income countries it has increased by ~1.3x, from 61.5 to 80.3.
- Life expectancy has been steadily increasing for the last ~70 years in countries of all incomes. 

### Life expectancy in upper-middle income countries dropped below that of lower-middle income countries from 1959 to 1961 as a result of China's great famine

<LineChart
    data="{life_expectancy_by_income_band}"
    title="Life expectancy by income band, 1950 to 2021"
    x="year"
    xAxisTitle="Year"
    y="life_expectancy"
    yAxisTitle='Life Expectancy (years)'
    series="income_band"
    sort=true
>
    <ReferenceArea xMin="1959" xMax="1961" label="China's great famine" color=red/>
</LineChart>

- China's great famine is widely regarded as the deadliest famine and one of the greatest man-made disasters in human history, with an estimated death toll due to starvation that ranges in the tens of millions.
- Average life expectancy during this period dropped significantly as a result. 

### Life expectancy was trending upwards for all income bands, until Covid... 

<LineChart
    data="{life_expectancy_by_income_band}"
    title="Life expectancy by income band, 1950 to 2021"
    x="year"
    xAxisTitle="Year"
    y="life_expectancy"
    yAxisTitle='Life Expectancy (years)'
    series="income_band"
    sort=true
>
    <ReferenceArea xMin="2019" xMax="2021" label="Covid" color=red/>
</LineChart>

<BarChart
    data="{life_expectancy_by_income_band_covid}"
    title="Life expectancy by income band, pre and post-Covid"
    x="income_band"
    xAxisTitle="Income Band"
    y="life_expectancy"
    yAxisTitle='Life Expectancy (years)'
    series="year"
    sort=true
    type=grouped
/>

- Covid impacted average life expectancy for countries of all income bands. 
- Lower-middle income countries were worst impacted, with life expectancy falling by 2.5 years from 2019 to 2021, while all other income bands saw drops of ~1 year during the same period. 


```sql life_expectancy_by_income_band_2021
select 
    income_band 
    , year 
    , life_expectancy
from ${life_expectancy_by_income_band}
where 
    year = 2021
```

```sql life_expectancy_by_income_band_covid
select 
    income_band 
    , year 
    , life_expectancy
from ${life_expectancy_by_income_band}
where 
    year in (2019, 2021)
```