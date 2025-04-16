import pandas as pd
import joblib
from collections import defaultdict

# Load the dataset
df = pd.read_csv("model_files/realistic_clean_synthetic_disease_data_50k.csv")

# Create the symptom-to-disease map
symptom_disease_map = defaultdict(set)

# Build mapping
for _, row in df.iterrows():
    symptoms = row["symptoms"].split(", ")
    disease = row["disease"]
    for symptom in symptoms:
        symptom_disease_map[symptom].add(disease)

# Convert sets to lists for saving
symptom_disease_map = {symptom: list(diseases) for symptom, diseases in symptom_disease_map.items()}

# Save the mapping as a .pkl file
joblib.dump(symptom_disease_map, "model_files/symptom_disease_map.pkl")

print("✅ symptom_disease_map.pkl generated successfully.")
