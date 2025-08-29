// Dart imports
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final TextEditingController _controller = TextEditingController();
  final List<_Message> _messages = [];
  bool _awaitingFullResults = false;
  Map<String, dynamic>? _latestPrediction;
  int _conversationStep = 0; // Tracks which follow-up question to ask next
  // if you are using a phone that is in the same network as your backend server, use the local IP address of your machine
  // e.g., 192.168.x.x
  // final Uri backendUrl = Uri.parse('http://192.168.100.11:8000/predict');
  // if you are using an emulator, use the following address
  // final Uri backendUrl = Uri.parse('http://10.0.2.2:8000/predict');
  // if you are using a physical device, use the local IP address of your machine
  // final Uri backendUrl = Uri.parse('http://YOUR_PCs_LOCAL_IP:8000/predict');
  // if you are using web, use localhost
  final Uri backendUrl = Uri.parse('http://localhost:8000/predict');
  @override
  void initState() {
    super.initState();
    // Show welcome message when chatbot opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _addBotMessage(
        "Hi! I'm HealthIQ you personal AI health assistant 🤖. How are you feeling today?",
      );
    });
  }

  void _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(_Message(text, isUser: true));
    });

    _controller.clear();

    if (_awaitingFullResults) {
      _handleBotResponse(text);
      return;
    }

    if (_handleBasicConversation(text.toLowerCase())) return;

    // Step-by-step guided conversation
    if (_conversationStep == 0) {
      _addBotMessage("Got it. How long have you been experiencing this?");
      _conversationStep = 1;
      return;
    } else if (_conversationStep == 1) {
      _addBotMessage(
        "Thanks. On a scale of mild, moderate, or severe — how bad are the symptoms?",
      );
      _conversationStep = 2;
      return;
    } else if (_conversationStep == 2) {
      _addBotMessage(
        "Okay. Any known medical conditions or history I should know about?",
      );
      _conversationStep = 3;
      return;
    } else if (_conversationStep == 3) {
      _addBotMessage(
        "Thanks for the info. Give me a moment while I analyze your symptoms...",
      );
      _conversationStep = 4;
    }

    try {
      final symptoms = _extractSymptoms(_messages.map((m) => m.text).join(" "));

      if (symptoms.isEmpty) {
        _addBotMessage(
          "Sorry, I couldn't detect clear symptoms. Could you describe it differently?",
        );
        return;
      }

      final response = await http.post(
        backendUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "symptoms": symptoms,
          "severity": "moderate",
          "duration": "3 days",
          "history": "no prior conditions",
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _latestPrediction = data;

        _addBotMessage(
          "Based on your symptoms, you might have *${data['disease']}*.",
        );
        _addBotMessage(
          "Would you like to see full details? (Yes/No)",
          isAskingForResults: true,
        );
        _awaitingFullResults = true;
      } else {
        _addBotMessage("Sorry, something went wrong. Please try again.");
      }
    } catch (e) {
      _addBotMessage("An error occurred. Please check your connection.");
    }
  }

  void _addBotMessage(String text, {bool isAskingForResults = false}) {
    setState(() {
      _messages.add(
        _Message(text, isUser: false, isAskingForResults: isAskingForResults),
      );
    });
  }

  bool _handleBasicConversation(String text) {
    if (text.contains("hello") ||
        text.contains("hi") ||
        text.contains("hey") ||
        text.contains("yo") ||
        text.contains("what's up")) {
      _addBotMessage("Hello! 👋 How are you feeling today?");
      return true;
    } else if (text.contains("thank you") || text.contains("thanks")) {
      _addBotMessage("You're welcome! 🌟");
      return true;
    } else if (text.contains("how are you")) {
      _addBotMessage("I'm doing great! 🤖 How can I help you today?");
      return true;
    }
    return false;
  }

  List<String> _extractSymptoms(String text) {
    final knownSymptoms = [
      "fever",
      "cough",
      "headache",
      "vomiting",
      "flu",
      "fatigue",
      "diarrhea",
      "dizziness",
      "rash",
      "sore throat",
      "runny nose",
      "chills",
      "nausea",
      "muscle pain",
    ];
    List<String> found = [];
    for (var symptom in knownSymptoms) {
      if (text.toLowerCase().contains(symptom)) {
        found.add(symptom);
      }
    }
    return found;
  }

  void _handleBotResponse(String userChoice) {
    if (userChoice.toLowerCase() == "yes" && _latestPrediction != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultsPage(prediction: _latestPrediction!),
        ),
      );
    } else {
      _addBotMessage("Alright! Let me know if you need anything else.");
    }
    _awaitingFullResults = false;
    _conversationStep = 0;
  }


  Future<void> _saveConversation() async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList('chat_history') ?? [];
    // save as JSON string
    final conversation = jsonEncode(_messages.map((m) => {
      'text': m.text,
      'isUser': m.isUser,
    }).toList());
    history.add(conversation);
    await prefs.setStringList('chat_history', history);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Conversation saved to history')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('HealthIQ Chatbot'),
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return Align(
                    alignment:
                        message.isUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!message.isUser)
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: CircleAvatar(
                              radius: 18,
                              backgroundColor: Colors.teal.shade200,
                              child: const Icon(
                                Icons.smart_toy,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        Flexible(
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color:
                                  message.isUser
                                      ? Colors.teal
                                      : Colors.grey[300],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              message.text,
                              style: TextStyle(
                                color:
                                    message.isUser
                                        ? Colors.white
                                        : Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Divider(height: 1),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText:
                            _awaitingFullResults
                                ? "Type 'Yes' or 'No'"
                                : "Describe your symptoms...",
                        filled: true,
                        fillColor: Colors.grey[100],
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: Colors.teal,
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Message {
  final String text;
  final bool isUser;
  final bool isAskingForResults;

  _Message(this.text, {required this.isUser, this.isAskingForResults = false});
}

class ResultsPage extends StatelessWidget {
  final Map<String, dynamic> prediction;

  const ResultsPage({super.key, required this.prediction});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diagnosis Details'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Disease: ${prediction['disease']}",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Confidence: ${(prediction['confidence'] * 100).toStringAsFixed(2)}%",
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),
                Text(
                  "Medication Recommendations:",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ...List.generate((prediction['medication'] as List).length, (
                  index,
                ) {
                  return Text(
                    "- ${prediction['medication'][index]}",
                    style: const TextStyle(fontSize: 16),
                  );
                }),
                const SizedBox(height: 20),
                Text(
                  "Self Care Tips:",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ...List.generate(
                  (prediction['recommendations'] as List).length,
                  (index) {
                    return Text(
                      "- ${prediction['recommendations'][index]}",
                      style: const TextStyle(fontSize: 16),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
