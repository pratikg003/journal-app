import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:journal_app/models/journal_entry.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JournalProvider extends ChangeNotifier {
  List<JournalEntry> _entries = [];
  bool _isLoading = false;
  String? _error;

  List<JournalEntry> get entries => _entries;
  bool get isLoading => _isLoading;
  String? get error => _error;

  int get totalEntries => _entries.length;

  int entriesThisWeek() {
    final now = DateTime.now();
    return _entries.where((e) {
      final diff = now.difference(e.createdAt).inDays;
      return diff >= 0 && diff < 7;
    }).length;
  }

  Set<DateTime> get entryDates {
    return _entries.map((e) {
      return DateTime(e.createdAt.year, e.createdAt.month, e.createdAt.day);
    }).toSet();
  }

  List<JournalEntry> entriesForDate(DateTime date) {
    return _entries.where((entry) {
      return entry.createdAt.year == date.year &&
          entry.createdAt.month == date.month &&
          entry.createdAt.day == date.day;
    }).toList();
  }

  Future<void> loadEntries() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getStringList('journal_entries');

      if (saved == null) return;

      _entries = saved
          .map((e) => JournalEntry.fromJson(jsonDecode(e)))
          .toList();
    } catch (_) {
      _error = "Failed to load journal entries.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _saveEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final list = _entries.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList('journal_entries', list);
  }

  void addEntry({required String title, required String content}) {
    _entries.insert(
      0,
      JournalEntry(
        id: DateTime.now().toString(),
        title: title,
        content: content,
        createdAt: DateTime.now(),
      ),
    );
    _saveEntries();
    notifyListeners();
  }

  void deleteEntry(String id) {
    _entries.removeWhere((e) => e.id == id);
    _saveEntries();
    notifyListeners();
  }

  void editEntry(String id, String title, String content) {
    final index = _entries.indexWhere((e) => e.id == id);
    if (index == -1) return;
    _entries[index].title = title;
    _entries[index].content = content;
    _saveEntries();
    notifyListeners();
  }

  JournalEntry? getEntryById(String id) {
    try {
      return _entries.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }
}
