import os

# Define the input CSV file
input_csv_file = 'weather.csv'

# Define the output folder for the split files
output_folder = 'weather_splitted_files'

# Define the number of parts to split the file into
num_parts = 8  # Change this to 8 for 8 parts

# Create the output folder if it doesn't exist
os.makedirs(output_folder, exist_ok=True)

# Open the input CSV file for reading
with open(input_csv_file, 'r') as input_file:
    # Read the header line from the input file
    header = input_file.readline()

    # Calculate the approximate number of lines per part
    total_lines = sum(1 for line in input_file)
    lines_per_part = total_lines // num_parts

    # Reset the input file pointer to the beginning
    input_file.seek(0)

    # Split the input file into multiple parts
    for part_num in range(num_parts):
        # Create the output file for the current part
        output_file = os.path.join(output_folder, f'part{part_num + 1}.csv')

        # Open the output file for writing
        with open(output_file, 'w') as output:
            # Write the header line to the output file
            output.write(header)

            # Write the lines for the current part to the output file
            for line_num in range(lines_per_part):
                line = input_file.readline()
                if not line:
                    break
                output.write(line)

print(f'Successfully split {input_csv_file} into {num_parts} parts in the {output_folder} folder.')
