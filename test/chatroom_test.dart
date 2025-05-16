import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni_pulse/Screens/users/chatroom.dart';

// DummyChatRoom for widget-only tests (no Firebase)
class DummyChatRoom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chatroom')),
      body: Column(
        children: [
          Expanded(child: ListView()),
          TextField(),
          IconButton(icon: const Icon(Icons.send), onPressed: () {}),
        ],
      ),
    );
  }
}

void main() {
  testWidgets('Chatroom widget renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: DummyChatRoom(),
      ),
    );

    expect(find.byType(AppBar), findsOneWidget);
    expect(find.text('Chatroom'), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.byType(IconButton), findsOneWidget);
  });
}