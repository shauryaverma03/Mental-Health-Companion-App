import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class BackendException implements Exception {
  final String message;
  final int? statusCode;

  BackendException(this.message, {this.statusCode});

  @override
  String toString() => 'BackendException: $message (status: $statusCode)';
}

bool isJsonResponse(http.Response response) {
  final contentType = response.headers['content-type'] ?? '';
  return contentType.contains('application/json');
}

dynamic safeJsonDecode(http.Response response) {
  if (!isJsonResponse(response)) {
    throw BackendException(
      'Server returned invalid response format (not JSON).',
      statusCode: response.statusCode,
    );
  }
  try {
    return jsonDecode(response.body);
  } catch (e) {
    throw BackendException(
      'Failed to parse server response.',
      statusCode: response.statusCode,
    );
  }
}

Future<T> retryWithBackoff<T>(
  Future<T> Function() action, {
  int maxRetries = 2,
  Duration initialDelay = const Duration(seconds: 2),
}) async {
  int retries = 0;
  Duration delay = initialDelay;
  while (true) {
    try {
      return await action();
    } catch (e) {
      if (retries >= maxRetries) {
        rethrow;
      }
      retries++;
      await Future.delayed(delay);
      delay *= 2;
    }
  }
}
