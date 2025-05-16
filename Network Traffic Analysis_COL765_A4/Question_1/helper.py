import os
import pandas as pd
import matplotlib.pyplot as plt

def compute_stats(df, file_name):
    output = []
    
    output.append(f"Statistics for file: {file_name}\n")
    
    total_flows = len(df)
    output.append(f"Total number of flows: {total_flows}\n")
    
    protocols = df['protocolName'].value_counts().head(5)
    output.append(f"Top 5 protocols:\n{protocols}\n")
    
    top_src = df['source'].value_counts().head(10)
    output.append(f"Top 10 active source IPs:\n{top_src}\n")
    
    top_dst = df['destination'].value_counts().head(10)
    output.append(f"Top 10 active destination IPs:\n{top_dst}\n")
    
    # Compute correct average packet size
    df['total_bytes'] = df['totalSourceBytes'] + df['totalDestinationBytes']
    df['total_packets'] = df['totalSourcePackets'] + df['totalDestinationPackets']
    total_bytes = df['total_bytes'].sum()
    total_packets = df['total_packets'].sum()
    
    avg_packet_size = total_bytes / total_packets if total_packets > 0 else 0
    output.append(f"Accurate average packet size (bytes/packet): {avg_packet_size}\n")
    
    pair_counts = df.groupby(['source', 'destination']).size().sort_values(ascending=False)
    most_common_pair = pair_counts.index[0]
    most_common_pair_count = pair_counts.iloc[0]
    output.append(f"Most common source-destination pair: {most_common_pair} with count: {most_common_pair_count}\n")

    # Convert startDateTime to datetime and sort the data for time series analysis
    df["startDateTime"] = pd.to_datetime(df["startDateTime"])
    df = df.sort_values(by="startDateTime").set_index("startDateTime")
    
    hourly_ips = [set(group["source"]).union(group["destination"]) for _, group in df.groupby(pd.Grouper(freq='h'))]
    consistent_ips = set.intersection(*hourly_ips) if hourly_ips else set()
    output.append(f"IPs communicating every hour: {', '.join(consistent_ips) if consistent_ips else 'None'}\n")
    
    # Define the time windows to analyze and their corresponding pandas offset aliases
    time_windows = {
        "1 hour": "1h",
        # "30 minutes": "30min",
        # "15 minutes": "15min",
        # "10 minutes": "10min",
        # "5 minutes": "5min"
        # "1 minutes": "1min"
    }
    
    base_name = os.path.basename(file_name).replace('.csv', '')
    
    for window_name, window_alias in time_windows.items():
        output.append(f"\n--- Spike Detection for Time Window: {window_name} ---\n")
        
        # Resample traffic counts according to the time window
        traffic_counts = df.resample(window_alias).size()
        
        # 1. Mean + 2 * Std Dev method
        mean_flow = traffic_counts.mean()
        std_flow = traffic_counts.std()
        threshold_std = mean_flow + 2 * std_flow
        spikes_std = traffic_counts[traffic_counts > threshold_std]
        
        # 2. Z-score method (values with z-score > 2)
        z_scores = (traffic_counts - mean_flow) / std_flow
        spikes_z = traffic_counts[z_scores > 2]
        
        # 3. Rolling mean + 2 * rolling std method (using a window of 3 intervals)
        rolling_mean = traffic_counts.rolling(window=3, center=True).mean()
        rolling_std = traffic_counts.rolling(window=3, center=True).std()
        threshold_rolling = rolling_mean + 2 * rolling_std
        spikes_rolling = traffic_counts[traffic_counts > threshold_rolling]
        
        # 4. 95th Percentile method
        threshold_percentile = traffic_counts.quantile(0.95)
        spikes_percentile = traffic_counts[traffic_counts > threshold_percentile]
        
        # Append textual results for this time window
        output.append("Traffic Spikes Detected (Mean + 2*Std):\n" + f"{spikes_std}\n")
        output.append("Traffic Spikes Detected (Z-Score > 2):\n" + f"{spikes_z}\n")
        output.append("Traffic Spikes Detected (Rolling Mean + 2*Std):\n" + f"{spikes_rolling}\n")
        output.append("Traffic Spikes Detected (95th Percentile):\n" + f"{spikes_percentile}\n")
        
        # --- Generate a graph for this time window ---
        plt.figure(figsize=(16, 12))
        plt.plot(traffic_counts.index, traffic_counts.values, label='Traffic Volume', color='gray')
        
        # Plot spikes detected by each method
        plt.scatter(spikes_std.index, spikes_std.values, label='Mean + 2*Std Spikes', color='red', marker='o')
        plt.scatter(spikes_z.index, spikes_z.values, label='Z-Score Spikes', color='blue', marker='x')
        plt.scatter(spikes_rolling.index, spikes_rolling.values, label='Rolling Mean Spikes', color='green', marker='^')
        plt.scatter(spikes_percentile.index, spikes_percentile.values, label='95th Percentile Spikes', color='purple', marker='s')
        
        # Draw threshold lines for Mean + 2*Std and 95th Percentile methods
        plt.axhline(y=threshold_std, color='red', linestyle='--', label='Mean + 2*Std Threshold')
        plt.axhline(y=threshold_percentile, color='purple', linestyle='--', label='95th Percentile Threshold')
        
        plt.title(f'Traffic Spike Detection for {base_name} ({window_name})')
        plt.xlabel('Time')
        plt.ylabel('Flow Count per ' + window_name)
        plt.legend()
        plt.grid(True)
        plt.tight_layout()
        
        # Save the graph with a unique filename including the time window descriptor
        graph_filename = f"spike_detection_{base_name}_{window_name.replace(' ', '_')}.png"
        plt.savefig(graph_filename)
        plt.close()
        
        output.append(f"Spike detection graph for {window_name} saved as {graph_filename}\n")
    
    # --- Compute variance of per-flow average packet size ---
    df['avg_packet_size'] = df.apply(
        lambda row: (row['total_bytes'] / row['total_packets']) if row['total_packets'] > 0 else None,
        axis=1
    )
    packet_size_variance = df['avg_packet_size'].var()
    output.append(f"Variance of per-flow average packet sizes: {packet_size_variance}\n")
    
    if packet_size_variance > 100000:
        output.append("Note: High variance may indicate mixed traffic types (e.g., DNS, streaming, file transfer).\n")
    else:
        output.append("Note: Low variance suggests consistent packet sizes across flows.\n")
    
    return "\n".join(output) + "\n" + ("-" * 50) + "\n\n"
