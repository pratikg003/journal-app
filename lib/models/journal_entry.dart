// import 'dart:async';

// import 'package:flutter/foundation.dart';

class JournalEntry {
  final String id;
  String content;
  final DateTime createdAt;

  JournalEntry({
    required this.id,
    required this.content,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory JournalEntry.fromJson(Map<String, dynamic> json) {
    return JournalEntry(
      id: json['id'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
