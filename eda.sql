 -- Exploratory data analysis
 -- layoff dataset has been used. Here we are just going to look around for the outliers or let's see what we can find
 
 select *
 from layoff_stag2;
 
 -- maximum layoffs in the dataset
 select max(total_laid_off),max(percentage_laid_off)
 from layoff_stag2;
 
 -- checking how big or variation are there in the layoffs
 select max(percentage_laid_off),min(percentage_laid_off)
 from layoff_stag2
 where percentage_laid_off is not null;
 -- here 1 represent 100 % layoff ,these are mostly startups it looks like who all went out of business during this time
 -- lets's look at funds_raised_millions to see how big a company has raised
 
 select *
 from layoff_stag2
 where percentage_laid_off = 1
 order by funds_raised_millions desc;
 -- BritishVolt looks like an EV company in United kingdom has raised the maximum funds .
 
 -- companies with the most total laid offs
 select company, sum(total_laid_off)
 from layoff_stag2
 group by company
 order by 2 desc
 limit 10;
 -- location
  select location, sum(total_laid_off)
 from layoff_stag2
 group by location
 order by 2 desc
 limit 10; -- SF Bay area has the max total laid_off in total in the past years 
 
 -- let's check for the single day
 -- Companies with the biggest single Layoff

SELECT company, total_laid_off
FROM layoff_stag2
ORDER BY 2 DESC
LIMIT 5;

-- Earlier we looked at Companies with the most Layoffs. Now let's look at that per year. It's a little more difficult.

WITH Company_Year AS 
(
  SELECT company, YEAR(date) AS years, SUM(total_laid_off) AS total_laid_off
  FROM layoff_stag2
  GROUP BY company, YEAR(date)
)
, Company_Year_Rank AS (
  SELECT company, years, total_laid_off, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
  FROM Company_Year
)
SELECT company, years, total_laid_off, ranking
FROM Company_Year_Rank
WHERE ranking <= 3
AND years IS NOT NULL
ORDER BY years ASC, total_laid_off DESC;
-- company layoff in the year with total_laid_off of 7525 in uber is not seen with the same margin or higher in the next year and same has oberved with the other company's as well

select company ,sum(total_laid_off),year(date)
from layoff_stag2
where company ='Amazon'
group by year(date);

