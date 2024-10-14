# Bank Customer Analysis

## Overview
This project focuses on analyzing a bank customer dataset to understand customer behaviors, segment them into groups, and predict customer propensity for a financial product (e.g., a loan or a credit card). The analysis covers **Exploratory Data Analysis (EDA)**, customer **segmentation**, and building a **propensity model** to identify promising customers.

## Project Structure
- **Exploratory Data Analysis (EDA)**: Understanding the dataset and visualizing key insights.
- **Customer Segmentation**: Using RFM (Recency, Frequency, and Monetary) analysis to segment customers.
- **Propensity Model**: Building a predictive model to identify customers likely to accept a product offer.

## Steps Involved

### 1. Exploratory Data Analysis (EDA)
   - Examining dataset dimensions, data types, and checking for missing values.
   - Univariate and bivariate analysis to uncover trends and patterns.
   - Visualizing key metrics such as customer age distribution, account balance, and transaction history.

### 2. Customer Segmentation
   - **RFM Analysis**:
     - **Recency**: How recently the customer made a purchase.
     - **Frequency**: How often the customer makes a purchase.
     - **Monetary**: How much the customer spends.
   - Customers are grouped into segments based on these scores, allowing targeted marketing efforts.

### 3. Propensity Model
   - A **classification model** is used to predict whether a customer will accept a financial product.
   - The dataset is split into training and testing sets to evaluate model performance.
   - Metrics like accuracy, precision, recall, and F1-score are used to assess the model.

## How to Run the Project
1. **Dependencies**: Make sure you have all the necessary Python libraries installed.
    ```bash
    pip install pandas numpy matplotlib seaborn scikit-learn
2. **Run the Notebook**: Open the notebook and follow the code execution in the following sections:
    - **EDA**: For understanding customer behaviors.
    - **Customer Segmentation**: To segment customers using RFM analysis.
    - **Propensity Model**: To build and evaluate the predictive model.
3. **Tools & Technologies Used**
    - **Python**: Primary programming language used.
    - **Pandas, Numpy**: For data manipulation and analysis.
    - **Matplotlib, Seaborn**: For visualizing data trends and patterns.
    - **Scikit-learn**: For building the machine learning models.

## Key Findings
- Customers with higher frequency and monetary values are more likely to accept product offers.
- Older customers tend to have larger account balances but lower transaction frequencies.
- The propensity model has an accuracy of 85%, making it a useful tool for identifying potential customers for the bank's products.

## Future Work
- Improve the Propensity Model: Experiment with more advanced algorithms such as XGBoost or Random Forest to improve model performance.
- Additional Segmentation: Perform clustering analysis (e.g., K-means) to further refine customer segments.
- Data Enrichment: Include additional customer data such as credit score, income, and external factors to enhance the analysis.

## Contact
For any inquiries or collaborations, feel free to reach out:

- **Email**: bahariantore@gmail.com
- **LinkedIn**: [My LinkedIn Profile](https://www.linkedin.com/in/baharianto)