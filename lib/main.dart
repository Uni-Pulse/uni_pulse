import 'package:flutter/material.dart';
import 'package:uni_pulse/Screens/start_screen.dart';
import 'package:firebase_core/firebase_core.dart';


var colorScheme = ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 68, 1, 254),
            primary: const Color.fromARGB(255, 94, 1, 254),
          );

final lightTheme = ThemeData().copyWith(colorScheme: colorScheme,);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
   const MyApp({super.key});

@override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const StartScreen(),
      theme : lightTheme,
    );
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
