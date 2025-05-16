import pandas as pd
import base64
import re
import numpy as np
import math
from sklearn.ensemble import IsolationForest
from sklearn.cluster import KMeans
import glob

# ----------------------------
# Helper Functions
# ----------------------------
def decode_and_clean(payload):
    """
    Decodes a Base64-encoded payload to UTF-8 and cleans out non-printable characters.
    """
    try:
        decoded = base64.b64decode(payload).decode('utf-8', errors='ignore')
        cleaned = re.sub(r'[\x00-\x1F\x7F-\x9F]', '', decoded)
        return cleaned.strip()
    except Exception as e:
        return ""

def shannon_entropy(data):
    if not data:
        return 0
    data = list(data)
    freq = {char: data.count(char) for char in set(data)}
    data_len = len(data)
    entropy = -sum((count / data_len) * math.log2(count / data_len) for count in freq.values())
    return entropy

def search_keywords(payload):
    suspicious_keywords = ["cmd", "control", "update", "ping", "malware", "attack"]
    payload_lower = payload.lower()
    for keyword in suspicious_keywords:
        if keyword in payload_lower:
            return True
    return False

def match_signatures(payload):
    malicious_patterns = [
        r"cmd[\W_]*",    # Pattern for 'cmd' with optional non-word characters
        r"control[\W_]*",
        r"update[\W_]*",
        r"ping[\W_]*",
        r"malware[\W_]*",
        r"attack[\W_]*"
    ]
    for pattern in malicious_patterns:
        if re.search(pattern, payload, re.IGNORECASE):
            return True
    return False

def flag_encrypted_anomalies(df, high_entropy_threshold=7.5, contamination=0.01):
    """
    Further examines payloads with high entropy (likely encrypted) to flag those that 
    deviate from normal encrypted traffic behavior using an Isolation Forest.
    """
    results = {}
    # Consider payloads with entropy above a threshold as candidate encrypted traffic
    encrypted_df = df[df['entropy'] >= high_entropy_threshold].copy()
    
    if encrypted_df.empty:
        results['encrypted_anomalies'] = pd.DataFrame()
        return results

    # Use payload length and entropy as features
    features = encrypted_df[['payload_length', 'entropy']].values
    
    # Apply Isolation Forest to detect anomalous encrypted payloads
    iso_forest_enc = IsolationForest(contamination=contamination, random_state=42)
    encrypted_df['enc_anomaly'] = iso_forest_enc.fit_predict(features)
    
    # Flag payloads predicted as anomalies (i.e. -1)
    anomalies_enc = encrypted_df[encrypted_df['enc_anomaly'] == -1]
    results['encrypted_anomalies'] = anomalies_enc
    return results

def is_encrypted(row):
    """
    Determine if a flow is likely encrypted based on:
    - The protocolName field (e.g., HTTPS, SSL, TLS indicate encryption).
    - The absence of a UTF payload when a Base64 payload is present.
    - The use of common encrypted ports (e.g., 443).
    Returns True if the flow is considered encrypted, False otherwise.
    """
    encrypted_protocols = {"HTTPS", "SSL", "TLS"}
    # Check protocolName if available
    if 'protocolName' in row and pd.notnull(row['protocolName']):
        if row['protocolName'].strip().upper() in encrypted_protocols:
            return True
    # Check for missing UTF payload but existing Base64 payload (for source)
    if ((pd.isnull(row.get('sourcePayloadAsUTF')) or row.get('sourcePayloadAsUTF').strip() == "") and
        pd.notnull(row.get('sourcePayloadAsBase64')) and row.get('sourcePayloadAsBase64').strip() != ""):
        return True
    # Check for missing UTF payload but existing Base64 payload (for destination)
    if ((pd.isnull(row.get('destinationPayloadAsUTF')) or row.get('destinationPayloadAsUTF').strip() == "") and
        pd.notnull(row.get('destinationPayloadAsBase64')) and row.get('destinationPayloadAsBase64').strip() != ""):
        return True
    # Check common encrypted ports (e.g., 443)
    if row.get('destinationPort') == 443 or row.get('sourcePort') == 443:
        return True
    return False

