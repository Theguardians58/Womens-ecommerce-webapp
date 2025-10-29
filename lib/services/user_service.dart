import 'package:shearose/models/user.dart';
import 'package:shearose/supabase/supabase_config.dart';

class UserService {
  static const String _tableName = 'users';

  // Convert camelCase model fields to snake_case database fields
  Map<String, dynamic> _convertToDb(User user) {
    return {
      'id': user.id,
      'name': user.name,
      'email': user.email,
      'phone': user.phone,
      'address': user.address,
      'created_at': user.createdAt.toIso8601String(),
      'updated_at': user.updatedAt.toIso8601String(),
    };
  }

  // Convert snake_case database fields to camelCase model fields
  User _convertFromDb(Map<String, dynamic> data) {
    return User(
      id: data['id'],
      name: data['name'],
      email: data['email'],
      phone: data['phone'],
      address: data['address'],
      createdAt: DateTime.parse(data['created_at']),
      updatedAt: DateTime.parse(data['updated_at']),
    );
  }

  Future<User?> getCurrentUser() async {
    try {
      final currentUser = SupabaseConfig.auth.currentUser;
      if (currentUser == null) return null;

      final userData = await SupabaseService.selectSingle(
        _tableName,
        filters: {'id': currentUser.id},
      );

      if (userData == null) return null;
      return _convertFromDb(userData);
    } catch (e) {
      throw Exception('Failed to get current user: $e');
    }
  }

  Future<User> createUser({
    required String id,
    required String name,
    required String email,
    String? phone,
    String? address,
  }) async {
    try {
      final now = DateTime.now();
      final user = User(
        id: id,
        name: name,
        email: email,
        phone: phone,
        address: address,
        createdAt: now,
        updatedAt: now,
      );

      final result = await SupabaseService.insert(
        _tableName,
        _convertToDb(user),
      );

      return _convertFromDb(result.first);
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }

  Future<User> updateUser(User user) async {
    try {
      final updatedUser = user.copyWith(updatedAt: DateTime.now());
      final result = await SupabaseService.update(
        _tableName,
        _convertToDb(updatedUser),
        filters: {'id': user.id},
      );

      return _convertFromDb(result.first);
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  Future<User?> getUserById(String id) async {
    try {
      final userData = await SupabaseService.selectSingle(
        _tableName,
        filters: {'id': id},
      );

      if (userData == null) return null;
      return _convertFromDb(userData);
    } catch (e) {
      throw Exception('Failed to get user by id: $e');
    }
  }
}
