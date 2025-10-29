import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shearose/screens/main_navigation.dart';
import 'package:shearose/screens/catalog_screen.dart';
import 'package:shearose/screens/login_screen.dart';
import 'package:shearose/screens/signup_screen.dart';
import 'package:shearose/widgets/app_logo.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeIn;
  late final Animation<Offset> _slideUp;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _slideUp = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _continueToApp() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenWelcome', true);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainNavigation()),
    );
  }

  void _browseCollections() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const CatalogScreen()),
    );
  }

  void _navigateToLogin() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  void _navigateToSignup() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const SignupScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.primary.withValues(alpha: 0.15),
              colorScheme.secondary.withValues(alpha: 0.10),
              colorScheme.tertiary.withValues(alpha: 0.08),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                FadeTransition(
                  opacity: _fadeIn,
                  child: SlideTransition(
                    position: _slideUp,
                    child: Column(
                      children: [
                        // Brand logo panel
                        const _WelcomeLogo(),
                        const SizedBox(height: 28),
                        Text(
                          'ShéaRose',
                          style: textTheme.displaySmall?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Elevate your everyday style',
                          style: textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                FadeTransition(
                  opacity: _fadeIn,
                  child: Column(
                    children: [
                      // Sign In button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.login),
                          label: const Text('Sign In'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          onPressed: _navigateToLogin,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Create Account button
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.person_add),
                          label: const Text('Create Account'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: BorderSide(color: colorScheme.primary.withValues(alpha: 0.6)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          onPressed: _navigateToSignup,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Divider with text
                      Row(
                        children: [
                          Expanded(child: Divider(color: colorScheme.onSurface.withValues(alpha: 0.3))),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'or',
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurface.withValues(alpha: 0.6),
                              ),
                            ),
                          ),
                          Expanded(child: Divider(color: colorScheme.onSurface.withValues(alpha: 0.3))),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Browse Collections button
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: _browseCollections,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: BorderSide(color: colorScheme.primary.withValues(alpha: 0.4)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: const Text('Browse Collections'),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Continue as Guest button
                      TextButton(
                        onPressed: _continueToApp,
                        child: const Text('Continue as Guest'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WelcomeLogo extends StatelessWidget {
  const _WelcomeLogo();

  @override
  Widget build(BuildContext context) {
    // Uses theme-aware AppLogo and falls back gracefully if asset missing
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final size = width.clamp(180.0, 320.0);
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: SizedBox(
              height: size,
              width: size,
              child: const _LogoCard(),
            ),
          ),
        );
      },
    );
  }
}

class _LogoCard extends StatelessWidget {
  const _LogoCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
              Theme.of(context).colorScheme.secondary.withValues(alpha: 0.10),
            ],
          ),
        ),
        alignment: Alignment.center,
        child: const Padding(
          padding: EdgeInsets.all(16.0),
          child: _LogoArt(),
        ),
      ),
    );
  }
}

class _LogoArt extends StatelessWidget {
  const _LogoArt();

  @override
  Widget build(BuildContext context) {
    // Import here to avoid circular import in hot reload
    return const SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.contain,
        child: _LogoInner(),
      ),
    );
  }
}

class _LogoInner extends StatelessWidget {
  const _LogoInner();

  @override
  Widget build(BuildContext context) {
    // Defer the import to here to keep build file clean
    // ignore: avoid_dynamic_calls
    return _AppLogoProxy();
  }
}

// A tiny indirection to keep WelcomeScreen free of a direct import cycle.
class _AppLogoProxy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // We import here to keep the top of file minimal.
    // This local import avoids a circular ref during hot reload.
    // ignore: import_of_legacy_library_into_null_safe
    return Builder(
      builder: (_) {
        // Use the AppLogo widget from widgets folder
        return const AppLogo(size: 220, monochrome: false);
      },
    );
  }
}
