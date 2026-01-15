-- Data Cleaning

-- Remove Duplicates
-- Standardize the data
-- Null values and blank values
-- Remove any columns that are not neccessary

SELECT *
FROM layoffs;

CREATE TABLE layoffs_staging
like layoffs;

SELECT *
FROM layoffs_staging;

INSERT layoffs_staging
SELECT *
FROM layoffs;

SELECT *
FROM layoffs_staging;

 
 WITH duplicate_cte AS
 (

SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT*
FROM duplicate_cte
WHERE  row_num > 1;



SELECT 
    company,
    location,
    industry,
    total_laid_off,
    percentage_laid_off,
    date,
    stage,
    country,
    funds_raised_millions,
    COUNT(*) as duplicate_count
FROM layoffs_staging
GROUP BY 
    company,
    location,
    industry,
    total_laid_off,
    percentage_laid_off,
    date,
    stage,
    country,
    funds_raised_millions
HAVING COUNT(*) > 1;


CREATE TABLE `layoffs_staging2` (
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

SELECT* 
FROM layoffs_staging2;

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

SELECT* 
FROM layoffs_staging2;

SELECT* 
FROM layoffs_staging2
WHERE row_num > 1;

SET SQL_SAFE_UPDATES = 0;

DELETE
FROM layoffs_staging2
WHERE row_num > 1;

SET SQL_SAFE_UPDATES = 1;

SELECT* 
FROM layoffs_staging2
WHERE row_num > 1;

-- Standardizeing data

-- Company

SELECT DISTINCT company 
FROM layoffs_staging2 ORDER BY company;

SET SQL_SAFE_UPDATES = 0;

UPDATE layoffs_staging2 
SET company = TRIM(company);




UPDATE layoffs_staging2 
SET company = 'Twitter' 
WHERE company IN ('Twitter', 'twitter', 'Twitter ');

-- INDUSTRY

SELECT DISTINCT INDUSTRY
FROM layoffs_staging2
ORDER BY industry;

SELECT*
FROM layoffs_staging2
WHERE industry like 'Crypto%';

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT*
FROM layoffs_staging2
WHERE industry like 'Fin%';

-- LOCATIONS

SELECT DISTINCT location
FROM layoffs_staging2
ORDER BY 1;

SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY country;

SELECT DISTINCT country
FROM layoffs_staging2
WHERE country like 'United States%'
ORDER BY country;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
Where country LIKE 'United States%';

-- DATE

SELECT `date`,
str_to_date(`date`, '%m/%d/%Y')
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = str_to_date(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

SELECT *
FROM layoffs_staging2;

-- NULL VALUES AND BLANK VALUES

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

SELECT t1.industry, t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
ON t1.company = t2.company
AND t1.location = t2.location
WHERE (t1.industry IS NULL OR t1.industry = '.')
AND t2.industry IS NOT NULL;

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

SELECT *
FROM layoffs_staging2;



SELECT company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions,
       COUNT(*) as duplicate_count
FROM layoffs_staging2
GROUP BY company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions
HAVING COUNT(*) > 1;

SELECT 
    (SELECT COUNT(*) FROM layoffs_staging2) as total_rows,
    (SELECT COUNT(DISTINCT company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions) 
     FROM layoffs_staging2) as distinct_rows,
    (SELECT COUNT(*) FROM layoffs_staging2) - 
    (SELECT COUNT(DISTINCT company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions) 
     FROM layoffs_staging2) as duplicate_count_in_final;

CREATE TABLE layoffs_staging2_backup AS
SELECT * FROM layoffs_staging2;

SELECT COUNT(*) FROM layoffs_staging2;

SELECT COUNT(*) FROM layoffs_staging2_backup;

-- CHECK DUPLICATES
SELECT
    company,
    location,
    industry,
    total_laid_off,
    percentage_laid_off,
    `date`,
    stage,
    country,
    funds_raised_millions,
    COUNT(*) AS duplicate_count
FROM layoffs_staging2
GROUP BY
    company,
    location,
    industry,
    total_laid_off,
    percentage_laid_off,
    `date`,
    stage,
    country,
    funds_raised_millions
HAVING COUNT(*) > 1;


SELECT
    company,
    location,
    industry,
    total_laid_off,
    percentage_laid_off,
    `date`,
    stage,
    country,
    funds_raised_millions,
    COUNT(*) AS duplicate_count
FROM layoffs_staging2
GROUP BY 1,2,3,4,5,6,7,8,9
HAVING COUNT(*) > 1;

SELECT DISTINCT industry FROM layoffs_staging2 ORDER BY industry;

UPDATE layoffs_staging2
SET industry = 'Unknown'
WHERE industry IS NULL OR industry = '';

UPDATE layoffs_staging2
SET stage = TRIM(stage);

UPDATE layoffs_staging2 
SET stage = 'Unknown' 
WHERE stage IS NULL OR stage = '';

SELECT*
FROM layoffs_staging2;


















































