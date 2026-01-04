import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:journal_app/models/journal_entry.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _entryController = TextEditingController();
  List<JournalEntry> entries = [];

  void _newEntry() {
    final text = _entryController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      entries.insert(
        0,
        JournalEntry(
          id: DateTime.now().toString(),
          content: text,
          createdAt: DateTime.now(),
        ),
      );
      _saveEntries();
    });

    _entryController.clear();
    Navigator.pop(context);
  }

  Future<void> _saveEntries() async {
    final prefs = await SharedPreferences.getInstance();

    final entryList = entries
        .map((entry) => jsonEncode(entry.toJson()))
        .toList();

    await prefs.setStringList('journal_entries', entryList);
  }

  Future<void> _loadEntries() async {
    final prefs = await SharedPreferences.getInstance();

    final List<String>? savedEntries = prefs.getStringList('journal_entries');

    if (savedEntries == null) return;
    setState(() {
      entries = savedEntries
          .map((entryString) => JournalEntry.fromJson(jsonDecode(entryString)))
          .toList();
    });
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      body: SafeArea(
        child: Column(
          children: [
            Material(
              elevation: 7.0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                color: Colors.teal,
                // decoration: BoxDecoration(
                //   color: Colors.teal[400]
                // ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Journal',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      // color: Colors.white,
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_month,
                            size: 28,
                            color: Colors.white,
                          ),
                          SizedBox(width: 20),
                          IconButton(
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.blueGrey[800],
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20),
                                  ),
                                ),
                                builder: (context) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                      left: 20,
                                      right: 20,
                                      top: 20,
                                      bottom:
                                          MediaQuery.of(
                                            context,
                                          ).viewInsets.bottom +
                                          20,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'New Entry',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 15),
                                        TextField(
                                          controller: _entryController,
                                          maxLines: 6,
                                          decoration: InputDecoration(
                                            hintText: 'Write your thoughts...',
                                            hintStyle: TextStyle(
                                              color: Colors.white54,
                                            ),
                                            filled: true,
                                            fillColor: Colors.blueGrey[700],
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: BorderSide.none,
                                            ),
                                          ),
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        const SizedBox(height: 15),
                                        ElevatedButton(
                                          onPressed: _newEntry,
                                          child: const Text('Save'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },

                            icon: Icon(
                              Icons.add,
                              size: 28,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: entries.isEmpty
                  ? Center(
                      child: Text(
                        'No entries yet.\nStart writing today.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white70, fontSize: 18),
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      itemCount: entries.length,
                      itemBuilder: (context, index) {
                        final entry = entries[index];

                        return Container(
                          margin: EdgeInsets.only(bottom: 12),
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blueGrey[800],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                entry.content,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                _formatDate(entry.createdAt),
                                style: TextStyle(
                                  color: Colors.white54,
                                  fontSize: 12
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
