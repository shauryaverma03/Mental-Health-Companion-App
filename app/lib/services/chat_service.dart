import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:saathi/services/api_helpers.dart';

class ChatService {
  Future<String> sendMessages(String userId, String message) async {
    try {
      final url = Uri.parse('https://gen-ai-g6tt.onrender.com/api/v1/chat/add');
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        'userId': userId,
        'message': message,
      });
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final responseBody = safeJsonDecode(response);
        return responseBody['botResponse'] ?? '';
      } else {
        throw BackendException('Failed to send message', statusCode: response.statusCode);
      }
    } catch (e) {
      print("Error sending messages: $e");
      rethrow;
    }
  }

  Future<List<dynamic>> getMessages(String userId, String date) async {
    return retryWithBackoff(() async {
      final url = Uri.parse(
          'https://gen-ai-g6tt.onrender.com/api/v1/chat/get/$userId/$date');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final messages = safeJsonDecode(response);
        if (messages is List) {
          return messages;
        } else {
          throw BackendException('Invalid message list format', statusCode: response.statusCode);
        }
      } else {
        throw BackendException('Failed to get messages', statusCode: response.statusCode);
      }
    });
  }
}
