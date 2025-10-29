import 'package:flutter/material.dart';
import 'package:shearose/auth/auth_manager.dart';
import 'package:shearose/models/user.dart' as app_user;
import 'package:shearose/services/user_service.dart';
import 'package:shearose/supabase/supabase_config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthManager extends AuthManager with EmailSignInManager {
  final UserService _userService = UserService();

  void _showErrorMessage(BuildContext context, String message) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  void _showSuccessMessage(BuildContext context, String message) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Future<app_user.User?> signInWithEmail(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      final response = await SupabaseConfig.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        _showErrorMessage(context, 'Failed to sign in');
        return null;
      }

      // Fetch user data from our users table
      final user = await _userService.getUserById(response.user!.id);
      
      if (user == null) {
        _showErrorMessage(context, 'User profile not found');
        await SupabaseConfig.auth.signOut();
        return null;
      }

      return user;
    } on AuthException catch (e) {
      _showErrorMessage(context, e.message);
      return null;
    } catch (e) {
      _showErrorMessage(context, 'An unexpected error occurred');
      return null;
    }
  }

  @override
  Future<app_user.User?> createAccountWithEmail(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      final response = await SupabaseConfig.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user == null) {
        _showErrorMessage(context, 'Failed to create account');
        return null;
      }

      // Extract name from email (before @ symbol) as default
      final defaultName = email.split('@').first;

      // Create user record in our users table
      final user = await _userService.createUser(
        id: response.user!.id,
        name: defaultName,
        email: email,
      );

      if (response.user!.emailConfirmedAt == null) {
        _showSuccessMessage(context, 'Please check your email to confirm your account');
      }

      return user;
    } on AuthException catch (e) {
      _showErrorMessage(context, e.message);
      return null;
    } catch (e) {
      _showErrorMessage(context, 'An unexpected error occurred during signup');
      return null;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await SupabaseConfig.auth.signOut();
    } catch (e) {
      // Silently handle sign out errors
    }
  }

  @override
  Future<void> deleteUser(BuildContext context) async {
    try {
      final currentUser = SupabaseConfig.auth.currentUser;
      if (currentUser == null) {
        _showErrorMessage(context, 'No user is currently signed in');
        return;
      }

      // Delete user from our users table first
      await SupabaseService.delete('users', filters: {'id': currentUser.id});
      
      // Then delete from auth
      await SupabaseConfig.client.auth.admin.deleteUser(currentUser.id);
      
      _showSuccessMessage(context, 'Account deleted successfully');
    } on AuthException catch (e) {
      _showErrorMessage(context, e.message);
    } catch (e) {
      _showErrorMessage(context, 'Failed to delete account');
    }
  }

  @override
  Future<void> updateEmail({
    required String email,
    required BuildContext context,
  }) async {
    try {
      await SupabaseConfig.auth.updateUser(
        UserAttributes(email: email),
      );
      
      _showSuccessMessage(context, 'Email updated successfully. Please check your new email for confirmation.');
    } on AuthException catch (e) {
      _showErrorMessage(context, e.message);
    } catch (e) {
      _showErrorMessage(context, 'Failed to update email');
    }
  }

  @override
  Future<void> resetPassword({
    required String email,
    required BuildContext context,
  }) async {
    try {
      await SupabaseConfig.auth.resetPasswordForEmail(email);
      _showSuccessMessage(context, 'Password reset email sent! Please check your inbox.');
    } on AuthException catch (e) {
      _showErrorMessage(context, e.message);
    } catch (e) {
      _showErrorMessage(context, 'Failed to send password reset email');
    }
  }
}