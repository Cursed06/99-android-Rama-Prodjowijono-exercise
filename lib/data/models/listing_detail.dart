import '../../core/error/app_exception.dart';
import 'listing.dart';

/// Detailed domain model for a single listing page.
class ListingDetail {
  /// Unique listing identifier.
  final int id;

  /// Project or building name (e.g. "Parkview Apartments").
  final String projectName;

  /// Remote URL for hero photo.
  final String photoUrl;

  /// Full text description of the listing.
  final String description;

  /// Comprehensive address including display title, subtitle, and coordinates.
  final DetailAddress address;

  /// Physical attributes (beds, baths, area size, price).
  final Attributes attributes;

  /// Dynamic list of specification rows (label and value).
  final List<PropertyDetailItem> propertyDetails;

  const ListingDetail({
    required this.id,
    required this.projectName,
    required this.photoUrl,
    required this.description,
    required this.address,
    required this.attributes,
    required this.propertyDetails,
  });

  /// Defensive JSON deserializer mapping Firebase detail payloads.
  factory ListingDetail.fromJson(Map<String, dynamic> json) {
    try {
      final rawDetails = json['property_details'];
      final List<PropertyDetailItem> items;
      if (rawDetails is List) {
        items = rawDetails
            .map((e) => PropertyDetailItem.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        items = const [];
      }

      return ListingDetail(
        id: (json['id'] as num).toInt(),
        projectName: json['project_name'] as String,
        photoUrl: json['photo'] as String,
        description: json['description'] as String? ?? '',
        address: DetailAddress.fromJson(json['address'] as Map<String, dynamic>),
        attributes: Attributes.fromJson(json['attributes'] as Map<String, dynamic>),
        propertyDetails: items,
      );
    } catch (e) {
      throw ParseException('Failed to parse ListingDetail: $e', e);
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ListingDetail &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          projectName == other.projectName &&
          photoUrl == other.photoUrl &&
          description == other.description &&
          address == other.address &&
          attributes == other.attributes;

  @override
  int get hashCode => Object.hash(
        id,
        projectName,
        photoUrl,
        description,
        address,
        attributes,
      );
}

/// Address representation with map coordinates for listing detail.
class DetailAddress {
  /// Primary title (e.g. "1 Keppel Bay View · Condo for Rent").
  final String title;

  /// Secondary subtitle (e.g. "Telok Blangah / Harbourfront (D4)").
  final String subtitle;

  /// Geographical latitude and longitude coordinates.
  final MapCoordinates mapCoordinates;

  const DetailAddress({
    required this.title,
    required this.subtitle,
    required this.mapCoordinates,
  });

  /// Factory constructor to parse [DetailAddress] from JSON.
  factory DetailAddress.fromJson(Map<String, dynamic> json) {
    try {
      return DetailAddress(
        title: json['title'] as String,
        subtitle: json['subtitle'] as String,
        mapCoordinates: MapCoordinates.fromJson(
            json['map_coordinates'] as Map<String, dynamic>),
      );
    } catch (e) {
      throw ParseException('Failed to parse DetailAddress: $e', e);
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DetailAddress &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          subtitle == other.subtitle &&
          mapCoordinates == other.mapCoordinates;

  @override
  int get hashCode => Object.hash(title, subtitle, mapCoordinates);
}

/// Latitude and longitude coordinates for map pinning.
class MapCoordinates {
  /// Latitude double coordinate.
  final double lat;

  /// Longitude double coordinate.
  final double lng;

  const MapCoordinates({
    required this.lat,
    required this.lng,
  });

  /// Factory constructor parsing floating-point coordinates defensively.
  factory MapCoordinates.fromJson(Map<String, dynamic> json) {
    try {
      return MapCoordinates(
        lat: (json['lat'] as num).toDouble(),
        lng: (json['lng'] as num).toDouble(),
      );
    } catch (e) {
      throw ParseException('Failed to parse MapCoordinates: $e', e);
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MapCoordinates &&
          runtimeType == other.runtimeType &&
          lat == other.lat &&
          lng == other.lng;

  @override
  int get hashCode => Object.hash(lat, lng);
}

/// Key-value specification item (e.g., "Price/sqft" -> "$1,420 psf").
class PropertyDetailItem {
  /// Left column label.
  final String label;

  /// Right column value.
  final String text;

  const PropertyDetailItem({
    required this.label,
    required this.text,
  });

  /// Factory constructor parsing dynamic property detail entries.
  factory PropertyDetailItem.fromJson(Map<String, dynamic> json) {
    try {
      return PropertyDetailItem(
        label: json['label'] as String,
        text: json['text'] as String,
      );
    } catch (e) {
      throw ParseException('Failed to parse PropertyDetailItem: $e', e);
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PropertyDetailItem &&
          runtimeType == other.runtimeType &&
          label == other.label &&
          text == other.text;

  @override
  int get hashCode => Object.hash(label, text);
}
