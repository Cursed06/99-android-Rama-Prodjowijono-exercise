import 'package:flutter_test/flutter_test.dart';
import 'package:ninety_nine_exercise/core/error/app_exception.dart';
import 'package:ninety_nine_exercise/data/models/listing_detail.dart';

void main() {
  group('ListingDetail.fromJson', () {
    const validJson = {
      'id': 0,
      'project_name': 'Parkview Apartments',
      'photo': 'https://picsum.photos/id/10/450/300',
      'description': 'Sit back and enjoy panorama views...',
      'address': {
        'title': '1 Keppel Bay View · Condo for Rent',
        'subtitle': 'Telok Blangah / Harbourfront (D4)',
        'map_coordinates': {
          'lat': 1.3884286902614,
          'lng': 103.87432292478,
        },
      },
      'attributes': {
        'area_size': 2561,
        'bathrooms': 2,
        'bedrooms': 3,
        'price': 2561,
      },
      'property_details': [
        {'label': 'Price/sqft', 'text': '\$1,420 psf'},
        {'label': 'Floor Level', 'text': 'Mid'},
      ],
    };

    test('parses valid Firebase listing detail JSON successfully', () {
      final detail = ListingDetail.fromJson(validJson);

      expect(detail.id, 0);
      expect(detail.projectName, 'Parkview Apartments');
      expect(detail.photoUrl, 'https://picsum.photos/id/10/450/300');
      expect(detail.description, 'Sit back and enjoy panorama views...');
      expect(detail.address.title, '1 Keppel Bay View · Condo for Rent');
      expect(detail.address.subtitle, 'Telok Blangah / Harbourfront (D4)');
      expect(detail.address.mapCoordinates.lat, 1.3884286902614);
      expect(detail.address.mapCoordinates.lng, 103.87432292478);
      expect(detail.attributes.price, 2561);
      expect(detail.propertyDetails.length, 2);
      expect(detail.propertyDetails.first.label, 'Price/sqft');
      expect(detail.propertyDetails.first.text, '\$1,420 psf');
    });

    test('handles missing or empty property_details gracefully', () {
      final jsonWithoutDetails = Map<String, dynamic>.from(validJson);
      jsonWithoutDetails.remove('property_details');

      final detail = ListingDetail.fromJson(jsonWithoutDetails);

      expect(detail.propertyDetails, isEmpty);
    });

    test('throws ParseException when coordinates are malformed', () {
      final jsonWithBadCoords = Map<String, dynamic>.from(validJson);
      jsonWithBadCoords['address'] = {
        'title': 'Test',
        'subtitle': 'Test Sub',
        'map_coordinates': {'lat': 'not_a_number'},
      };

      expect(
        () => ListingDetail.fromJson(jsonWithBadCoords),
        throwsA(isA<ParseException>()),
      );
    });
  });
}
