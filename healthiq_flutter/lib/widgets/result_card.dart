import 'package:flutter/material.dart';

class ResultCard extends StatelessWidget {
  final String disease;
  final double confidence;

  const ResultCard({super.key, required this.disease, required this.confidence});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(Icons.medical_services_outlined, color: Colors.green),
        title: Text(disease),
        subtitle: Text("Confidence: ${(confidence * 100).toStringAsFixed(1)}%"),
      ),
    );
  }
}
