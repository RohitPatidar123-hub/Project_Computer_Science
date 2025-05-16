import pandas as pd
import hashlib
import math
import time
import sys
import glob
import matplotlib.pyplot as plt
import seaborn as sns  # Added import for seaborn

def count_leading_zeros(bin_str):
    """Count the number of consecutive zeros from the start of a binary string."""
    count = 0
    for char in bin_str:
        if char == '0':
            count += 1
        else:
            break
    return count

def hyperloglog_bucket_estimate(ips, p):
    """
    Estimate the number of unique elements using a bucket-based (HyperLogLog-like) method.
    
    Parameters:
      ips: A pandas Series or list of IP strings.
      p: The number of bits used for bucket indexing (number of buckets = 2^p).
      
    Returns:
      E: The estimated number of unique IP addresses.
      buckets: The bucket list used (for space analysis).
    """
    m = 2 ** p  # Number of buckets
    buckets = [0] * m  # Initialize all buckets to zero
    
    for ip in ips:
        # Compute the MD5 hash (128-bit) of the IP address
        hash_bytes = hashlib.md5(ip.encode('utf-8')).digest()
        hash_int = int.from_bytes(hash_bytes, byteorder='big')
        # Represent the hash as a 128-bit binary string
        bin_str = format(hash_int, '0128b')
        # The first p bits determine the bucket index
        bucket_index = int(bin_str[:p], 2)
        # The remaining bits are used to determine the run of leading zeros
        remaining = bin_str[p:]
        # Count leading zeros in the remaining part; add 1 as per the algorithm
        r = count_leading_zeros(remaining) + 1
        # Update the bucket with the maximum run observed
        buckets[bucket_index] = max(buckets[bucket_index], r)
    
    # Calculate the harmonic sum Z = sum(2^{-bucket_value}) for all buckets
    Z = sum(2 ** (-b) for b in buckets)
    # Correction constant: For m buckets, alpha_m = 0.7213 / (1 + 1.079/m)
    alpha_m = 0.7213 / (1 + 1.079 / m)
    # Estimated cardinality using the HyperLogLog formula
    E = alpha_m * m * m / Z
    return E, buckets

def process_file(filename, p):
    """Process one CSV file and return output string and metrics for visualization."""
    out_lines = []
    out_lines.append(f"====== Processing File: {filename} ======")
    
    try:
        df = pd.read_csv(filename)
    except Exception as e:
        out_lines.append(f"Error reading file: {e}")
        return "\n".join(out_lines), None
    
    # Ensure required columns exist
    if 'source' not in df.columns or 'destination' not in df.columns:
        out_lines.append("Required columns 'source' and 'destination' not found.")
        return "\n".join(out_lines), None
    
    ips = pd.concat([df['source'], df['destination']]).dropna().astype(str).str.strip()
    
    # --- Sublinear Method: HyperLogLog Bucket-Based Estimate ---
    start_time = time.time()
    approx_unique, buckets = hyperloglog_bucket_estimate(ips, p)
    approx_time = time.time() - start_time
    
    # Estimate memory usage for HLL buckets (approximate)
    buckets_memory = sys.getsizeof(buckets) + sum(sys.getsizeof(b) for b in buckets)
    
    # --- Linear Method: Exact Unique Count ---
    start_time = time.time()
    exact_unique = len(ips.unique())
    linear_time = time.time() - start_time
    exact_set = set(ips.unique())
    exact_memory = sys.getsizeof(exact_set) + sum(sys.getsizeof(ip) for ip in exact_set)
    
    error_rate = abs(approx_unique - exact_unique) / exact_unique * 100 if exact_unique else 0
    
    # --- Prepare Output for this File ---
    out_lines.append(f"Approximate unique IP count (Bucket Method HLL): {approx_unique:.2f}")
    out_lines.append(f"Exact unique IP count: {exact_unique}")
    out_lines.append(f"Error rate: {error_rate:.2f}%")
    if error_rate <= 10:
        out_lines.append("✅ Error rate is within acceptable bounds (≤10%).")
    else:
        out_lines.append("⚠️ Error rate is too high (>10%).")
    
    out_lines.append("\n--- Computation Time ---")
    out_lines.append(f"Time taken (HyperLogLog): {approx_time:.6f} seconds")
    out_lines.append(f"Time taken (Exact Count): {linear_time:.6f} seconds")
    
    out_lines.append("\n--- Space Usage ---")
    out_lines.append(f"Memory for HLL buckets (approx): {buckets_memory} bytes")
    out_lines.append(f"Memory for Exact IP set (approx): {exact_memory} bytes")
    
    out_lines.append("\n--- Trade-off Analysis ---")
    out_lines.append("Space: HyperLogLog uses fixed, sublinear space (here, 2^p buckets) compared to storing all unique IPs exactly.")
    out_lines.append("Accuracy: When properly tuned, HyperLogLog typically achieves ~1–3% error; high error here indicates parameter tuning may be needed.")
    out_lines.append("Computation Time: HyperLogLog updates are O(1) per element, making it very fast for large datasets compared to linear methods.")
    out_lines.append("--------------------------------------------------------------\n")
    
    metrics = {
        'filename': filename,
        'approx_unique': approx_unique,
        'exact_unique': exact_unique,
        'error_rate': error_rate,
        'approx_time': approx_time,
        'linear_time': linear_time,
        'buckets_memory': buckets_memory,
        'exact_memory': exact_memory
    }
    
    return "\n".join(out_lines), metrics

