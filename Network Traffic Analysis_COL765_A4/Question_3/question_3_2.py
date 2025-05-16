import dask.dataframe as dd
import pandas as pd
import numpy as np
import glob
import matplotlib.pyplot as plt
import os

class BehavioralAnalyzer:
    def __init__(self, file_pattern, use_cols=None, parse_dates=None):
        # Default columns and date parsing if not provided
        if use_cols is None:
            self.use_cols = ['startDateTime', 'stopDateTime', 'source', 'destination', 
                             'totalSourceBytes', 'totalDestinationBytes']
        else:
            self.use_cols = use_cols
        if parse_dates is None:
            self.parse_dates = ['startDateTime', 'stopDateTime']
        else:
            self.parse_dates = parse_dates
        
        self.file_pattern = file_pattern
        self.df = self.load_data()
    
    def load_data(self):
        # Read all CSV files using Dask for scalability
        df_dd = dd.read_csv(self.file_pattern, usecols=self.use_cols, parse_dates=self.parse_dates)
        df_dd['totalTraffic'] = df_dd['totalSourceBytes'] + df_dd['totalDestinationBytes']
        # Compute Dask dataframe into a pandas DataFrame and sort
        df = df_dd.compute().sort_values(by=['source', 'startDateTime'])
        return df
    
    def detect_sudden_spikes(self, inactivity_threshold=3600):
        """
        R1: Detect IPs with sudden traffic spikes after long inactivity.
        For each source, compute the time gap between consecutive flows and flag those
        where the gap > inactivity_threshold AND the totalTraffic exceeds (mean + 3*std)
        for that source.
        """
        df = self.df.copy()
        df['time_gap'] = df.groupby('source')['startDateTime'].diff().dt.total_seconds()
        traffic_threshold = df.groupby('source')['totalTraffic'].transform(lambda x: x.mean() + 3 * x.std())
        df['sudden_spike'] = (df['time_gap'] > inactivity_threshold) & (df['totalTraffic'] > traffic_threshold)
        return df[df['sudden_spike']][['source', 'startDateTime', 'totalTraffic']]
    
    def detect_common_targets(self, time_window='10min', threshold=5):
        """
        R2: Detect network-wide correlation patterns.
        Group the data into 10-minute buckets and, for each destination, count the unique source IPs.
        Returns a DataFrame where the unique source count exceeds the specified threshold.
        """
        df = self.df.copy()
        df['time_bucket'] = df['startDateTime'].dt.floor(time_window)
        common_target_df = df.groupby(['destination', 'time_bucket'])['source'].nunique().reset_index()
        common_target_df.rename(columns={'source': 'unique_source_count'}, inplace=True)
        return common_target_df[common_target_df['unique_source_count'] > threshold]
    
    def detect_high_fanin_destinations(self, time_window='10min', fan_in_threshold=50):
        """
        R3: Flag destination IPs with high fan-in.
        Group by destination and a 10-minute time bucket, then count unique source IPs.
        Returns a DataFrame of destinations with counts higher than fan_in_threshold.
        """
        df = self.df.copy()
        df['time_bucket'] = df['startDateTime'].dt.floor(time_window)
        fan_in_df = df.groupby(['destination', 'time_bucket'])['source'].nunique().reset_index(name='unique_source_count')
        return fan_in_df[fan_in_df['unique_source_count'] > fan_in_threshold]
    
    def run_analysis(self):
        results = {
            'sudden_spikes': self.detect_sudden_spikes(),
            'common_targets': self.detect_common_targets(),
            'high_fanin': self.detect_high_fanin_destinations()
        }
        return results
    
    def get_results_string(self):
        results = self.run_analysis()
        output_lines = []
        
        output_lines.append("IPs with Sudden Traffic Spikes After Inactivity:")
        if not results['sudden_spikes'].empty:
            output_lines.append(results['sudden_spikes'].to_string(index=False))
        else:
            output_lines.append("No IPs detected with sudden spikes after inactivity.")
        
        output_lines.append("\nDestinations contacted by multiple IPs within 10-minute windows:")
        if not results['common_targets'].empty:
            output_lines.append(results['common_targets'].sort_values(by='unique_source_count', ascending=False).to_string(index=False))
        else:
            output_lines.append("No common targets detected within short time windows.")
        
        output_lines.append("\nDestinations with High Fan-in (>50 sources in 10-minute windows):")
        if not results['high_fanin'].empty:
            output_lines.append(results['high_fanin'].sort_values(by='unique_source_count', ascending=False).to_string(index=False))
        else:
            output_lines.append("No destinations detected with high fan-in within short time windows.")
        
        return "\n".join(output_lines)
    
    def write_results(self, output_file):
        results_str = self.get_results_string()
        with open(output_file, "w") as f:
            f.write(results_str)
    
    def save_graphs(self, output_dir="graphs"):
        """
        Save graphs for better visualization:
          - Graph for sudden spikes: scatter plot of startDateTime vs. totalTraffic for sudden spike events.
          - Graph for common targets: bar chart of destination vs. total unique source count (aggregated over 10-min windows).
          - Graph for high fan-in: bar chart for the top 10 destination IPs (by unique source count) in high fan-in events.
        """
        os.makedirs(output_dir, exist_ok=True)
        
        # Graph for sudden spikes (R1)
        df_spike = self.detect_sudden_spikes()
        if not df_spike.empty:
            plt.figure(figsize=(12,6))
            for ip, group in df_spike.groupby('source'):
                plt.scatter(group['startDateTime'], group['totalTraffic'], label=ip, alpha=0.7)
            plt.xlabel("Time")
            plt.ylabel("Total Traffic")
            plt.title("Sudden Traffic Spikes After Inactivity")
            plt.legend(bbox_to_anchor=(1.05, 1), loc='upper left', fontsize='small')
            plt.tight_layout()
            spike_graph = os.path.join(output_dir, "sudden_spikes.png")
            plt.savefig(spike_graph, dpi=300)
            plt.close()
        else:
            print("No sudden spikes to plot.")
        
        # Graph for common targets (R2)
        common_targets = self.detect_common_targets(time_window='10min', threshold=5)
        if not common_targets.empty:
            common_targets_summary = common_targets.groupby('destination')['unique_source_count'].sum().reset_index()
            common_targets_summary = common_targets_summary.sort_values(by='unique_source_count', ascending=False)
            plt.figure(figsize=(12,6))
            plt.bar(common_targets_summary['destination'].head(10), common_targets_summary['unique_source_count'].head(10), color='skyblue')
            plt.xlabel("Destination IP")
            plt.ylabel("Total Unique Source Count (10-min windows)")
            plt.title("Top 10 Common Targets")
            plt.xticks(rotation=90)
            plt.tight_layout()
            common_targets_graph = os.path.join(output_dir, "common_targets.png")
            plt.savefig(common_targets_graph, dpi=300)
            plt.close()
        else:
            print("No common targets to plot.")
        
        # Graph for high fan-in (R3) - show top 10 destination IPs by unique source count
        high_fanin = self.detect_high_fanin_destinations(time_window='10min', fan_in_threshold=50)
        if not high_fanin.empty:
            high_fanin_summary = high_fanin.groupby('destination')['unique_source_count'].sum().reset_index()
            high_fanin_summary = high_fanin_summary.sort_values(by='unique_source_count', ascending=False).head(10)
            plt.figure(figsize=(12,6))
            plt.bar(high_fanin_summary['destination'], high_fanin_summary['unique_source_count'], color='salmon')
            plt.xlabel("Destination IP")
            plt.ylabel("Total Unique Source Count (10-min windows)")
            plt.title("Top 10 High Fan-in Destinations")
            plt.xticks(rotation=90)
            plt.tight_layout()
            high_fanin_graph = os.path.join(output_dir, "high_fanin.png")
            plt.savefig(high_fanin_graph, dpi=300)
            plt.close()
        else:
            print("No high fan-in destinations to plot.")

# Usage Example:
if __name__ == "__main__":
    analyzer = BehavioralAnalyzer("../network_analysis_data*.csv")
    output_file = "output_3_2.txt"
    analyzer.write_results(output_file)
    analyzer.save_graphs()  # Saves graphs to the "graphs" folder
    print(f"Behavioral analysis complete. Results saved in '{output_file}' and graphs in the 'graphs' folder.")
