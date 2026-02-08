import 'dart:convert';

import 'package:journal_app/models/journal_entry.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JournalRepository {
  static const String _keysList = 'journal_entry_list';

  Future<List<JournalEntry>> loadAllEntries() async{
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList(_keysList) ?? [];

    List<JournalEntry> entries = [];

    for(String id in ids) {
      final entryJson = prefs.getString('entry_$id');
      if(entryJson != null) {
        entries.add(JournalEntry.fromJson(jsonDecode(entryJson)));
      }
    }

    entries.sort((a,b)=> b.createdAt.compareTo(a.createdAt));
    return entries;
  }

  Future<void> saveEntry(JournalEntry entry) async{
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('entry_${entry.id}', jsonEncode(entry.toJson()));

    List<String> ids = prefs.getStringList(_keysList) ?? [];

    if(!ids.contains(entry.id)) {
      ids.add(entry.id);
      await prefs.setStringList(_keysList, ids);
    }
  }

  Future<void> deleteEntry(String id) async{
    final prefs = await SharedPreferences.getInstance();

    prefs.remove('entry_$id');

    List<String> ids = prefs.getStringList(_keysList) ?? [];
    ids.remove(id);
    await prefs.setStringList(_keysList, ids);
  }
}