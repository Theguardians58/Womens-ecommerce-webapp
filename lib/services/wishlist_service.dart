import 'package:shearose/models/product.dart';
import 'package:shearose/supabase/supabase_config.dart';
import 'package:shearose/services/product_service.dart';

class WishlistService {
  static const String _tableName = 'wishlist';
  final ProductService _productService = ProductService();

  // Convert data for database storage
  Map<String, dynamic> _convertToDb(String userId, String productId) {
    final now = DateTime.now();
    return {
      'id': now.millisecondsSinceEpoch.toString(),
      'user_id': userId,
      'product_id': productId,
      'created_at': now.toIso8601String(),
      'updated_at': now.toIso8601String(),
    };
  }

  String _getCurrentUserId() {
    final currentUser = SupabaseConfig.auth.currentUser;
    if (currentUser == null) {
      throw Exception('User not authenticated');
    }
    return currentUser.id;
  }

  Future<List<Product>> getWishlist() async {
    try {
      final userId = _getCurrentUserId();
      final result = await SupabaseService.select(
        _tableName,
        filters: {'user_id': userId},
        orderBy: 'created_at',
        ascending: false,
      );

      final List<Product> products = [];
      for (final data in result) {
        try {
          final product = await _productService.getProductById(data['product_id']);
          if (product != null) {
            products.add(product);
          }
        } catch (e) {
          // Skip products that no longer exist
          continue;
        }
      }

      return products;
    } catch (e) {
      throw Exception('Failed to get wishlist: $e');
    }
  }

  Future<bool> isInWishlist(String productId) async {
    try {
      final userId = _getCurrentUserId();
      final result = await SupabaseService.selectSingle(
        _tableName,
        filters: {
          'user_id': userId,
          'product_id': productId,
        },
      );

      return result != null;
    } catch (e) {
      throw Exception('Failed to check wishlist status: $e');
    }
  }

  Future<void> toggleWishlist(Product product) async {
    try {
      final userId = _getCurrentUserId();
      final isInWishlist = await this.isInWishlist(product.id);

      if (isInWishlist) {
        await SupabaseService.delete(
          _tableName,
          filters: {
            'user_id': userId,
            'product_id': product.id,
          },
        );
      } else {
        await SupabaseService.insert(
          _tableName,
          _convertToDb(userId, product.id),
        );
      }
    } catch (e) {
      throw Exception('Failed to toggle wishlist: $e');
    }
  }

  Future<void> addToWishlist(String productId) async {
    try {
      final userId = _getCurrentUserId();
      final isAlreadyInWishlist = await isInWishlist(productId);

      if (!isAlreadyInWishlist) {
        await SupabaseService.insert(
          _tableName,
          _convertToDb(userId, productId),
        );
      }
    } catch (e) {
      throw Exception('Failed to add to wishlist: $e');
    }
  }

  Future<void> removeFromWishlist(String productId) async {
    try {
      final userId = _getCurrentUserId();
      await SupabaseService.delete(
        _tableName,
        filters: {
          'user_id': userId,
          'product_id': productId,
        },
      );
    } catch (e) {
      throw Exception('Failed to remove from wishlist: $e');
    }
  }

  Future<void> clearWishlist() async {
    try {
      final userId = _getCurrentUserId();
      await SupabaseService.delete(
        _tableName,
        filters: {'user_id': userId},
      );
    } catch (e) {
      throw Exception('Failed to clear wishlist: $e');
    }
  }

  Future<int> getWishlistCount() async {
    try {
      final userId = _getCurrentUserId();
      final result = await SupabaseService.select(
        _tableName,
        filters: {'user_id': userId},
      );

      return result.length;
    } catch (e) {
      throw Exception('Failed to get wishlist count: $e');
    }
  }
}
