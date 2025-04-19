import 'dart:convert';
import 'package:flutter/material.dart';

class JsonPrettyViewer extends StatelessWidget {
  final String jsonString;
  final bool enableCopy;

  const JsonPrettyViewer({
    Key? key,
    required this.jsonString,
    this.enableCopy = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (jsonString.isEmpty) {
      return const Center(child: Text('No content to display'));
    }

    try {
      // Try to parse the JSON to validate it
      final dynamic parsedJson = json.decode(jsonString);
      final prettyString = const JsonEncoder.withIndent('  ').convert(parsedJson);
      
      return Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: SelectableText(
              prettyString,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 14,
              ),
            ),
          ),
          if (enableCopy)
            Positioned(
              top: 8,
              right: 8,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(16),
                color: Theme.of(context).colorScheme.surface,
                child: IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: () {
                    _copyToClipboard(context, prettyString);
                  },
                  tooltip: 'Copy to clipboard',
                ),
              ),
            ),
        ],
      );
    } catch (e) {
      // If not valid JSON, just show as plain text
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: SelectableText(
          jsonString,
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 14,
          ),
        ),
      );
    }
  }

  void _copyToClipboard(BuildContext context, String text) {
    // Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copied to clipboard')),
    );
  }
}