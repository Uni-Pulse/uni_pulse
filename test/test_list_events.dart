import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni_pulse/Screens/users/list_events.dart';
import 'package:uni_pulse/Providers/events_provider.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uni_pulse/Models/events.dart';

class MockEventsNotifier extends Mock implements EventNotifier {}

void main() {
  testWidgets('ListEvents displays search bar and empty state', (WidgetTester tester) async {
    final mockNotifier = MockEventsNotifier();
    final container = ProviderContainer(overrides: [
      eventsProvider.overrideWith((ref) => mockNotifier),
  
    ]);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: ListEvents(),
        ),
      ),
    );

    // Should show search bar
    expect(find.byType(TextField), findsOneWidget);
    // Should show empty state if no events
    expect(find.text('No events found.'), findsOneWidget);
  });

  testWidgets('ListEvents displays a list of events and allows tapping', (WidgetTester tester) async {
    // Mock event data
    final mockNotifier = MockEventsNotifier();
    final mockEvents = [
     
      EventData(
        eventName: 'Event 1',
        organisation: 'Org',
        date: DateTime(2025, 5, 16),
        ticketPrice: '10',
        eventType: EventType.other,
        description: 'Description 1',
        eventId: 'WDPEJAPamCSWcdhscidnsuWXLDLM',
      ),
      EventData(
        eventName: 'Event 2',
        organisation: 'Org',
        date: DateTime(2025, 5, 17),
        ticketPrice: '20',
        eventType: EventType.other,
        description: 'Description 2',
        eventId: 'WsejlvnruiCKSJBWLslcj',
      ),
    ];
    when(() => mockNotifier.state).thenReturn(mockEvents);
    final container = ProviderContainer(overrides: [
      eventsProvider.overrideWith((ref) => mockNotifier),
    ]);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: ListEvents(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Should show both event names
    expect(find.text('Event 1'), findsOneWidget);
    expect(find.text('Event 2'), findsOneWidget);

    // Tap on the first event (simulate navigation)
    await tester.tap(find.text('Event 1'));
   
  });

  testWidgets('ListEvents filters events by search', (WidgetTester tester) async {
    final mockNotifier = MockEventsNotifier();
    final mockEvents = [
      EventData(
        eventName: 'Alpha Event',
        organisation: 'Org',
        date: DateTime(2025, 5, 16),
        ticketPrice: '10',
        eventType: EventType.other,
        description: 'Description 1',
        eventId: 'id3',
      ),
      EventData(
        eventName: 'Beta Event',
        organisation: 'Org',
        date: DateTime(2025, 5, 17),
        ticketPrice: '20',
        eventType: EventType.other,
        description: 'Description 2',
        eventId: 'id4',
      ),
    ];
    when(() => mockNotifier.state).thenReturn(mockEvents);
    final container = ProviderContainer(overrides: [
      eventsProvider.overrideWith((ref) => mockNotifier),
    ]);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: ListEvents(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Enter search text
    await tester.enterText(find.byType(TextField), 'Alpha');
    await tester.pumpAndSettle();

    // Only 'Alpha Event' should be visible
    expect(find.text('Alpha Event'), findsOneWidget);
    expect(find.text('Beta Event'), findsNothing);
  });
}
