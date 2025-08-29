import 'package:flutter/material.dart';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final List<String> tips = [
    "Drink at least 8 cups of water daily.",
    "Stretch your body for five minutes every hour.",
    "Get 7-8 hours of sleep everyday.",
    "Avoid too much processed sugars",
    "Eat a healthy balanced diet",
    "Wash your hands regularly",
    "Get 30 minutes of exercise daily",
    "Limit alcohol consumption",
    "Eat more fruits and vegetables",
    "Take short screen breaks to rest your eyes",
    "Avoid smoking. Its bad for your lungs!",
    "Change your clothes everyday.",
    "Avoid eating too much junk food",
  ];

  final List<Map<String, String>> blogPosts = [
    {
      'title': '5 Tips for a Healthier Lifestyle',
      'excerpt': 'Discover simple changes you can make to improve your overall health...',
      'date': 'Mar 15, 2024',
    },
    {
      'title': 'Understanding Mental Health',
      'excerpt': 'Learn about the importance of mental well-being and how to maintain it...',
      'date': 'Mar 14, 2024',
    },
    {
      'title': 'Benefits of Morning Exercise',
      'excerpt': 'Find out how starting your day with physical activity boosts productivity...',
      'date': 'Mar 13, 2024',
    },
  ];

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    final String dailyTip = tips[Random().nextInt(tips.length)];
    final user = FirebaseAuth.instance.currentUser;
    final username = user?.displayName ?? user?.email ?? "Friend";

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
            icon: const Icon(Icons.notifications_none, color: Colors.white54),
            onPressed: () => Navigator.pushNamed(context, '/notifications'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${_getGreeting()}, $username 👋",
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
              _buildHealthAssistantCard(context),
              const SizedBox(height: 30),
              const Text(
                "Quick Actions",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildActionButton(
                    Icons.local_hospital,
                    "AI Diagnosis",
                    onPressed: () => Navigator.pushNamed(context, '/chatbot'),
                  ),
                  _buildActionButton(
                    Icons.medication,
                    "Medication",
                    onPressed: () => Navigator.pushNamed(context, '/medication'),
                  ),
                  _buildActionButton(
                    Icons.history,
                    "History",
                    onPressed: () => Navigator.pushNamed(context, '/history'),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Text(
                "Today's Health Metrics",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildMetricCard("Steps", "8,432", Icons.directions_walk),
                  _buildMetricCard("Heart Rate", "72 BPM", Icons.favorite_border),
                  _buildMetricCard("Calories", "1,200", Icons.local_fire_department),
                ],
              ),
              const SizedBox(height: 30),
              const Text(
                "Latest Health Blogs",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 200,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: blogPosts.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 12),
                  itemBuilder: (context, index) => _buildBlogPostCard(blogPosts[index]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHealthAssistantCard(BuildContext context) {
    return Card(
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
              const Text(
                'How are You Feeling Today?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Describe your symptoms to get a preliminary diagnosis.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                label: const Text('Talk to HealthIQ 🤖'),
                onPressed: () => Navigator.pushNamed(context, '/chatbot'),
                icon: const Icon(Icons.chat_bubble_outline),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, {required VoidCallback onPressed}) {
    return Column(
      children: [
        InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(30),
          child: CircleAvatar(
            backgroundColor: Colors.teal.shade100,
            radius: 28,
            child: Icon(icon, size: 30, color: Colors.teal.shade900),
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, size: 30, color: Colors.teal),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(title, style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
          ],
        ),
      ),
    );
  }

  Widget _buildBlogPostCard(Map<String, String> post) {
    return SizedBox(
      width: 280,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post['title']!,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                post['date']!,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
              const SizedBox(height: 12),
              Text(
                post['excerpt']!,
                style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  onPressed: () {}, // Add navigation to blog detail
                  child: const Text('Read More →'),
                  style: TextButton.styleFrom(foregroundColor: Colors.teal.shade700),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}