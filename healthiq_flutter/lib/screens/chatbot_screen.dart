import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../model/message_model.dart';
import '../services/ai_handler.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/suggestion_widget.dart';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final TextEditingController _controller = TextEditingController();
  final AiHandler _openAi = AiHandler();
  final List<MessageModel> _messages = [];
  final List<String> _suggestions = [
    'I have a headache',
    'I feel tired all the time',
    'My stomach hurts',
    'I have a sore throat'
  ];

  bool _isTyping = false;
  bool _isListening = false;

  late stt.SpeechToText _speech;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void _sendMessage() async {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      _messages.add(MessageModel(isUser: true, message: _controller.text.trim()));
      _isTyping = true;
    });

    String userMessage = _controller.text.trim();
    _controller.clear();
    FocusScope.of(context).unfocus();

    final aiResponse = await _openAi.getResponse(userMessage);

    setState(() {
      _messages.add(MessageModel(isUser: false, message: aiResponse));
      _isTyping = false;
    });
  }

  void _onMicButtonPressed() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (status) {
          if (status == 'done') {
            setState(() => _isListening = false);
          }
        },
        onError: (error) {
          setState(() => _isListening = false);
          print('Speech recognition error: $error');
        },
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (result) {
            setState(() {
              _controller.text = result.recognizedWords;
            });
          },
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        title: Text(
          'HealthIQ ChatBot',
          style: GoogleFonts.lato(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.teal[700],
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          if (_messages.isEmpty) ...[
            const SizedBox(height: 40),
            Icon(Icons.chat_bubble_outline, size: 80, color: Colors.teal[300]),
            const SizedBox(height: 20),
            Text(
              'Hi there! 👋\nAsk me anything about your symptoms.',
              textAlign: TextAlign.center,
              style: GoogleFonts.lato(fontSize: 18, color: Colors.black87),
            ),
            const SizedBox(height: 30),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: _suggestions.map((sugg) {
                return GestureDetector(
                  onTap: () {
                    _controller.text = sugg;
                    _sendMessage();
                  },
                  child: SuggestionWidget(text: sugg),
                );
              }).toList(),
            )
          ] else ...[
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return ChatBubble(message: _messages[index]);
                },
              ),
            ),
          ],
          if (_isTyping) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.teal[100],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Text("Typing"),
                      const SizedBox(width: 6),
                      SizedBox(
                        width: 20,
                        height: 12,
                        child: Animate(
                          effects: const [FadeEffect(), ScaleEffect()],
                          child: const Row(
                            children: [
                              CircleAvatar(radius: 2.5, backgroundColor: Colors.black54),
                              SizedBox(width: 2),
                              CircleAvatar(radius: 2.5, backgroundColor: Colors.black54),
                              SizedBox(width: 2),
                              CircleAvatar(radius: 2.5, backgroundColor: Colors.black54),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ).animate().fadeIn(),
          ],
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: _controller,
                    hintText: 'Enter symptoms...',
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: _onMicButtonPressed,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isListening ? Colors.red[400] : Colors.grey[300],
                    ),
                    child: Icon(
                      _isListening ? Icons.mic : Icons.mic_none,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.teal[400],
                    ),
                    child: const Icon(Icons.send, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
