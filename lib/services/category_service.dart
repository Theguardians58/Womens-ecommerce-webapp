import 'package:shearose/models/category.dart';
import 'package:shearose/supabase/supabase_config.dart';

class CategoryService {
  static const String _tableName = 'categories';

  // Convert camelCase model fields to snake_case database fields
  Map<String, dynamic> _convertToDb(Category category) {
    return {
      'id': category.id,
      'name': category.name,
      'icon': category.icon,
      'created_at': category.createdAt.toIso8601String(),
      'updated_at': category.updatedAt.toIso8601String(),
    };
  }

  // Convert snake_case database fields to camelCase model fields
  Category _convertFromDb(Map<String, dynamic> data) {
    return Category(
      id: data['id'],
      name: data['name'],
      icon: data['icon'],
      createdAt: DateTime.parse(data['created_at']),
      updatedAt: DateTime.parse(data['updated_at']),
    );
  }

  Future<List<Category>> getAllCategories() async {
    try {
      final result = await SupabaseService.select(
        _tableName,
        orderBy: 'name',
        ascending: true,
      );

      return result.map((data) => _convertFromDb(data)).toList();
    } catch (e) {
      throw Exception('Failed to get categories: $e');
    }
  }

  Future<Category?> getCategoryById(String id) async {
    try {
      final data = await SupabaseService.selectSingle(
        _tableName,
        filters: {'id': id},
      );

      if (data == null) return null;
      return _convertFromDb(data);
    } catch (e) {
      throw Exception('Failed to get category by id: $e');
    }
  }

  Future<Category> createCategory({
    required String name,
    required String icon,
  }) async {
    try {
      final now = DateTime.now();
      final category = Category(
        id: now.millisecondsSinceEpoch.toString(),
        name: name,
        icon: icon,
        createdAt: now,
        updatedAt: now,
      );

      final result = await SupabaseService.insert(
        _tableName,
        _convertToDb(category),
      );

      return _convertFromDb(result.first);
    } catch (e) {
      throw Exception('Failed to create category: $e');
    }
  }

  Future<Category> updateCategory(Category category) async {
    try {
      final updatedCategory = category.copyWith(updatedAt: DateTime.now());
      final result = await SupabaseService.update(
        _tableName,
        _convertToDb(updatedCategory),
        filters: {'id': category.id},
      );

      return _convertFromDb(result.first);
    } catch (e) {
      throw Exception('Failed to update category: $e');
    }
  }

  Future<void> deleteCategory(String id) async {
    try {
      await SupabaseService.delete(
        _tableName,
        filters: {'id': id},
      );
    } catch (e) {
      throw Exception('Failed to delete category: $e');
    }
  }
}
