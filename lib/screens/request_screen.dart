import 'package:flutter/material.dart';
import '../models/request_model.dart';
import '../services/api_service.dart';
import '../services/local_storage_service.dart';
import '../widgets/key_value_editor.dart';
import 'response_screen.dart';
import 'package:uuid/uuid.dart';

class RequestScreen extends StatefulWidget {
  final SavedRequest? existingRequest;

  const RequestScreen({Key? key, this.existingRequest}) : super(key: key);

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  final _apiService = ApiService();
  final _storageService = LocalStorageService();
  final _urlController = TextEditingController();
  final _bodyController = TextEditingController();
  
  String _selectedMethod = 'GET';
  Map<String, String> _headers = {};
  Map<String, String> _queryParams = {};
  bool _isLoading = false;
  
  final _methodOptions = ['GET', 'POST', 'PUT', 'DELETE', 'PATCH', 'HEAD'];

  @override
  void initState() {
    super.initState();
    if (widget.existingRequest != null) {
      _loadExistingRequest();
    }
  }

  void _loadExistingRequest() {
    final request = widget.existingRequest!;
    _selectedMethod = request.method;
    _urlController.text = request.url;
    _headers = Map<String, String>.from(request.headers);
    _queryParams = Map<String, String>.from(request.queryParams);
    if (request.body != null) {
      _bodyController.text = request.body!;
    }
  }

  Future<void> _sendRequest() async {
    if (_urlController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a URL')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Create a temporary request for the API call
      final tempRequest = SavedRequest(
        id: const Uuid().v4(),
        method: _selectedMethod,
        url: _urlController.text,
        headers: _headers,
        queryParams: _queryParams,
        body: _bodyController.text.isNotEmpty ? _bodyController.text : null,
        timestamp: DateTime.now(),
      );

      final response = await _apiService.sendRequest(tempRequest);

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResponseScreen(
            request: tempRequest,
            response: response,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _saveRequest() async {
    if (_urlController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a URL')),
      );
      return;
    }

    try {
      if (widget.existingRequest != null) {
        // Update existing request
        final updatedRequest = SavedRequest(
          id: widget.existingRequest!.id,
          method: _selectedMethod,
          url: _urlController.text,
          headers: _headers,
          queryParams: _queryParams,
          body: _bodyController.text.isNotEmpty ? _bodyController.text : null,
          timestamp: DateTime.now(),
        );
        await _storageService.updateRequest(updatedRequest);
      } else {
        // Create new request
        await _storageService.saveRequest(
          _selectedMethod,
          _urlController.text,
          _headers,
          _queryParams,
          _bodyController.text.isNotEmpty ? _bodyController.text : null,
        );
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Request saved successfully')),
      );
      
      // If it's a new request, go back to the home screen
      if (widget.existingRequest == null) {
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving request: ${e.toString()}')),
      );
    }
  }

  @override
  void dispose() {
    _urlController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingRequest != null ? 'Edit Request' : 'New Request'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveRequest,
            tooltip: 'Save Request',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Method & URL row
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedMethod,
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _selectedMethod = value;
                                });
                              }
                            },
                            items: _methodOptions.map((method) {
                              return DropdownMenuItem(
                                value: method,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(method),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _urlController,
                          decoration: const InputDecoration(
                            hintText: 'https://api.example.com/v1/resource',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Headers
                  KeyValueEditor(
                    initialData: _headers,
                    onChanged: (value) {
                      _headers = value;
                    },
                    title: 'Headers',
                    icon: Icons.view_headline,
                  ),

                  // Query Parameters
                  KeyValueEditor(
                    initialData: _queryParams,
                    onChanged: (value) {
                      _queryParams = value;
                    },
                    title: 'Query Parameters',
                    icon: Icons.help_outline,
                  ),

                  // Request Body (only for POST, PUT, PATCH)
                  if (['POST', 'PUT', 'PATCH'].contains(_selectedMethod))
                    Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.code),
                                const SizedBox(width: 8),
                                Text(
                                  'Request Body',
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _bodyController,
                              maxLines: 8,
                              decoration: const InputDecoration(
                                hintText: '{\n  "key": "value"\n}',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.all(16),
                              ),
                              style: const TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  const SizedBox(height: 16),
// Send button
                  ElevatedButton.icon(
                    onPressed: _sendRequest,
                    icon: const Icon(Icons.send),
                    label: const Text('Send Request'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}