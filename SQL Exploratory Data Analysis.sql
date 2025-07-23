-- Exploratory Data Analysis

SELECT *
FROM layoffscopy2;

-- I. Initial Data Exploration and Overview
-- Max "Total Laid Off" : Identifying the single largest layoff event in terms of the number of people laid off
SELECT MAX(total_laid_off)
FROM layoffscopy2;

-- Max "Percentage Laid Off" : Found instances where 100% of a company's employees were laid off, indicating company closure
SELECT MAX(percentage_laid_off)
FROM layoffscopy2;

-- Investigating specific companies that laid off 100% of their workforce
SELECT *
FROM layoffscopy2
WHERE percentage_laid_off = 1;

-- Top Companies by "Total Laid Off" (Overall): Order companies by the total number of paople laid off
SELECT *
FROM layoffscopy2
WHERE percentage_laid_off =  1
ORDER BY total_laid_off DESC;

-- Top Companies by "Total Laid Off" (Overall): Order companies by the amount of funding
SELECT *
FROM layoffscopy2
WHERE percentage_laid_off =  1
ORDER BY funds_raised_millions DESC;

-- Top Companies by "Total Laid Off" (Overall): Order companies by their total layoffs
SELECT company, SUM(total_laid_off)
FROM layoffscopy2
GROUP BY company
ORDER BY 2 DESC ;


-- II. Categorical Analysis

-- Layoffs by Industry: Analyzing which industries were most affected by layoffs 
-- The Most affected
SELECT industry, SUM(total_laid_off)
FROM layoffscopy2
GROUP BY industry
ORDER BY 2 DESC ;

-- The Least affected
SELECT industry, SUM(total_laid_off)
FROM layoffscopy2
GROUP BY industry
ORDER BY 2 ASC ;

-- Layoffs by Country: Identifying countries with the highest number of layoffs
SELECT country, SUM(total_laid_off)
FROM layoffscopy2
GROUP BY country
ORDER BY 2 DESC ;

-- Layoffs by Comapany Stage: Examining layoffs based on the company's funding stage
SELECT stage, SUM(total_laid_off)
FROM layoffscopy2
GROUP BY stage
ORDER BY 2 DESC ;


-- III. Temporal Analysis
-- Date Range of Data : Determining the minimum and maximum dates in the dataset
SELECT MIN(`date`), MAX(`date`)
FROM layoffscopy2;
-- The dates seem to align with the start of the COVID-19 pandemic

-- Layoffs by Year: Grouped total layoffs by year to see annual trends.
SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffscopy2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC ;

-- Total laid off by month
SELECT SUBSTRING(`date`, 1, 7) AS `MONTH`, SUM(total_laid_off)
FROM layoffscopy2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC ;

-- Rolling Sum of Layoffs by Month: 
-- Calculating a cumulative sum of layoffs month by month, providing a progressive view of job losses over time and highlighting periods of significant increases
WITH rolling_total AS
(
SELECT SUBSTRING(`date`, 1, 7) AS `MONTH`, SUM(total_laid_off) AS total_L_off
FROM layoffscopy2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
)
SELECT `MONTH`, total_L_off, SUM(total_L_off) OVER (ORDER BY `MONTH`) AS Rolling_Total
FROM rolling_total ;

-- IV. Advanced Analysis (using CTEs and Window Functions): Rank of Companies by Layoffs Per Year
-- Using DENSE_RANK() with PARTITION BY year to rank companies based on the number of people they laid off in a given year.
-- This allows for identification of the top layoff events for specific companies within each year 

SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffscopy2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC ;

WITH Company_Year (company, years, total_laid_off) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffscopy2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC
),  Company_Year_Rank AS 
(SELECT *, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_Year 
WHERE years IS NOT NULL 
)
SELECT *
FROM Company_Year_Rank
WHERE Ranking <= 5 ;

 