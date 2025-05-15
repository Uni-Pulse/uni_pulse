import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni_pulse/Screens/initializing/start_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:uni_pulse/Providers/events_provider.dart';

final colorSchemeLight = ColorScheme.fromSwatch(
  primarySwatch: Colors.deepPurple,
  backgroundColor: const Color.fromARGB(
      255, 159, 145, 192), // slightly purple-tinted background
  accentColor: Colors.deepPurpleAccent,
  cardColor: const Color.fromARGB(255, 204, 162, 229),
  errorColor: Colors.red,
).copyWith(
  surface:
      const Color.fromARGB(255, 220, 199, 254), // override surface color here
);

final colorSchemeDark = ColorScheme.fromSwatch(
  primarySwatch: Colors.deepPurple,
  backgroundColor: const Color.fromARGB(
      255, 159, 145, 192), // slightly purple-tinted background
  accentColor: Colors.deepPurpleAccent,
  cardColor: const Color.fromARGB(255, 86, 63, 100),
  errorColor: Colors.red,
).copyWith(
  surface:
      const Color.fromARGB(255, 72, 42, 73), // override surface color here
);

final lightTheme = ThemeData(
  colorScheme: colorSchemeLight,
  useMaterial3: true,
  scaffoldBackgroundColor: colorSchemeLight.surface,
  appBarTheme: AppBarTheme(
    backgroundColor: colorSchemeLight.primary,
    foregroundColor: colorSchemeLight.onPrimary,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: colorSchemeLight.primary,
    selectedItemColor: colorSchemeLight.onPrimary,
    unselectedItemColor: colorSchemeLight.onSurface,
  ),
  textTheme: const TextTheme(
    titleLarge: TextStyle(
      fontSize: 30.0,
      color: Colors.black,
    ),
    bodyLarge: TextStyle(fontSize: 16.0, color: Colors.white),
    bodyMedium: TextStyle(fontSize: 14.0, color: Colors.white),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: colorSchemeLight.primary,
      foregroundColor: colorSchemeLight.onPrimary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  ),
  iconTheme: const IconThemeData(
    color: Colors.deepPurple, // Set your desired icon color                // Optional: set a default icon size
  ),
   iconButtonTheme: IconButtonThemeData(
    style: ButtonStyle(
      iconColor: WidgetStateProperty.all(Colors.deepPurple),
      backgroundColor: WidgetStateProperty.all(Colors.transparent),
      overlayColor: WidgetStateProperty.all(Colors.deepPurple.withOpacity(0.1)),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: Colors.deepPurple),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: Colors.deepPurple),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
  ),
  labelStyle: const TextStyle(
    color: Color.fromARGB(255, 1, 1, 1),
    fontWeight: FontWeight.normal,
  ),
  hintStyle: const TextStyle(
    color: Color.fromARGB(255, 34, 27, 27),
    fontStyle: FontStyle.italic,
  ),
  fillColor: const Color.fromARGB(255, 192, 184, 184), // or colorScheme.surface for dark mode
  filled: true,
  prefixIconColor: Colors.deepPurple, 
  suffixIconColor: Colors.deepPurple, 
),
);

final darkTheme = ThemeData(
  colorScheme: colorSchemeDark,
  useMaterial3: true,
  scaffoldBackgroundColor: colorSchemeDark.surface,
  appBarTheme: AppBarTheme(
    backgroundColor: const Color.fromARGB(255, 48, 31, 48),
    foregroundColor: colorSchemeDark.onSurface,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: const Color.fromARGB(255, 48, 31, 48),
    selectedItemColor: Colors.white,
    unselectedItemColor: const Color.fromARGB(255, 148, 114, 148),
  ),
  textTheme: const TextTheme(
    titleLarge: TextStyle(
      fontSize: 30.0,
      color: Colors.white,
    ),
    bodyLarge: TextStyle(fontSize: 21.0, color: Colors.white),
    bodyMedium: TextStyle(fontSize: 14.0, color: Colors.white),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color.fromARGB(255, 48, 31, 48),
      foregroundColor: const Color.fromARGB(255, 48, 31, 48),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  ),
  iconTheme: const IconThemeData(
    color: Colors.white, // Set your desired icon color              // Optional: set a default icon size
  ),
  iconButtonTheme: IconButtonThemeData(
    style: ButtonStyle(
      iconColor: WidgetStateProperty.all(Colors.white),
      backgroundColor: WidgetStateProperty.all(Colors.transparent),
      overlayColor: WidgetStateProperty.all(Colors.white.withOpacity(0.1)),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: Colors.white),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: Colors.white),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: Colors.white, width: 2),
  ),
  labelStyle: const TextStyle(
    color: Color.fromARGB(255, 254, 254, 255),
    fontWeight: FontWeight.normal,
  ),
  hintStyle: const TextStyle(
    color: Color.fromARGB(255, 227, 222, 222),
    fontStyle: FontStyle.italic,
  ),
  fillColor: colorSchemeDark.surface, // or colorScheme.surface for dark mode
  filled: true,
  prefixIconColor: Colors.white, 
  suffixIconColor: Colors.white, 
),
);

// final lightTheme = ThemeData().copyWith(colorScheme: colorScheme,);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyBHvPpaJ90VcO7airwkpx84hmj6GrXNtXI",
            authDomain: "unipulse-2c41a.firebaseapp.com",
            projectId: "unipulse-2c41a",
            storageBucket: "unipulse-2c41a.firebasestorage.app",
            messagingSenderId: "922789382300",
            appId: "1:922789382300:web:390b709a317241a9b78559",
            measurementId: "G-RHZ5MRV9CF"));
  } catch (e) {
    debugPrint('Error initializing $e');
  }

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // 👈 This hides the DEBUG banner
      home: const SplashScreen(),
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system, // Use system theme mode
    );
  }
}

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: _initializeApp(ref),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return const StartScreen();
        }
      },
    );
  }

  Future<void> _initializeApp(WidgetRef ref) async {
    await ref.read(accountsProvider.notifier).fetchUsers();
    await ref.read(eventsProvider.notifier).fetchEvents();
  }
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Provider(
//       create: (context) => 'hello',
//       child: MaterialApp(
//         title: 'UniPulse',
//         theme: ThemeData(
//           fontFamily: 'Moderustic',
//           colorScheme: ColorScheme.fromSeed(
//             seedColor: const Color.fromARGB(255, 68, 1, 254),
//             primary: const Color.fromARGB(255, 94, 1, 254),
//           ),
//           appBarTheme: const AppBarTheme(
//             titleTextStyle: TextStyle(
//               fontSize: 20,
//               color: Colors.black,
//             ),
//           ),
//           inputDecorationTheme: const InputDecorationTheme(
//             hintStyle: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 16,
//             ),
//             prefixIconColor: Color.fromRGBO(119, 119, 119, 1),
//           ),
//           textTheme: const TextTheme(
//             titleLarge: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 35,
//             ),
//             titleMedium: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 20,
//             ),
//             bodySmall: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 16,
//             ),
//           ),
//           useMaterial3: true,
//         ),

//         home: const HomePage(),
//       ),
//     );
//   }
// }
