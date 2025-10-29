import 'package:flutter/material.dart';
import 'package:shearose/theme.dart';
import 'package:shearose/screens/main_navigation.dart';
import 'package:shearose/screens/welcome_screen.dart';
import 'package:shearose/supabase/supabase_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
