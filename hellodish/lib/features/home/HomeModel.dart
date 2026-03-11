// Helper: safely parse int from String, int, or null
int _parseInt(dynamic value, [int fallback = 0]) {
  if (value == null) return fallback;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value) ?? fallback;
  return fallback;
}

// Helper: safely parse double from String, num, or null
double _parseDouble(dynamic value, [double fallback = 0.0]) {
  if (value == null) return fallback;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? fallback;
  return fallback;
}

// Helper: safely parse bool from bool, int, String, or null
bool _parseBool(dynamic value, [bool fallback = true]) {
  if (value == null) return fallback;
  if (value is bool) return value;
  if (value is int) return value == 1;
  if (value is String) return value == '1' || value.toLowerCase() == 'true';
  return fallback;
}

class HomeModel {
  final List<BannerModel> banners;
  final List<CategoryModel> categories;
  final List<RestaurantModel> popularRestaurants;
  final List<RestaurantModel> allRestaurants;

  HomeModel({
    required this.banners,
    required this.categories,
    required this.popularRestaurants,
    required this.allRestaurants,
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    return HomeModel(
      banners: (data['banners'] as List<dynamic>? ?? [])
          .map((e) => BannerModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      categories: (data['categories'] as List<dynamic>? ?? [])
          .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      popularRestaurants: (data['popular_restaurants'] as List<dynamic>? ?? [])
          .map((e) => RestaurantModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      allRestaurants: (data['restaurants'] as List<dynamic>? ?? [])
          .map((e) => RestaurantModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class BannerModel {
  final int id;
  final String image;
  final String? title;
  final String? subtitle;
  final String? actionUrl;

  BannerModel({
    required this.id,
    required this.image,
    this.title,
    this.subtitle,
    this.actionUrl,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) => BannerModel(
    id: _parseInt(json['id']),
    image: json['image']?.toString() ?? '',
    title: json['title']?.toString(),
    subtitle: json['subtitle']?.toString(),
    actionUrl: json['action_url']?.toString(),
  );
}

class CategoryModel {
  final int id;
  final String name;
  final String image;
  final String? emoji;

  CategoryModel({
    required this.id,
    required this.name,
    required this.image,
    this.emoji,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    id: _parseInt(json['id']),
    name: json['name']?.toString() ?? '',
    image: json['image']?.toString() ?? '',
    emoji: json['emoji']?.toString(),
  );
}

class RestaurantModel {
  final int id;
  final String name;
  final String image;
  final String? cuisine;
  final double rating;
  final int deliveryTime;
  final String? deliveryFee;
  final bool isOpen;
  final String? distance;

  RestaurantModel({
    required this.id,
    required this.name,
    required this.image,
    this.cuisine,
    required this.rating,
    required this.deliveryTime,
    this.deliveryFee,
    required this.isOpen,
    this.distance,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) =>
      RestaurantModel(
        id: _parseInt(json['id']),
        name: json['name']?.toString() ?? '',
        image: json['image']?.toString() ?? '',
        cuisine: json['cuisine']?.toString(),
        rating: _parseDouble(json['rating']),
        deliveryTime: _parseInt(json['delivery_time'], 30),
        deliveryFee: json['delivery_fee']?.toString(),
        isOpen: _parseBool(json['is_open']),
        distance: json['distance']?.toString(),
      );
}