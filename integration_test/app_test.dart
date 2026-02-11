import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:journal_app/main.dart' as app;

void main() {
  // 1. Initialize the binding (Required for physical/emulated devices)
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('End-to-End Test', () {
    testWidgets('Create a new journal entry and verify it appears',
        (tester) async {
      // 2. Launch the App
      app.main();
      
      // Wait for the app to settle (animations, loading data)
      await tester.pumpAndSettle();

      // 3. Find the "Add" button and tap it
      final fab = find.byKey(const Key('add_entry_fab'));
      await tester.tap(fab);
      
      // Wait for the BottomSheet to slide up
      await tester.pumpAndSettle();

      // 4. Enter Text
      await tester.enterText(find.byKey(const Key('title_field')), 'Robot Entry');
      await tester.enterText(find.byKey(const Key('content_field')), 'Beep Boop. Testing is fun.');
      
      // Close keyboard (sometimes necessary to see the button)
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      // 5. Tap Save
      await tester.tap(find.byKey(const Key('save_button')));
      
      // Wait for BottomSheet to close and list to update
      await tester.pumpAndSettle();

      // 6. Verification (Did it work?)
      // Look for the text "Robot Entry" on the screen
      expect(find.text('Robot Entry'), findsOneWidget);
    });
  });
}