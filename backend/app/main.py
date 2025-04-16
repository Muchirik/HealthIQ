import traceback
from fastapi import Request
from fastapi import FastAPI
from fastapi.responses import JSONResponse
from .schemas import SymptomInput, PredictionResponse
from .model import predict_diseases

from pydantic import BaseModel

app = FastAPI()

# class SymptomInput(BaseModel):
#     symptoms: str
#
# # Simulated disease-medication-image mapping
# medication_data = {
#     "flu": {
#         "medication": "Tamiflu",
#         "dosage": "75mg twice daily for 5 days",
#         "image_url": "https://upload.wikimedia.org/wikipedia/commons/thumb/7/72/Tamiflu.JPG/320px-Tamiflu.JPG"
#     },
#     "malaria": {
#         "medication": "Coartem",
#         "dosage": "4 tablets twice daily for 3 days",
#         "image_url": "https://www.who.int/images/default-source/medicines/photo---coartem-pack-and-blisters.jpg"
#     },
#     "covid-19": {
#         "medication": "Paxlovid",
#         "dosage": "300mg nirmatrelvir + 100mg ritonavir, twice daily for 5 days",
#         "image_url": "https://www.fda.gov/files/drugs/paxlovid-tablets.png"
#     }
# }


@app.get("/")
def root():
    return {"message": "Welcome to HealthIQ API 🚀"}

@app.post("/predict", response_model=PredictionResponse)
def predict_disease(input: SymptomInput):
    try:
        prediction = predict_diseases(input)
        return prediction
    except Exception as e:
        print("Error Occurred: ", e)
        traceback.print_exc()

    return JSONResponse(
        status_code=500,
        content={"error": "Check Server logs for traceback"},
    )