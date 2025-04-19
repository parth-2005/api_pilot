import 'package:flutter/material.dart';

class KeyValueEditor extends StatefulWidget {
  final Map<String, String> initialData;
  final Function(Map<String, String>) onChanged;
  final String title;
  final IconData icon;

  const KeyValueEditor({
    Key? key,
    required this.initialData,
    required this.onChanged,
    required this.title,
    required this.icon,
  }) : super(key: key);

  @override
  State<KeyValueEditor> createState() => _KeyValueEditorState();
}

class _KeyValueEditorState extends State<KeyValueEditor> {
  late List<MapEntry<String, String>> _entries;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _entries = widget.initialData.entries.toList();
    // Always have an empty row at the end
    if (_entries.isEmpty) {
      _entries.add(const MapEntry('', ''));
    }
  }

  void _updateMap() {
    // Filter out empty key entries
    final validEntries = _entries.where((e) => e.key.isNotEmpty).toList();
    final map = Map<String, String>.fromEntries(validEntries);
    widget.onChanged(map);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ExpansionTile(
        leading: Icon(widget.icon),
        title: Text(widget.title),
        subtitle: Text('${widget.initialData.length} items'),
        initiallyExpanded: _isExpanded,
        onExpansionChanged: (expanded) {
          setState(() {
            _isExpanded = expanded;
          });
        },
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _entries.length,
            itemBuilder: (context, index) {
              return _buildKeyValueRow(index);
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _entries.add(const MapEntry('', ''));
                });
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.add),
                  SizedBox(width: 8),
                  Text('Add Item'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyValueRow(int index) {
    final entry = _entries[index];
    final keyController = TextEditingController(text: entry.key);
    final valueController = TextEditingController(text: entry.value);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: keyController,
              decoration: const InputDecoration(
                hintText: 'Key',
                isDense: true,
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _entries[index] = MapEntry(value, _entries[index].value);
                _updateMap();
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: valueController,
              decoration: const InputDecoration(
                hintText: 'Value',
                isDense: true,
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _entries[index] = MapEntry(_entries[index].key, value);
                _updateMap();
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              if (_entries.length > 1) {
                setState(() {
                  _entries.removeAt(index);
                  _updateMap();
                });
              } else {
                // If this is the last entry, just clear it
                setState(() {
                  _entries[index] = const MapEntry('', '');
                  _updateMap();
                });
              }
            },
          ),
        ],
      ),
    );
  }
}