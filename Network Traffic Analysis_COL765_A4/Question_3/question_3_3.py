import pandas as pd
import numpy as np
import glob
import os
import matplotlib.pyplot as plt


class SuspiciousPatternAnalyzer:
    def __init__(self, file_pattern, output_file="output_3_3.txt", graph_dir="graphs_3_3"):
        self.file_pattern = file_pattern
        self.output_file = output_file
        self.graph_dir = graph_dir
        self.use_cols = ['startDateTime', 'stopDateTime', 'source', 'destination',
                         'totalSourceBytes', 'totalDestinationBytes', 'protocolName']
        self.csv_files = sorted(glob.glob(file_pattern))
        self.output_lines = ["=== Suspicious Communication Patterns Consolidated Report ===\n"]
        os.makedirs(self.graph_dir, exist_ok=True)

    def process_individual_file(self, csv_file):
        self.output_lines.append(f"=== Results for File: {csv_file} ===\n")
        try:
            df = pd.read_csv(csv_file, usecols=self.use_cols, parse_dates=['startDateTime', 'stopDateTime'])
        except Exception as e:
            self.output_lines.append(f"Error reading file {csv_file}: {e}\n")
            return

        try:
            df['startDateTime'] = pd.to_datetime(df['startDateTime'])
            df['stopDateTime'] = pd.to_datetime(df['stopDateTime'])
        except Exception as e:
            self.output_lines.append(f"Error parsing dates in file {csv_file}: {e}\n")
            return

        df['duration'] = (df['stopDateTime'] - df['startDateTime']).dt.total_seconds()
        mean_duration = df['duration'].mean()
        std_duration = df['duration'].std()
        threshold_duration = mean_duration + 3 * std_duration
        long_duration_flows = df[df['duration'] > threshold_duration]

        self.output_lines.append("---- Long-Duration Connections ----")
        self.output_lines.append(f"Mean Connection Duration: {mean_duration:.2f} seconds")
        self.output_lines.append(f"Std Dev of Duration: {std_duration:.2f} seconds")
        self.output_lines.append(f"Threshold (Mean + 3*Std): {threshold_duration:.2f} seconds")
        self.output_lines.append(f"Number of flows exceeding threshold: {len(long_duration_flows)}")
        if not long_duration_flows.empty:
            self.output_lines.append("Sample Long-Duration Flows:")
            self.output_lines.append(long_duration_flows[['source', 'destination', 'duration']].head(5).to_string(index=False))
            self._plot_duration_histogram(df['duration'], os.path.basename(csv_file))
        self.output_lines.append("\n")

        df.sort_values('startDateTime', inplace=True)
        df['time_bin'] = df['startDateTime'].dt.floor('10min')
        protocol_diversity = df.groupby(['source', 'time_bin'])['protocolName'].nunique().reset_index()
        suspicious_protocol_usage = protocol_diversity[protocol_diversity['protocolName'] >= 3]

        self.output_lines.append("---- Multiple Protocols in Short Time ----")
        self.output_lines.append("For each source IP, the number of unique protocols used in each 10-minute window is calculated.")
        self.output_lines.append("Suspicious if count >= 3.")
        self.output_lines.append(f"Number of suspicious time windows: {len(suspicious_protocol_usage)}")
        if not suspicious_protocol_usage.empty:
            self.output_lines.append("Sample suspicious protocol usage records:")
            self.output_lines.append(suspicious_protocol_usage.head(10).to_string(index=False))
            self._plot_protocol_usage_hist(protocol_diversity, os.path.basename(csv_file))
        self.output_lines.append("\n" + "=" * 70 + "\n")

    def process_combined_analysis(self):
        self.output_lines.append("=== Combined Data Analysis for All CSV Files ===\n")
        try:
            combined_df = pd.concat([pd.read_csv(f, usecols=self.use_cols, parse_dates=['startDateTime', 'stopDateTime'])
                                     for f in self.csv_files], ignore_index=True)
        except Exception as e:
            self.output_lines.append(f"Error combining CSV files: {e}\n")
            return

        combined_df['startDateTime'] = pd.to_datetime(combined_df['startDateTime'])
        combined_df['stopDateTime'] = pd.to_datetime(combined_df['stopDateTime'])
        combined_df['duration'] = (combined_df['stopDateTime'] - combined_df['startDateTime']).dt.total_seconds()
        mean_duration = combined_df['duration'].mean()
        std_duration = combined_df['duration'].std()
        threshold_duration = mean_duration + 3 * std_duration
        long_duration_flows = combined_df[combined_df['duration'] > threshold_duration]

        self.output_lines.append("---- Long-Duration Connections (Combined Data) ----")
        self.output_lines.append(f"Mean Connection Duration: {mean_duration:.2f} seconds")
        self.output_lines.append(f"Std Dev of Duration: {std_duration:.2f} seconds")
        self.output_lines.append(f"Threshold (Mean + 3*Std): {threshold_duration:.2f} seconds")
        self.output_lines.append(f"Number of flows exceeding threshold: {len(long_duration_flows)}")
        if not long_duration_flows.empty:
            self.output_lines.append("Sample Long-Duration Flows:")
            self.output_lines.append(long_duration_flows[['source', 'destination', 'duration']].head(5).to_string(index=False))
            self._plot_duration_histogram(combined_df['duration'], "combined")
        self.output_lines.append("\n")

        combined_df.sort_values('startDateTime', inplace=True)
        combined_df['time_bin'] = combined_df['startDateTime'].dt.floor('10min')
        protocol_diversity = combined_df.groupby(['source', 'time_bin'])['protocolName'].nunique().reset_index()
        suspicious_protocol_usage = protocol_diversity[protocol_diversity['protocolName'] >= 3]

        self.output_lines.append("---- Multiple Protocols in Short Time (Combined Data) ----")
        self.output_lines.append("Suspicious if count >= 3.")
        self.output_lines.append(f"Number of suspicious time windows: {len(suspicious_protocol_usage)}")
        if not suspicious_protocol_usage.empty:
            self.output_lines.append("Sample suspicious protocol usage records:")
            self.output_lines.append(suspicious_protocol_usage.head(10).to_string(index=False))
            self._plot_protocol_usage_hist(protocol_diversity, "combined")

        # fan_in_df = combined_df.groupby(['destination', 'time_bin'])['source'].nunique().reset_index(name='unique_source_count')
        # suspicious_destinations = fan_in_df[fan_in_df['unique_source_count'] > 50]

        # self.output_lines.append("---- High Fan-in Destinations (Combined Data) ----")
        # self.output_lines.append("Flagging destination IPs contacted by >50 unique sources in 10-minute windows:")
        # if not suspicious_destinations.empty:
        #     self.output_lines.append(suspicious_destinations.sort_values(by='unique_source_count', ascending=False).to_string(index=False))
        #     self._plot_fanin_bar(suspicious_destinations, "combined")
        # else:
        #     self.output_lines.append("No destinations detected with high fan-in within short time windows.")
        self.output_lines.append("\n" + "=" * 70 + "\n")

    def _plot_duration_histogram(self, durations, label):
        plt.figure(figsize=(10, 6))
        plt.hist(durations, bins=50, color='skyblue', edgecolor='black')
        plt.title(f"Connection Duration Distribution ({label})")
        plt.xlabel("Duration (seconds)")
        plt.ylabel("Count")
        plt.tight_layout()
        plt.savefig(os.path.join(self.graph_dir, f"duration_hist_{label}.png"))
        plt.close()

    def _plot_protocol_usage_hist(self, diversity_df, label):
        plt.figure(figsize=(10, 6))
        diversity_df['protocolName'].hist(bins=range(1, diversity_df['protocolName'].max() + 2), color='orange', edgecolor='black')
        plt.title(f"Protocol Diversity per Source-Time Bin ({label})")
        plt.xlabel("Unique Protocol Count")
        plt.ylabel("Number of Time Bins")
        plt.tight_layout()
        plt.savefig(os.path.join(self.graph_dir, f"protocol_diversity_{label}.png"))
        plt.close()

    # def _plot_fanin_bar(self, fanin_df, label):
    #     top_dest = fanin_df.groupby('destination')['unique_source_count'].sum().nlargest(10)
    #     plt.figure(figsize=(12, 6))
    #     top_dest.plot(kind='bar', color='red')
    #     plt.title(f"Top 10 High Fan-in Destinations ({label})")
    #     plt.xlabel("Destination IP")
    #     plt.ylabel("Total Unique Source Count")
    #     plt.tight_layout()
    #     plt.savefig(os.path.join(self.graph_dir, f"high_fanin_{label}.png"))
    #     plt.close()

    def write_report(self):
        with open(self.output_file, "w") as f:
            f.write("\n".join(self.output_lines))

    def run(self):
        for file in self.csv_files:
            self.process_individual_file(file)
        self.process_combined_analysis()
        self.write_report()
        return self.output_file, self.graph_dir


analyzer = SuspiciousPatternAnalyzer("../network_analysis_data*.csv")
analyzer.run()
