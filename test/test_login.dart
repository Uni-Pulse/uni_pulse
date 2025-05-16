import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uni_pulse/Screens/organizations/org_home.dart';
import 'package:uni_pulse/Screens/users/user_home_page.dart';
import 'package:uni_pulse/Screens/initializing/login.dart';
import 'package:uni_pulse/Providers/events_provider.dart';
import 'package:uni_pulse/Models/acconts.dart';

// ----------------------------------------------
// 🔧 Mock Setup
// ----------------------------------------------

class MockAccountsNotifier extends Mock implements AccountNotifier {}

// To support null safety
class FakeBuildContext extends Fake implements BuildContext {}

void main() {
  late MockAccountsNotifier mockNotifier;

  setUpAll(() {
    registerFallbackValue(FakeBuildContext());
  });

  setUp(() {
    mockNotifier = MockAccountsNotifier();
  });

  Widget createTestWidget() {
    return ProviderScope(
      overrides: [
        accountsProvider.overrideWith((ref) => mockNotifier),
      ],
      child: MaterialApp(home: AuthScreen()),
    );
  }

  // ----------------------------------------------
  // 1️⃣ UI Renders Correctly
  // ----------------------------------------------
  testWidgets('All widgets are present', (tester) async {
    await tester.pumpWidget(createTestWidget());

    expect(find.text('Login'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.widgetWithText(ElevatedButton, 'LOGIN'), findsOneWidget);
  });

  // ----------------------------------------------
  // 2️⃣ Empty Fields Validation
  // ----------------------------------------------
  testWidgets('Show error if fields are empty', (tester) async {
    await tester.pumpWidget(createTestWidget());

    await tester.tap(find.text('LOGIN'));
    await tester.pumpAndSettle();

    expect(find.text('All fields are required.'), findsOneWidget);
  });

  // ----------------------------------------------
  // 3️⃣ Invalid Credentials
  // ----------------------------------------------
  testWidgets('Show error on invalid credentials', (tester) async {
    when(() => mockNotifier.authenticate(any(), any()))
        .thenAnswer((_) async => null);

    await tester.pumpWidget(createTestWidget());

    await tester.enterText(find.byType(TextField).at(0), 'user@example.com');
    await tester.enterText(find.byType(TextField).at(1), 'wrongpassword');
    await tester.tap(find.text('LOGIN'));
    await tester.pumpAndSettle();

    expect(find.text('Invalid credentials. Please try again.'), findsOneWidget);
  });

  // ----------------------------------------------
  // 4️⃣ Successful Login as Organisation
  testWidgets('Navigates to OrgHomePage on org login', (tester) async {
    when(() => mockNotifier.authenticate(any(), any()))
        .thenAnswer((_) async => AccountData(
          isOrganisation: true,
          userName: 'org',
          email: 'org@example.com',
          firstName: '',
          lastName: '',
          phoneNum: 0,
          dob: null,
          favouriteEvents: [],
        ));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          accountsProvider.overrideWith((ref) => mockNotifier),
        ],
        child: MaterialApp(
          home: AuthScreen(),
          routes: {
            '/org': (context) => const Scaffold(body: Text('Org Home')),
          },
        ),
      ),
    );

    await tester.enterText(find.byType(TextField).at(0), 'org@example.com');
    await tester.enterText(find.byType(TextField).at(1), 'password');
    await tester.tap(find.text('LOGIN'));
    await tester.pumpAndSettle();

    expect(find.text('Org Home'), findsOneWidget);
  });

  // ----------------------------------------------
  // 5️⃣ Successful Login as User
  testWidgets('Navigates to HomePage on user login', (tester) async {
    when(() => mockNotifier.authenticate(any(), any()))
        .thenAnswer((_) async => AccountData(
          isOrganisation: false,
          userName: 'user',
          email: 'user@example.com',
          firstName: '',
          lastName: '',
          phoneNum: 0,
          dob: null,
          favouriteEvents: [],
        ));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          accountsProvider.overrideWith((ref) => mockNotifier),
        ],
        child: MaterialApp(
          home: AuthScreen(),
          routes: {
            '/user': (context) => const Scaffold(body: Text('User Home')),
          },
        ),
      ),
    );

    await tester.enterText(find.byType(TextField).at(0), 'user@example.com');
    await tester.enterText(find.byType(TextField).at(1), 'password');
    await tester.tap(find.text('LOGIN'));
    await tester.pumpAndSettle();

    expect(find.text('User Home'), findsOneWidget);
  });

  // ----------------------------------------------
  // 6️⃣ Handle Exception Gracefully
  testWidgets('Handles exceptions and shows error dialog', (tester) async {
    when(() => mockNotifier.authenticate(any(), any()))
        .thenThrow(Exception('Some error'));

    await tester.pumpWidget(createTestWidget());

    await tester.enterText(find.byType(TextField).at(0), 'user@example.com');
    await tester.enterText(find.byType(TextField).at(1), 'password');
    await tester.tap(find.text('LOGIN'));
    await tester.pumpAndSettle();

    expect(find.text('An error occurred during login. Please try again.'), findsOneWidget);
  });
}
