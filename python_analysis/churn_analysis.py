import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt

df=pd.read_csv("customer_churn.csv")

# first 5 rows
print(df.head())

#shape
print("Shape:", df.shape)

#columns
print(df.columns)

#dataset info
print(df.info())

#missing values
print(df.isnull().sum())

#statistics
print(df.describe())

#clean column name
df.columns=df.columns.str.strip()
df.columns=df.columns.str.replace(" ","_")
df.columns=df.columns.str.lower()

print(df.columns)

# CHECKING DUPLICATES RECORDS

print("duplicate rows:", df.duplicated().sum())

# fill missing categorical values

df['offer'] = df['offer'].fillna('No Offer')

df['internet_type'] = df['internet_type'].fillna('No Internet')

df['churn_category'] = df['churn_category'].fillna('No Churn')

df['churn_reason'] = df['churn_reason'].fillna('Not Churned')


# verify missing values

print(df.isnull().sum())

#check data types
print(df.dtypes)

df.to_csv("cleaned_customer_churn.csv", index=False)

print("Cleaned dataset saved successfully")

# churn distribution

sns.countplot(x='churn_label', data=df)
plt.title("Customer Churn Distribution")
plt.show()

# contract type vs churn

sns.countplot(x='contract',hue='churn_label', data=df)
plt.title("Contract Type vs Churn")
plt.xticks(rotation=45)
plt.show()

# payment method vs churn

plt.figure(figsize=(10,6))
sns.countplot(x='payment_method', hue='churn_label', data=df)
plt.xticks(rotation=90)

plt.title("Payment Method vs Churn")
plt.show()

# monthly charge distribution

sns.histplot(df['monthly_charge'], kde=True)
plt.title("Monthly Charge Distribution")
plt.show()

# internet type vs churn
sns.countplot(x='internet_type', hue='churn_label',data=df)
plt.xticks(rotation=45)
plt.title("Internet Type vs Churn")
plt.show()

#  tenure distribution

plt.figure(figsize=(10,6))
sns.boxplot(x='churn_label', y='tenure_in_months', data=df)
plt.title("Tenure vs churn")
plt.show()

# satisfaction score vs churn

sns.boxplot(x='churn_label',y='satisfaction_score',data=df)
plt.title("satisfaction score vs churn")
plt.show()

#correlation heatmap

numeric_df=df.select_dtypes(include=['int64','float64'])
plt.figure(figsize=(14,8))
sns.heatmap(numeric_df.corr(), annot=True)
plt.title("Correlation Heatmap")
plt.show()

plt.savefig("visualizations/churn_distribution.png")