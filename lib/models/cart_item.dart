import 'package:shearose/models/product.dart';

class CartItem {
  final String id;
  final Product product;
  final int quantity;
  final String? selectedSize;
  final String? selectedColor;
  final DateTime createdAt;
  final DateTime updatedAt;

  CartItem({
    required this.id,
    required this.product,
    required this.quantity,
    this.selectedSize,
    this.selectedColor,
    required this.createdAt,
    required this.updatedAt,
  });

  double get totalPrice => product.price * quantity;

  Map<String, dynamic> toJson() => {
    'id': id,
    'product': product.toJson(),
    'quantity': quantity,
    'selectedSize': selectedSize,
    'selectedColor': selectedColor,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
    id: json['id'],
    product: Product.fromJson(json['product']),
    quantity: json['quantity'],
    selectedSize: json['selectedSize'],
    selectedColor: json['selectedColor'],
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
  );

  CartItem copyWith({String? id, Product? product, int? quantity, String? selectedSize, String? selectedColor, DateTime? createdAt, DateTime? updatedAt}) => CartItem(
    id: id ?? this.id,
    product: product ?? this.product,
    quantity: quantity ?? this.quantity,
    selectedSize: selectedSize ?? this.selectedSize,
    selectedColor: selectedColor ?? this.selectedColor,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
