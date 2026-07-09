
import streamlit as st
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

from scipy import stats
from scipy.stats import ttest_1samp

from sklearn.preprocessing import LabelEncoder
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LinearRegression
from sklearn.ensemble import RandomForestRegressor
from sklearn.metrics import mean_absolute_error, mean_squared_error, r2_score

st.title("Walmart Sales Analysis & ML Prediction")

# Load Dataset

features = pd.read_csv("Dataset/Raw/features.csv")
stores = pd.read_csv("Dataset/Raw/stores.csv")
train = pd.read_csv("Dataset/Raw/train.csv")

df = train.merge(features, on=["Store", "Date", "IsHoliday"], how="left")
df = df.merge(stores, on="Store", how="left")

# Data Cleaning

df.drop_duplicates(inplace=True)

for col in ["MarkDown1", "MarkDown2", "MarkDown3", "MarkDown4", "MarkDown5"]:
    df[col] = df[col].fillna(0)

# Feature Engineering

df["Date"] = pd.to_datetime(df["Date"])
df["Year"] = df["Date"].dt.year
df["Month"] = df["Date"].dt.month_name()

# Exploratory Data Analysis (EDA)

st.header("Exploratory Data Analysis")

# Distribution of Weekly Sales

fig, ax = plt.subplots(figsize=(10, 6))
sns.histplot(df["Weekly_Sales"], bins=50, kde=True, ax=ax)
ax.set_title("Distribution of Weekly Sales")
st.pyplot(fig)

# Correlation Heatmap

fig, ax = plt.subplots(figsize=(12, 8))
sns.heatmap(df.corr(numeric_only=True), annot=True, ax=ax)
ax.set_title("Correlation Heatmap")
st.pyplot(fig)

# Top 10 Stores by Sales

top_sales = (
    df.groupby("Store")["Weekly_Sales"]
    .sum()
    .sort_values(ascending=False)
    .head(10)
)

fig, ax = plt.subplots(figsize=(10, 6))
sns.barplot(x=top_sales.index.astype(str), y=top_sales.values, ax=ax)
ax.set_title("Top 10 Stores by Sales")
ax.set_xlabel("Store")
ax.set_ylabel("Total Sales")
st.pyplot(fig)

# Monthly Sales Trend

month_order = [
    "January", "February", "March", "April",
    "May", "June", "July", "August",
    "September", "October", "November", "December"
]

df["Month"] = pd.Categorical(df["Month"], categories=month_order, ordered=True)

monthly_sales = df.groupby("Month", observed=False)["Weekly_Sales"].sum()

fig, ax = plt.subplots(figsize=(10, 6))
ax.plot(monthly_sales.index, monthly_sales.values, marker="o")
ax.set_title("Monthly Sales Trend")
ax.set_xlabel("Month")
ax.set_ylabel("Sales")
plt.xticks(rotation=45)
plt.grid(True)
st.pyplot(fig)

# Holiday vs Non-Holiday Sales

holiday_sales = df.groupby("IsHoliday")["Weekly_Sales"].sum()

fig, ax = plt.subplots(figsize=(6, 5))
ax.bar(["Non-Holiday", "Holiday"], holiday_sales.values)
ax.set_title("Holiday vs Non-Holiday Sales")
ax.set_ylabel("Total Sales")
st.pyplot(fig)

# Statistical Analysis

# Statistical Analysis

st.header("Statistical Analysis")

mean_sales = df["Weekly_Sales"].mean()

ci = stats.t.interval(
    0.95,
    len(df)-1,
    loc=mean_sales,
    scale=df["Weekly_Sales"].std()/np.sqrt(len(df))
)
t_stat, p_value = ttest_1samp(
    df["Weekly_Sales"],
    16000
)
col1, col2 = st.columns(2)

with col1:
    st.metric(
        "Average Weekly Sales",
        f"${mean_sales:,.2f}"
    )
with col2:
    st.metric(
        "P Value",
        round(p_value,4)
    )
st.write(
    "95% Confidence Interval:",
    f"({ci[0]:,.2f}, {ci[1]:,.2f})"
)
st.write(
    "T Statistic:",
    round(t_stat,4)
)
if p_value > 0.05:
    st.info(
        "No significant difference found from the target sales value of 16000."
    )
else:
    st.success(
        "Significant difference found."
    )
# Machine Learning

st.header("Machine Learning Models")

# Label Encoding

df["Type"] = LabelEncoder().fit_transform(df["Type"])
df["Month"] = LabelEncoder().fit_transform(df["Month"])

X = df.drop(columns=["Weekly_Sales", "Date"])
y = df["Weekly_Sales"]

# Train Test Split

X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42
)

# Linear Regression

lr = LinearRegression()
lr.fit(X_train, y_train)

lr_pred = lr.predict(X_test)

st.subheader("Linear Regression")

st.write("MAE:", mean_absolute_error(y_test, lr_pred))
st.write("RMSE:", np.sqrt(mean_squared_error(y_test, lr_pred)))
st.write("R2 Score:", r2_score(y_test, lr_pred))

# Random Forest
st.write("Starting Random Forest Training...")

rf = RandomForestRegressor(n_estimators=100, random_state=42)
rf.fit(X_train, y_train)

rf_pred = rf.predict(X_test)

st.subheader("Random Forest")

st.write("MAE:", mean_absolute_error(y_test, rf_pred))
st.write("RMSE:", np.sqrt(mean_squared_error(y_test, rf_pred)))
st.write("R2 Score:", r2_score(y_test, rf_pred))

# Feature Importance

importance = pd.DataFrame({
    "Feature": X.columns,
    "Importance": rf.feature_importances_
}).sort_values("Importance", ascending=False)

fig, ax = plt.subplots(figsize=(10, 6))
ax.barh(importance["Feature"], importance["Importance"])
ax.invert_yaxis()
ax.set_title("Feature Importance")
st.pyplot(fig)

# Actual vs Predicted Sales

st.subheader("Actual vs Predicted Sales")

fig, ax = plt.subplots(figsize=(8, 6))
ax.scatter(y_test, rf_pred)
ax.set_xlabel("Actual Sales")
ax.set_ylabel("Predicted Sales")
ax.set_title("Actual vs Predicted")
st.pyplot(fig)

# Save Final Dataset

df["Predicted_Sales"] = rf.predict(X)
df.to_csv("Walmart_Final_RF.csv", index=False)

st.success("Final Dataset Saved Successfully!")