def process_combined_data(df, label, p):
    """Process combined DataFrame from all CSV files and return output string and metrics."""
    out_lines = []
    out_lines.append(f"====== Processing Combined Data: {label} ======")
    
    # Ensure required columns exist
    if 'source' not in df.columns or 'destination' not in df.columns:
        out_lines.append("Required columns 'source' and 'destination' not found.")
        return "\n".join(out_lines), None
    
    ips = pd.concat([df['source'], df['destination']]).dropna().astype(str).str.strip()
    
    # --- Sublinear Method: HyperLogLog Bucket-Based Estimate ---
    start_time = time.time()
    approx_unique, buckets = hyperloglog_bucket_estimate(ips, p)
    approx_time = time.time() - start_time
    buckets_memory = sys.getsizeof(buckets) + sum(sys.getsizeof(b) for b in buckets)
    
    # --- Linear Method: Exact Unique Count ---
    start_time = time.time()
    exact_unique = len(ips.unique())
    linear_time = time.time() - start_time
    exact_set = set(ips.unique())
    exact_memory = sys.getsizeof(exact_set) + sum(sys.getsizeof(ip) for ip in exact_set)
    
    error_rate = abs(approx_unique - exact_unique) / exact_unique * 100 if exact_unique else 0
    
    out_lines.append(f"Approximate unique IP count (Bucket Method HLL): {approx_unique:.2f}")
    out_lines.append(f"Exact unique IP count: {exact_unique}")
    out_lines.append(f"Error rate: {error_rate:.2f}%")
    if error_rate <= 10:
        out_lines.append("✅ Error rate is within acceptable bounds (≤10%).")
    else:
        out_lines.append("⚠️ Error rate is too high (>10%).")
    
    out_lines.append("\n--- Computation Time ---")
    out_lines.append(f"Time taken (HyperLogLog): {approx_time:.6f} seconds")
    out_lines.append(f"Time taken (Exact Count): {linear_time:.6f} seconds")
    
    out_lines.append("\n--- Space Usage ---")
    out_lines.append(f"Memory for HLL buckets (approx): {buckets_memory} bytes")
    out_lines.append(f"Memory for Exact IP set (approx): {exact_memory} bytes")
    
    out_lines.append("\n--- Trade-off Analysis ---")
    out_lines.append("Space: HyperLogLog uses fixed, sublinear space (here, 2^p buckets) compared to storing all unique IPs exactly.")
    out_lines.append("Accuracy: When properly tuned, HyperLogLog typically achieves ~1–3% error; high error here indicates parameter tuning may be needed.")
    out_lines.append("Computation Time: HyperLogLog updates are O(1) per element, making it very fast for large datasets compared to linear methods.")
    out_lines.append("--------------------------------------------------------------\n")
    
    metrics = {
        'filename': label,
        'approx_unique': approx_unique,
        'exact_unique': exact_unique,
        'error_rate': error_rate,
        'approx_time': approx_time,
        'linear_time': linear_time,
        'buckets_memory': buckets_memory,
        'exact_memory': exact_memory
    }
    
    return "\n".join(out_lines), metrics

# ------------------- Main Processing -------------------
csv_files = glob.glob("../network_analysis_data*.csv")
p = 10  # Using 2^10 = 1024 buckets for HLL
all_outputs = []
all_metrics = []

