import pandas as pd
import numpy as np
import hashlib
import glob
import matplotlib.pyplot as plt
import seaborn as sns

class CountMinSketch:
    def __init__(self, width, depth):
        self.width = width
        self.depth = depth
        self.table = np.zeros((depth, width), dtype=int)
        # Use a different seed for each row
        self.seeds = [i for i in range(depth)]
    
    def _hash(self, item, i):
        # Combine the item with the seed and compute MD5 hash
        h = hashlib.md5((str(item) + str(self.seeds[i])).encode('utf-8'))
        return int(h.hexdigest(), 16) % self.width
    
    def add(self, item, count=1):
        for i in range(self.depth):
            index = self._hash(item, i)
            self.table[i][index] += count
    
    def estimate(self, item):
        # The estimate is the minimum count across all hash functions
        return min(self.table[i][self._hash(item, i)] for i in range(self.depth))

def process_heavy_hitters(filename, width=2000, depth=10):
    """
    Processes one CSV file to approximate heavy hitters (destination IP counts)
    using Count-Min Sketch and compares with exact counts.
    
    Returns a tuple: (textual_result, metrics_dict)
    Metrics include:
      - avg_error: Average error (%) among top 10 heavy hitters.
      - max_error: Maximum error (%) among top 10 heavy hitters.
      - top1_exact: Exact count of the top heavy hitter.
      - top1_approx: Approximate count of the top heavy hitter.
    """
    out_lines = []
    out_lines.append(f"Top 10 heavy hitters for {filename}:")
    
    try:
        df = pd.read_csv(filename)
    except Exception as e:
        out_lines.append(f"Error reading file: {e}")
        return "\n".join(out_lines), None
    
    if 'destination' not in df.columns:
        out_lines.append(f"Column 'destination' not found in {filename}.")
        return "\n".join(out_lines), None
    
    dest_ips = df['destination'].dropna().astype(str).str.strip()
    
    # Initialize Count-Min Sketch
    cms = CountMinSketch(width=width, depth=depth)
    for ip in dest_ips:
        cms.add(ip)
    
    unique_ips = dest_ips.unique()
    approx_counts = {ip: cms.estimate(ip) for ip in unique_ips}
    exact_counts_series = dest_ips.value_counts()
    exact_counts = exact_counts_series.to_dict()
    
    # Get the top 10 heavy hitters based on exact counts
    top_10_exact = sorted(exact_counts.items(), key=lambda x: x[1], reverse=True)[:10]
    
    errors = []
    top1_exact = None
    top1_approx = None
    for idx, (ip, exact) in enumerate(top_10_exact):
        approx = approx_counts.get(ip, 0)
        error = abs(approx - exact) / exact * 100 if exact != 0 else 0
        errors.append(error)
        out_lines.append(f"IP: {ip} | Exact: {exact} | Approx: {approx} | Error: {error:.2f}%")
        if idx == 0:
            top1_exact = exact
            top1_approx = approx

    avg_error = np.mean(errors) if errors else 0
    max_error = np.max(errors) if errors else 0
    
    if all(err <= 10 for err in errors):
        out_lines.append("✅ All heavy hitters' error rates are within acceptable bounds (≤10%).")
    else:
        out_lines.append("⚠️ Some heavy hitters' error rates exceed acceptable bounds (>10%).")
    
    out_lines.append("--------------------------------------------------------------\n")
    
    metrics = {
        'filename': filename,
        'avg_error': avg_error,
        'max_error': max_error,
        'top1_exact': top1_exact,
        'top1_approx': top1_approx
    }
    
    return "\n".join(out_lines), metrics

