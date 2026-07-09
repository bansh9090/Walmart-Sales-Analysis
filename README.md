# Walmart Sales Analysis

## Overview

This project is an end-to-end analysis of Walmart sales data, where I explored sales trends, compared store performance, and identified the key factors that affect weekly sales. Along with data analysis, I built SQL reports, designed an interactive Power BI dashboard, and applied machine learning models to predict future sales. I also created a Streamlit web application so the project can be explored interactively.

**Live Streamlit App:**
https://walmart-sales-analysis-zmvxrgbbbweeizz3c2sfxv.streamlit.app/

## Objectives

The main goals of this project were to:

* Clean and prepare the raw Walmart sales data.
* Perform business analysis using SQL.
* Explore the data through visualizations.
* Build an interactive Power BI dashboard.
* Compare the performance of different stores and departments.
* Analyze monthly and yearly sales trends.
* Train machine learning models to predict weekly sales.
* Deploy the analysis using Streamlit.

## Dataset

The dataset contains historical Walmart sales information along with several economic and store-related features, including:

* Store
* Department
* Date
* Weekly Sales
* Holiday Flag
* Temperature
* Fuel Price
* CPI
* Unemployment
* Store Type
* Store Size
* MarkDown1 to MarkDown5

## Tools & Technologies

This project was completed using the following tools:

* Python
* Pandas
* NumPy
* Matplotlib
* Scikit-learn
* MySQL
* Power BI
* Streamlit
* Jupyter Notebook
* Visual Studio Code

## Project Workflow

The project was completed in several stages:

1. Loaded and explored the raw datasets.
2. Cleaned missing values and corrected data types.
3. Merged multiple datasets into a single dataset.
4. Performed Exploratory Data Analysis (EDA) to understand sales patterns.
5. Imported the cleaned dataset into MySQL.
6. Wrote SQL queries to answer business-related questions.
7. Built an interactive Power BI dashboard.
8. Trained and evaluated machine learning models for sales prediction.
9. Developed a Streamlit application to present the complete analysis.

## SQL Analysis

Using MySQL, I answered several business questions, including:

* Total and average sales
* Store-wise sales performance
* Department-wise analysis
* Monthly and yearly sales trends
* Holiday vs Non-Holiday sales comparison
* Top and bottom performing stores
* Store ranking using window functions
* Year-over-year sales growth
* Sales contribution of each store

## Power BI Dashboard

The dashboard provides an interactive view of the business using:

* Total Sales KPI
* Average Weekly Sales
* Sales by Store
* Sales by Department
* Monthly Sales Trend
* Holiday vs Non-Holiday Comparison
* Store Performance Overview
* Interactive filters for Year, Store, and Department

## Streamlit Application

To make the project more interactive, I developed a Streamlit web application where users can explore the analysis, visualizations, statistical results, and machine learning models in one place.

**Live Application:**
https://walmart-sales-analysis-zmvxrgbbbweeizz3c2sfxv.streamlit.app/

## Machine Learning

To understand how sales prediction works, I trained two regression models using the cleaned dataset.

### Linear Regression

* Built a baseline model to predict weekly sales.
* Used numerical features such as Temperature, Fuel Price, CPI, Unemployment, and Store Size.
* Evaluated the model using standard regression metrics.

### Random Forest Regressor

* Trained a Random Forest model to capture more complex relationships in the data.
* Compared its performance with the Linear Regression model.
* The Random Forest model achieved better prediction accuracy and overall performance.

## Skills Demonstrated

Through this project, I strengthened my skills in:

* Data Cleaning
* Exploratory Data Analysis (EDA)
* SQL
* Window Functions
* Business Analysis
* Data Visualization
* Power BI Dashboard Development
* Streamlit
* Linear Regression
* Random Forest Regression
* Machine Learning Fundamentals

## Future Improvements

In the future, I plan to:

* Experiment with additional regression models.
* Perform feature engineering to improve prediction accuracy.
* Connect the dashboard to a live database.
* Deploy a complete end-to-end sales prediction application.

## Author

**Bansh Sharma**

This project was created as a practical learning experience to improve my skills in Python, SQL, Power BI, Streamlit, and Machine Learning by working with a real-world retail sales dataset. It demonstrates the complete data analytics workflow, from data cleaning and business analysis to visualization, predictive modeling, and deployment.
