import 'package:flutter/material.dart';
import 'package:final_project/screens/welcome_screen.dart';
import 'package:provider/provider.dart';
import 'package:final_project/utils/app_state.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Roboto',
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 96,
            fontWeight: FontWeight.w300,
            letterSpacing: -1.5,
          ),
          displayMedium: TextStyle(
            fontSize: 60,
            fontWeight: FontWeight.w300,
            letterSpacing: -0.5,
          ),
          displaySmall: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.w400,
            letterSpacing: 0,
          ),
          headlineMedium: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.25,
          ),
          headlineSmall: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w400,
            letterSpacing: 0,
          ),
          titleLarge: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.15,
          ),
          titleMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.15,
          ),
          titleSmall: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.1,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.5,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.25,
          ),
          labelLarge: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.25,
          ),
          bodySmall: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.4,
          ),
          labelSmall: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w400,
            letterSpacing: 1.5,
          ),
        ),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF6A994E), // light_primary
          onPrimary: Colors.white,
          primaryContainer: Color(0xFFE0F7D7), // light_accent
          onPrimaryContainer: Colors.black,
          secondary: Color(0xFF6A994E), // using light_primary for secondary
          onSecondary: Colors.white,
          secondaryContainer: Color(0xFFE0F7D7), // light_accent
          onSecondaryContainer: Colors.black,
          surface: Color(0xFFF8F8F8), // light_card_background
          onSurface: Colors.black,
          onSurfaceVariant: Color(0xFF49454F),
          error: Color(0xFFB00020),
          onError: Colors.white,
          errorContainer: Color(0xFFFFDAD6),
          onErrorContainer: Color(0xFF410002),
          outline: Color(0xFF79747E),
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFF4D03F), // dark_primary
          onPrimary: Colors.black,
          primaryContainer: Color(0xFFFFF7E0), // dark_accent
          onPrimaryContainer: Colors.black,
          secondary: Color(0xFFF4D03F), // using dark_primary for secondary
          onSecondary: Colors.black,
          secondaryContainer: Color(0xFFFFF7E0), // dark_accent
          onSecondaryContainer: Colors.black,
          surface: Color(0xFF2C2C2C), // dark_card_background
          onSurface: Colors.white,
          onSurfaceVariant: Color(0xFFCAC4D0),
          error: Color(0xFFCF6679),
          onError: Colors.black,
          errorContainer: Color(0xFF8C1D18),
          onErrorContainer: Color(0xFFF9DEDC),
          outline: Color(0xFF938F99),
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      home: const WelcomeScreen(),
    );
  }
}
