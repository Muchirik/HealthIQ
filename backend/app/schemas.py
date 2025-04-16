from pydantic import BaseModel
from typing import List

class SymptomInput(BaseModel):
    symptoms: List[str]
    severity: str
    duration: str
    history: str

    class Config:
        schema_extra = {
            "example": {
                "symptoms": ["fever", "cough"],
                "severity": "moderate",
                "duration": "3 days",
                "history": "no prior conditions"
            }
        }

class PredictionResponse(BaseModel):
    disease: str
    confidence: float
    medication: List[str]
    recommendations: List[str]

    class Config:
        schema_extra = {
            "example": {
                "disease": "flu",
                "confidence": 0.88,
                "medication": ["Paracetamol"],
                "recommendations": ["Rest", "Drink fluids", "Take Paracetamol"]
            }
        }