# ----------------------------
# Process All CSV Files and Consolidate Results
# ----------------------------
csv_files = glob.glob("../network_analysis_data*.csv")

report_lines = []
report_lines.append("=== Combined Payload Feature Extraction Report ===\n")

for file in sorted(csv_files):
    report_lines.append(f"--- Processing file: {file} ---\n")
    
    try:
        df = pd.read_csv(file)
    except Exception as e:
        report_lines.append(f"Error reading {file}: {e}\n")
        continue

    # Determine which payload column to use
    if 'sourcePayloadAsBase64' in df.columns:
        payload_col = 'sourcePayloadAsBase64'
    elif 'destinationPayloadAsBase64' in df.columns:
        payload_col = 'destinationPayloadAsBase64'
    else:
        report_lines.append("No payload column found.\n")
        continue

    # Drop rows where payload is missing
    df = df.dropna(subset=[payload_col])
    
    # Decode and clean payloads
    df['decoded_payload'] = df[payload_col].apply(decode_and_clean)
    
    # If no 'encrypted' column exists, use our is_encrypted function to add one
    if 'encrypted' not in df.columns:
        df['encrypted'] = df.apply(is_encrypted, axis=1)
    
    # ----------------------------
    # 2. Statistical Analysis and Feature Extraction
    # ----------------------------
    # A. Payload Length
    df['payload_length'] = df['decoded_payload'].apply(len)
    
    # B. Shannon Entropy Calculation
    df['entropy'] = df['decoded_payload'].apply(shannon_entropy)
    
    # C. Descriptive Statistics for Payload Features
    length_mean = df['payload_length'].mean()
    length_median = df['payload_length'].median()
    length_std = df['payload_length'].std()
    
    entropy_mean = df['entropy'].mean()
    entropy_median = df['entropy'].median()
    entropy_std = df['entropy'].std()
    
    # D. Thresholding Example (for entropy)
    entropy_threshold = entropy_mean + 2 * entropy_std
    flagged_high_entropy = df[df['entropy'] > entropy_threshold]
    
    # E. Example Character Frequency Distribution (for first payload)
    if not df.empty:
        example_payload = df['decoded_payload'].iloc[0]
    else:
        example_payload = ""
    char_freq = {char: example_payload.count(char) for char in set(example_payload)}
    
    # F. Keyword or Pattern Search (simple rule-based)
    df['suspicious'] = df['decoded_payload'].apply(search_keywords)
    num_suspicious = df['suspicious'].sum()
    
    # ----------------------------
    # 3. Machine Learning / Clustering Approaches
    # ----------------------------
    # Construct feature vectors from payload_length and entropy.
    features = df[['payload_length', 'entropy']].values
    
    # A. Isolation Forest for anomaly detection on all payloads
    iso_forest = IsolationForest(contamination=0.01, random_state=42)
    df['iso_pred'] = iso_forest.fit_predict(features)
    anomalies_iso = df[df['iso_pred'] == -1]
    
    # B. K-Means Clustering (flag small clusters as anomalies)
    kmeans = KMeans(n_clusters=3, random_state=42)
    df['cluster'] = kmeans.fit_predict(features)
    cluster_counts = df['cluster'].value_counts()
    small_clusters = cluster_counts[cluster_counts < 0.05 * len(df)].index.tolist()
    anomalies_cluster = df[df['cluster'].isin(small_clusters)]
    
    # ----------------------------
    # 4. Signature-Based Methods for C&C Pattern Detection
    # ----------------------------
    df['malicious_signature'] = df['decoded_payload'].apply(match_signatures)
    num_malicious = df['malicious_signature'].sum()
    
    # ----------------------------
    # 5. Flag IP Payloads from Anomalous Flows
    # ----------------------------
    # Extract unique source IPs from flows flagged by Isolation Forest and K-Means, if available.
    if 'source' in df.columns:
        flagged_ips_iso = df[df['iso_pred'] == -1]['source'].unique()
        flagged_ips_cluster = df[df['cluster'].isin(small_clusters)]['source'].unique()
    else:
        flagged_ips_iso = []
        flagged_ips_cluster = []
    
    # ----------------------------
    # 6. Encrypted Traffic Analysis via Payload Features
    # ----------------------------
    enc_results = flag_encrypted_anomalies(df, high_entropy_threshold=7.5, contamination=0.01)
    encrypted_anomalies = enc_results.get('encrypted_anomalies', pd.DataFrame())
    
    # ----------------------------
    # 7. Encrypted Traffic Analysis via Total Destination Bytes (if available)
    # ----------------------------
    if 'encrypted' in df.columns:
        encrypted_flows = df[df['encrypted'] == True]
        if not encrypted_flows.empty and 'totalDestinationBytes' in encrypted_flows.columns:
            typical_size_mean = encrypted_flows['totalDestinationBytes'].mean()
            typical_size_std = encrypted_flows['totalDestinationBytes'].std()
            encrypted_anomalies_bytes = encrypted_flows[
                (encrypted_flows['totalDestinationBytes'] > typical_size_mean + 3 * typical_size_std) |
                (encrypted_flows['totalDestinationBytes'] < typical_size_mean - 3 * typical_size_std)
            ]
            bytes_report = f"Encrypted traffic anomalies based on totalDestinationBytes detected: {len(encrypted_anomalies_bytes)}"
        else:
            bytes_report = "No encrypted flows found based on totalDestinationBytes."
    else:
        bytes_report = "No 'encrypted' column available for totalDestinationBytes analysis."
    
    # ----------------------------
    # 8. Append Results for This File
    # ----------------------------
    report_lines.append("Payload Length Statistics:")
    report_lines.append(f"Mean: {length_mean:.2f}, Median: {length_median:.2f}, Std Dev: {length_std:.2f}\n")
    
    report_lines.append("Payload Entropy Statistics:")
    report_lines.append(f"Mean: {entropy_mean:.2f}, Median: {entropy_median:.2f}, Std Dev: {entropy_std:.2f}")
    report_lines.append(f"\nEntropy Threshold (Mean + 2σ): {entropy_threshold:.2f}\n")
    report_lines.append(f"Number of payloads with high entropy: {len(flagged_high_entropy)}\n")
    
    report_lines.append("Example Character Frequency Distribution (First Payload):")
    report_lines.append(str(char_freq) + "\n")
    
    report_lines.append(f"Number of payloads flagged with suspicious keywords: {num_suspicious}\n")
    
    report_lines.append("=== Machine Learning / Clustering Analysis ===")
    report_lines.append(f"Isolation Forest detected {len(anomalies_iso)} anomalous payloads.")
    report_lines.append("K-Means Clustering:")
    report_lines.append("Cluster counts:\n" + cluster_counts.to_string())
    report_lines.append(f"\nPayloads flagged from small clusters (potential anomalies): {len(anomalies_cluster)}\n")
    
    report_lines.append("=== Signature-Based Detection for C&C Patterns ===")
    report_lines.append(f"Number of payloads flagged by malicious signature matching: {num_malicious}\n")
    
    report_lines.append("=== Flagged Source IPs from Anomalous Payloads ===")
    report_lines.append("Isolation Forest flagged source IPs:")
    report_lines.append(str(flagged_ips_iso))
    report_lines.append("K-Means Clustering flagged source IPs:")
    report_lines.append(str(flagged_ips_cluster))
    
    report_lines.append("=== Encrypted Traffic Analysis (Payload Features) ===")
    report_lines.append(f"Encrypted traffic (entropy >= 7.5) detected: {len(df[df['entropy'] >= 7.5])}")
    report_lines.append(f"Abnormal encrypted payloads flagged: {len(encrypted_anomalies)}\n")
    
    report_lines.append("=== Encrypted Traffic Analysis (Total Destination Bytes) ===")
    report_lines.append(bytes_report + "\n")
    
    report_lines.append("\n" + "="*70 + "\n")

# ----------------------------
# Save the Consolidated Report
# ----------------------------
with open("output_4_2.txt", "w") as f:
    f.write("\n".join(report_lines))

print("Payload feature extraction and ML report saved as output_4_2.txt")
