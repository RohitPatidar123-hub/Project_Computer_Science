import pandas as pd
import numpy as np
import glob

# -------------------------------
# Helper Functions
# -------------------------------

def flag_stealthy_port_scans(df):
    """
    Detects stealthy port scans by monitoring the number of distinct destination ports
    contacted by each source IP over the entire period and over 24-hour windows.
    """
    results = {}
    # Overall distinct destination ports per source IP
    port_counts = df.groupby('source')['destination'].nunique()
    mean_ports = port_counts.mean()
    std_ports = port_counts.std()
    threshold_ports = mean_ports + 2 * std_ports  # threshold: mean + 2σ

    flagged_overall = port_counts[port_counts > threshold_ports]
    results['overall_flagged'] = flagged_overall
    results['overall_threshold'] = threshold_ports

    # 24-Hour window analysis (resample into 24h intervals)
    df_temp = df.copy()
    df_temp['startDateTime'] = pd.to_datetime(df_temp['startDateTime'])
    df_temp.set_index('startDateTime', inplace=True)
    
    # For each source, count unique destination ports in each 24h window
    def unique_ports(series):
        return series.nunique()
    ports_24h = df_temp.groupby('source').resample('24h')['destination'].apply(unique_ports)
    
    # For each source, compute moving average and std over time (using a window of 3 days)
    moving_stats = ports_24h.groupby(level=0).rolling(window=3, min_periods=1).agg(['mean', 'std'])
    moving_stats['threshold'] = moving_stats['mean'] + 3 * moving_stats['std']
    
    # Flag windows where the unique port count exceeds the threshold
    flagged_windows = {}
    for source, group in ports_24h.groupby(level=0):
        stats = moving_stats.loc[source]
        flagged = group[group > stats['threshold']]
        if not flagged.empty:
            flagged_windows[source] = flagged.to_dict()
    
    results['24h_flagged'] = flagged_windows
    return results

def flag_slow_ddos(df):
    """
    Detects slow DDoS attacks by monitoring a steady increase in flow counts per destination IP.
    Uses resampling (by hour) and thresholding (mean + 2σ) to identify gradual anomalies.
    """
    results = {}
    df_temp = df.copy()
    df_temp['startDateTime'] = pd.to_datetime(df_temp['startDateTime'])
    df_temp.set_index('startDateTime', inplace=True)
    
    # Aggregate flow counts per destination IP by hour
    flows_by_dest = df_temp.groupby('destination').resample('h').size()
    
    flagged_dest = {}
    for dest, series in flows_by_dest.groupby(level=0):
        mean_flow = series.mean()
        std_flow = series.std()
        threshold_flow = mean_flow + 2 * std_flow
        # Flag hours where flow count exceeds the threshold
        anomalies = series[series > threshold_flow]
        if not anomalies.empty:
            flagged_dest[dest] = anomalies.to_dict()
    results['flagged_dest'] = flagged_dest
    return results

def flag_ip_hopping(df, time_window='10min', min_ips=5):
    """
    Detects IP hopping behavior by tracking the number of distinct source IPs contacting each destination
    within a short time window. If the count exceeds min_ips, flag that destination.
    """
    results = {}
    df_temp = df.copy()
    df_temp['startDateTime'] = pd.to_datetime(df_temp['startDateTime'])
    df_temp.set_index('startDateTime', inplace=True)
    
    # Count distinct source IPs for each destination in each time window
    src_counts = df_temp.groupby('destination').resample(time_window)['source'].nunique()
    flagged = src_counts[src_counts > min_ips]
    results['flagged_ip_hopping'] = flagged.to_dict()
    results['ip_hopping_rule'] = f"More than {min_ips} distinct source IPs within {time_window}"
    return results

# -------------------------------
# Main Processing
# -------------------------------

csv_files = glob.glob("../network_analysis_data*.csv")
advanced_report_lines = []

for file in sorted(csv_files):
    advanced_report_lines.append(f"=== Advanced Threat Detection for file: {file} ===")
    try:
        df = pd.read_csv(file)
    except Exception as e:
        advanced_report_lines.append(f"Error reading file: {e}")
        continue

    # Ensure key columns exist
    key_cols = ['startDateTime', 'source', 'destination']
    df = df.dropna(subset=key_cols)
    df['startDateTime'] = pd.to_datetime(df['startDateTime'])
    
    # 1. Stealthy Port Scans Detection
    port_scan_results = flag_stealthy_port_scans(df)
    advanced_report_lines.append("\n--- Stealthy Port Scans Detection ---")
    advanced_report_lines.append(f"Overall threshold for distinct destination ports: {port_scan_results['overall_threshold']:.2f}")
    advanced_report_lines.append("Source IPs exceeding threshold (Overall):")
    advanced_report_lines.append(port_scan_results['overall_flagged'].to_string())
    advanced_report_lines.append("\n24-Hour Window Analysis (Flagged Windows):")
    advanced_report_lines.append(str(port_scan_results['24h_flagged']))
    
    # 2. Slow DDoS Attack Detection
    ddos_results = flag_slow_ddos(df)
    advanced_report_lines.append("\n--- Slow DDoS Attack Detection ---")
    if ddos_results['flagged_dest']:
        advanced_report_lines.append("Destinations with anomalous hourly flow counts:")
        for dest, anomalies in ddos_results['flagged_dest'].items():
            advanced_report_lines.append(f"Destination: {dest}, Anomalies: {anomalies}")
    else:
        advanced_report_lines.append("No significant slow DDoS patterns detected.")
    
    # 3. IP Hopping Behavior Detection
    ip_hopping_results = flag_ip_hopping(df, time_window='10min', min_ips=5)
    advanced_report_lines.append("\n--- IP Hopping Behavior Detection ---")
    advanced_report_lines.append(f"Rule: {ip_hopping_results['ip_hopping_rule']}")
    if ip_hopping_results['flagged_ip_hopping']:
        advanced_report_lines.append("Flagged instances:")
        advanced_report_lines.append(str(ip_hopping_results['flagged_ip_hopping']))
    else:
        advanced_report_lines.append("No IP hopping patterns detected.")
    
    advanced_report_lines.append("\n" + "="*60 + "\n")

# Write the advanced threat detection report to a text file
with open("output_4_1.txt", "w") as f:
    f.write("\n".join(advanced_report_lines))

print("Advanced threat detection report generated in output_4_1.txt")
