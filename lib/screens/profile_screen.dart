import 'package:flutter/material.dart';
import 'package:shearose/models/user.dart';
import 'package:shearose/services/user_service.dart';
import 'package:shearose/screens/orders_screen.dart';
import 'package:shearose/screens/login_screen.dart';
import 'package:shearose/screens/welcome_screen.dart';
import 'package:shearose/auth/supabase_auth_manager.dart';
import 'package:shearose/supabase/supabase_config.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserService _userService = UserService();
  final SupabaseAuthManager _authManager = SupabaseAuthManager();
  User? _user;
  bool _isLoading = true;
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    setState(() => _isLoading = true);
    
    // Check if user is authenticated
    final isAuth = SupabaseConfig.auth.currentUser != null;
    
    if (isAuth) {
      final user = await _userService.getCurrentUser();
      if (mounted) setState(() {
        _user = user;
        _isAuthenticated = true;
        _isLoading = false;
      });
    } else {
      if (mounted) setState(() {
        _user = null;
        _isAuthenticated = false;
        _isLoading = false;
      });
    }
  }

  void _navigateToLogin() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  Future<void> _signOut() async {
    await _authManager.signOut();
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const WelcomeScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator()) 
        : !_isAuthenticated 
          ? _buildUnauthenticatedView()
          : _user == null 
            ? const Center(child: Text('No user data')) 
            : SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.secondary],
                ),
              ),
              child: Center(child: Text(_user!.name.substring(0, 1).toUpperCase(), style: Theme.of(context).textTheme.displayLarge?.copyWith(color: Colors.white))),
            ),
            const SizedBox(height: 24),
            Text(_user!.name, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text(_user!.email, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey)),
            const SizedBox(height: 32),
            _buildInfoCard('Phone', _user!.phone ?? 'Not set', Icons.phone),
            const SizedBox(height: 16),
            _buildInfoCard('Address', _user!.address ?? 'Not set', Icons.location_on),
            const SizedBox(height: 32),
            _buildMenuTile('My Orders', Icons.shopping_bag, () => Navigator.push(context, MaterialPageRoute(builder: (context) => const OrdersScreen()))),
            _buildMenuTile('Settings', Icons.settings, () {}),
            _buildMenuTile('Help & Support', Icons.help_outline, () {}),
            _buildMenuTile('About', Icons.info_outline, () {}),
            const SizedBox(height: 16),
            _buildMenuTile('Sign Out', Icons.logout, _signOut, isDestructive: true),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.grey)),
                const SizedBox(height: 4),
                Text(value, style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnauthenticatedView() {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.primary.withValues(alpha: 0.1),
              ),
              child: Icon(
                Icons.person_outline,
                size: 60,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Sign In Required',
              style: textTheme.headlineSmall?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Sign in to view your profile, orders, and account settings.',
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.login),
                label: const Text('Sign In'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: _navigateToLogin,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuTile(String title, IconData icon, VoidCallback onTap, {bool isDestructive = false}) {
    final colorScheme = Theme.of(context).colorScheme;
    final iconColor = isDestructive ? colorScheme.error : colorScheme.primary;
    final textColor = isDestructive ? colorScheme.error : null;

    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title, style: TextStyle(color: textColor)),
      trailing: isDestructive ? null : const Icon(Icons.chevron_right),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
