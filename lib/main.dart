import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni_pulse/Screens/initializing/start_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:uni_pulse/Providers/events_provider.dart';


final colorSchemeLight = ColorScheme.fromSwatch(
  primarySwatch: Colors.deepPurple,
  backgroundColor: const Color.fromARGB(255, 159, 145, 192), // slightly purple-tinted background
  accentColor: Colors.deepPurpleAccent,
  cardColor: const Color.fromARGB(255, 204, 162, 229),
  errorColor: Colors.red,
).copyWith(
  surface: const Color.fromARGB(255, 220, 199, 254), // override surface color here
);

final colorSchemeDark = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 63, 5, 238),
  brightness: Brightness.dark,
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
    bodyLarge: TextStyle(fontSize: 16.0),
    bodyMedium: TextStyle(fontSize: 14.0),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: colorSchemeLight.primary,
      foregroundColor: colorSchemeLight.onPrimary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    filled: true,
    fillColor: colorSchemeLight.surface,
  ),
);

final darkTheme = ThemeData(
  colorScheme: colorSchemeDark,
  useMaterial3: true,
  scaffoldBackgroundColor: colorSchemeDark.surface,
  appBarTheme: AppBarTheme(
    backgroundColor: colorSchemeLight.primary,
    foregroundColor: colorSchemeDark.onSurface,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: colorSchemeLight.primary, 
    selectedItemColor: colorSchemeDark.primary,
    unselectedItemColor: colorSchemeDark.onSurface,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(fontSize: 16.0),
    bodyMedium: TextStyle(fontSize: 14.0),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: colorSchemeDark.primary,
      foregroundColor: colorSchemeDark.onPrimary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    filled: true,
    fillColor: colorSchemeDark.surface,
  ),
);

final lightTheme = ThemeData().copyWith(colorScheme: colorScheme,);



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try{
  await Firebase.initializeApp(
    options:const FirebaseOptions(
  apiKey: "AIzaSyBHvPpaJ90VcO7airwkpx84hmj6GrXNtXI",
  authDomain: "unipulse-2c41a.firebaseapp.com",
  projectId: "unipulse-2c41a",
  storageBucket: "unipulse-2c41a.firebasestorage.app",
  messagingSenderId: "922789382300",
  appId: "1:922789382300:web:390b709a317241a9b78559",
  measurementId: "G-RHZ5MRV9CF"
    )
  ); } catch (e) {debugPrint ('Error initializing $e');} 

  runApp(const ProviderScope(child:MyApp()));

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

@override
  Widget build(BuildContext context) {
    return MaterialApp(
       debugShowCheckedModeBanner: false, // 👈 This hides the DEBUG banner
      home: const SplashScreen(),
      theme : lightTheme,
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
