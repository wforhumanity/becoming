import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'providers/service_providers.dart';
import 'screens/home_screen.dart';
import 'screens/onboarding_screen.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp();
  
  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  
  // Run the app with providers
  runApp(
    ProviderScope(
      overrides: [
        // Override the SharedPreferences provider with the instance
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const BecomingApp(),
    ),
  );
}

class BecomingApp extends ConsumerWidget {
  const BecomingApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get SharedPreferences instance
    final prefs = ref.watch(sharedPreferencesProvider);
    
    // Check if onboarding is completed
    final onboardingCompleted = prefs.getBool('onboarding_completed') ?? false;
    
    return MaterialApp(
      title: 'Becoming - Tiny Life Experiments',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
          primary: Colors.deepPurple,
          secondary: Colors.teal,
          tertiary: Colors.amber,
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
          ),
        ),
      ),
      home: onboardingCompleted ? const HomeScreen() : const OnboardingScreen(),
    );
  }
}
