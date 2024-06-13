import pandas as pd
import os

file_path = 'cleaned_flights.csv'
data = pd.read_csv(file_path)

num_rows = len(data)
split_size = num_rows // 3

part1 = data.iloc[:split_size]
part2 = data.iloc[split_size:2*split_size]
part3 = data.iloc[2*split_size:]

output_folder = 'cleaned_flights_splits'
os.makedirs(output_folder, exist_ok=True)

part1.to_csv(os.path.join(output_folder, 'cleaned_flights_1.csv'), index=False)
part2.to_csv(os.path.join(output_folder, 'cleaned_flights_2.csv'), index=False)
part3.to_csv(os.path.join(output_folder, 'cleaned_flights_3.csv'), index=False)

print("Les fichiers ont été divisés et enregistrés avec succès dans le dossier:", output_folder)
