import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Clean white background
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0), // Nice padding all around
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20), // Space at top

              // HealthIQ Logo and Name
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.grey[300],
                    child: Icon(
                      Icons.person,
                      size: 30,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'HealthIQ',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 40),

              // Big Title
              Text(
                'Disease Prediction',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              SizedBox(height: 20),

              // Description Text
              Text(
                'Get personalized health insights based on your symptoms.',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black54,
                ),
              ),

              Spacer(),

              // Get Started Button
              SizedBox(
                width: double.infinity, // Full width button
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/signin');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Get Started',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
