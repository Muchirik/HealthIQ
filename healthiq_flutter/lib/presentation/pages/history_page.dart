import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HistoryPage extends StatelessWidget {
  HistoryPage({super.key});

  final List<Map<String, String>> history = [
    {'user': 'I have a headache', 'bot': 'It might be due to dehydration or stress.'},
    {'user': 'I feel tired all the time', 'bot': 'You might want to check your iron levels or sleep quality.'},
    {'user': 'My stomach hurts', 'bot': 'Could be indigestion or something more serious.'},
    // Add more mock history here or fetch from storage/db.
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chat History',
          style: GoogleFonts.lato(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal[700],
        centerTitle: true,
      ),
      body: history.isEmpty
          ? Center(
        child: Text(
          'No chat history yet.',
          style: GoogleFonts.lato(fontSize: 18, color: Colors.grey[600]),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: history.length,
        itemBuilder: (context, index) {
          final item = history[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('🧑‍⚕️ You: ${item['user']}', style: GoogleFonts.lato(fontSize: 16)),
                  const SizedBox(height: 8),
                  Text('🤖 Bot: ${item['bot']}', style: GoogleFonts.lato(fontSize: 15, color: Colors.teal[800])),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
