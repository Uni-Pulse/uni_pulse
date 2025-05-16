import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni_pulse/Screens/organizations/add_event.dart';
import 'package:uni_pulse/Providers/events_provider.dart';
import 'package:mocktail/mocktail.dart';

class MockEventsNotifier extends Mock implements EventNotifier {}

void main() {
  late MockEventsNotifier mockEventsNotifier;

  setUp(() {
    mockEventsNotifier = MockEventsNotifier();
  });

  Widget createTestWidget() {
    return ProviderScope(
      overrides: [
        eventsProvider.overrideWith((ref) => mockEventsNotifier),
      ],
      child: const MaterialApp(
        home: AddEventScreen(),
      ),
    );
  }

  testWidgets('AddEventScreen UI renders and validates required fields', (tester) async {
    await tester.pumpWidget(createTestWidget());

    // All main input fields should be present
    expect(find.byType(TextField), findsNWidgets(3)); // Title, Description, Ticket Price
    expect(find.text('Add Event'), findsOneWidget);

    // Try to save without filling required fields
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    expect(find.text('Please fill in all required fields.'), findsOneWidget);
  });

  testWidgets('AddEventScreen saves event with valid input', (tester) async {
    when(() => mockEventsNotifier.addEvent(any(), any(), any(), any(), any(), any())).thenAnswer((_) async => 'eventId');

    await tester.pumpWidget(createTestWidget());

    // Enter event title
    await tester.enterText(find.byType(TextField).at(0), 'Test Event');
    // Enter event description
    await tester.enterText(find.byType(TextField).at(1), 'A test event description');
    // Enter ticket price
    await tester.enterText(find.byType(TextField).at(2), '10');

    // Pick a date
    await tester.tap(find.byIcon(Icons.calendar_month));
    await tester.pumpAndSettle();
    // Select the first available date
    await tester.tap(find.text('${DateTime.now().day}'));
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    // Tap the save button
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    // Should pop the screen (no error shown)
    expect(find.text('Please fill in all required fields.'), findsNothing);
    verify(() => mockEventsNotifier.addEvent(any(), any(), any(), any(), any(), any())).called(1);
  });
}
