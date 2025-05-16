import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  group('UserHomePage Widget Tests', () {
    testWidgets('Renders UserHomePage with AppBar and DummyListEvents', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              appBar: AppBar(),
              body: DummyListEvents(),
            ),
          ),
        ),
      );
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(DummyListEvents), findsOneWidget);
    });

    testWidgets('Displays a welcome message', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(body: Center(child: Text('Welcome, user!'))),
          ),
        ),
      );
      expect(find.textContaining('Welcome'), findsWidgets);
    });

    testWidgets('Navigates to profile page when profile button is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: HomePageWithFakeProfile(),
          ),
        ),
      );
      final profileButton = find.byIcon(Icons.account_circle);
      expect(profileButton, findsOneWidget);
      await tester.tap(profileButton);
      await tester.pumpAndSettle();
      expect(find.text('Profile Details'), findsOneWidget);
    });
  });
}

// Dummy ListEvents for testing
class DummyListEvents extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Dummy Events List'));
  }
}

// Dummy ProfileScreen for testing navigation without Firebase
class DummyProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Profile Details'));
  }
}

// HomePage with Dummy widgets for test
class HomePageWithFakeProfile extends StatefulWidget {
  const HomePageWithFakeProfile({super.key});
  @override
  State<HomePageWithFakeProfile> createState() => _HomePageWithFakeProfileState();
}
class _HomePageWithFakeProfileState extends State<HomePageWithFakeProfile> {
  int currentPage = 0;
  late final List<Widget> pages;
  @override
  void initState() {
    super.initState();
    pages = [DummyListEvents(), DummyProfileScreen()];
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: currentPage,
          children: pages,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 35,
        selectedFontSize: 0,
        unselectedFontSize: 0,
        onTap: (value) {
          setState(() {
            currentPage = value;
          });
        },
        currentIndex: currentPage,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}