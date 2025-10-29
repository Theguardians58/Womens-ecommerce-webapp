import 'package:flutter/material.dart';
import 'package:shearose/models/cart_item.dart';
import 'package:shearose/services/cart_service.dart';
import 'package:shearose/services/order_service.dart';
import 'package:shearose/services/user_service.dart';
import 'package:shearose/widgets/cart_item_widget.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> with SingleTickerProviderStateMixin {
  final CartService _cartService = CartService();
  final OrderService _orderService = OrderService();
  final UserService _userService = UserService();
  
  List<CartItem> _cartItems = [];
  double _totalAmount = 0.0;
  bool _isLoading = true;
  bool _isCheckingOut = false;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    _loadCart();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadCart() async {
    setState(() => _isLoading = true);
    final items = await _cartService.getCartItems();
    final total = await _cartService.getCartTotal();
    
    if (mounted) {
      setState(() {
        _cartItems = items;
        _totalAmount = total;
        _isLoading = false;
      });
      _controller.forward();
    }
  }

  Future<void> _checkout() async {
    if (_cartItems.isEmpty) return;
    
    setState(() => _isCheckingOut = true);
    final user = await _userService.getCurrentUser();
    if (user != null) {
      await _orderService.createOrder(user.id, _cartItems, _totalAmount, user.address);
      await _cartService.clearCart();
      
      if (mounted) {
        setState(() => _isCheckingOut = false);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('Order placed successfully!'), backgroundColor: Colors.green, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shopping Cart')),
      body: _isLoading ? const Center(child: CircularProgressIndicator()) : _cartItems.isEmpty ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.shopping_cart_outlined, size: 100, color: Colors.grey[300]), const SizedBox(height: 24), Text('Your cart is empty', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.grey)), const SizedBox(height: 12), Text('Add items to get started', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey))])) : FadeTransition(
        opacity: _controller,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(24),
                itemCount: _cartItems.length,
                itemBuilder: (context, index) => CartItemWidget(item: _cartItems[index], onUpdate: _loadCart),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, -4))],
                borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Subtotal', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey)),
                        Text('\$${_totalAmount.toStringAsFixed(2)}', style: Theme.of(context).textTheme.titleMedium),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Shipping', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey)),
                        Text('Free', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.green)),
                      ],
                    ),
                    const Divider(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total', style: Theme.of(context).textTheme.titleLarge),
                        Text('\$${_totalAmount.toStringAsFixed(2)}', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isCheckingOut ? null : _checkout,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 0,
                        ),
                        child: _isCheckingOut ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : Text('Checkout', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
