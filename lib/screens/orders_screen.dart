import 'package:flutter/material.dart';
import 'package:shearose/models/order.dart';
import 'package:shearose/services/order_service.dart';
import 'package:shearose/services/user_service.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final OrderService _orderService = OrderService();
  final UserService _userService = UserService();
  List<Order> _orders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() => _isLoading = true);
    final user = await _userService.getCurrentUser();
    if (user != null) {
      final orders = await _orderService.getOrders(user.id);
      if (mounted) setState(() {
        _orders = orders;
        _isLoading = false;
      });
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending': return Colors.orange;
      case 'processing': return Colors.blue;
      case 'shipped': return Colors.purple;
      case 'delivered': return Colors.green;
      case 'cancelled': return Colors.red;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: _isLoading ? const Center(child: CircularProgressIndicator()) : _orders.isEmpty ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.receipt_long_outlined, size: 100, color: Colors.grey[300]), const SizedBox(height: 24), Text('No orders yet', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.grey)), const SizedBox(height: 12), Text('Your order history will appear here', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey))])) : ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: _orders.length,
        itemBuilder: (context, index) {
          final order = _orders[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Order #${order.id.substring(0, 8)}', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: _getStatusColor(order.status).withValues(alpha: 0.2), borderRadius: BorderRadius.circular(20)),
                      child: Text(order.status, style: TextStyle(color: _getStatusColor(order.status), fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text('${order.items.length} item${order.items.length > 1 ? 's' : ''}', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey)),
                const SizedBox(height: 8),
                Text('Total: \$${order.totalAmount.toStringAsFixed(2)}', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.primary)),
                const SizedBox(height: 8),
                Text('Placed on ${order.createdAt.day}/${order.createdAt.month}/${order.createdAt.year}', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey)),
              ],
            ),
          );
        },
      ),
    );
  }
}
