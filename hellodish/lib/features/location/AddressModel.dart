class AddressModel {
  final String id;
  final String addressType;
  final String address;
  final String latitude;
  final String longitude;
  final String userId;
  final String contactPersonName;
  final String contactPersonNumber;
  final String countryCode;
  final String? floor;
  final String? road;
  final String? house;
  final String? zoneId;

  AddressModel({
    required this.id,
    required this.addressType,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.userId,
    required this.contactPersonName,
    required this.contactPersonNumber,
    required this.countryCode,
    this.floor,
    this.road,
    this.house,
    this.zoneId,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id']?.toString() ?? '',
      addressType: json['addressType'] ?? 'other',
      address: json['address'] ?? '',
      latitude: json['latitude']?.toString() ?? '',
      longitude: json['longitude']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      contactPersonName: json['contactPersonName'] ?? '',
      contactPersonNumber: json['contactPersonNumber'] ?? '',
      countryCode: json['countryCode'] ?? '+91',
      floor: json['floor'],
      road: json['road'],
      house: json['house'],
      zoneId: json['zoneId']?.toString(),
    );
  }

  /// Returns emoji + label based on addressType
  String get typeLabel {
    switch (addressType.toLowerCase()) {
      case 'home':
        return '🏠 Home';
      case 'work':
        return '💼 Work';
      case 'hotel':
        return '🏨 Hotel';
      default:
        return '🏢 Other';
    }
  }

  String get typeEmoji {
    switch (addressType.toLowerCase()) {
      case 'home':
        return '🏠';
      case 'work':
        return '💼';
      case 'hotel':
        return '🏨';
      default:
        return '🏢';
    }
  }

  /// Short display address (first meaningful part)
  String get shortAddress {
    final parts = address.split(',');
    if (parts.length >= 2) {
      return '${parts[0].trim()}, ${parts[1].trim()}';
    }
    return address;
  }
}