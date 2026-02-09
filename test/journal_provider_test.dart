import 'package:flutter_test/flutter_test.dart';
import 'package:journal_app/models/journal_entry.dart';
import 'package:journal_app/providers/journal_provider.dart';
import 'package:journal_app/repositories/journal_repository.dart';

// 1. THE MOCK
// We create a fake version of the repository.
// It implements the real class but doesn't touch SharedPreferences.
class MockJournalRepository implements JournalRepository {
  final List<JournalEntry> _fakeStorage = [];

  @override
  Future<List<JournalEntry>> loadAllEntries() async {
    return _fakeStorage;
  }

  @override
  Future<void> saveEntry(JournalEntry entry) async {
    // Instead of saving to disk, we just update our fake list
    // If it exists, remove old version first
    _fakeStorage.removeWhere((e) => e.id == entry.id);
    _fakeStorage.add(entry);
  }

  @override
  Future<void> deleteEntry(String id) async {
    _fakeStorage.removeWhere((e) => e.id == id);
  }
}

void main() {
  late JournalProvider provider;
  late MockJournalRepository mockRepo;

  // This runs before EVERY single test
  setUp(() {
    mockRepo = MockJournalRepository();
    provider = JournalProvider(repository: mockRepo);
  });

  group('JournalProvider Tests', () {
    test('Initial state should be empty', () {
      expect(provider.entries.length, 0);
      expect(provider.isLoading, false);
    });

    test('addEntry should update state and call repository', () async {
      // Act
      await provider.addEntry(title: 'Test Day 54', content: 'Unit Testing is cool');

      // Assert (Check the Provider state)
      expect(provider.entries.length, 1);
      expect(provider.entries.first.title, 'Test Day 54');

      // Assert (Check the Mock Repository - did it actually save?)
      final savedData = await mockRepo.loadAllEntries();
      expect(savedData.length, 1);
      expect(savedData.first.title, 'Test Day 54');
    });

    test('deleteEntry should remove item from state and repository', () async {
      // Arrange (Seed with one item)
      await provider.addEntry(title: 'To Delete', content: 'Bye bye');
      final idToDelete = provider.entries.first.id;

      // Act
      await provider.deleteEntry(idToDelete);

      // Assert
      expect(provider.entries.length, 0);
      
      final savedData = await mockRepo.loadAllEntries();
      expect(savedData.length, 0);
    });
  });
}