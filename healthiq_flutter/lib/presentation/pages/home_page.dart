import 'package:flutter/material.dart';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

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

  // final username = FirebaseAuth.instance.currentUser;
  final username = 'Ken';
  @override
  Widget build(BuildContext context) {
    final String dailyTip = tips[Random().nextInt(tips.length)];

    return Scaffold(
      appBar: AppBar(
         title: const Text('HealthIQ'),
         titleTextStyle: const TextStyle(
           color: Colors.white54,
           fontSize: 24,
           fontWeight: FontWeight.bold,
         ),
         backgroundColor: Colors.teal,
         actions: [
           IconButton(
             icon: const Icon(Icons.notifications_none, color: Colors.white54,),
             onPressed: () {
               Navigator.pushNamed(context, '/home');
             },
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
              "Here's your health tip for the day:",
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  dailyTip,
                  style: const TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: LinearGradient(
                      colors: [
                        Colors.teal.shade300,
                        Colors.teal.shade500,
                        Colors.teal.shade700,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                  ),
                ),
              child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                      'How are You Feeling Today?',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10,),
                      Text(
                        'Describe your symptoms to get a preliminary diagnosis.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white60,
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton.icon(
                          label: Text('Talk to HealthIQ 🤖'),
                          onPressed: () {
                            Navigator.pushNamed(context, '/chatbot');
                          },
                        icon: Icon(Icons.chat_bubble_outline),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.teal,
                          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),)
                        ),
                    ],
                  ),
                ),
              ),
            ),
            // ElevatedButton.icon(
            //   onPressed: () {
            //     Navigator.pushNamed(context, '/chatbot');
            //   },
            //   icon: Icon(Icons.chat_bubble_outline),
            //   label: Text("Chat with HealthIQ 🤖"),
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: Colors.teal,
            //     foregroundColor: Colors.white,
            //     padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            //   ),
            // ),

            //placeholder for future elements like chatbot and symptom checker
            const SizedBox(height: 5),
            const Text(
              "Quick Actions",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildActionButton(Icons.history, "History"),
                _buildActionButton(Icons.local_hospital, "AI Diagnosis"),
                _buildActionButton(Icons.medication, "Medication"),
              ],
            ),
            const SizedBox(height: 40,),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/history');
              },
              icon: Icon(Icons.history_edu_outlined),
              label: Text("Checkout Your Medical History 📜"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal.shade200,
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
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