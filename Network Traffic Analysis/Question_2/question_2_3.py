import pandas as pd
import numpy as np
import hashlib
import glob
import matplotlib.pyplot as plt
import seaborn as sns
from pybloom_live import BloomFilter
import random

def random_ip():
    """Generate a random IPv4 address as a string."""
    return ".".join(str(random.randint(0, 255)) for _ in range(4))

def process_membership(filename, error_rate_target=0.01):
    """
    Processes one CSV file to perform membership testing using a Bloom filter.
    
    It uses the 'source' column as the blocklist and tests a known IP as well as 
    a set of random IP addresses (that are not in the blocklist) to estimate the 
    false positive rate.
    
    Returns:
      A tuple containing the textual result (string) and a metrics dictionary.
    """
    out_lines = []
    out_lines.append(f"Processing membership test for {filename}:")
    
    try:
        df = pd.read_csv(filename)
    except Exception as e:
        out_lines.append(f"Error reading file: {e}")
        return "\n".join(out_lines), None
    
    if 'source' not in df.columns:
        out_lines.append(f"Column 'source' not found in {filename}.")
        return "\n".join(out_lines), None
    
    # Build the blocklist from the 'source' column
    blocklist = set(df['source'].dropna().astype(str).str.strip())
    
    # Initialize the Bloom filter with capacity equal to the number of unique IPs 
    # in the blocklist and the desired error rate.
    bf = BloomFilter(capacity=len(blocklist), error_rate=error_rate_target)
    for ip in blocklist:
        bf.add(ip)
    
    # Test membership for a known IP (should return True)
    known_ip = next(iter(blocklist))
    result_known = known_ip in bf
    out_lines.append(f"Membership test for known IP '{known_ip}': {result_known} (Expected: True)")
    
    # Estimate the false positive rate by generating random IPs that are NOT in the blocklist.
    n_tests = 10000
    false_positive_count = 0
    tests_done = 0
    while tests_done < n_tests:
        ip = random_ip()
        if ip in blocklist:
            continue  # Skip if the generated IP accidentally exists in the blocklist
        if ip in bf:
            false_positive_count += 1
        tests_done += 1
    fp_rate = (false_positive_count / n_tests) * 100
    out_lines.append(f"Tested {n_tests} random IPs not in blocklist.")
    out_lines.append(f"False positive rate: {fp_rate:.2f}%")
    out_lines.append("Exact membership test using a Python set yields 0% false positives.")
    out_lines.append("--------------------------------------------------------------\n")
    
    metrics = {
        'filename': filename,
        'false_positive_rate': fp_rate
    }
    
    return "\n".join(out_lines), metrics

def process_membership_combined(df, label, error_rate_target=0.01):
    """
    Processes a combined DataFrame to perform membership testing using a Bloom filter.
    
    It uses the 'source' column as the blocklist and tests a known IP as well as 
    a set of random IP addresses (that are not in the blocklist) to estimate the 
    false positive rate.
    
    Returns:
      A tuple containing the textual result (string) and a metrics dictionary.
    """
    out_lines = []
    out_lines.append(f"Processing membership test for {label}:")
    
    if 'source' not in df.columns:
        out_lines.append(f"Column 'source' not found in the combined data.")
        return "\n".join(out_lines), None
    
    # Build the blocklist from the 'source' column
    blocklist = set(df['source'].dropna().astype(str).str.strip())
    
    # Initialize the Bloom filter
    bf = BloomFilter(capacity=len(blocklist), error_rate=error_rate_target)
    for ip in blocklist:
        bf.add(ip)
    
    # Test membership for a known IP (should return True)
    known_ip = next(iter(blocklist))
    result_known = known_ip in bf
    out_lines.append(f"Membership test for known IP '{known_ip}': {result_known} (Expected: True)")
    
    # Estimate the false positive rate using random IPs not in the blocklist.
    n_tests = 10000
    false_positive_count = 0
    tests_done = 0
    while tests_done < n_tests:
        ip = random_ip()
        if ip in blocklist:
            continue
        if ip in bf:
            false_positive_count += 1
        tests_done += 1
    fp_rate = (false_positive_count / n_tests) * 100
    out_lines.append(f"Tested {n_tests} random IPs not in blocklist.")
    out_lines.append(f"False positive rate: {fp_rate:.2f}%")
    out_lines.append("Exact membership test using a Python set yields 0% false positives.")
    out_lines.append("--------------------------------------------------------------\n")
    
    metrics = {
        'filename': label,
        'false_positive_rate': fp_rate
    }
    
    return "\n".join(out_lines), metrics

# ------------------- Main Processing -------------------
file_list = [
    "../network_analysis_data1.csv",
    "../network_analysis_data2.csv",
    "../network_analysis_data3.csv",
    "../network_analysis_data4.csv",
    "../network_analysis_data5.csv",
    "../network_analysis_data6.csv"
]

all_outputs = []
all_metrics = []
all_outputs.append("********** Efficient Membership Testing Using Bloom Filter **********\n")

# Process individual CSV files
for f in file_list:
    result_text, metrics = process_membership(f)
    all_outputs.append(result_text)
    if metrics:
        all_metrics.append(metrics)

# Process combined data from all CSV files
try:
    combined_df = pd.concat([pd.read_csv(f) for f in file_list], ignore_index=True)
    combined_label = "All Combined Files"
    combined_output, combined_metrics = process_membership_combined(combined_df, combined_label)
    all_outputs.append("====== Combined Data Analysis ======")
    all_outputs.append(combined_output)
    if combined_metrics:
        all_metrics.append(combined_metrics)
except Exception as e:
    all_outputs.append(f"Error processing combined data: {e}")

# Write the combined output to output_2_3.txt
with open("output_2_3.txt", "w") as outfile:
    outfile.write("\n".join(all_outputs))

print("Processing complete. Check output_2_3.txt for the results.")
