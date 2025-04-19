import 'package:hive_flutter/hive_flutter.dart';
import '../models/request_model.dart';
import 'package:uuid/uuid.dart';

class LocalStorageService {
  final Box<SavedRequest> _requestsBox = Hive.box<SavedRequest>('requests');
  final uuid = const Uuid();

  // Get all saved requests sorted by timestamp (newest first)
  List<SavedRequest> getAllRequests() {
    final requests = _requestsBox.values.toList();
    requests.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return requests;
  }

  // Save a new request
  Future<String> saveRequest(
    String method,
    String url,
    Map<String, String> headers,
    Map<String, String> queryParams,
    String? body,
  ) async {
    final id = uuid.v4();
    final request = SavedRequest(
      id: id,
      method: method,
      url: url,
      headers: headers,
      queryParams: queryParams,
      body: body,
      timestamp: DateTime.now(),
    );
    
    await _requestsBox.put(id, request);
    return id;
  }

  // Update an existing request
  Future<void> updateRequest(SavedRequest request) async {
    await _requestsBox.put(request.id, request);
  }

  // Delete a request
  Future<void> deleteRequest(String id) async {
    await _requestsBox.delete(id);
  }

  // Get a request by ID
  SavedRequest? getRequestById(String id) {
    return _requestsBox.get(id);
  }

  // Clear all requests
  Future<void> clearAllRequests() async {
    await _requestsBox.clear();
  }
}