import 'package:hive/hive.dart';
import 'dart:convert';

part 'request_model.g.dart';

@HiveType(typeId: 0)
class SavedRequest {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String method;

  @HiveField(2)
  final String url;

  @HiveField(3)
  final String headersJson; // Store as JSON string

  @HiveField(4)
  final String queryParamsJson; // Store as JSON string

  @HiveField(5)
  final String? body;

  @HiveField(6)
  final DateTime timestamp;

  SavedRequest({
    required this.id,
    required this.method,
    required this.url,
    required Map<String, String> headers,
    required Map<String, String> queryParams,
    this.body,
    required this.timestamp,
  }) : headersJson = jsonEncode(headers),
       queryParamsJson = jsonEncode(queryParams);

  // Constructor that directly takes the JSON strings
  // This constructor is used by Hive when reading from storage
  SavedRequest.fromJson({
    required this.id,
    required this.method,
    required this.url,
    required this.headersJson,
    required this.queryParamsJson,
    this.body,
    required this.timestamp,
  });

  // Getters to convert JSON strings back to maps
  Map<String, String> get headers => 
    Map<String, String>.from(jsonDecode(headersJson));
  
  Map<String, String> get queryParams => 
    Map<String, String>.from(jsonDecode(queryParamsJson));
  
  // Create a copy with some fields replaced
  SavedRequest copyWith({
    String? id,
    String? method,
    String? url,
    Map<String, String>? headers,
    Map<String, String>? queryParams,
    String? body,
    DateTime? timestamp,
  }) {
    return SavedRequest(
      id: id ?? this.id,
      method: method ?? this.method,
      url: url ?? this.url,
      headers: headers ?? this.headers,
      queryParams: queryParams ?? this.queryParams,
      body: body ?? this.body,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}