import 'package:flutter/material.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const SarafApp());
}

class SarafApp extends StatelessWidget {
  const SarafApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Saraf',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF14B8A6),   // teal accent
          secondary: Color(0xFFF5C542), // gold accent
          surface: Color(0xFF0F1316),
          onSurface: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xFF0B0F11),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF14191D),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF27323A)),
            borderRadius: BorderRadius.circular(14),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF14B8A6), width: 1.2),
            borderRadius: BorderRadius.circular(14),
          ),
          labelStyle: const TextStyle(color: Color(0xFFB8C3C9)),
          hintStyle: const TextStyle(color: Color(0xFF88959C)),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF14B8A6),
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          ),
        ),
        cardTheme: CardTheme(
          color: const Color(0xFF10161A),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          margin: EdgeInsets.zero,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      home: const HomePage(),
    );
  }
}
