import 'package:flutter/material.dart';
import 'package:shearose/models/product.dart';
import 'package:shearose/services/product_service.dart';
import 'package:shearose/widgets/product_card.dart';
import 'package:shearose/screens/product_detail_screen.dart';

class CatalogScreen extends StatefulWidget {
  final String? categoryId;
  final String? categoryName;

  const CatalogScreen({super.key, this.categoryId, this.categoryName});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final ProductService _productService = ProductService();
  List<Product> _products = [];
  bool _isLoading = true;
  String _sortBy = 'name';

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() => _isLoading = true);
    List<Product> products;
    if (widget.categoryId != null) {
      products = await _productService.getProductsByCategory(widget.categoryId!);
    } else {
      products = await _productService.getAllProducts();
    }
    
    if (mounted) setState(() {
      _products = products;
      _sortProducts();
      _isLoading = false;
    });
  }

  void _sortProducts() {
    switch (_sortBy) {
      case 'price_low':
        _products.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'price_high':
        _products.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'rating':
        _products.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      default:
        _products.sort((a, b) => a.name.compareTo(b.name));
    }
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sort By', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            _buildSortOption('Name', 'name'),
            _buildSortOption('Price: Low to High', 'price_low'),
            _buildSortOption('Price: High to Low', 'price_high'),
            _buildSortOption('Rating', 'rating'),
          ],
        ),
      ),
    );
  }

  Widget _buildSortOption(String label, String value) {
    final isSelected = _sortBy == value;
    return ListTile(
      title: Text(label, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
      trailing: isSelected ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary) : null,
      onTap: () {
        setState(() {
          _sortBy = value;
          _sortProducts();
        });
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName ?? 'All Products'),
        actions: [
          IconButton(icon: const Icon(Icons.sort), onPressed: _showSortOptions),
        ],
      ),
      body: _isLoading ? const Center(child: CircularProgressIndicator()) : _products.isEmpty ? Center(child: Text('No products found', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.grey))) : Padding(
        padding: const EdgeInsets.all(24),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.65, crossAxisSpacing: 16, mainAxisSpacing: 16),
          itemCount: _products.length,
          itemBuilder: (context, index) {
            final product = _products[index];
            return ProductCard(product: product, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailScreen(product: product))));
          },
        ),
      ),
    );
  }
}
