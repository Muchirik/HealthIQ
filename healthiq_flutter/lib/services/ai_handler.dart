import 'dart:convert';
import 'package:http/http.dart' as http;

class AiHandler {
  final String _apiUrl = 'http://localhost:8000/predict';

  Future<String> getResponse(String message) async {
    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'message': message}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['response'] ?? 'Sorry, I couldn\'t understand that.';
      } else {
        return 'Failed to get response from server. Please try again later.';
      }
    } catch (e) {
      return 'Error occurred: $e';
    }
  }
}
