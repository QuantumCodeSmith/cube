import os
import pandas as pd
import matplotlib.pyplot as plt


def process_file(file_path):
    try:
        # Open the file in read mode
        with open(file_path, 'r') as file:
            # Read all lines from the file
            lines = file.readlines()

            # Check if the file has at least 6 lines (to ensure there are enough lines to delete)
            if len(lines) >= 6:
                # Delete the first two and last four lines
                processed_lines = lines[2:-4]

                # Extract two columns of floats
                data = [list(map(float, line.strip().split())) for line in processed_lines]

                # Create a Pandas DataFrame
                df = pd.DataFrame(data, columns=['Wavelength', 'Count'])
                df.name = os.path.splitext(os.path.basename(file_path))[0]  # Assigning DataFrame name based on the file name

                return df

            else:
                print(f"File '{file_path}' does not have enough lines to process.")
                return None

    except FileNotFoundError:
        print(f"Error: File '{file_path}' not found.")
        return None

def process_files_in_folder(folder_path):
    # List all files in the folder
    files = [f for f in os.listdir(folder_path) if os.path.isfile(os.path.join(folder_path, f))]

    # List to store DataFrames
    white = []

    # Process each file with "white" in the name
    for file_name in files:
        if "white" in file_name.lower():
            file_path = os.path.join(folder_path, file_name)

            # Process the file
            df = process_file(file_path)

            # Append the DataFrame to the 'white' list
            if df is not None:
                white.append(df)
                print(f"Processed file '{file_name}' and appended to the 'white' list.")

    return white

def merge_and_save(white_list, output_file_path):
    # Merge DataFrames based on the 'Wavelength' column
    combined_df = pd.DataFrame(columns=['Wavelength', 'Count'])

    for df in white_list:
        if combined_df.empty:
            combined_df = df
        else:
            combined_df = pd.merge(combined_df, df, on='Wavelength', how='outer', suffixes=('', '_'+df.name))

    # Calculate SNR for each wavelength
    means = combined_df.filter(like='Count').mean(axis=1)
    stds = combined_df.filter(like='Count').std(axis=1)
    combined_df['SNR'] = means / stds

    # Add columns for means and standard deviations
    combined_df['Mean'] = means
    combined_df['Std'] = stds

    # Save the merged DataFrame to a new CSV file
    combined_df.to_csv(output_file_path, index=False)

    print(f"Merged DataFrame with SNR, Means, and Stds saved to '{output_file_path}'.")

    return combined_df


def plot_snr_graph(dataframe):
    plt.figure(figsize=(10, 6))
    plt.plot(dataframe['Wavelength'], dataframe['SNR'], marker='o', linestyle='-', color='b')
    plt.axhline(y=dataframe['SNR'].mean(), color='r', linestyle='--', label=f'Average SNR: {dataframe["SNR"].mean():.2f}')  # Horizontal dashed line at the average SNR with label
    plt.title('SNR vs Wavelength')
    plt.xlabel('Wavelength')
    plt.ylabel('SNR')
    plt.ylim(0, 130)  # Set y-axis range from 0 to 30
    plt.legend()
    plt.grid(True)
    plt.savefig("/Users/kasik2/Documents/Lipstick_Sunscreen Images/Lipstick 1/SNR.png", bbox_inches='tight')

    plt.show()

def plot_std_comparison(file1, file2):
    try:
        # Read CSV files into Pandas DataFrames
        df1 = pd.read_csv(file1)
        df2 = pd.read_csv(file2)

        # Extract 'Wavelength' and 'Std' columns from each DataFrame
        wavelength1, std1 = df1['Wavelength'], df1['Mean']
        wavelength2, std2 = df2['Wavelength'], df2['Mean']

        # Plot 'Std' columns against 'Wavelength' for each CSV file with labels
        plt.figure(figsize=(10, 6))
        plt.plot(wavelength1, std1, marker='o', linestyle='-', color='b', label='White')
        plt.plot(wavelength2, std2, marker='o', linestyle='-', color='r', label='Dark')

        plt.title('Comparison of Mean for each Wavelength 2 lights 4.0F')
        plt.xlabel('Wavelength')
        plt.ylabel('Mean')
        plt.legend()
        plt.grid(True)
        plt.show()

    except FileNotFoundError as e:
        print(f"Error: {e}")


# Replace "your_folder_path" with the actual folder path
white_list = process_files_in_folder("/Users/kasik2/Documents/Lipstick_Sunscreen Images/Lipstick 1")

# Replace "output_merged.csv" with the desired output file path
merged_df = merge_and_save(white_list, "/Users/kasik2/Documents/2_27 and 3_1 Camera Session/2 lights/white.csv")

plot_snr_graph(white)


