import 'package:flutter/material.dart';
import 'package:shearose/models/category.dart';
import 'package:shearose/models/product.dart';
import 'package:shearose/services/category_service.dart';
import 'package:shearose/services/product_service.dart';
import 'package:shearose/services/cart_service.dart';
import 'package:shearose/widgets/category_chip.dart';
import 'package:shearose/widgets/product_card.dart';
import 'package:shearose/screens/product_detail_screen.dart';
import 'package:shearose/screens/catalog_screen.dart';
import 'package:shearose/screens/search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final ProductService _productService = ProductService();
  final CategoryService _categoryService = CategoryService();
  final CartService _cartService = CartService();

  List<Product> _featuredProducts = [];
  List<Product> _newProducts = [];
  List<Category> _categories = [];
  int _cartItemCount = 0;
  bool _isLoading = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 800), vsync: this);
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn));
    _loadData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final featured = await _productService.getFeaturedProducts();
    final newProducts = await _productService.getNewProducts();
    final categories = await _categoryService.getAllCategories();
    final cartCount = await _cartService.getCartItemCount();

    if (mounted) {
      setState(() {
        _featuredProducts = featured;
        _newProducts = newProducts;
        _categories = categories;
        _cartItemCount = cartCount;
        _isLoading = false;
      });
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : FadeTransition(
              opacity: _fadeAnimation,
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 200,
                    floating: false,
                    pinned: true,
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withValues(alpha: 0.2),
                              Theme.of(context)
                                  .colorScheme
                                  .secondary
                                  .withValues(alpha: 0.1),
                            ],
                          ),
                        ),
                        child: SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text('Discover',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall
                                        ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface)),
                                const SizedBox(height: 4),
                                Text('Your Style Journey',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(color: Colors.grey[600])),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    actions: [
                      Stack(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.shopping_bag_outlined),
                            onPressed: () {},
                          ),
                          if (_cartItemCount > 0)
                            Positioned(
                              right: 8,
                              top: 8,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                constraints: const BoxConstraints(
                                    minWidth: 16, minHeight: 16),
                                child: Text(
                                  '$_cartItemCount',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Categories',
                              style: Theme.of(context).textTheme.headlineSmall),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 50,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: _categories.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 12),
                              itemBuilder: (context, index) {
                                final category = _categories[index];
                                return CategoryChip(
                                    category: category,
                                    isSelected: false,
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CatalogScreen(
                                                      categoryId: category.id,
                                                      categoryName:
                                                          category.name)));
                                    });
                              },
                            ),
                          ),
                          const SizedBox(height: 32),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Featured',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall),
                              TextButton(
                                  onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const CatalogScreen())),
                                  child: const Text('View All')),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 320,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: _featuredProducts.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 16),
                              itemBuilder: (context, index) {
                                final product = _featuredProducts[index];
                                return SizedBox(
                                    width: 200,
                                    child: ProductCard(
                                        product: product,
                                        onTap: () async {
                                          await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProductDetailScreen(
                                                          product: product)));
                                          _loadData();
                                        }));
                              },
                            ),
                          ),
                          const SizedBox(height: 32),
                          Text('New Arrivals',
                              style: Theme.of(context).textTheme.headlineSmall),
                          const SizedBox(height: 16),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 0.65,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16),
                            itemCount: _newProducts.length,
                            itemBuilder: (context, index) {
                              final product = _newProducts[index];
                              return ProductCard(
                                  product: product,
                                  onTap: () async {
                                    await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProductDetailScreen(
                                                    product: product)));
                                    _loadData();
                                  });
                            },
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
