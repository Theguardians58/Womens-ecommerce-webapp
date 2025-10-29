import 'package:flutter/material.dart';
import 'package:shearose/models/product.dart';
import 'package:shearose/services/wishlist_service.dart';
import 'package:shearose/widgets/product_card.dart';
import 'package:shearose/screens/product_detail_screen.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  final WishlistService _wishlistService = WishlistService();
  List<Product> _wishlistItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWishlist();
  }

  Future<void> _loadWishlist() async {
    setState(() => _isLoading = true);
    final items = await _wishlistService.getWishlist();
    if (mounted) setState(() {
      _wishlistItems = items;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wishlist')),
      body: _isLoading ? const Center(child: CircularProgressIndicator()) : _wishlistItems.isEmpty ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.favorite_border, size: 100, color: Colors.grey[300]), const SizedBox(height: 24), Text('Your wishlist is empty', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.grey)), const SizedBox(height: 12), Text('Save your favorite items here', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey))])) : Padding(
        padding: const EdgeInsets.all(24),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.65, crossAxisSpacing: 16, mainAxisSpacing: 16),
          itemCount: _wishlistItems.length,
          itemBuilder: (context, index) {
            final product = _wishlistItems[index];
            return ProductCard(product: product, onTap: () async {
              await Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailScreen(product: product)));
              _loadWishlist();
            });
          },
        ),
      ),
    );
  }
}
