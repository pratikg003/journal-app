// import 'dart:async';

// import 'package:flutter/foundation.dart';

class JournalEntry {
  final String id;
  String title;
  String content;
  final DateTime createdAt;

  JournalEntry({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory JournalEntry.fromJson(Map<String, dynamic> json) {
    return JournalEntry(
      id: json['id'],
      title: json['title'] ?? 'Untitled',
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
