import 'dart:math';

class PredictionService {
  final _random = Random();

  // Mock prediction logic based on symptoms
  Future<List<Map<String, dynamic>>> predictDiseases(List<String> symptoms) async {
    await Future.delayed(Duration(seconds: 2)); // Simulate network delay

    // Mock disease predictions
    List<Map<String, dynamic>> predictions = [
      {"disease": "Common Cold", "confidence": _random.nextDouble()},
      {"disease": "Flu", "confidence": _random.nextDouble()},
      {"disease": "Malaria", "confidence": _random.nextDouble()},
      {"disease": "Pneumonia", "confidence": _random.nextDouble()},
      {"disease": "Typhoid", "confidence": _random.nextDouble()},
    ];

    predictions.shuffle();
    predictions = predictions.take(3).toList(); // return top 3

    return predictions;
  }

  // Mock medication suggestions
  Future<List<Map<String, String>>> getMedications(String disease) async {
    await Future.delayed(Duration(seconds: 1)); // Simulate delay

    return [
      {
        "name": "Med-${disease.substring(0, 3).toUpperCase()}",
        "dosage": "1 tablet twice a day",
        "imageUrl": "https://unsplash.com/photos/white-and-blue-medication-pill-blister-pack-jwWtZrm67VI"
      },
      {
        "name": "Heal-${disease.substring(0, 2).toUpperCase()}",
        "dosage": "5ml syrup once a day",
        "imageUrl": "https://unsplash.com/photos/white-and-blue-medication-pill-blister-pack-jwWtZrm67VI"
      },
    ];
  }
}
