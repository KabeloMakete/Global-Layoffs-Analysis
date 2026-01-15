-- DATA ANALYSIS

-- Layoffs Overtime

SELECT 
    DATE_FORMAT(date, '%Y-%m') AS month,
    SUM(total_laid_off) AS total_layoffs
FROM layoffs_staging2
GROUP BY month
ORDER BY month;

-- Layoffs By Industry

SELECT 
    industry,
    SUM(total_laid_off) AS total_layoffs
FROM layoffs_staging2
WHERE industry IS NOT NULL
GROUP BY industry
ORDER BY total_layoffs DESC;

-- Layoffs By Country

SELECT 
    country,
    SUM(total_laid_off) AS total_layoffs
FROM layoffs_staging2
WHERE total_laid_off IS NOT NULL
GROUP BY country
ORDER BY total_layoffs DESC;

-- Layoffs By Company Stsge

SELECT 
    stage,
    SUM(total_laid_off) AS total_layoffs
FROM layoffs_staging2
WHERE stage IS NOT NULL
GROUP BY stage
ORDER BY total_layoffs DESC;

-- Severity Of Layoffs

SELECT 
    company,
    percentage_laid_off,
    total_laid_off
FROM layoffs_staging2
WHERE percentage_laid_off IS NOT NULL
ORDER BY percentage_laid_off DESC;








