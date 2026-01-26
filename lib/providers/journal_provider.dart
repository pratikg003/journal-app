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

  void addEntry(String text) {
    _entries.insert(
      0,
      JournalEntry(
        id: DateTime.now().toString(),
        content: text,
        createdAt: DateTime.now(),
      ),
    );
    _saveEntries();
    notifyListeners();
  }

  void deleteEntry(int index) {
    _entries.removeAt(index);
    _saveEntries();
    notifyListeners();
  }

  void editEntry(int index, String text) {
    _entries[index].content = text;
    _saveEntries();
    notifyListeners();
  }
}
