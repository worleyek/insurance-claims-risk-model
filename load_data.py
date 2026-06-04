# necessary installations
# pip install pandas sqlalchemy psycopg2-binary

import pandas as pd
from sqlalchemy import create_engine

# read CSV
df = pd.read_csv("AutoInsuranceClaims2024.csv")

# connect to PostgreSQL
engine = create_engine(
    "postgresql+psycopg2://postgres:YOUR_PASSWORD@localhost:PORT_NUMBER/YOUR_DATABASE" # replace YOUR_PASSWORD, PORT_NUMBER, and YOUR_DATABASE
)

# load dataframe into PostgreSQL
df.to_sql(
    "raw_claims",
    engine,
    if_exists="replace",
    index=False
)

print("Data loaded successfully!")