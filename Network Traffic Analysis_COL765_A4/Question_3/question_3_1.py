import pandas as pd
import numpy as np
import glob
import matplotlib.pyplot as plt
import os
from sklearn.ensemble import IsolationForest
from sklearn.decomposition import PCA
import random

# Get all CSV files that match the pattern
csv_files = glob.glob("../network_analysis_data*.csv")
output_lines = []

# Process each CSV file individually
for file in sorted(csv_files):
    output_lines.append("=== Summary for file: {} ===".format(file))
    try:
        df = pd.read_csv(file)
    except Exception as e:
        output_lines.append("Error reading file: {}".format(e))
        continue

    # Basic Cleaning:
    # Drop rows with missing key values in startDateTime, source, destination, and totalSourceBytes
    key_columns = ['startDateTime', 'source', 'destination', 'totalSourceBytes']
    df_clean = df.dropna(subset=key_columns).copy()
    
    # Convert startDateTime to datetime format
    try:
        df_clean['startDateTime'] = pd.to_datetime(df_clean['startDateTime'])
    except Exception as e:
        output_lines.append("Error converting startDateTime: {}".format(e))
    
    # ---------------------------
    # 1. Descriptive Statistics for Numeric Columns
    # ---------------------------
    numeric_cols = ['totalSourceBytes', 'totalDestinationBytes', 'totalSourcePackets', 'totalDestinationPackets']
    summary_stats = df_clean[numeric_cols].describe()
    output_lines.append("\n--- Descriptive Statistics for Numeric Columns ---")
    output_lines.append(summary_stats.to_string())
    
    # ---------------------------
    # Protocol Distribution Analysis
    # ---------------------------
    protocol_counts = df_clean['protocolName'].value_counts()
    protocol_percentage = protocol_counts / protocol_counts.sum() * 100
    output_lines.append("\n--- Protocol Distribution Analysis ---")
    output_lines.append("Protocol Counts:")
    output_lines.append(protocol_counts.to_string())
    output_lines.append("\nProtocol Distribution (%):")
    output_lines.append(protocol_percentage.to_string())
    
    # ---------------------------
    # Packet Size Analysis (using totalSourceBytes)
    # ---------------------------
    packet_sizes = df_clean['totalSourceBytes']
    mean_packet = packet_sizes.mean()
    median_packet = packet_sizes.median()
    std_packet = packet_sizes.std()
    
    # Mean ± 3σ thresholds
    upper_threshold = mean_packet + 3 * std_packet
    lower_threshold = mean_packet - 3 * std_packet
    
    # IQR based thresholds
    Q1 = packet_sizes.quantile(0.25)
    Q3 = packet_sizes.quantile(0.75)
    IQR = Q3 - Q1
    iqr_lower = Q1 - 1.5 * IQR
    iqr_upper = Q3 + 1.5 * IQR
    
    output_lines.append("\n--- Packet Size (totalSourceBytes) Analysis ---")
    output_lines.append(f"Mean: {mean_packet:.2f}, Median: {median_packet:.2f}, Std Dev: {std_packet:.2f}")
    output_lines.append(f"Threshold (Mean ± 3σ): [{lower_threshold:.2f}, {upper_threshold:.2f}]")
    output_lines.append(f"IQR: {IQR:.2f}, IQR Threshold: [{iqr_lower:.2f}, {iqr_upper:.2f}]")
    
    anomalous_packets_std = df_clean[(packet_sizes > upper_threshold) | (packet_sizes < lower_threshold)]
    anomalous_packets_iqr = df_clean[(packet_sizes > iqr_upper) | (packet_sizes < iqr_lower)]
    output_lines.append(f"Anomalous packets (Mean ± 3σ): {len(anomalous_packets_std)}")
    output_lines.append(f"Anomalous packets (IQR method): {len(anomalous_packets_iqr)}")
    
    # ---------------------------
    # 2. Flow Counts and Thresholds Over Time
    # ---------------------------
    df_clean.set_index('startDateTime', inplace=True)
    hourly_flows = df_clean.resample('h').size()
    daily_flows = df_clean.resample('D').size()
    
    mean_hourly = hourly_flows.mean()
    std_hourly = hourly_flows.std()
    hourly_threshold = mean_hourly + 3 * std_hourly
    
    mean_daily = daily_flows.mean()
    std_daily = daily_flows.std()
    daily_threshold = mean_daily + 3 * std_daily
    
    output_lines.append("\n--- Flow Count Analysis ---")
    output_lines.append(f"Hourly Flows: Mean: {mean_hourly:.2f}, Std Dev: {std_hourly:.2f}, Threshold: {hourly_threshold:.2f}")
    output_lines.append(f"Daily Flows: Mean: {mean_daily:.2f}, Std Dev: {std_daily:.2f}, Threshold: {daily_threshold:.2f}")
    anomalous_hours = hourly_flows[hourly_flows > hourly_threshold]
    anomalous_days = daily_flows[daily_flows > daily_threshold]
    output_lines.append("Anomalous Hourly Flow Counts: " + str(anomalous_hours.to_dict()))
    output_lines.append("Anomalous Daily Flow Counts: " + str(anomalous_days.to_dict()))
    
    # ---------------------------
    # 3. Time Series Analysis
    # ---------------------------
    output_lines.append("\n--- Time Series Analysis ---")
    window_size = 3  # Adjust as needed
    moving_avg = hourly_flows.rolling(window=window_size).mean()
    moving_std = hourly_flows.rolling(window=window_size).std()
    spikes = hourly_flows[hourly_flows > (moving_avg + 3 * moving_std)]
    
    output_lines.append(f"Moving Average (window={window_size}) for Hourly Flows (first 5 values):")
    output_lines.append(moving_avg.head().to_string())
    output_lines.append(f"Moving Std Dev (window={window_size}) for Hourly Flows (first 5 values):")
    output_lines.append(moving_std.head().to_string())
    output_lines.append(f"Detected sudden spikes in Hourly Flows: {spikes.to_dict()}")
    
    # ---------------------------
    # 4. Outlier Detection by Traffic Volume per IP
    # ---------------------------
    df_clean.reset_index(inplace=True)
    ip_flow_counts = df_clean['source'].value_counts()
    mean_ip_flow = ip_flow_counts.mean()
    std_ip_flow = ip_flow_counts.std()
    ip_threshold = mean_ip_flow + 3 * std_ip_flow
    outlier_ips = ip_flow_counts[ip_flow_counts > ip_threshold]
    
    output_lines.append("\n--- Outlier IP Analysis ---")
    output_lines.append("Top 10 IPs by Flow Count:")
    output_lines.append(ip_flow_counts.head(10).to_string())
    output_lines.append(f"Outlier Threshold (Mean + 3σ): {ip_threshold:.2f}")
    output_lines.append("Outlier IPs (above threshold):")
    output_lines.append(outlier_ips.to_string())
    
    # ---------------------------
    # 5. Machine Learning-Based Anomaly Detection (Optional/Advanced)
    # ---------------------------
    output_lines.append("\n--- Machine Learning-Based Anomaly Detection ---")
    ml_key_cols = ['totalSourceBytes', 'totalSourcePackets']
    if all(col in df.columns for col in ml_key_cols):
        df_ml = df.dropna(subset=ml_key_cols)[ml_key_cols].copy()
        from sklearn.ensemble import IsolationForest
        iso_forest = IsolationForest(contamination=0.01, random_state=42)
        preds = iso_forest.fit_predict(df_ml)
        
        # Apply PCA to reduce dimensions
        from sklearn.decomposition import PCA
        pca = PCA(n_components=2)
        pca_results = pca.fit_transform(df_ml)
        df_ml['PCA1'] = pca_results[:, 0]
        df_ml['PCA2'] = pca_results[:, 1]
        
        anomalies_ml = df_ml[preds == -1].copy()
        output_lines.append(f"Isolation Forest detected {len(anomalies_ml)} anomalies based on ML features.")
        
        base_name = os.path.basename(file)
        file_index = sorted(csv_files).index(file) + 1
        short_name = f"file{file_index}.csv"
        plt.figure(figsize=(8,6))
        plt.scatter(df_ml['PCA1'], df_ml['PCA2'], c='blue', label='Normal', alpha=0.6)
        if not anomalies_ml.empty:
            plt.scatter(anomalies_ml['PCA1'], anomalies_ml['PCA2'], c='red', label='Anomaly', alpha=0.8)
        plt.xlabel("PCA Component 1")
        plt.ylabel("PCA Component 2")
        plt.title(f"PCA of {short_name} (Isolation Forest Anomalies)")
        plt.legend()
        ml_plot_file = f"ml_pca_{short_name.replace('.csv','')}.png"
        plt.savefig(ml_plot_file, dpi=300)
        plt.close()
        output_lines.append(f"PCA scatter plot saved as {ml_plot_file}")
    else:
        output_lines.append("Required ML columns not found for advanced anomaly detection.")
    
    output_lines.append("\n" + "="*60 + "\n")

