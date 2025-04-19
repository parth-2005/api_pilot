import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/request_model.dart';
import '../services/api_service.dart';
import '../widgets/json_pretty_viewer.dart';

class ResponseScreen extends StatefulWidget {
  final SavedRequest request;
  final ApiResponse response;

  const ResponseScreen({
    Key? key,
    required this.request,
    required this.response,
  }) : super(key: key);

  @override
  State<ResponseScreen> createState() => _ResponseScreenState();
}

class _ResponseScreenState extends State<ResponseScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Color _getStatusColor(int statusCode) {
    if (statusCode >= 200 && statusCode < 300) {
      return Colors.green;
    } else if (statusCode >= 300 && statusCode < 400) {
      return Colors.amber;
    } else if (statusCode >= 400) {
      return Colors.red;
    } else {
      return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Response'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Pretty'),
            Tab(text: 'Raw'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Response info bar
          Container(
            padding: const EdgeInsets.all(12),
            color: Theme.of(context).colorScheme.surfaceVariant,
            child: Row(
              children: [
                // Status code badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(widget.response.statusCode),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    widget.response.statusCode.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Time taken
                Text('${widget.response.timeInMs} ms'),
                const Spacer(),
                // Copy button
                IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: widget.response.body));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Response copied to clipboard')),
                    );
                  },
                  tooltip: 'Copy response',
                ),
              ],
            ),
          ),
          // Response tabs
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Pretty tab
                JsonPrettyViewer(jsonString: widget.response.body),
                
                // Raw tab
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: SelectableText(
                    widget.response.body,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 14,
                    ),
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