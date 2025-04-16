import 'package:flutter/material.dart';
import 'results_screen.dart';

class SymptomsScreen extends StatefulWidget {
  const SymptomsScreen({super.key});

  @override
  _SymptomsScreenState createState() => _SymptomsScreenState();
}

class _SymptomsScreenState extends State<SymptomsScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _symptoms = [];

  void _addSymptom(String symptom) {
    if (symptom.isNotEmpty) {
      setState(() {
        _symptoms.add(symptom);
        _controller.clear();
      });
    }
  }

  void _proceed() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResultsScreen(symptoms: _symptoms),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Enter Your Symptoms")
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              onSubmitted: _addSymptom,
              decoration: InputDecoration(
                hintText: 'Enter a symptom eg, fever, headache',
                suffixIcon: IconButton(
                  icon: Icon(Icons.add),
                  color: Colors.green,
                  onPressed: () => _addSymptom(_controller.text),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 6.0,
              children: _symptoms.map((symptom) => Chip(label: Text(symptom))).toList(),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: _proceed,
              child: Text('Check Results'),
            )
          ],
        ),
      ),
    );
  }
}
