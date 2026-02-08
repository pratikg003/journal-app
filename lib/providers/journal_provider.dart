import 'package:flutter/material.dart';
import 'package:journal_app/models/journal_entry.dart';
import 'package:journal_app/repositories/journal_repository.dart';

class JournalProvider extends ChangeNotifier {
  final JournalRepository _repository;

  List<JournalEntry> _entries = [];
  bool _isLoading = false;
  String? _error;

  JournalProvider({required JournalRepository repository})
    : _repository = repository;

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
      _entries = await _repository.loadAllEntries();
    } catch (_) {
      _error = "Failed to load journal entries";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addEntry({
    required String title,
    required String content,
    DateTime? date,
  }) async {
    final newEntry = JournalEntry(
      id: DateTime.now().toString(),
      title: title,
      content: content,
      createdAt: date ?? DateTime.now(),
    );

    _entries.insert(0, newEntry);
    notifyListeners();

    await _repository.saveEntry(newEntry);
  }

  Future<void> editEntry(String id, String title, String content) async {
    final index = _entries.indexWhere((e) => e.id == id);
    if (index == -1) return;
    _entries[index].title = title;
    _entries[index].content = content;
    notifyListeners();

    await _repository.saveEntry(_entries[index]);
  }

  Future<void> deleteEntry(String id) async {
    _entries.removeWhere((e) => e.id == id);
    notifyListeners();

    await _repository.deleteEntry(id);
  }

  JournalEntry? getEntryById(String id) {
    try {
      return _entries.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }
}
