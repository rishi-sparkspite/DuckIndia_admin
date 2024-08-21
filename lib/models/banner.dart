import 'category.dart';

class BannerModel {
  final String id;
  final String imageUrl;
  final Category? category;

  BannerModel({
    required this.id,
    required this.imageUrl,
    this.category, // Make category optional
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['_id'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      category:
          json['category'] != null ? Category.fromJson(json['category']) : null,
    );
  }
}
