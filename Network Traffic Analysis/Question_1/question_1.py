import pandas as pd
import helper as hp
# List of CSV files
csv_files = [
    "../network_analysis_data1.csv",
    "../network_analysis_data2.csv",
    "../network_analysis_data3.csv",
    "../network_analysis_data4.csv",
    "../network_analysis_data5.csv",
    "../network_analysis_data6.csv"
]
# csv_files = ["../network_analysis_data1.csv"]
# Open output file
with open("output_1.txt", "w") as outfile:
    # Process each file individually
    for csv_file in csv_files:
        df = pd.read_csv(csv_file)
        stats = hp.compute_stats(df, csv_file)
        outfile.write(stats)

    # Now combine all files and compute statistics
    combined_df = pd.concat([pd.read_csv(f) for f in csv_files], ignore_index=True)
    combined_stats = hp.compute_stats(combined_df, "All Combined Files")

    outfile.write("\n" + ("#"*20) + " COMBINED FILES " + ("#"*20) + "\n")
    outfile.write(combined_stats)

    # Final remark
    outfile.write("Remark: All outputs above correspond to Question 1 of the assignment.\n")