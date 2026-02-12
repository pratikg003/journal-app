import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:journal_app/models/journal_entry.dart';
import 'package:journal_app/widgets/journal_entry_card.dart';

void main() {
  testWidgets('JournalEntryCard golden test', (WidgetTester tester) async {
    // 1. Arrange: Create data and the widget
    final testEntry = JournalEntry(
      id: '1',
      title: 'Golden Test Day',
      content: 'Testing pixels is fun',
      createdAt: DateTime(2026, 2, 9),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: JournalEntryCard(
              entry: testEntry,
              onTap: () {},
            ),
          ),
        ),
      ),
    );

    // 2. Act & Assert: Match against the golden file
    await expectLater(
      find.byType(JournalEntryCard),
      matchesGoldenFile('goldens/journal_entry_card.png'),
    );
  }, tags: 'golden');
}