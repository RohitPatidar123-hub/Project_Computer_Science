# helper.py

def flag_stealthy_port_scans(df):
    # Your implementation goes here
    results = {}
    port_counts = df.groupby('source')['destination'].nunique()
    mean_ports = port_counts.mean()
    std_ports = port_counts.std()
    threshold_ports = mean_ports + 2 * std_ports
    flagged_overall = port_counts[port_counts > threshold_ports]
    results['overall_flagged'] = flagged_overall
    results['overall_threshold'] = threshold_ports
    # 24-hour window analysis can be added here
    results['24h_flagged'] = {}
    return results

def flag_slow_ddos(df):
    results = {}
    df_temp = df.copy()
    df_temp['startDateTime'] = pd.to_datetime(df_temp['startDateTime'])
    df_temp.set_index('startDateTime', inplace=True)
    flows_by_dest = df_temp.groupby('destination').resample('h').size()
    flagged_dest = {}
    for dest, series in flows_by_dest.groupby(level=0):
        mean_flow = series.mean()
        std_flow = series.std()
        threshold_flow = mean_flow + 3 * std_flow
        anomalies = series[series > threshold_flow]
        if not anomalies.empty:
            flagged_dest[dest] = anomalies.to_dict()
    results['flagged_dest'] = flagged_dest
    return results

def flag_ip_hopping(df, time_window='10min', min_ips=5):
    results = {}
    df_temp = df.copy()
    df_temp['startDateTime'] = pd.to_datetime(df_temp['startDateTime'])
    df_temp.set_index('startDateTime', inplace=True)
    src_counts = df_temp.groupby('destination').resample(time_window)['source'].nunique()
    flagged = src_counts[src_counts > min_ips]
    results['flagged_ip_hopping'] = flagged.to_dict()
    results['ip_hopping_rule'] = f"More than {min_ips} distinct source IPs within {time_window}"
    return results
