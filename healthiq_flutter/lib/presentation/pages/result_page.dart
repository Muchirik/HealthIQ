import 'package:flutter/material.dart';

class ResultsPage extends StatelessWidget {
  final String disease;
  final double confidence;
  final List<String> matchedSymptoms;
  final String explanation;
  final List<String> medication;
  final List<String> recommendations;

  const ResultsPage({
    super.key,
    required this.disease,
    required this.confidence,
    required this.matchedSymptoms,
    required this.explanation,
    required this.medication,
    required this.recommendations,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HealthIQ Diagnosis Result'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Predicted Disease'),
            _buildCard(disease, icon: Icons.local_hospital, color: Colors.teal[300]!),

            const SizedBox(height: 20),

            _buildSectionTitle('Confidence'),
            _buildCard('${(confidence * 100).toStringAsFixed(2)}%', icon: Icons.trending_up, color: Colors.green),

            const SizedBox(height: 20),

            _buildSectionTitle('Matched Symptoms'),
            _buildListCard(matchedSymptoms, icon: Icons.check_circle_outline),

            const SizedBox(height: 20),

            _buildSectionTitle('Explanation'),
            _buildCard(explanation, icon: Icons.info_outline, color: Colors.blue),

            const SizedBox(height: 20),

            _buildSectionTitle('Recommended Medication'),
            _buildListCard(medication, icon: Icons.medical_services),

            const SizedBox(height: 20),

            _buildSectionTitle('Health Recommendations'),
            _buildListCard(recommendations, icon: Icons.health_and_safety),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildCard(String text, {required IconData icon, required Color color}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color,
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(fontSize: 18, color: Colors.black87),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListCard(List<String> items, {required IconData icon}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: items.isEmpty
            ? const Text('None reported.', style: TextStyle(fontSize: 16, color: Colors.black54))
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: items.map((item) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Icon(icon, size: 20, color: Colors.teal),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    item,
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ),
              ],
            ),
          )).toList(),
        ),
      ),
    );
  }
}
