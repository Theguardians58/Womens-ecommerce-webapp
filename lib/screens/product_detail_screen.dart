import 'package:flutter/material.dart';
import 'package:shearose/models/product.dart';
import 'package:shearose/services/cart_service.dart';
import 'package:shearose/services/wishlist_service.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> with SingleTickerProviderStateMixin {
  final CartService _cartService = CartService();
  final WishlistService _wishlistService = WishlistService();
  
  int _currentImageIndex = 0;
  String? _selectedSize;
  String? _selectedColor;
  bool _isInWishlist = false;
  bool _addingToCart = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
    _checkWishlist();
    if (widget.product.sizes.isNotEmpty) _selectedSize = widget.product.sizes.first;
    if (widget.product.colors.isNotEmpty) _selectedColor = widget.product.colors.first;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _checkWishlist() async {
    final isInWishlist = await _wishlistService.isInWishlist(widget.product.id);
    if (mounted) setState(() => _isInWishlist = isInWishlist);
  }

  Future<void> _toggleWishlist() async {
    await _wishlistService.toggleWishlist(widget.product);
    if (mounted) setState(() => _isInWishlist = !_isInWishlist);
  }

  Future<void> _addToCart() async {
    setState(() => _addingToCart = true);
    await _cartService.addToCart(widget.product, size: _selectedSize, color: _selectedColor);
    await _controller.forward();
    await _controller.reverse();
    
    if (mounted) {
      setState(() => _addingToCart = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('Added to cart!'), backgroundColor: Colors.green, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), duration: const Duration(seconds: 2)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: PageView.builder(
                itemCount: widget.product.images.length,
                onPageChanged: (index) => setState(() => _currentImageIndex = index),
                itemBuilder: (context, index) => Image.asset(widget.product.images[index], fit: BoxFit.cover),
              ),
            ),
            actions: [
              IconButton(icon: Icon(_isInWishlist ? Icons.favorite : Icons.favorite_border, color: _isInWishlist ? Colors.red : Colors.white), onPressed: _toggleWishlist),
            ],
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: List.generate(widget.product.images.length, (index) => Container(margin: const EdgeInsets.only(right: 8), width: 8, height: 8, decoration: BoxDecoration(shape: BoxShape.circle, color: _currentImageIndex == index ? Theme.of(context).colorScheme.primary : Colors.grey.withValues(alpha: 0.3)))),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: Text(widget.product.name, style: Theme.of(context).textTheme.headlineMedium)),
                        ScaleTransition(scale: _scaleAnimation, child: Text('\$${widget.product.price.toStringAsFixed(2)}', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Theme.of(context).colorScheme.primary))),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 20),
                        const SizedBox(width: 4),
                        Text('${widget.product.rating}', style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(width: 8),
                        Text('(${widget.product.reviewCount} reviews)', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey)),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text('Description', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text(widget.product.description, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey[700], height: 1.6)),
                    if (widget.product.sizes.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      Text('Size', style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 12,
                        children: widget.product.sizes.map((size) {
                          final isSelected = _selectedSize == size;
                          return GestureDetector(
                            onTap: () => setState(() => _selectedSize = size),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              decoration: BoxDecoration(
                                color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.surface,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey.withValues(alpha: 0.3)),
                              ),
                              child: Text(size, style: TextStyle(color: isSelected ? Colors.white : Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w500)),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                    if (widget.product.colors.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      Text('Color', style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 12,
                        children: widget.product.colors.map((color) {
                          final isSelected = _selectedColor == color;
                          return GestureDetector(
                            onTap: () => setState(() => _selectedColor = color),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              decoration: BoxDecoration(
                                color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.surface,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey.withValues(alpha: 0.3)),
                              ),
                              child: Text(color, style: TextStyle(color: isSelected ? Colors.white : Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w500)),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, -4))],
        ),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: _addingToCart ? null : _addToCart,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 0,
            ),
            child: _addingToCart ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : Text('Add to Cart', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }
}
