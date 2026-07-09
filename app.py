#!/usr/bin/env python
# coding: utf-8

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

from scipy import stats
from scipy.stats import ttest_1samp

from sqlalchemy import create_engine

from sklearn.preprocessing import LabelEncoder
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LinearRegression
from sklearn.ensemble import RandomForestRegressor
from sklearn.metrics import mean_absolute_error, mean_squared_error, r2_score

features = pd.read_csv("Dataset/Raw/features.csv")
stores = pd.read_csv("Dataset/Raw/stores.csv")
train = pd.read_csv("Dataset/Raw/train.csv")

df = train.merge(features, on=["Store", "Date", "IsHoliday"], how="left")
df = df.merge(stores, on="Store", how="left")

df.drop_duplicates(inplace=True)

for col in ["MarkDown1", "MarkDown2", "MarkDown3", "MarkDown4", "MarkDown5"]:
    df[col] = df[col].fillna(0)

df["Date"] = pd.to_datetime(df["Date"])
df["Year"] = df["Date"].dt.year
df["Month"] = df["Date"].dt.month_name()

plt.figure(figsize=(10, 6))
sns.histplot(df["Weekly_Sales"], bins=50, kde=True)
plt.title("Distribution of Weekly Sales")
plt.xlabel("Weekly Sales")
plt.ylabel("Frequency")
plt.show()

plt.figure(figsize=(12, 8))
sns.heatmap(df.corr(numeric_only=True), annot=True, cmap="coolwarm")
plt.title("Correlation Heatmap")
plt.show()

top_store_sales = (
    df.groupby("Store")["Weekly_Sales"]
    .sum()
    .sort_values(ascending=False)
    .head(10)
)

plt.figure(figsize=(10, 6))
sns.barplot(
    x=top_store_sales.index.astype(str),
    y=top_store_sales.values
)
plt.title("Top 10 Stores by Sales")
plt.xlabel("Store")
plt.ylabel("Total Sales")
plt.show()

month_order = [
    "January", "February", "March", "April",
    "May", "June", "July", "August",
    "September", "October", "November", "December"
]

df["Month"] = pd.Categorical(
    df["Month"],
    categories=month_order,
    ordered=True
)

monthly_sales = (
    df.groupby("Month")["Weekly_Sales"]
    .sum()
)

plt.figure(figsize=(10, 6))
plt.plot(monthly_sales.index, monthly_sales.values, marker="o")
plt.title("Monthly Sales Trend")
plt.xlabel("Month")
plt.ylabel("Weekly Sales")
plt.xticks(rotation=45)
plt.grid(True)
plt.show()

holiday_sales = df.groupby("IsHoliday")["Weekly_Sales"].sum()

plt.figure(figsize=(6, 5))
plt.bar(["Non-Holiday", "Holiday"], holiday_sales.values)
plt.title("Holiday vs Non-Holiday Sales")
plt.ylabel("Total Sales")
plt.show()

mean_sales = df["Weekly_Sales"].mean()
std_sales = df["Weekly_Sales"].std(ddof=1)
sample_size = len(df)

standard_error = std_sales / np.sqrt(sample_size)

confidence_interval = stats.t.interval(
    0.95,
    df=sample_size - 1,
    loc=mean_sales,
    scale=standard_error
)

print("Mean Sales:", mean_sales)
print("95% Confidence Interval:", confidence_interval)

t_stat, p_value = ttest_1samp(df["Weekly_Sales"], 16000)

print("T Statistic:", t_stat)
print("P Value:", p_value)

type_encoder = LabelEncoder()
month_encoder = LabelEncoder()

df["Type"] = type_encoder.fit_transform(df["Type"])
df["Month"] = month_encoder.fit_transform(df["Month"])

X = df.drop(["Weekly_Sales", "Date"], axis=1)
y = df["Weekly_Sales"]

X_train, X_test, y_train, y_test = train_test_split(
    X,
    y,
    test_size=0.20,
    random_state=42
)

linear_model = LinearRegression()
linear_model.fit(X_train, y_train)

linear_predictions = linear_model.predict(X_test)

print("\nLinear Regression Results")
print("MAE :", mean_absolute_error(y_test, linear_predictions))
print("MSE :", mean_squared_error(y_test, linear_predictions))
print("RMSE:", np.sqrt(mean_squared_error(y_test, linear_predictions)))
print("R2 Score:", r2_score(y_test, linear_predictions))

random_forest = RandomForestRegressor(
    n_estimators=100,
    random_state=42
)

random_forest.fit(X_train, y_train)

rf_predictions = random_forest.predict(X_test)

print("\nRandom Forest Results")
print("MAE :", mean_absolute_error(y_test, rf_predictions))
print("MSE :", mean_squared_error(y_test, rf_predictions))
print("RMSE:", np.sqrt(mean_squared_error(y_test, rf_predictions)))
print("R2 Score:", r2_score(y_test, rf_predictions))

feature_importance = pd.DataFrame({
    "Feature": X.columns,
    "Importance": random_forest.feature_importances_
}).sort_values(by="Importance", ascending=False)

print(feature_importance)

plt.figure(figsize=(10, 6))
plt.barh(
    feature_importance["Feature"],
    feature_importance["Importance"]
)
plt.gca().invert_yaxis()
plt.xlabel("Importance")
plt.ylabel("Feature")
plt.title("Feature Importance")
plt.show()

plt.figure(figsize=(8, 6))
plt.scatter(y_test, rf_predictions)
plt.xlabel("Actual Sales")
plt.ylabel("Predicted Sales")
plt.title("Actual vs Predicted Sales")
plt.show()

comparison = pd.DataFrame({
    "Actual Sales": y_test,
    "Predicted Sales": rf_predictions
})

print(comparison.head(10))

df["Predicted_Sales"] = random_forest.predict(X)

df["Month"] = month_encoder.inverse_transform(df["Month"])
df["Type"] = type_encoder.inverse_transform(df["Type"])

df.to_csv("Walmart_Final_RF.csv", index=False)

print("Final dataset saved successfully")