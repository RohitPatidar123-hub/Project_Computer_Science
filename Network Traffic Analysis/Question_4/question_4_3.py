import re
from collections import defaultdict

# Input report files
EDA_FILE = 'eda_report.txt'
PATTERNS_FILE = 'output_suspicious_patterns.txt'
PAYLOAD_FILE = 'payload_report.txt'
THREAT_FILE = 'advanced_threat_report.txt'
OUTPUT_FILE = 'final_risk_report.txt'

# Data structure for each CSV file's metrics
data_metrics = defaultdict(lambda: {
    "iqr_anomalies": 0,
    "ml_anomalies": 0,
    "long_duration_flows": 0,
    "protocol_bursts": 0,
    "payload_signatures": 0,
    "payload_entropy_anomalies": 0,
    "payload_cluster_anomalies": 0,
    "stealthy_scan_ips": 0,
    "slow_ddos_ips": 0,
    "data_exfil_ips": 0,
    "botnet_ips": 0
})

#############################################
# --- Parse EDA Report (eda_report.txt) -----
#############################################
with open(EDA_FILE, 'r') as f:
    content = f.read()
    # Each block begins with "=== Summary for file:" and continues until the next "===" line or end-of-file.
    pattern_eda = re.compile(r"=== Summary for file:\s*(.*?) ===\n(.*?)(?=\n===|\Z)", re.S)
    for file_name, section in pattern_eda.findall(content):
        key = file_name.strip().split("/")[-1]
        iqr_match = re.search(r"Anomalous packets \(IQR method\):\s*(\d+)", section)
        ml_match = re.search(r"Isolation Forest detected\s*(\d+)\s*anomalies", section)
        if iqr_match:
            data_metrics[key]["iqr_anomalies"] = int(iqr_match.group(1))
        if ml_match:
            data_metrics[key]["ml_anomalies"] = int(ml_match.group(1))

#####################################################
# --- Parse Suspicious Patterns Report ------------
#####################################################
with open(PATTERNS_FILE, 'r') as f:
    content = f.read()
    pattern_patterns = re.compile(r"=== Results for File:\s*(.*?) ===\n(.*?)(?=\n===|\Z)", re.S)
    for file_name, section in pattern_patterns.findall(content):
        key = file_name.strip().split("/")[-1]
        lf_match = re.search(r"Number of flows exceeding threshold:\s*(\d+)", section)
        pb_match = re.search(r"Number of suspicious time windows:\s*(\d+)", section)
        if lf_match:
            data_metrics[key]["long_duration_flows"] = int(lf_match.group(1))
        if pb_match:
            data_metrics[key]["protocol_bursts"] = int(pb_match.group(1))

#############################################
# --- Parse Payload Report (payload_report.txt)
#############################################
with open(PAYLOAD_FILE, 'r') as f:
    content = f.read()
    pattern_payload = re.compile(
        r"Processing file:\s*(.*?)\s*---.*?"
        r"Number of payloads with high entropy:\s*(\d+).*?"
        r"Number of payloads flagged with suspicious keywords:\s*(\d+).*?"
        r"Payloads flagged from small clusters.*?:\s*(\d+)",
        re.S)
    for file_name, entropy, sig, cluster in pattern_payload.findall(content):
        key = file_name.strip().split("/")[-1]
        data_metrics[key]["payload_entropy_anomalies"] = int(entropy)
        data_metrics[key]["payload_signatures"] = int(sig)
        data_metrics[key]["payload_cluster_anomalies"] = int(cluster)

#####################################################
# --- Parse Advanced Threat Report (advanced_threat_report.txt)
#####################################################
with open(THREAT_FILE, 'r') as f:
    content = f.read()
    pattern_threat = re.compile(
        r"=== Advanced Threat Detection for file:\s*(.*?) ===\n(.*?)(?=\n===|\Z)",
        re.S)
    for file_name, section in pattern_threat.findall(content):
        key = file_name.strip().split("/")[-1]

        # Stealth scans: count lines after "Source IPs exceeding threshold (Overall):"
        stealth_block = re.search(r"Source IPs exceeding threshold \(Overall\):\s*\n((?:.*\S.*\n)+)", section)
        if stealth_block:
            # Remove header (e.g. "source") and blank lines
            lines = [line for line in stealth_block.group(1).splitlines() if line.strip() and not line.lower().startswith("source")]
            data_metrics[key]["stealthy_scan_ips"] = len(lines)
        else:
            data_metrics[key]["stealthy_scan_ips"] = 0

        # Slow DDoS: Sum anomaly counts from lines that start with "Destination:" in the slow DDoS section.
        ddos_matches = re.findall(r"Destination:\s*[\d\.]+,\s*Anomalies:\s*\{[^\}]*?:\s*(\d+)", section)
        if ddos_matches:
            total_ddos = sum(int(count) for count in ddos_matches)
            data_metrics[key]["slow_ddos_ips"] = total_ddos
        else:
            data_metrics[key]["slow_ddos_ips"] = 0

        # Data Exfiltration: count unique IPs flagged with [EXFILTRATION]
        exfil_matches = re.findall(r"\[EXFILTRATION\]\s*-\s*IP:\s*([\d\.]+)", section)
        data_metrics[key]["data_exfil_ips"] = len(set(exfil_matches))

        # Botnet Activity: count unique IPs from [BOTNET_ACTIVITY]; if none, fallback to IP-hopping extraction.
        botnet_matches = re.findall(r"\[BOTNET_ACTIVITY\]\s*-\s*IP:\s*([\d\.]+)", section)
        if botnet_matches:
            data_metrics[key]["botnet_ips"] = len(set(botnet_matches))
        else:
            ip_hop_matches = re.findall(r"\(\s*'([\d\.]+)'\s*,", section)
            data_metrics[key]["botnet_ips"] = len(set(ip_hop_matches))

#############################################
# --- Risk Classification Heuristic ---------
#############################################
def classify_risk(metrics):
    score = 0
    # EDA + ML thresholds
    if metrics["iqr_anomalies"] > 20000:
        score += 1
