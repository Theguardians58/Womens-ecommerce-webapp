import 'package:flutter/material.dart';
import 'package:shearose/theme.dart';
import 'package:shearose/screens/main_navigation.dart';
import 'package:shearose/screens/welcome_screen.dart';
import 'package:shearose/supabase/supabase_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://dljqpqvyqbylqjvwuluh.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRsanFwcXZ5cWJ5bHFqdnd1bHVoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjEwMzAxODAsImV4cCI6MjA3NjYwNjE4MH0.T7tHYgoInQyAWSYPYMP5wxIp6Ew4CFJ8wF0qjaSGAF0',
  );
  runApp(MyApp());
}
        

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseConfig.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> _hasSeenWelcome() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('hasSeenWelcome') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShéaRose',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      home: FutureBuilder<bool>(
        future: _hasSeenWelcome(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          final seen = snapshot.data ?? false;
          return seen ? const MainNavigation() : const WelcomeScreen();
        },
      ),
    );
  }
}
