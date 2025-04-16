import joblib
import numpy as np
import tensorflow as tf
from pathlib import Path

# Load model and encoders once
BASE_DIR = Path(__file__).resolve().parent
model = tf.keras.models.load_model(BASE_DIR / "model_files" / "healthiq_disease_model.h5")

mlb = joblib.load(BASE_DIR / "model_files" / "symptom_encoder.pkl")
print("Symptom encoder classes:", mlb.classes_)
severity_enc = joblib.load(BASE_DIR / "model_files" / "severity_encoder.pkl")
duration_enc = joblib.load(BASE_DIR / "model_files" / "duration_encoder.pkl")
history_enc = joblib.load(BASE_DIR / "model_files" / "history_encoder.pkl")
disease_enc = joblib.load(BASE_DIR / "model_files" / "disease_encoder.pkl")
symptom_disease_map = joblib.load(BASE_DIR / "model_files" / "symptom_disease_map.pkl")


# Ensure "no prior conditions" is in the history encoder classes
if "no prior conditions" not in history_enc.classes_:
    updated_classes = np.sort(np.append(history_enc.classes_, "no prior conditions"))
    history_enc.classes_ = updated_classes

def predict_diseases(data):
    #encode inputs
    symptoms = mlb.transform([data.symptoms])
    severity = severity_enc.transform([data.severity])
    duration = duration_enc.transform([data.duration])
    history = history_enc.transform([data.history])

    #combine all input features
    input_data = np.column_stack((symptoms, severity, duration, history))

    #make prediction
    prediction = model.predict(input_data)[0]
    disease_idx = np.argmax(prediction)
    confidence = float(np.max(prediction))
    disease = disease_enc.inverse_transform([disease_idx])[0]

    #explanation: Match user symptoms with typical  symptoms of the predicted disease
    matched_symptoms = []
    possible_symptoms = symptom_disease_map.get(disease, [])
    for symptom in data.symptoms:
        if symptom in possible_symptoms:
            matched_symptoms.append(symptom)

    explanation = (
        f"You are probably suffering from {disease} because your reported symptoms "
        f"{', '.join(matched_symptoms) if matched_symptoms else  'did not match any specific pattern'}"
        f"are commonly associated with this condition."
    )

    return {
        "disease": disease,
        "confidence": confidence,
        "explanation": explanation,
        "matched_symptoms": matched_symptoms,
        "medication": ["consult your doctor for the correct meds"],
        "recommendations": ["Get Rest", "Hydrate", "Monitor Symptoms"]
    }
