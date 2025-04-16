import 'package:flutter/material.dart';

class MedicationScreen extends StatelessWidget {
  const MedicationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Recommended Medication")),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            child: ListTile(
              leading: Icon(Icons.medical_services),
              title: Text("Paracetamol 500mg"),
              subtitle: Text("Take 1 tablet every 6 hours for pain/fever"),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.medical_services),
              title: Text("Cough Syrup"),
              subtitle: Text("2 teaspoons twice a day after meals"),
            ),
          ),
          // Add AI-recommended medications dynamically later
        ],
      ),
    );
  }
}
