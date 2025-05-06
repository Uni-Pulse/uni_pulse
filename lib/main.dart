import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni_pulse/Screens/initializing/start_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:uni_pulse/Providers/events_provider.dart';



var colorScheme = ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 68, 1, 254),
            primary: const Color.fromARGB(255, 94, 1, 254),
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
      home: const SplashScreen(),
      theme : lightTheme,
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
