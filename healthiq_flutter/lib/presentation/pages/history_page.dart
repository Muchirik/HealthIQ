import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthiq/presentation/pages/chatbot_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<List<Map<String, dynamic>>> conversations = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList('chat_history') ?? [];
    setState(() {
      conversations = history.map((jsonStr) =>
      List<Map<String, dynamic>>.from(jsonDecode(jsonStr))
      ).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chat History',
          // style: GoogleFonts.lato(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal[700],
        centerTitle: true,
      ),
      body:  conversations.isEmpty
            ? Center(
              child: Text(
                'No chat history yet.',
                style: GoogleFonts.lato(
                  fontSize: 18,
                  color: Colors.grey[600],
                ),
              ),
            )
            : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: conversations.length,
              itemBuilder: (context, index) {
                final convo = conversations[index];
                final firstUserMsg = convo.firstWhere((m) => m['isUser'], orElse: () => {'text': ''})['text'];
                final firstBotMsg = convo.firstWhere((m) =>  !m['isUser'], orElse: () => {'text': ''})['text'];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: ListTile(
                      title: Text('🧑‍⚕️You: $firstUserMsg'),
                      subtitle: Text('🤖Bot: $firstBotMsg'),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ChatbotPage(initialMessages: convo,),),);
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
