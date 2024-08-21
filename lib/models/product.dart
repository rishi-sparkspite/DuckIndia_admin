import 'category.dart';

class Variant {
  final String? size;
  final double? weight;
  final double wholesalePrice;
  final double retailPrice;

  Variant({
    this.size,
    this.weight,
    required this.wholesalePrice,
    required this.retailPrice,
  });

  factory Variant.fromJson(Map<String, dynamic> json) {
    return Variant(
      size: json['size'],
      weight: (json['weight'] as num?)?.toDouble(),
      wholesalePrice: (json['wholesalePrice'] as num).toDouble(),
      retailPrice: (json['retailPrice'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'size': size,
      'weight': weight,
      'wholesalePrice': wholesalePrice,
      'retailPrice': retailPrice,
    };
  }
}

class Product {
  final String id;
  final String name;
  final String category;
  final List<Variant> variants;
  final List<String> images;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.variants,
    required this.images,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'],
      name: json['name'],
      category: json['category'] ?? '',
      variants: (json['variants'] as List)
          .map((variant) => Variant.fromJson(variant))
          .toList(),
      images: List<String>.from(json['images']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'category': category,
      'variants': variants.map((variant) => variant.toJson()).toList(),
      'images': images,
    };
  }
}
