import 'package:flutter/material.dart';
import 'package:shearose/models/cart_item.dart';
import 'package:shearose/services/cart_service.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem item;
  final VoidCallback onUpdate;

  const CartItemWidget({super.key, required this.item, required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    final cartService = CartService();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(item.product.images.first, width: 90, height: 90, fit: BoxFit.cover),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.product.name, style: Theme.of(context).textTheme.titleMedium, maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                if (item.selectedSize != null || item.selectedColor != null) Text('${item.selectedSize ?? ''} ${item.selectedColor ?? ''}', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey)),
                const SizedBox(height: 8),
                Text('\$${item.product.price.toStringAsFixed(2)}', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.primary)),
              ],
            ),
          ),
          Column(
            children: [
              IconButton(icon: const Icon(Icons.delete_outline, color: Colors.red), onPressed: () async {
                await cartService.removeFromCart(item.id);
                onUpdate();
              }),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer, borderRadius: BorderRadius.circular(20)),
                child: Row(
                  children: [
                    IconButton(icon: const Icon(Icons.remove, size: 18), padding: const EdgeInsets.all(8), constraints: const BoxConstraints(), onPressed: () async {
                      await cartService.updateQuantity(item.id, item.quantity - 1);
                      onUpdate();
                    }),
                    Text('${item.quantity}', style: Theme.of(context).textTheme.titleSmall),
                    IconButton(icon: const Icon(Icons.add, size: 18), padding: const EdgeInsets.all(8), constraints: const BoxConstraints(), onPressed: () async {
                      await cartService.updateQuantity(item.id, item.quantity + 1);
                      onUpdate();
                    }),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