def process_heavy_hitters_combined(df, label, width=2000, depth=10):
    """
    Processes combined DataFrame to approximate heavy hitters (destination IP counts)
    using Count-Min Sketch and compares with exact counts.
    
    Returns a tuple: (textual_result, metrics_dict) using the provided label.
    """
    out_lines = []
    out_lines.append(f"Top 10 heavy hitters for {label}:")
    
    if 'destination' not in df.columns:
        out_lines.append(f"Column 'destination' not found in combined data.")
        return "\n".join(out_lines), None
    
    dest_ips = df['destination'].dropna().astype(str).str.strip()
    
    # Initialize Count-Min Sketch
    cms = CountMinSketch(width=width, depth=depth)
    for ip in dest_ips:
        cms.add(ip)
    
    unique_ips = dest_ips.unique()
    approx_counts = {ip: cms.estimate(ip) for ip in unique_ips}
    exact_counts_series = dest_ips.value_counts()
    exact_counts = exact_counts_series.to_dict()
    
    # Get the top 10 heavy hitters based on exact counts
    top_10_exact = sorted(exact_counts.items(), key=lambda x: x[1], reverse=True)[:10]
    
    errors = []
    top1_exact = None
    top1_approx = None
    for idx, (ip, exact) in enumerate(top_10_exact):
        approx = approx_counts.get(ip, 0)
        error = abs(approx - exact) / exact * 100 if exact != 0 else 0
        errors.append(error)
        out_lines.append(f"IP: {ip} | Exact: {exact} | Approx: {approx} | Error: {error:.2f}%")
        if idx == 0:
            top1_exact = exact
            top1_approx = approx

    avg_error = np.mean(errors) if errors else 0
    max_error = np.max(errors) if errors else 0
    
    if all(err <= 10 for err in errors):
        out_lines.append("✅ All heavy hitters' error rates are within acceptable bounds (≤10%).")
    else:
        out_lines.append("⚠️ Some heavy hitters' error rates exceed acceptable bounds (>10%).")
    
    out_lines.append("--------------------------------------------------------------\n")
    
    metrics = {
        'filename': label,
        'avg_error': avg_error,
        'max_error': max_error,
        'top1_exact': top1_exact,
        'top1_approx': top1_approx
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

p_width = 2000  # default width for CMS
p_depth = 10    # default depth for CMS

all_outputs = []
all_metrics = []
all_outputs.append("********** Heavy Hitters Estimation Using Count-Min Sketch **********\n")

# Process individual CSV files
for f in file_list:
    result_text, metrics = process_heavy_hitters(f, width=p_width, depth=p_depth)
    all_outputs.append(result_text)
    if metrics:
        all_metrics.append(metrics)

# Process combined data from all CSV files
try:
    combined_df = pd.concat([pd.read_csv(f) for f in file_list], ignore_index=True)
    combined_label = "All Combined Files"
    combined_output, combined_metrics = process_heavy_hitters_combined(combined_df, combined_label, width=p_width, depth=p_depth)
    all_outputs.append("====== Combined Data Analysis ======")
    all_outputs.append(combined_output)
    if combined_metrics:
        all_metrics.append(combined_metrics)
except Exception as e:
    all_outputs.append(f"Error processing combined data: {e}")

# Write the combined output to output_2_2.txt
with open("output_2_2.txt", "w") as outfile:
    outfile.write("\n".join(all_outputs))

print("Textual processing complete. Check output_2_2.txt for the results.")

# ------------------- Visualization -------------------
# Create a DataFrame from the collected metrics
df_metrics = pd.DataFrame(all_metrics)
df_metrics.set_index('filename', inplace=True)

# Generate short file labels; if the file is combined, label it as 'all_combined_file.csv'
files_short = []
for fname in df_metrics.index:
    if fname == "All Combined Files":
        files_short.append("all_combined_file.csv")
    else:
        files_short.append(fname.split("/")[-1])

# ------------------- Graph 1: Average Error Rate -------------------
plt.figure(figsize=(8,6))
ax1 = sns.barplot(x=files_short, y=df_metrics['avg_error'], palette="rocket", hue=None)
ax1.set_title("Average Error Rate (%) of Top 10 Heavy Hitters per File")
ax1.set_xlabel("CSV File")
ax1.set_ylabel("Average Error Rate (%)")
ax1.set_ylim(0, df_metrics["avg_error"].max() * 1.2)
for i, v in enumerate(df_metrics['avg_error']):
    ax1.text(i, v + 0.5, f"Max: {df_metrics['max_error'].iloc[i]:.1f}%", color='black', ha='center', fontsize=10)
plt.tight_layout()
plt.savefig("heavy_hitters_error_rate.png", dpi=300)
plt.show()

# ------------------- Graph 2: Top Heavy Hitter Comparison -------------------
plt.figure(figsize=(8,6))
x = np.arange(len(df_metrics))
width = 0.35
plt.bar(x - width/2, df_metrics['top1_exact'], width, label="Exact", color='skyblue')
plt.bar(x + width/2, df_metrics['top1_approx'], width, label="Approximate", color='salmon')
plt.xlabel("CSV File")
plt.ylabel("Top Heavy Hitter Count")
plt.title("Top Heavy Hitter (First) - Exact vs. Approximate Counts")
plt.xticks(x, files_short)
plt.legend()
plt.tight_layout()
plt.savefig("heavy_hitters_top_comparison.png", dpi=300)
plt.show()

plt.subplots_adjust(bottom=0.1, top=0.9)

print("Visualization complete. Check heavy_hitters_error_rate.png and heavy_hitters_top_comparison.png for the graphs.")
