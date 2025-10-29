import 'package:shearose/models/product.dart';
import 'package:shearose/supabase/supabase_config.dart';

class ProductService {
  static const String _tableName = 'products';

  // Convert camelCase model fields to snake_case database fields
  Map<String, dynamic> _convertToDb(Product product) {
    return {
      'id': product.id,
      'name': product.name,
      'description': product.description,
      'price': product.price,
      'category_id': product.categoryId,
      'images': product.images,
      'sizes': product.sizes,
      'colors': product.colors,
      'rating': product.rating,
      'review_count': product.reviewCount,
      'is_new': product.isNew,
      'is_featured': product.isFeatured,
      'created_at': product.createdAt.toIso8601String(),
      'updated_at': product.updatedAt.toIso8601String(),
    };
  }

  // Convert snake_case database fields to camelCase model fields
  Product _convertFromDb(Map<String, dynamic> data) {
    return Product(
      id: data['id'],
      name: data['name'],
      description: data['description'],
      price: data['price'].toDouble(),
      categoryId: data['category_id'],
      images: List<String>.from(data['images']),
      sizes: List<String>.from(data['sizes']),
      colors: List<String>.from(data['colors']),
      rating: data['rating'].toDouble(),
      reviewCount: data['review_count'],
      isNew: data['is_new'] ?? false,
      isFeatured: data['is_featured'] ?? false,
      createdAt: DateTime.parse(data['created_at']),
      updatedAt: DateTime.parse(data['updated_at']),
    );
  }

  Future<List<Product>> getAllProducts() async {
    try {
      final result = await SupabaseService.select(
        _tableName,
        orderBy: 'created_at',
        ascending: false,
      );

      return result.map((data) => _convertFromDb(data)).toList();
    } catch (e) {
      throw Exception('Failed to get products: $e');
    }
  }

  Future<Product?> getProductById(String id) async {
    try {
      final data = await SupabaseService.selectSingle(
        _tableName,
        filters: {'id': id},
      );

      if (data == null) return null;
      return _convertFromDb(data);
    } catch (e) {
      throw Exception('Failed to get product by id: $e');
    }
  }

  Future<List<Product>> getProductsByCategory(String categoryId) async {
    try {
      final result = await SupabaseService.select(
        _tableName,
        filters: {'category_id': categoryId},
        orderBy: 'name',
        ascending: true,
      );

      return result.map((data) => _convertFromDb(data)).toList();
    } catch (e) {
      throw Exception('Failed to get products by category: $e');
    }
  }

  Future<List<Product>> getFeaturedProducts() async {
    try {
      final result = await SupabaseService.select(
        _tableName,
        filters: {'is_featured': true},
        orderBy: 'created_at',
        ascending: false,
      );

      return result.map((data) => _convertFromDb(data)).toList();
    } catch (e) {
      throw Exception('Failed to get featured products: $e');
    }
  }

  Future<List<Product>> getNewProducts() async {
    try {
      final result = await SupabaseService.select(
        _tableName,
        filters: {'is_new': true},
        orderBy: 'created_at',
        ascending: false,
      );

      return result.map((data) => _convertFromDb(data)).toList();
    } catch (e) {
      throw Exception('Failed to get new products: $e');
    }
  }

  Future<List<Product>> searchProducts(String query) async {
    try {
      // Use Supabase's text search functionality
      final result = await SupabaseService.from(_tableName)
        .select()
        .or('name.ilike.%${query}%,description.ilike.%${query}%')
        .order('name');

      return result.map((data) => _convertFromDb(data)).toList();
    } catch (e) {
      throw Exception('Failed to search products: $e');
    }
  }

  Future<Product> createProduct({
    required String name,
    required String description,
    required double price,
    required String categoryId,
    required List<String> images,
    required List<String> sizes,
    required List<String> colors,
    double rating = 0.0,
    int reviewCount = 0,
    bool isNew = false,
    bool isFeatured = false,
  }) async {
    try {
      final now = DateTime.now();
      final product = Product(
        id: now.millisecondsSinceEpoch.toString(),
        name: name,
        description: description,
        price: price,
        categoryId: categoryId,
        images: images,
        sizes: sizes,
        colors: colors,
        rating: rating,
        reviewCount: reviewCount,
        isNew: isNew,
        isFeatured: isFeatured,
        createdAt: now,
        updatedAt: now,
      );

      final result = await SupabaseService.insert(
        _tableName,
        _convertToDb(product),
      );

      return _convertFromDb(result.first);
    } catch (e) {
      throw Exception('Failed to create product: $e');
    }
  }

  Future<Product> updateProduct(Product product) async {
    try {
      final updatedProduct = product.copyWith(updatedAt: DateTime.now());
      final result = await SupabaseService.update(
        _tableName,
        _convertToDb(updatedProduct),
        filters: {'id': product.id},
      );

      return _convertFromDb(result.first);
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      await SupabaseService.delete(
        _tableName,
        filters: {'id': id},
      );
    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }
}