all_outputs.append("********** Unique IP Estimation Using Bucket-Based HyperLogLog **********\n")

# Process individual CSV files
for file in sorted(csv_files):
    output_text, metrics = process_file(file, p)
    all_outputs.append(output_text)
    if metrics:
        all_metrics.append(metrics)

# Process combined data from all CSV files
try:
    combined_df = pd.concat([pd.read_csv(f) for f in sorted(csv_files)], ignore_index=True)
    combined_output, combined_metrics = process_combined_data(combined_df, "All Combined Files", p)
    all_outputs.append("====== Combined Data Analysis ======")
    all_outputs.append(combined_output)
    if combined_metrics:
        all_metrics.append(combined_metrics)
except Exception as e:
    all_outputs.append(f"Error processing combined data: {e}")

# Write the combined output to output_2_1.txt
with open("output_2_1.txt", "w") as f:
    f.write("\n".join(all_outputs))

print("Textual processing complete. Check output_2_1.txt for results from all CSV files.")

# ------------------- Visualization -------------------
# Create a DataFrame from the collected metrics
df_metrics = pd.DataFrame(all_metrics)
df_metrics.set_index('filename', inplace=True)

# Generate short file labels:
files_short = []
for i, fname in enumerate(df_metrics.index):
    if fname == "All Combined Files":
        files_short.append("all_combined_file.csv")
    else:
        files_short.append(f"file{i+1}.csv")

# Create a 2x2 grid of subplots for clear, separate graphs
fig, axs = plt.subplots(2, 2, figsize=(16, 12))
fig.suptitle("Unique IP Estimation Metrics per CSV File", fontsize=20)

# Graph 1: Error Rate per File
axs[0,0].bar(files_short, df_metrics['error_rate'], color='salmon')
axs[0,0].set_title("Error Rate (%)")
axs[0,0].set_xlabel("CSV File")
axs[0,0].set_ylabel("Error Rate (%)")
axs[0,0].set_ylim(0, df_metrics["error_rate"].max() * 1.2)
for patch, label in zip(axs[0,0].patches, df_metrics['error_rate']):
    axs[0,0].annotate(f'{label:.1f}%', 
                      (patch.get_x() + patch.get_width() / 2., patch.get_height()),
                      ha='center', va='bottom', fontsize=10)

# Graph 2: Unique IP Counts (Exact vs. Approximate)
x = range(len(df_metrics))
width = 0.35
axs[0,1].bar(x, df_metrics['exact_unique'], width, label='Exact', color='lightblue')
axs[0,1].bar([i + width for i in x], df_metrics['approx_unique'], width, label='Approximate', color='orange')
axs[0,1].set_title("Unique IP Counts")
axs[0,1].set_xlabel("CSV File")
axs[0,1].set_ylabel("Unique IP Count")
axs[0,1].set_xticks([i + width/2 for i in x])
axs[0,1].set_xticklabels(files_short, rotation=45)
axs[0,1].legend()

# Graph 3: Computation Time Comparison
axs[1,0].bar(x, df_metrics['approx_time'], width, label='HyperLogLog Time', color='lightgreen')
axs[1,0].bar([i + width for i in x], df_metrics['linear_time'], width, label='Exact Time', color='purple')
axs[1,0].set_title("Computation Time (seconds)")
axs[1,0].set_xlabel("CSV File")
axs[1,0].set_ylabel("Time (seconds)")
axs[1,0].set_xticks([i + width/2 for i in x])
axs[1,0].set_xticklabels(files_short, rotation=45)
axs[1,0].legend()

# Graph 4: Space Usage Comparison
axs[1,1].bar(x, df_metrics['buckets_memory'], width, label='HLL Buckets', color='cyan')
axs[1,1].bar([i + width for i in x], df_metrics['exact_memory'], width, label='Exact Set', color='magenta')
axs[1,1].set_title("Space Usage (bytes)")
axs[1,1].set_xlabel("CSV File")
axs[1,1].set_ylabel("Memory (bytes)")
axs[1,1].set_xticks([i + width/2 for i in x])
axs[1,1].set_xticklabels(files_short, rotation=45)
axs[1,1].legend()

plt.tight_layout(rect=[0, 0.03, 1, 0.95])
plt.savefig("output2_graph.png", dpi=300)
plt.show()