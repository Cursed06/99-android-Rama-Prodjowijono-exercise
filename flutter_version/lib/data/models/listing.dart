import '../../core/error/app_exception.dart';

/// Immutable domain model representing a single property listing in search results.
class Listing {
  /// Unique listing identifier.
  final int id;

  /// Display name of the building or project (e.g. "Parkview Apartments").
  final String projectName;

  /// Remote URL for the primary preview photograph.
  final String photoUrl;

  /// Property category (e.g. "Condo", "Apartment").
  final String category;

  /// Year or date of completion (e.g. "2020").
  final String completedAt;

  /// Lease tenure duration in years (e.g. 99).
  final int tenure;

  /// Address details including street and district.
  final Address address;

  /// Key specifications including pricing, bed/bath count, and area.
  final Attributes attributes;

  const Listing({
    required this.id,
    required this.projectName,
    required this.photoUrl,
    required this.category,
    required this.completedAt,
    required this.tenure,
    required this.address,
    required this.attributes,
  });

  /// Defensive JSON deserializer mapping Firebase listing objects.
  factory Listing.fromJson(Map<String, dynamic> json) {
    try {
      return Listing(
        id: (json['id'] as num).toInt(),
        projectName: json['project_name'] as String,
        photoUrl: json['photo'] as String,
        category: json['category'] as String,
        completedAt: json['completed_at'].toString(),
        tenure: (json['tenure'] as num).toInt(),
        address: Address.fromJson(json['address'] as Map<String, dynamic>),
        attributes: Attributes.fromJson(json['attributes'] as Map<String, dynamic>),
      );
    } catch (e) {
      throw ParseException('Failed to parse Listing: $e', e);
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Listing &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          projectName == other.projectName &&
          photoUrl == other.photoUrl &&
          category == other.category &&
          completedAt == other.completedAt &&
          tenure == other.tenure &&
          address == other.address &&
          attributes == other.attributes;

  @override
  int get hashCode => Object.hash(
        id,
        projectName,
        photoUrl,
        category,
        completedAt,
        tenure,
        address,
        attributes,
      );
}

/// Address details for a property listing.
class Address {
  /// Street address name (e.g. "12 Meyappa Chettiar Rd").
  final String streetName;

  /// District code (e.g. "D13").
  final String district;

  const Address({
    required this.streetName,
    required this.district,
  });

  /// Factory constructor to parse [Address] from JSON.
  factory Address.fromJson(Map<String, dynamic> json) {
    try {
      return Address(
        streetName: json['street_name'] as String,
        district: json['district'] as String,
      );
    } catch (e) {
      throw ParseException('Failed to parse Address: $e', e);
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Address &&
          runtimeType == other.runtimeType &&
          streetName == other.streetName &&
          district == other.district;

  @override
  int get hashCode => Object.hash(streetName, district);
}

/// Physical property attributes and pricing.
class Attributes {
  /// Floor area size in square feet (e.g. 2561).
  final int areaSize;

  /// Number of bathrooms.
  final int bathrooms;

  /// Number of bedrooms.
  final int bedrooms;

  /// Rental price per month (e.g. 2561).
  final int price;

  const Attributes({
    required this.areaSize,
    required this.bathrooms,
    required this.bedrooms,
    required this.price,
  });

  /// Factory constructor parsing numeric fields defensively.
  factory Attributes.fromJson(Map<String, dynamic> json) {
    try {
      return Attributes(
        areaSize: (json['area_size'] as num).toInt(),
        bathrooms: (json['bathrooms'] as num).toInt(),
        bedrooms: (json['bedrooms'] as num).toInt(),
        price: (json['price'] as num).toInt(),
      );
    } catch (e) {
      throw ParseException('Failed to parse Attributes: $e', e);
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Attributes &&
          runtimeType == other.runtimeType &&
          areaSize == other.areaSize &&
          bathrooms == other.bathrooms &&
          bedrooms == other.bedrooms &&
          price == other.price;

  @override
  int get hashCode => Object.hash(areaSize, bathrooms, bedrooms, price);
}
