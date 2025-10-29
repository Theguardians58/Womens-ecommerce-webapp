import 'package:shearose/models/cart_item.dart';

class Order {
  final String id;
  final String userId;
  final List<CartItem> items;
  final double totalAmount;
  final String status;
  final String? shippingAddress;
  final DateTime createdAt;
  final DateTime updatedAt;

  Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.status,
    this.shippingAddress,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'items': items.map((e) => e.toJson()).toList(),
    'totalAmount': totalAmount,
    'status': status,
    'shippingAddress': shippingAddress,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    id: json['id'],
    userId: json['userId'],
    items: (json['items'] as List).map((e) => CartItem.fromJson(e)).toList(),
    totalAmount: json['totalAmount'].toDouble(),
    status: json['status'],
    shippingAddress: json['shippingAddress'],
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
  );

  Order copyWith({String? id, String? userId, List<CartItem>? items, double? totalAmount, String? status, String? shippingAddress, DateTime? createdAt, DateTime? updatedAt}) => Order(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    items: items ?? this.items,
    totalAmount: totalAmount ?? this.totalAmount,
    status: status ?? this.status,
    shippingAddress: shippingAddress ?? this.shippingAddress,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
