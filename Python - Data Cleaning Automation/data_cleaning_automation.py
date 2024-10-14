# Import necessary libraries
import pandas as pd
import numpy as np
from scipy import stats

# Function to load the dataset
def load_dataset(file_path):
    return pd.read_csv(file_path)

# Function to report and handle missing values
def report_missing_values(df):
    missing_values = df.isnull().sum()
    print("\nMissing values report:")
    for col, count in missing_values.items():
        if count > 0:
            print(f"Column '{col}' has {count} missing values.")
    return df

# Function to remove duplicates
def handle_duplicates(df):
    print(f"\nTotal duplicates found: {df.duplicated().sum()}")
    df.drop_duplicates(inplace=True)
    print(f"Duplicates removed. Dataset now has {df.shape[0]} rows.")
    return df

# Function to detect and report outliers using the IQR method
def report_outliers(df):
    numeric_cols = df.select_dtypes(include=np.number).columns
    print("\nOutliers report:")
    
    for col in numeric_cols:
        Q1 = df[col].quantile(0.25)
        Q3 = df[col].quantile(0.75)
        IQR = Q3 - Q1
        outliers = df[((df[col] < (Q1 - 1.5 * IQR)) | (df[col] > (Q3 + 1.5 * IQR)))]
        
        if len(outliers) > 0:
            print(f"Column '{col}' has {len(outliers)} outliers.")
        else:
            print(f"Column '{col}' has no outliers.")

    return df

# Main function to execute the reporting and cleaning process
def main(file_path):
    df = load_dataset(file_path)
    
    print(f"Dataset Overview:\nTotal observations (rows): {df.shape[0]}\nTotal features (columns): {df.shape[1]}")
    print(f"\nFeature types:\n{df.dtypes}")

    # Report missing values, handle duplicates, and report outliers
    df = report_missing_values(df)
    df = handle_duplicates(df)
    df = report_outliers(df)
    
    # Save the cleaned dataset without duplicates
    df.to_csv('cleaned_dataset.csv', index=False)
    print("\nData cleaning and reporting completed. Cleaned dataset saved as 'cleaned_dataset.csv'.")

# Run the main function
if __name__ == '__main__':
    file_path = 'your_dataset.csv'  # Replace with your dataset file path
    main(file_path)
