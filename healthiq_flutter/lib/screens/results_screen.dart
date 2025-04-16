import 'package:flutter/material.dart';
import '../services/prediction_service.dart';
import '../widgets/result_card.dart';
import '../widgets/medication_card.dart';

class ResultsScreen extends StatefulWidget {
  final List<String> symptoms;

  const ResultsScreen({super.key, required this.symptoms});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  final PredictionService _predictionService = PredictionService();
  List<Map<String, dynamic>> _predictions = [];
  List<Map<String, String>> _medications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPredictions();
  }

  Future<void> _fetchPredictions() async {
    final predictions = await _predictionService.predictDiseases(widget.symptoms);

    final topDisease = predictions[0]['disease'];
    final medications = await _predictionService.getMedications(topDisease);

    setState(() {
      _predictions = predictions;
      _medications = medications;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Results")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text("Predicted Diseases", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ..._predictions.map((prediction) => ResultCard(
              disease: prediction['disease'],
              confidence: prediction['confidence'],
            )),
            const SizedBox(height: 20),
            const Text("Recommended Medications", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ..._medications.map((med) => MedicationCard(
              name: med['name']!,
              dosage: med['dosage']!,
              imageUrl: med['imageUrl']!,
            )),
          ],
        ),
      ),
    );
  }
}
