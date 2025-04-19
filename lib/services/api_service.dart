import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/request_model.dart';

class ApiResponse {
  final int statusCode;
  final Map<String, String> headers;
  final String body;
  final int timeInMs;
  final bool isSuccess;
  final String? errorMessage;

  ApiResponse({
    required this.statusCode,
    required this.headers,
    required this.body,
    required this.timeInMs,
    required this.isSuccess,
    this.errorMessage,
  });
}

class ApiService {
  Future<ApiResponse> sendRequest(SavedRequest request) async {
    final startTime = DateTime.now();
    int timeInMs = 0;
    
    try {
      // Build URI with query parameters
      final uri = Uri.parse(request.url).replace(
        queryParameters: request.queryParams.isEmpty ? null : request.queryParams,
      );

      // Prepare headers
      final headers = Map<String, String>.from(request.headers);

      // Send request based on method
      http.Response response;
      switch (request.method.toUpperCase()) {
        case 'GET':
          response = await http.get(uri, headers: headers);
          break;
        case 'POST':
          response = await http.post(uri, headers: headers, body: request.body);
          break;
        case 'PUT':
          response = await http.put(uri, headers: headers, body: request.body);
          break;
        case 'DELETE':
          response = await http.delete(uri, headers: headers);
          break;
        case 'PATCH':
          response = await http.patch(uri, headers: headers, body: request.body);
          break;
        default:
          throw Exception('Unsupported HTTP method: ${request.method}');
      }

      timeInMs = DateTime.now().difference(startTime).inMilliseconds;
      
      return ApiResponse(
        statusCode: response.statusCode,
        headers: response.headers,
        body: utf8.decode(response.bodyBytes),
        timeInMs: timeInMs,
        isSuccess: response.statusCode >= 200 && response.statusCode < 300,
      );
    } catch (e) {
      timeInMs = DateTime.now().difference(startTime).inMilliseconds;
      return ApiResponse(
        statusCode: 0,
        headers: {},
        body: '',
        timeInMs: timeInMs,
        isSuccess: false,
        errorMessage: e.toString(),
      );
    }
  }
}