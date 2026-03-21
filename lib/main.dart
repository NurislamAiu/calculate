import 'package:example/auth_gate.dart';
import 'package:example/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Define the main color
    const Color mainBrown = Color(0xFF79573C);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Food Delivery',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: mainBrown,
          primary: mainBrown,
        ),
        scaffoldBackgroundColor: const Color(0xFFF8F9FA), 

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.black87),
          titleTextStyle: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: mainBrown,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: mainBrown, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          hintStyle: TextStyle(color: Colors.grey[400]),
          labelStyle: TextStyle(color: Colors.grey[600]),
          prefixIconColor: Colors.grey[500],
        ),
      ),
      home: const AuthGate(),
    );
  }
}
