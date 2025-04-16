import 'package:flutter/material.dart';
import 'symptoms_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(title: Text('HealthIQ')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (_) => SymptomsScreen(),
            ));
          },
          child: Text('Start Symptom Check'),
        ),
      ),
    );
  }
}
