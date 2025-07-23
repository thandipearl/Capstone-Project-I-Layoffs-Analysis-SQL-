# Layoffs-Data-Analysis

# MySQL Layoffs Data Analysis Project  

This repository contains a comprehensive data analysis project focusing on recent layoffs data. The project leverages **MySQL** for both data cleaning and in-depth **Exploratory Data Analysis (EDA)**, providing a complete workflow from raw data to actionable insights.  

---

## 📌 Project Overview  

The primary goal of this project was to understand the **trends and patterns of layoffs**, particularly during the period affected by the **COVID-19 pandemic**.  

The analysis involved a two-phase approach:  

1. **Data Cleaning** – Preparing the raw dataset for analysis by addressing common data quality issues.  
2. **Exploratory Data Analysis (EDA)** – Delving into the cleaned data to uncover insights, identify key trends, and visualize significant findings.  

---

## 📊 Data Source  

The dataset contains information about **layoffs from various companies** across different industries, locations, and time periods.  

---

## 🧹 Data Cleaning (SQL)  

The `SQL Data Cleaning.sql` script details the meticulous steps taken to ensure data quality and integrity.  

Key data cleaning operations include:  

- **Duplicate Removal**  
  - Identifying and eliminating duplicate records to ensure each layoff event is unique.  

- **Data Standardization**  
  - **Trimming Whitespace:** Removing extra spaces from company names for consistency.  
  - **Consistent Categorization:** Standardizing industry names (e.g., consolidating all `Crypto%` entries into **Crypto**).  
  - **Country Standardization:** Removing extraneous characters (e.g., trailing periods) from country names.  
  - **Date Formatting:** Converting text-based date columns into a proper `DATE` data type for accurate time analysis.  

- **Handling NULL and Blank Values**  
  - Identifying rows with missing values in critical columns.  
  - Populating missing industry values where possible by cross-referencing company data.  
  - Deleting rows where both `total_laid_off` AND `percentage_laid_off` were NULL, as they provided no meaningful data.  

- **Irrelevant Column Removal**  
  - Dropping the temporary `row_num` column created during the duplicate removal process.  

---

## 🔍 Exploratory Data Analysis (SQL)  

The `SQL Exploratory Data Analysis.sql` script showcases a wide range of analytical queries to extract insights from the cleaned data.  

### Key EDA Findings  

- **Overall Layoff Scale**  
  - Identified the maximum number of people laid off in a single event (**12,000**).  
  - Found instances of **100% company layoffs**.  

- **Top Companies by Layoffs**  
  - Ranked companies by their total layoff figures, highlighting major players like **Amazon, Google, Meta, and Microsoft**.  

- **Temporal Analysis**  
  - Dataset date range: **March 2020 – early 2023**, aligning with the COVID-19 impact.  
  - **2022 was the worst year**, with a concerning accelerating trend into 2023.  
  - Calculated a **rolling sum of layoffs by month** to visualize the cumulative impact over time.  

- **Categorical Analysis**  
  - Identified **most affected industries** (Consumer & Retail hit hardest) and **least affected** (Manufacturing & Tech).  
  - Pinpointed **countries with the highest layoffs**, with the **United States leading significantly**.  
  - Examined layoffs by **company funding stage**, revealing **post-IPO companies** experienced the most layoffs.  

- **Advanced Analysis (CTEs & Window Functions)**  
  - Implemented `DENSE_RANK()` with `PARTITION BY year` to rank companies by their annual layoff figures.  
  - Identified **top 5 companies with the most layoffs each year** (e.g., **Uber in 2020**, **Meta in 2022**, **Google in 2023**).  

---

## 🛠️ Technologies Used  

- **MySQL** – Database management system for all data cleaning and analysis operations.  
- **SQL** – Query language for interacting with the MySQL database.  

---

## 📂 Repository Contents  

- `SQL Data Cleaning.sql` – Scripts for cleaning and standardizing raw layoff data.  
- `SQL Exploratory Data Analysis.sql` – Scripts for analyzing trends, patterns, and insights.
- `layoffs.csv` - Raw dataset.
- `Layoffs Data Analysis Insights.pdf` - PDF of Insights and Conclusions derived from the data.

---

### ✅ Insights at a Glance  

- Layoffs peaked during **COVID-19** and continued into **2023**.  
- **Consumer & Retail** industries were hit hardest.  
- **Post-IPO companies** faced the most layoffs.  
- Major layoffs were concentrated in **Amazon, Google, Meta, Microsoft**.  



