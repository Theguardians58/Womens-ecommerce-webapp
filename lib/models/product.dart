class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String categoryId;
  final List<String> images;
  final List<String> sizes;
  final List<String> colors;
  final double rating;
  final int reviewCount;
  final bool isNew;
  final bool isFeatured;
  final DateTime createdAt;
  final DateTime updatedAt;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.categoryId,
    required this.images,
    required this.sizes,
    required this.colors,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.isNew = false,
    this.isFeatured = false,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'price': price,
    'categoryId': categoryId,
    'images': images,
    'sizes': sizes,
    'colors': colors,
    'rating': rating,
    'reviewCount': reviewCount,
    'isNew': isNew,
    'isFeatured': isFeatured,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    price: json['price'].toDouble(),
    categoryId: json['categoryId'],
    images: List<String>.from(json['images']),
    sizes: List<String>.from(json['sizes']),
    colors: List<String>.from(json['colors']),
    rating: json['rating'].toDouble(),
    reviewCount: json['reviewCount'],
    isNew: json['isNew'] ?? false,
    isFeatured: json['isFeatured'] ?? false,
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
  );

  Product copyWith({String? id, String? name, String? description, double? price, String? categoryId, List<String>? images, List<String>? sizes, List<String>? colors, double? rating, int? reviewCount, bool? isNew, bool? isFeatured, DateTime? createdAt, DateTime? updatedAt}) => Product(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description ?? this.description,
    price: price ?? this.price,
    categoryId: categoryId ?? this.categoryId,
    images: images ?? this.images,
    sizes: sizes ?? this.sizes,
    colors: colors ?? this.colors,
    rating: rating ?? this.rating,
    reviewCount: reviewCount ?? this.reviewCount,
    isNew: isNew ?? this.isNew,
    isFeatured: isFeatured ?? this.isFeatured,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
