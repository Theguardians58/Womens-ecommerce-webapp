import 'package:shearose/models/cart_item.dart';
import 'package:shearose/models/product.dart';
import 'package:shearose/supabase/supabase_config.dart';
import 'package:shearose/services/product_service.dart';

class CartService {
  static const String _tableName = 'cart_items';
  final ProductService _productService = ProductService();

  // Convert camelCase model fields to snake_case database fields
  Map<String, dynamic> _convertToDb(CartItem cartItem, String userId) {
    return {
      'id': cartItem.id,
      'user_id': userId,
      'product_id': cartItem.product.id,
      'quantity': cartItem.quantity,
      'selected_size': cartItem.selectedSize,
      'selected_color': cartItem.selectedColor,
      'created_at': cartItem.createdAt.toIso8601String(),
      'updated_at': cartItem.updatedAt.toIso8601String(),
    };
  }

  // Convert snake_case database fields to camelCase model fields
  Future<CartItem> _convertFromDb(Map<String, dynamic> data) async {
    // Fetch the product data separately
    final product = await _productService.getProductById(data['product_id']);
    if (product == null) {
      throw Exception('Product not found for cart item: ${data['product_id']}');
    }

    return CartItem(
      id: data['id'],
      product: product,
      quantity: data['quantity'],
      selectedSize: data['selected_size'],
      selectedColor: data['selected_color'],
      createdAt: DateTime.parse(data['created_at']),
      updatedAt: DateTime.parse(data['updated_at']),
    );
  }

  String _getCurrentUserId() {
    final currentUser = SupabaseConfig.auth.currentUser;
    if (currentUser == null) {
      throw Exception('User not authenticated');
    }
    return currentUser.id;
  }

  Future<List<CartItem>> getCartItems() async {
    try {
      final userId = _getCurrentUserId();
      final result = await SupabaseService.select(
        _tableName,
        filters: {'user_id': userId},
        orderBy: 'created_at',
        ascending: false,
      );

      final List<CartItem> cartItems = [];
      for (final data in result) {
        try {
          final cartItem = await _convertFromDb(data);
          cartItems.add(cartItem);
        } catch (e) {
          // Skip items with missing products
          continue;
        }
      }

      return cartItems;
    } catch (e) {
      throw Exception('Failed to get cart items: $e');
    }
  }

  Future<void> addToCart(Product product, {String? size, String? color, int quantity = 1}) async {
    try {
      final userId = _getCurrentUserId();
      
      // Check if item already exists with same product, size, and color
      final existingItems = await SupabaseService.select(
        _tableName,
        filters: {
          'user_id': userId,
          'product_id': product.id,
        },
      );

      final existingItem = existingItems.where((item) => 
        item['selected_size'] == size && item['selected_color'] == color
      ).firstOrNull;

      if (existingItem != null) {
        // Update existing item quantity
        await SupabaseService.update(
          _tableName,
          {
            'quantity': existingItem['quantity'] + quantity,
            'updated_at': DateTime.now().toIso8601String(),
          },
          filters: {'id': existingItem['id']},
        );
      } else {
        // Create new cart item
        final now = DateTime.now();
        final newCartItem = CartItem(
          id: now.millisecondsSinceEpoch.toString(),
          product: product,
          quantity: quantity,
          selectedSize: size,
          selectedColor: color,
          createdAt: now,
          updatedAt: now,
        );

        await SupabaseService.insert(
          _tableName,
          _convertToDb(newCartItem, userId),
        );
      }
    } catch (e) {
      throw Exception('Failed to add to cart: $e');
    }
  }

  Future<void> updateQuantity(String itemId, int quantity) async {
    try {
      final userId = _getCurrentUserId();
      
      if (quantity <= 0) {
        await SupabaseService.delete(
          _tableName,
          filters: {'id': itemId, 'user_id': userId},
        );
      } else {
        await SupabaseService.update(
          _tableName,
          {
            'quantity': quantity,
            'updated_at': DateTime.now().toIso8601String(),
          },
          filters: {'id': itemId, 'user_id': userId},
        );
      }
    } catch (e) {
      throw Exception('Failed to update cart item quantity: $e');
    }
  }

  Future<void> removeFromCart(String itemId) async {
    try {
      final userId = _getCurrentUserId();
      await SupabaseService.delete(
        _tableName,
        filters: {'id': itemId, 'user_id': userId},
      );
    } catch (e) {
      throw Exception('Failed to remove from cart: $e');
    }
  }

  Future<void> clearCart() async {
    try {
      final userId = _getCurrentUserId();
      await SupabaseService.delete(
        _tableName,
        filters: {'user_id': userId},
      );
    } catch (e) {
      throw Exception('Failed to clear cart: $e');
    }
  }

  Future<double> getCartTotal() async {
    try {
      final items = await getCartItems();
      return items.fold<double>(0.0, (sum, item) => sum + item.totalPrice);
    } catch (e) {
      throw Exception('Failed to get cart total: $e');
    }
  }

  Future<int> getCartItemCount() async {
    try {
      final items = await getCartItems();
      return items.fold<int>(0, (sum, item) => sum + item.quantity);
    } catch (e) {
      throw Exception('Failed to get cart item count: $e');
    }
  }
}