# ---------------------------
# Combined Data Analysis
# ---------------------------
output_lines.append("=== Combined Data Analysis for All CSV Files ===")
try:
    combined_df = pd.concat([pd.read_csv(f) for f in sorted(csv_files)], ignore_index=True)
except Exception as e:
    output_lines.append("Error combining CSV files: {}".format(e))
else:
    # Basic Cleaning:
    key_columns = ['startDateTime', 'source', 'destination', 'totalSourceBytes']
    combined_clean = combined_df.dropna(subset=key_columns).copy()
    try:
        combined_clean['startDateTime'] = pd.to_datetime(combined_clean['startDateTime'])
    except Exception as e:
        output_lines.append("Error converting startDateTime in combined data: {}".format(e))
    
    # Descriptive Statistics for Numeric Columns
    numeric_cols = ['totalSourceBytes', 'totalDestinationBytes', 'totalSourcePackets', 'totalDestinationPackets']
    combined_summary = combined_clean[numeric_cols].describe()
    output_lines.append("\n--- Descriptive Statistics for Numeric Columns (Combined Data) ---")
    output_lines.append(combined_summary.to_string())
    
    # Protocol Distribution for Combined Data
    protocol_counts_c = combined_clean['protocolName'].value_counts()
    protocol_percentage_c = protocol_counts_c / protocol_counts_c.sum() * 100
    output_lines.append("\n--- Protocol Distribution Analysis (Combined Data) ---")
    output_lines.append("Protocol Counts:")
    output_lines.append(protocol_counts_c.to_string())
    output_lines.append("\nProtocol Distribution (%):")
    output_lines.append(protocol_percentage_c.to_string())
    
    # Packet Size Analysis (Combined Data) using totalSourceBytes
    packet_sizes_combined = combined_clean['totalSourceBytes']
    mean_packet_c = packet_sizes_combined.mean()
    median_packet_c = packet_sizes_combined.median()
    std_packet_c = packet_sizes_combined.std()
    upper_threshold_c = mean_packet_c + 3 * std_packet_c
    lower_threshold_c = mean_packet_c - 3 * std_packet_c
    Q1_c = packet_sizes_combined.quantile(0.25)
    Q3_c = packet_sizes_combined.quantile(0.75)
    IQR_c = Q3_c - Q1_c
    iqr_lower_c = Q1_c - 1.5 * IQR_c
    iqr_upper_c = Q3_c + 1.5 * IQR_c
    
    output_lines.append("\n--- Packet Size (totalSourceBytes) Analysis (Combined Data) ---")
    output_lines.append(f"Mean: {mean_packet_c:.2f}, Median: {median_packet_c:.2f}, Std Dev: {std_packet_c:.2f}")
    output_lines.append(f"Threshold (Mean ± 3σ): [{lower_threshold_c:.2f}, {upper_threshold_c:.2f}]")
    output_lines.append(f"IQR: {IQR_c:.2f}, IQR Threshold: [{iqr_lower_c:.2f}, {iqr_upper_c:.2f}]")
    
    anomalous_packets_std_c = combined_clean[(packet_sizes_combined > upper_threshold_c) | (packet_sizes_combined < lower_threshold_c)]
    anomalous_packets_iqr_c = combined_clean[(packet_sizes_combined > iqr_upper_c) | (packet_sizes_combined < iqr_lower_c)]
    output_lines.append(f"Anomalous packets (Mean ± 3σ) in Combined Data: {len(anomalous_packets_std_c)}")
    output_lines.append(f"Anomalous packets (IQR method) in Combined Data: {len(anomalous_packets_iqr_c)}")
    
    # Flow Counts and Thresholds Over Time (Combined Data)
    combined_clean.set_index('startDateTime', inplace=True)
    hourly_flows_c = combined_clean.resample('h').size()
    daily_flows_c = combined_clean.resample('D').size()
    mean_hourly_c = hourly_flows_c.mean()
    std_hourly_c = hourly_flows_c.std()
    hourly_threshold_c = mean_hourly_c + 3 * std_hourly_c
    mean_daily_c = daily_flows_c.mean()
    std_daily_c = daily_flows_c.std()
    daily_threshold_c = mean_daily_c + 3 * std_daily_c
    
    output_lines.append("\n--- Flow Count Analysis (Combined Data) ---")
    output_lines.append(f"Hourly Flows: Mean: {mean_hourly_c:.2f}, Std Dev: {std_hourly_c:.2f}, Threshold: {hourly_threshold_c:.2f}")
    output_lines.append(f"Daily Flows: Mean: {mean_daily_c:.2f}, Std Dev: {std_daily_c:.2f}, Threshold: {daily_threshold_c:.2f}")
    anomalous_hours_c = hourly_flows_c[hourly_flows_c > hourly_threshold_c]
    anomalous_days_c = daily_flows_c[daily_flows_c > daily_threshold_c]
    output_lines.append("Anomalous Hourly Flow Counts (Combined): " + str(anomalous_hours_c.to_dict()))
    output_lines.append("Anomalous Daily Flow Counts (Combined): " + str(anomalous_days_c.to_dict()))
    
    # Time Series Analysis (Combined Data)
    output_lines.append("\n--- Time Series Analysis (Combined Data) ---")
    window_size_c = 3  # Adjust as needed
    moving_avg_c = hourly_flows_c.rolling(window=window_size_c).mean()
    moving_std_c = hourly_flows_c.rolling(window=window_size_c).std()
    spikes_c = hourly_flows_c[hourly_flows_c > (moving_avg_c + 3 * moving_std_c)]
    
    output_lines.append(f"Moving Average (window={window_size_c}) for Hourly Flows (first 5 values, Combined):")
    output_lines.append(moving_avg_c.head().to_string())
    output_lines.append(f"Moving Std Dev (window={window_size_c}) for Hourly Flows (first 5 values, Combined):")
    output_lines.append(moving_std_c.head().to_string())
    output_lines.append(f"Detected sudden spikes in Hourly Flows (Combined): {spikes_c.to_dict()}")
    
    # Outlier Detection by Traffic Volume per IP (Combined Data)
    combined_clean.reset_index(inplace=True)
    ip_flow_counts_c = combined_clean['source'].value_counts()
    mean_ip_flow_c = ip_flow_counts_c.mean()
    std_ip_flow_c = ip_flow_counts_c.std()
    ip_threshold_c = mean_ip_flow_c + 3 * std_ip_flow_c
    outlier_ips_c = ip_flow_counts_c[ip_flow_counts_c > ip_threshold_c]
    
    output_lines.append("\n--- Outlier IP Analysis (Combined Data) ---")
    output_lines.append("Top 10 IPs by Flow Count (Combined):")
    output_lines.append(ip_flow_counts_c.head(10).to_string())
    output_lines.append(f"Outlier Threshold (Mean + 3σ) (Combined): {ip_threshold_c:.2f}")
    output_lines.append("Outlier IPs (above threshold, Combined):")
    output_lines.append(outlier_ips_c.to_string())
    
    # (Optional) ML-Based Anomaly Detection for Combined Data
    output_lines.append("\n--- Machine Learning-Based Anomaly Detection (Combined Data) ---")
    ml_key_cols = ['totalSourceBytes', 'totalSourcePackets']
    if all(col in combined_df.columns for col in ml_key_cols):
        df_ml_c = combined_df.dropna(subset=ml_key_cols)[ml_key_cols].copy()
        iso_forest_c = IsolationForest(contamination=0.01, random_state=42)
        preds_c = iso_forest_c.fit_predict(df_ml_c)
        pca_c = PCA(n_components=2)
        pca_results_c = pca_c.fit_transform(df_ml_c)
        df_ml_c['PCA1'] = pca_results_c[:, 0]
        df_ml_c['PCA2'] = pca_results_c[:, 1]
        anomalies_ml_c = df_ml_c[preds_c == -1].copy()
        output_lines.append(f"Isolation Forest detected {len(anomalies_ml_c)} anomalies in Combined Data.")
        
        plt.figure(figsize=(8,6))
        plt.scatter(df_ml_c['PCA1'], df_ml_c['PCA2'], c='blue', label='Normal', alpha=0.6)
        if not anomalies_ml_c.empty:
            plt.scatter(anomalies_ml_c['PCA1'], anomalies_ml_c['PCA2'], c='red', label='Anomaly', alpha=0.8)
        plt.xlabel("PCA Component 1")
        plt.ylabel("PCA Component 2")
        plt.title("PCA of Combined Data (Isolation Forest Anomalies)")
        plt.legend()
        combined_ml_plot = "ml_pca_combined.png"
        plt.savefig(combined_ml_plot, dpi=300)
        plt.close()
        output_lines.append(f"PCA scatter plot for Combined Data saved as {combined_ml_plot}")
    else:
        output_lines.append("Required ML columns not found for advanced anomaly detection in Combined Data.")
    
    output_lines.append("\n" + "="*60 + "\n")

# Write the accumulated EDA output to a text file
with open("eda_report.txt", "w") as f:
    f.write("\n".join(output_lines))

print("EDA report generated in eda_report.txt")
