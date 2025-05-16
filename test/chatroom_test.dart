import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uni_pulse/Screens/users/chatroom.dart';

void main() {
    testWidgets('Chatroom widget renders correctly', (WidgetTester tester) async {
        // Build the Chatroom widget.
        await tester.pumpWidget(
            MaterialApp(
                home: ChatRoom(),
            ),
        );

        // Verify if the Chatroom widget contains expected elements.
        expect(find.byType(AppBar), findsOneWidget);
        expect(find.text('Chatroom'), findsOneWidget); // Assuming the AppBar title is 'Chatroom'.
        expect(find.byType(ListView), findsOneWidget); // Assuming messages are displayed in a ListView.
        expect(find.byType(TextField), findsOneWidget); // Assuming there's a TextField for input.
        expect(find.byType(IconButton), findsOneWidget); // Assuming there's a send button.
    });
}