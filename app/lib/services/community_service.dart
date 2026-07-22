import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:saathi/services/api_helpers.dart';

class CommunityService {
  Future<void> createCommunityMessage(String userId, String message) async {
    try {
      final url =
          Uri.parse('https://gen-ai-g6tt.onrender.com/api/v1/community/create');
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        'userId': userId,
        'message': message,
      });
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        print('Message created');
      } else {
        throw BackendException('Failed to create message', statusCode: response.statusCode);
      }
    } catch (e) {
      print("Error creating messages: $e");
      rethrow;
    }
  }

  Future<void> addComment(String userId, String comment) async {
    try {
      final url = Uri.parse(
          'https://gen-ai-g6tt.onrender.com/api/v1/community/addComment/$userId');
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        'userId': userId,
        'comment': comment,
      });
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        print('comment sent');
      } else {
        throw BackendException('Failed to send comment', statusCode: response.statusCode);
      }
    } catch (e) {
      print("Error sending comment: $e");
      rethrow;
    }
  }

  Future<List<dynamic>> getCommunityMessages() async {
    return retryWithBackoff(() async {
      final url =
          Uri.parse('https://gen-ai-g6tt.onrender.com/api/v1/community/get');
      final headers = {'Content-Type': 'application/json'};
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final messages = safeJsonDecode(response);
        if (messages is List) {
          return messages;
        } else {
          throw BackendException('Invalid community messages format', statusCode: response.statusCode);
        }
      } else {
        throw BackendException('Failed to get message', statusCode: response.statusCode);
      }
    });
  }

  Future<List<dynamic>> getCommunityMessagesById(String userId) async {
    return retryWithBackoff(() async {
      final url = Uri.parse(
          'https://gen-ai-g6tt.onrender.com/api/v1/community/get/$userId');
      final headers = {'Content-Type': 'application/json'};
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final messages = safeJsonDecode(response);
        if (messages is List) {
          return messages;
        } else {
          throw BackendException('Invalid community messages format', statusCode: response.statusCode);
        }
      } else {
        throw BackendException('Failed to get message', statusCode: response.statusCode);
      }
    });
  }

  Future<void> reportPost(String postId, String reason, String details) async {
    try {
      await FirebaseFirestore.instance.collection('reports').add({
        'postId': postId,
        'reason': reason,
        'details': details,
        'timestamp': FieldValue.serverTimestamp(),
      });
      print('Post reported successfully');
    } catch (e) {
      print('Error reporting post: $e');
      rethrow;
    }
  }
}
