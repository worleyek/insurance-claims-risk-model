# Insurance Claim Prediction & Risk Analytics

🔗 **[Explore the Insurance Claims Dashboard](https://worleyek.github.io/building/insurance-claims-dashboard.html)**

## Project Overview

This project builds an end-to-end insurance analytics pipeline to predict claim severity and identify high-risk policyholders using SQL, Python, and machine learning. 

The workflow includes data extraction from PostgreSQL, data cleaning and feature engineering, predictive modeling, and business intelligence reporting through Power BI and an interactive dashboard on my portfolio website.

The objective is to help insurers better understand risk drivers and improve underwriting and pricing decisions.


## Tools & Technologies

- **SQL (PostgreSQL)** – data extraction, cleaning, feature engineering
- **Python** – data processing and modeling
- **Pandas / NumPy** – data manipulation
- **Scikit-learn** – machine learning models and evaluation
- **Matplotlib** – visualization
- **Power BI** – business intelligence reporting and visualizations
- **Java** – data validation, aggregation, and JSON export for the website dashboard
- **HTML / CSS / JavaScript** – interactive portfolio dashboard with responsive charts and filters
- **GitHub Pages** – hosting for the portfolio dashboard


## Interactive Website Dashboard

**[Explore the Insurance Claims Dashboard](https://worleyek.github.io/building/insurance-claims-dashboard.html)**

I built an interactive dashboard for my [personal portfolio website](https://worleyek.github.io/) to make the analysis accessible in a browser. It complements the Power BI report and presents the insurance claims results using the website's existing visual design and dark/light theme support.

The dashboard includes:
- **Portfolio overview:** summary metrics and comparisons of observed versus predicted claim amounts.
- **Risk segmentation:** exploration of risk scores, claim severity, and policyholder segments.
- **Customer insights:** interactive analysis of customer and policy characteristics.
- **Model performance:** comparison of regression models and feature importance.
- **Interactive filtering:** explore results by state, coverage, vehicle class, and income band, with chart-level interactions.

The website dashboard summarizes **500,000 synthetic policy records** from the expanded prediction export. 

A Java exporter validates and aggregates the project data into a JSON file consumed by client-side JavaScript. **This is an interactive static snapshot, not a live database connection or real-time prediction service.** 

The dashboard source code is maintained in the [personal website repository](https://github.com/worleyek/worleyek.github.io), under `building/insurance-claims-dashboard.html` and `building/dashboard/insurance-claims/`.


## Folders in Repository
- [`data`](https://github.com/worleyek/insurance-claims-risk-model/tree/main/data) - contains raw and processed datasets
- [`dashboard`](https://github.com/worleyek/insurance-claims-risk-model/tree/main/dashboard) - contains model output files used for dashboard creation, Power BI project files, and dashboard images
- [`java-api`](https://github.com/worleyek/insurance-claims-risk-model/tree/main/java-api) - contains the Java application and related source files

## Files in Repository

- `insurance_claim_modeling.ipynb` – full analysis and modeling pipeline
- `insurance_claims_sql_pipeline.sql` - SQL data cleaning, analysis, and feature engineering
- `load_data.py` – used to load data into PostgreSQL
- `requirements.txt` – Python dependencies


## Dataset

Auto insurance claims dataset containing policyholder demographics, vehicle attributes, policy details, and claim amounts ([source](https://www.kaggle.com/datasets/thebumpkin/auto-insurance-claims-updated-to-2024)).

Key features include:
- Income
- Vehicle Class
- Policy Type
- Monthly Premium
- Customer Lifetime Value
- Number of Complaints
- Claim Amount (target variable)


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
- MAE (mean absolute error)
- RMSE (root mean square error)
- R²

### 4. Hyperparameter Tuning
Random Forest and Gradient Boosting models were optimized using RandomizedSearchCV.

### 5. Model Comparison
Random Forest achieved the best overall performance in terms of error reduction and predictive accuracy.

### 6. Feature Importance Analysis
Key drivers of claim severity were identified using Random Forest feature importance.

### 7. Business Intelligence and Website Dashboard Output
The final dataset was exported for Power BI, including:
- Predicted claim amounts
- Risk scores
- Income bands
- Claim severity labels

The expanded predictions and model results were also used to build a Java-generated JSON export for the interactive website dashboard.


## Key Results

- Random Forest achieved the highest predictive accuracy
- Monthly premium and vehicle characteristics were strong predictors of claim severity
- Removing premium and CLV reduced model performance, indicating they contain meaningful risk information

| Model | MAE | RMSE | R² |
|:------|:----|:-----|:----|
| Random Forest | 93.03 | 138.42 | 0.8608 |
| Gradient Boosting | 95.23 | 139.46 | 0.8587 |
| Lasso | 125.46 | 177.21 | 0.7719 |
| Elastic Net | 123.84 | 177.82 | 0.7703 |
| Linear Regression | 127.78 | 178.46 | 0.7687 |
| Ridge | 149.65 | 206.48 | 0.6903 |


## Final Output

The final datasets support Power BI reporting and the interactive website dashboard for:
- Risk segmentation
- Claim severity analysis
- Policyholder profiling
- Model performance visualization

<img width="2767" height="1600" alt="image" src="https://github.com/user-attachments/assets/2042c8e7-875c-40b6-afd7-32effedfd9e3"/>

More Power BI dashboard images can be found [here](https://github.com/worleyek/insurance-claims-risk-model/tree/main/dashboard/images).

**Interactive web version:** [Insurance Claims Explorer](https://worleyek.github.io/building/insurance-claims-dashboard.html).



## Modeling Strategy

Due to computational limitations, model training and evaluation were performed on a subset of approximately 9,000 records. Training directly on the full synthetic dataset (~500,000 rows) resulted in significantly longer runtimes, particularly for ensemble methods such as Random Forest.

To balance performance and scalability, the workflow was structured as follows:

- Models were trained and tuned on the smaller dataset for efficiency and iteration speed
- The best-performing models were then used to generate predictions on the full synthetic dataset
- The expanded dataset with predictions was exported for Power BI dashboard development

This approach allowed for efficient model development while still enabling large-scale business intelligence reporting and visualization.


## Limitations
- The dataset is synthetic/secondary and may not fully represent real-world insurance claim behavior.
- Monthly Premium and Customer Lifetime Value may partially encode risk information, which could inflate predictive performance.
- Temporal effects were not explicitly modeled (e.g., claim trends over time).
- External risk factors such as driving behavior, weather, or geographic hazard exposure were not included.

## Future Work 🪷
- Incorporate time-series or survival analysis techniques for claim prediction over time.
- Evaluate advanced gradient boosting frameworks such as XGBoost.
- Build a classification model to predict high-risk policyholders.
- Connect the website dashboard to a deployed API or database for live updates and, if appropriate, real-time risk scoring.
