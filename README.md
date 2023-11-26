# Credit Card Segmentation - Data Science Capstone Project

## Overview

This project focuses on customer segmentation to define a targeted marketing strategy based on the usage behavior of approximately 9000 active credit card holders over the last 6 months. The dataset includes customer-level information with 18 behavioral variables.

## Files

- `credit-card-data`: Raw data containing customer information.
- `Project_python1.ipynb`: Jupyter notebook with Python code.
- `Project_R_1.R`: R code.
- `Project Report.doc`: Detailed project report with visualizations and behavioral patterns.
- `Credit-Card Segmentation Project DF_Python.csv`: Cluster results formed with Python code.
- `Credit-Card Segmentation Project DF_R.csv`: Cluster results formed with R code.

## Characteristics Analysis

### Cluster 1: Good Payers, Hesitant Users

- Not frequent credit card users.
- Majority use cash advance transactions with low frequency.
- Low credit limit with a high payment ratio.
- Low usage limit and percentage for full payment.
  
**Marketing Strategy Ideas:**
- Extend credit limits.
- Reduce transaction charges for cash advances.
- Provide low-interest rates and incentives for purchases.

### Cluster 2: Good Payers and Good Users

- Good cash advance and decent purchase type users.
- Good payment ratio and credit usage.
- Slightly low percentage of full payment.
  
**Marketing Strategy Ideas:**
- Offer high reward points.
- Eliminate late fees and minor charges.
- Provide internationally accepted cards.

### Cluster 3: Mediocre Users with Some Defaulters

- Good purchase type users.
- Poor cash advance users.
- Some defaulters with high payment ratio and low credit limit.
  
**Marketing Strategy Ideas:**
- Offer reduced interest rates for expensive products.
- Advertise advantages of using cash advance transactions.

## Data Analysis

### 1. Missing Value Analysis

- Missing values in `MINIMUM_PAYMENTS`: 313
- Imputed using KNN imputation method.

### 2. Feature Engineering

- New variable `Card_use_type` derived to indicate the type of transaction.
- Monthly average purchase and cash advance amount calculated.
- Limit usage, payment ratio, and other features engineered.

### 3. Outlier Analysis

- Outliers dropped for variables: `BALANCE`, `CREDIT_LIMIT`, `PAYMENTS`.

### 4. Correlation Analysis

- Heatmap used to identify and drop correlated variables.

### 5. Normalization

- Numerical data normalized using standardization technique.

### 6. Model Development

- Elbow method used to determine the optimum number of clusters (3).
- K-means clustering applied, and observations classified into three clusters.

## Cluster Counts

- Cluster 1: 3340
- Cluster 2: 2701
- Cluster 3: 1239

For more details, please refer to the [Project Report](Project%20Report.doc).
