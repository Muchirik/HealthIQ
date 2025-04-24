import 'package:flutter/material.dart';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final List<String> tips = [
    "Drink at least 8 cups of water daily.",
    "Stretch your body for five minutes every hour.",
    "Get 7-8 hours of sleep.",
    "Avoid too much processed sugars",
    "Eat a healthy diet",
    "Wash your hands regularly",
    "Get 30 minutes of exercise daily",
    "Limit alcohol consumption",
    "Eat more fruits and vegetables",
    "Take short screen breaks to rest your eyes",
    "Avoid smoking",
    "Change your clothes",
    "Avoid alot of junk food",
  ];

  final username = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final String dailyTip = tips[Random().nextInt(tips.length)];

    return Scaffold(
      appBar: AppBar(
         title: const Text('HealthIQ'),
         backgroundColor: Colors.teal,
         actions: [
           IconButton(
             icon: const Icon(Icons.notifications_none),
             onPressed: () {},
           ),
         ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text (
              "Hello, $username 👋",
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Here's your tip for the day:",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  dailyTip,
                  style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                ),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/chatbot');
              },
              icon: Icon(Icons.chat_bubble_outline),
              label: Text("Chat with HealthIQ"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),

            //placeholder for future elements like chatbot and symptom checker
            const Text(
              "Quick Actions",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildActionButton(Icons.healing, "Symptoms"),
                _buildActionButton(Icons.chat, "Chatbot"),
                _buildActionButton(Icons.medication, "Medication"),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.teal.shade100,
          radius: 28,
          child: Icon(icon, size: 30, color: Colors.teal.shade900),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 14)
        ),
      ],
    );
  }
}