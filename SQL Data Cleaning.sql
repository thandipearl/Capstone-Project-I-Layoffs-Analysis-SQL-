-- Data Cleaning

SELECT *
FROM  layoffs;

-- 1. Remove Duplicates if there are any
-- 2. Standardize the data e.g. are there any spelling errors in the data?
-- 3. Handling the NULL values and the blank values
-- 4. Removing any rows and columns that are not necessary or are irrelevant


-- Creating the data that we will be working on because we do not want to alter the raw data.
CREATE TABLE layoffsCopy
LIKE layoffs;

SELECT *
FROM layoffsCopy;

INSERT layoffsCopy
SELECT *
FROM layoffs;


-- 1. Removing Duplicates
SELECT *,
ROW_NUMBER() OVER (
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) AS row_num
FROM layoffsCopy;

WITH duplicate_cte AS 
(
SELECT *,
ROW_NUMBER() OVER (
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) AS row_num
FROM layoffsCopy
)
SELECT *
FROM duplicate_cte
WHERE  row_num > 1;

-- Creating a table with an extra column row_num and deleting all entries with row_num > 1

CREATE TABLE `layoffscopy2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM layoffsCopy2;

INSERT INTO layoffsCopy2
SELECT *,
ROW_NUMBER() OVER (
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) AS row_num
FROM layoffsCopy;

SET SQL_SAFE_UPDATES = 0;


DELETE
FROM layoffscopy2
WHERE row_num > 1;


SELECT *
FROM layoffscopy2
WHERE row_num > 1;

-- We note that column row_num only has values of 1 which means all the duplicates have been removed



-- 2. Standardizing Data

-- 2.1. Eliminating unnecessary spaces
SELECT company, TRIM(company)
FROM layoffsCopy2;

UPDATE layoffsCopy2
SET company = TRIM(company);

-- 2.2. We want all name columns to have distinct entries
SELECT DISTINCT industry
FROM layoffsCopy2
ORDER BY 1;

SELECT *
FROM layoffsCopy2 
WHERE industry LIKE 'Crypto%';

UPDATE layoffsCopy2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';                                     -- all industries are now distinct

SELECT DISTINCT location
FROM layoffsCopy2
ORDER BY 1;                                                        -- all locations are already distinct

SELECT DISTINCT country
FROM layoffsCopy2
ORDER BY 1;

SELECT *
FROM layoffsCopy2
WHERE country LIKE 'United States%';

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffsCopy2
ORDER BY 1;

UPDATE layoffscopy2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%' ;                            -- Now all countries are distinct

-- For EDA, timeseries and Data Visualization, we will need the date data type to be changed from text to date.
SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoffsCopy2;

UPDATE layoffsCopy2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffsCopy2
MODIFY COLUMN `date` DATE;                                      -- Now the data type for date has been changed from text to date


-- 3. Handling NULL and blank values


SELECT *
FROM layoffscopy2
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;   -- If a row has NULL's in both of these fields, it MIGHT be an irrelevent row that we could delete.

SELECT *
FROM layoffsCopy2
WHERE industry IS NULL OR industry = '' ;  -- Running this, we get three rows that are blank and one row that is NULL
										   -- One of the rows with the blank has company detailed Airbnb
                                           -- We want to see if any of Airbnb's industry column is populated

SELECT *
FROM layoffsCopy2
WHERE company = 'Airbnb';                  -- Running this, we get another entry with Airbnb with Travel as an industry
                                           -- So we pupulate the Airbnb with a blank to also have Travel under the industry column

UPDATE layoffscopy2
SET industry = NULL 
WHERE 	industry  = '' ;                            -- Setting all blanks to nulls

SELECT t1.industry, t2.industry
FROM layoffscopy2 t1
JOIN layoffscopy2 t2
	ON t1.company = t2.company
    AND t1.location = t2.location
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL ;                      -- Now all blanks are set to nulls   


UPDATE layoffscopy2 t1
JOIN layoffscopy2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL 
AND t2.industry IS NOT NULL ;

SELECT *
FROM layoffscopy2
WHERE industry = ' ' OR industry IS NULL ;       -- Checking if there are any blanks or NULL values under the industry column
                                                 -- We found the company Bally's Interactive but its the only row that has this company
                                                 -- So we cannot populate it.
                                                 -- We will keep the row since it does have an entry in the percentage_laid_off column
SELECT *
FROM layoffsCopy2;		

-- 4. Removing any rows and columns that are not necessary or are irrelevant										
                                                
-- Back to the total_laid_off column
DELETE
FROM layoffscopy2
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;

-- Dropping the row_num column that we created when we were removing duplicates
ALTER TABLE layoffscopy2
DROP COLUMN row_num ;                           





















