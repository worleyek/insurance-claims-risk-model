# Insurance Claim Prediction & Risk Analytics

## Project Overview

This project builds an end-to-end insurance analytics pipeline to predict claim severity and identify high-risk policyholders using SQL, Python, and machine learning. The workflow includes data extraction from PostgreSQL, data cleaning and feature engineering, predictive modeling, and preparation of business intelligence outputs for Power BI.

The objective is to help insurers better understand risk drivers and improve underwriting and pricing decisions.

---

## Tools & Technologies

- SQL (PostgreSQL) – data extraction, cleaning, feature engineering
- Python – data processing and modeling
- Pandas / NumPy – data manipulation
- Scikit-learn – machine learning models and evaluation
- Matplotlib – visualization
- Power BI – dashboarding (final output layer)

---

## Dataset

Auto insurance claims dataset containing policyholder demographics, vehicle attributes, policy details, and claim amounts.

Key features include:
- Income
- Vehicle Class
- Policy Type
- Monthly Premium
- Customer Lifetime Value
- Number of Complaints
- Claim Amount (target variable)

---

## Workflow

### 1. SQL Data Preparation
- Cleaned raw insurance data
- Handled missing values and outliers
- Engineered income bands and risk indicators
- Created structured analysis tables

### 2. Feature Engineering
- Income quartiles and bands
- Claim severity categorization
- Complaint risk segmentation
- Risk scoring system

### 3. Machine Learning Models
The following regression models were trained and evaluated:
- Linear Regression
- Ridge Regression
- Lasso Regression
- Elastic Net
- Random Forest Regressor
- Gradient Boosting Regressor

Models were evaluated using:
- MAE
- RMSE
- R²

### 4. Hyperparameter Tuning
Random Forest and Gradient Boosting models were optimized using RandomizedSearchCV.

### 5. Model Comparison
Random Forest achieved the best overall performance in terms of error reduction and predictive accuracy.

### 6. Feature Importance Analysis
Key drivers of claim severity were identified using Random Forest feature importance.

### 7. Business Intelligence Output
Final dataset was exported for Power BI, including:
- Predicted claim amounts
- Risk scores
- Income bands
- Claim severity labels

---

## Key Results

- Random Forest achieved the highest predictive accuracy
- Monthly premium and vehicle characteristics were strong predictors of claim severity
- Removing premium and CLV reduced model performance, indicating they contain meaningful risk information

---

## Final Output

The final dataset is designed for Power BI dashboards to support:
- Risk segmentation
- Claim severity analysis
- Policyholder profiling
- Model performance visualization

---

## Folders in Repository
- `data` - contains raw and processed datasets
- `dashboard` - contains model output files used for dashboard creation, Power BI project files, and dashboard images

## Files in Repository

- `insurance_claims_model.ipynb` – full analysis and modeling pipeline
- `insurance_claims_sql_pipeline.sql` - SQL data cleaning, analysis, and feature engineering
- `load_data.py` – used to load data into PostgreSQL
- `requirements.txt` – Python dependencies

---

## Modeling Strategy

Due to computational limitations, model training and evaluation were performed on a subset of approximately 9,000 records. Training directly on the full synthetic dataset (~500,000 rows) resulted in significantly longer runtimes, particularly for ensemble methods such as Random Forest.

To balance performance and scalability, the workflow was structured as follows:

- Models were trained and tuned on the smaller dataset for efficiency and iteration speed
- The best-performing models were then used to generate predictions on the full synthetic dataset
- The expanded dataset with predictions was exported for Power BI dashboard development

This approach allowed for efficient model development while still enabling large-scale business intelligence reporting and visualization.
