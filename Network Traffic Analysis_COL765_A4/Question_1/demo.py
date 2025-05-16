import pandas as pd
import numpy as np

# Load the CSV file normally (assuming it's in the same directory).
df = pd.read_csv('../network_analysis_data1.csv')

# Display the first few rows to inspect the data structure.
print(df.head())

# Assuming your CSV has columns 'timestamp' and 'traffic_volume'.
# If your columns have different names, adjust them accordingly.
df['timestamp'] = pd.to_datetime(df['timestamp'])
df.sort_values('timestamp', inplace=True)

# Set the rolling window size (this could be time-based or number of rows; here we use a window of 10 rows).
window_size = 10

# Calculate rolling mean and standard deviation for the traffic volume.
df['rolling_mean'] = df['traffic_volume'].rolling(window=window_size).mean()
df['rolling_std'] = df['traffic_volume'].rolling(window=window_size).std()

# Define a threshold for detecting spikes.
# For example, a spike is detected if the traffic volume exceeds the rolling mean by more than 3 standard deviations.
threshold = 3
df['is_spike'] = df['traffic_volume'] > (df['rolling_mean'] + threshold * df['rolling_std'])

# Filter the data to view only the irregular spikes.
spikes = df[df['is_spike']]
print("Detected spikes:")
print(spikes[['timestamp', 'traffic_volume']])
