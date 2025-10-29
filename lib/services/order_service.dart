import 'package:shearose/models/order.dart';
import 'package:shearose/models/cart_item.dart';
import 'package:shearose/models/product.dart';
import 'package:shearose/supabase/supabase_config.dart';

class OrderService {
  static const String _ordersTable = 'orders';
  static const String _orderItemsTable = 'order_items';

  // Convert camelCase model fields to snake_case database fields for orders
  Map<String, dynamic> _convertOrderToDb(Order order) {
    return {
      'id': order.id,
      'user_id': order.userId,
      'total_amount': order.totalAmount,
      'status': order.status,
      'shipping_address': order.shippingAddress,
      'created_at': order.createdAt.toIso8601String(),
      'updated_at': order.updatedAt.toIso8601String(),
    };
  }

  // Convert camelCase model fields to snake_case database fields for order items
  Map<String, dynamic> _convertOrderItemToDb(String orderId, CartItem item) {
    return {
      'id': '${orderId}_${item.id}',
      'order_id': orderId,
      'product_id': item.product.id,
      'product_name': item.product.name,
      'product_price': item.product.price,
      'quantity': item.quantity,
      'selected_size': item.selectedSize,
      'selected_color': item.selectedColor,
      'created_at': item.createdAt.toIso8601String(),
      'updated_at': item.updatedAt.toIso8601String(),
    };
  }

  // Convert snake_case database fields to camelCase model fields
  Future<Order> _convertOrderFromDb(Map<String, dynamic> orderData) async {
    // Get order items
    final orderItemsData = await SupabaseService.select(
      _orderItemsTable,
      filters: {'order_id': orderData['id']},
      orderBy: 'created_at',
      ascending: true,
    );

    // Convert order items to CartItem objects
    final List<CartItem> items = [];
    for (final itemData in orderItemsData) {
      final cartItem = CartItem(
        id: itemData['id'],
        product: _createProductFromOrderItem(itemData),
        quantity: itemData['quantity'],
        selectedSize: itemData['selected_size'],
        selectedColor: itemData['selected_color'],
        createdAt: DateTime.parse(itemData['created_at']),
        updatedAt: DateTime.parse(itemData['updated_at']),
      );
      items.add(cartItem);
    }

    return Order(
      id: orderData['id'],
      userId: orderData['user_id'],
      items: items,
      totalAmount: orderData['total_amount'].toDouble(),
      status: orderData['status'],
      shippingAddress: orderData['shipping_address'],
      createdAt: DateTime.parse(orderData['created_at']),
      updatedAt: DateTime.parse(orderData['updated_at']),
    );
  }

  // Create a Product object from order item data (snapshot at purchase time)
  Product _createProductFromOrderItem(Map<String, dynamic> itemData) {
    // Create a Product with minimal data from the order item snapshot
    final now = DateTime.now();
    return Product(
      id: itemData['product_id'],
      name: itemData['product_name'],
      description: 'Product snapshot from order',
      price: itemData['product_price'].toDouble(),
      categoryId: '', // Not stored in order items
      images: [], // Not stored in order items
      sizes: [], // Not stored in order items  
      colors: [], // Not stored in order items
      rating: 0.0, // Not stored in order items
      reviewCount: 0, // Not stored in order items
      isNew: false,
      isFeatured: false,
      createdAt: now,
      updatedAt: now,
    );
  }

  String _getCurrentUserId() {
    final currentUser = SupabaseConfig.auth.currentUser;
    if (currentUser == null) {
      throw Exception('User not authenticated');
    }
    return currentUser.id;
  }

  Future<List<Order>> getOrders(String userId) async {
    try {
      final ordersData = await SupabaseService.select(
        _ordersTable,
        filters: {'user_id': userId},
        orderBy: 'created_at',
        ascending: false,
      );

      final List<Order> orders = [];
      for (final orderData in ordersData) {
        final order = await _convertOrderFromDb(orderData);
        orders.add(order);
      }

      return orders;
    } catch (e) {
      throw Exception('Failed to get orders: $e');
    }
  }

  Future<Order?> getOrderById(String orderId) async {
    try {
      final orderData = await SupabaseService.selectSingle(
        _ordersTable,
        filters: {'id': orderId},
      );

      if (orderData == null) return null;
      return await _convertOrderFromDb(orderData);
    } catch (e) {
      throw Exception('Failed to get order by id: $e');
    }
  }

  Future<Order> createOrder(String userId, List<CartItem> items, double totalAmount, String? shippingAddress) async {
    try {
      final now = DateTime.now();
      final orderId = now.millisecondsSinceEpoch.toString();

      // Create the order
      final order = Order(
        id: orderId,
        userId: userId,
        items: items,
        totalAmount: totalAmount,
        status: 'Pending',
        shippingAddress: shippingAddress,
        createdAt: now,
        updatedAt: now,
      );

      // Insert order into orders table
      await SupabaseService.insert(
        _ordersTable,
        _convertOrderToDb(order),
      );

      // Insert order items into order_items table
      for (final item in items) {
        await SupabaseService.insert(
          _orderItemsTable,
          _convertOrderItemToDb(orderId, item),
        );
      }

      return order;
    } catch (e) {
      throw Exception('Failed to create order: $e');
    }
  }

  Future<Order> updateOrderStatus(String orderId, String status) async {
    try {
      final now = DateTime.now();
      final result = await SupabaseService.update(
        _ordersTable,
        {
          'status': status,
          'updated_at': now.toIso8601String(),
        },
        filters: {'id': orderId},
      );

      if (result.isEmpty) {
        throw Exception('Order not found');
      }

      return await _convertOrderFromDb(result.first);
    } catch (e) {
      throw Exception('Failed to update order status: $e');
    }
  }

  Future<void> deleteOrder(String orderId) async {
    try {
      // Delete order items first
      await SupabaseService.delete(
        _orderItemsTable,
        filters: {'order_id': orderId},
      );

      // Delete the order
      await SupabaseService.delete(
        _ordersTable,
        filters: {'id': orderId},
      );
    } catch (e) {
      throw Exception('Failed to delete order: $e');
    }
  }

  Future<List<Order>> getOrdersByStatus(String status, String userId) async {
    try {
      final ordersData = await SupabaseService.select(
        _ordersTable,
        filters: {
          'user_id': userId,
          'status': status,
        },
        orderBy: 'created_at',
        ascending: false,
      );

      final List<Order> orders = [];
      for (final orderData in ordersData) {
        final order = await _convertOrderFromDb(orderData);
        orders.add(order);
      }

      return orders;
    } catch (e) {
      throw Exception('Failed to get orders by status: $e');
    }
  }
}

