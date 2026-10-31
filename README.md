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
- **Java 21 / Spring Boot 3.5.6** – REST API backed by PostgreSQL; a separate Java exporter prepares JSON for the interactive website dashboard
- **HTML / CSS / JavaScript** – interactive portfolio dashboard with responsive charts and filters
- **GitHub Pages** – hosting for the portfolio dashboard


## Interactive Website Dashboard

🔗 **[Explore the Insurance Claims Dashboard](https://worleyek.github.io/building/insurance-claims-dashboard.html)**

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

🌐 **Interactive web version:** [Insurance Claims Explorer](https://worleyek.github.io/building/insurance-claims-dashboard.html).


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

## Local Setup

The workflow has three parts: prepare the PostgreSQL tables, run the Python modeling notebook, and use the outputs in Power BI or the website dashboard. The Java REST API can run as soon as `claims_final` exists; model training is not required for its endpoints.

### Prerequisites

- Python 3 with `pip` and virtual environment support. The saved notebook metadata records Python 3.14.5; dependencies are not pinned to the original environment.
- A running PostgreSQL server and access to `psql` and `createdb`, or pgAdmin for equivalent database operations.
- JDK 21 and Maven for the REST API. The API's `pom.xml` targets Java 21 and Spring Boot 3.5.6. Maven must be installed separately; no Maven wrapper is included.
- Power BI Desktop on Windows to open the Power BI project.
- Git to clone the repositories, or download and extract their ZIP archives.

The shell commands below use Bash/macOS/Linux syntax unless labeled otherwise. Run commands from the insurance project root, except where a step explicitly changes directories.

### 1. Get the project and install Python dependencies

```bash
git clone https://github.com/worleyek/insurance-claims-risk-model.git
cd insurance-claims-risk-model

python -m venv .venv
source .venv/bin/activate
python -m pip install -r requirements.txt
python -m pip install psycopg2-binary jupyterlab ipykernel
python -m ipykernel install --user --name insurance-claims --display-name "Insurance Claims (.venv)"
```

On Windows PowerShell, activate the environment with `.\.venv\Scripts\Activate.ps1` instead of `source .venv/bin/activate`.

`psycopg2-binary` supplies the PostgreSQL driver used by the loader and notebook. It and the notebook tools are not currently listed in `requirements.txt`, so install them separately as shown above.

### 2. Create the database and load the source data

Create a dedicated local database named `insurance_analytics`, using the PostgreSQL account configured on your machine:

```bash
createdb -h localhost -p 5432 -U postgres insurance_analytics
```

Skip creation if that database already exists and is dedicated to this project. The SQL script drops and rebuilds project tables and views, and the loader replaces `raw_claims`.

The source CSV is included at `data/raw/AutoInsuranceClaims2024.csv`. In `load_data.py`, change the CSV-reading line to:

```python
df = pd.read_csv("data/raw/AutoInsuranceClaims2024.csv")
```

Replace the placeholder connection configuration in both `load_data.py` and the notebook's PostgreSQL connection cell. For example, this form prompts for the password and handles special characters in it:

```python
from getpass import getpass
from sqlalchemy import create_engine, URL

engine = create_engine(
    URL.create(
        "postgresql+psycopg2",
        username="postgres",
        password=getpass("PostgreSQL password: "),
        host="localhost",
        port=5432,
        database="insurance_analytics",
    )
)
```

Adjust the username, host, port, and database if needed. In the notebook, retain the subsequent `pd.read_sql("SELECT * FROM claims_final", engine)` call.

Load the raw data:

```bash
python load_data.py
```

The supplied raw dataset contains 9,134 records.

### 3. Run SQL preparation before modeling

`insurance_claims_sql_pipeline.sql` includes both the initial preparation and later checks against `claims_large`. That table is created by the notebook, so run the SQL in two stages.

In pgAdmin, execute everything before the `VALIDATION CHECKS FOR LARGE DATASET` section. Alternatively, split the file from the project root with Python:

```python
from pathlib import Path

sql = Path("insurance_claims_sql_pipeline.sql").read_text(encoding="utf-8")
marker = "/* =========================================================\n   VALIDATION CHECKS FOR LARGE DATASET"
setup, separator, checks = sql.partition(marker)
if not separator:
    raise ValueError("Could not find the large-dataset validation section")
Path("claims_setup.sql").write_text(setup, encoding="utf-8")
Path("claims_large_checks.sql").write_text(separator + checks, encoding="utf-8")
```

Then run:

```bash
psql -h localhost -p 5432 -U postgres -d insurance_analytics -v ON_ERROR_STOP=1 -f claims_setup.sql
psql -h localhost -p 5432 -U postgres -d insurance_analytics -c "SELECT COUNT(*) FROM public.claims_final;"
```

The expected `claims_final` count is **9,134**. This stage creates the cleaned tables, income bands, severity labels, complaint segments, descriptive risk scores, and indexes.

### 4. Run the modeling notebook

```bash
python -m jupyterlab insurance_claim_modeling.ipynb
```

Select the **Insurance Claims (.venv)** kernel. Confirm the database configuration from step 2, then run the notebook from top to bottom with the project root as its working directory.

The notebook:

- Reads `claims_final` and expands it to 500,000 synthetic records by resampling and adding numeric noise.
- Writes `claims_large` to PostgreSQL.
- Trains and evaluates six regression models using an 80/20 split of the original 9,134 records, with cross-validation for tuning.
- Applies the fitted Random Forest to the expanded synthetic dataset.
- Writes `model_results.csv` and `claims_predictions.csv` to the notebook's working directory.

Hyperparameter searches can take substantial time. The saved Random Forest benchmark is R² **0.8608**, MAE **93.03**, and RMSE **138.42** on the original dataset's test split. These are not evaluation metrics for the expanded 500,000-row portfolio.

The notebook calculates feature importance but does not currently export `feature_importances.csv`. To regenerate that file for the selected full-feature Random Forest, add and run this cell after `feature_importance_df` has been created:

```python
dashboard_features = feature_importance_df.head(10).copy()
dashboard_features["Feature"] = dashboard_features["Feature"].str.replace(
    r"^(num|cat)__", "", regex=True
)
dashboard_features.to_csv("feature_importances.csv", index=False)
```

This exports the top ten features from the current fitted model. Rankings can differ from the committed dashboard feature file; use matching model outputs when rebuilding a report.

After the notebook creates `claims_large`, run the remaining SQL checks:

```bash
psql -h localhost -p 5432 -U postgres -d insurance_analytics -v ON_ERROR_STOP=1 -f claims_large_checks.sql
```

The expected `claims_large` count is **500,000**, with **500,000 distinct customer IDs**. The notebook writes this database table before its final feature recalculations and prediction export, so the SQL checks inspect that earlier snapshot. `claims_predictions.csv` contains the final predictions.

### 5. Open or refresh the Power BI dashboard

To explore the supplied results without retraining, extract the committed predictions archive:

```bash
python -m zipfile -e dashboard/dashboard-data/claims-predictions.zip dashboard/dashboard-data
```

The supplied archive extracts the CSV to `dashboard/dashboard-data/claims-predictions/claims_predictions.csv`.

Open `dashboard/power-bi-files/insurance_claims_analysis.pbip` in Power BI Desktop. The project includes its associated report and semantic model folders; keep them together.

In **Transform data**, update the `File.Contents(...)` source paths for the following queries to files on your machine, then apply changes and refresh:

| Query | Use the supplied results | Use a new notebook run |
| --- | --- | --- |
| `claims_predictions` | `dashboard/dashboard-data/claims-predictions/claims_predictions.csv` | Root-level `claims_predictions.csv` |
| `model_results` | `dashboard/dashboard-data/model_results.csv` | Root-level `model_results.csv` |

The `feature_importance` query currently contains embedded values rather than a CSV connection. To refresh its rankings, replace that query's source with the newly exported `feature_importances.csv`, preserving the `Feature` and `Importance` columns.

For a preview without Power BI Desktop, see the screenshots and PDF in `dashboard/images/` or the [interactive website dashboard](https://worleyek.github.io/building/insurance-claims-dashboard.html).

### 6. Run the Java REST API

The API uses Spring Boot, Spring JDBC, and PostgreSQL. It queries **`public.claims_final`**, which contains the original prepared records. Its endpoints return database records and descriptive summaries as JSON; they do not run the Python model or serve the expanded prediction CSV.

From the project root, configure the database and start the API:

```bash
export DB_URL='jdbc:postgresql://localhost:5432/insurance_analytics'
export DB_USERNAME='postgres'
read -r -s -p 'PostgreSQL password: ' DB_PASSWORD
export DB_PASSWORD

cd java-api
mvn spring-boot:run
```

For Windows PowerShell, use this configuration and launch sequence from the project root instead:

```powershell
$env:DB_URL = 'jdbc:postgresql://localhost:5432/insurance_analytics'
$env:DB_USERNAME = 'postgres'
$credential = Get-Credential -UserName $env:DB_USERNAME -Message 'PostgreSQL credentials'
$env:DB_PASSWORD = $credential.GetNetworkCredential().Password

Set-Location java-api
mvn spring-boot:run
```

The default port is **8080**. Set `SERVER_PORT` before startup if another port is needed. Check that `java -version` and `mvn -version` both use JDK 21.

With the application running, open these URLs in a browser or request them from a second terminal:

```bash
curl 'http://localhost:8080/api/health'
curl 'http://localhost:8080/api/claims?page=0&size=5'
curl 'http://localhost:8080/api/analytics/summary'
```

| Endpoint | Purpose |
| --- | --- |
| `GET /api/health` | Checks database connectivity; a successful response contains `status: UP` and `database: UP`. |
| `GET /api/claims?page=0&size=20` | Returns a JSON array of claims ordered by customer ID. Pages start at 0; page size must be 1–100. |
| `GET /api/claims/{customerId}` | Returns one customer record. Replace `{customerId}` with an ID from the claims response. Missing IDs return HTTP 404. |
| `GET /api/analytics/summary` | Returns record count, average and total claim amount, and average monthly premium. |
| `GET /api/analytics/by-state` | Groups record counts and claim amounts by state. |
| `GET /api/analytics/risk-distribution` | Groups record counts and average claim amounts by descriptive risk score. |
| `GET /api/analytics/severity` | Groups record counts and average claim amounts by claim severity. |

The API uses a read-only database connection. Its summary should report `customer_count: 9134` when using the supplied dataset prepared by the SQL pipeline.

### 7. Optional: rebuild the website dashboard dataset

The [website repository](https://github.com/worleyek/worleyek.github.io) contains the dashboard's HTML, CSS, JavaScript, and Java exporter. The website currently loads a **static JSON file** rather than calling the REST API.

To rebuild that JSON from a new notebook run, first place these three outputs in `dashboard/dashboard-data/`:

- `claims_predictions.csv`
- `model_results.csv`
- `feature_importances.csv`

Copy them from the notebook's working directory, keeping existing results backed up if needed. The exporter also supports the supplied predictions ZIP. The regenerated feature file must have the `Feature` and `Importance` headers shown in step 4.

With the website repository checked out beside this repository, run these commands from the insurance project root:

```bash
git clone https://github.com/worleyek/worleyek.github.io.git ../worleyek.github.io
java ../worleyek.github.io/building/dashboard/insurance-claims/tools/ClaimsDataExporter.java . ../worleyek.github.io/building/dashboard/insurance-claims/claims-data.json
python -m http.server 8000 --directory ../worleyek.github.io
```

Skip the clone command if that checkout already exists. The standalone exporter specifies JDK 17+; the API's JDK 21 also satisfies that requirement.

Open `http://localhost:8000/building/insurance-claims-dashboard.html` to preview the dashboard with its regenerated data. The exporter validates and aggregates the records; the browser uses the generated JSON for interactive charts and filters.

### Reproducibility Notes

- `requirements.txt` does not pin dependency versions, so exact numeric results may vary across environments.
- The train/test split, resampling, and randomized ensemble searches use `random_state=42`. The NumPy noise-generation cells do not set a seed, so regenerated synthetic records will differ between runs.
  - To make future expansions repeatable, add `np.random.seed(42)` immediately before the first noise-generation cell; that will not recreate the original unseeded expansion exactly.
- The notebook reads `claims_final` without `ORDER BY`. Database row order can affect the train/test assignment even with a fixed random seed.
  - For a stable future workflow, add `ORDER BY customer_id` to that read query and establish a new benchmark from the resulting run.
- Use the committed dashboard exports to inspect the saved results. A fresh run reproduces the workflow, but is not guaranteed to reproduce every saved metric or synthetic record exactly.
- The 500,000 records are a synthetic expansion of the original data, not an independent validation dataset. Risk scores include observed claim amounts and are descriptive segments.
- The supplied `data/processed/processed.zip` is not a usable archive in this snapshot. Use the included raw CSV, the individual processed CSVs, or regenerate the expanded data through the notebook.
