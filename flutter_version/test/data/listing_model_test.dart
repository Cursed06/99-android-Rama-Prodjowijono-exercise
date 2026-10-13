import 'package:flutter_test/flutter_test.dart';
import 'package:ninety_nine_exercise/core/error/app_exception.dart';
import 'package:ninety_nine_exercise/data/models/listing.dart';

void main() {
  group('Listing.fromJson', () {
    const validJson = {
      'id': 0,
      'project_name': 'Parkview Apartments',
      'photo': 'https://picsum.photos/id/10/450/300',
      'category': 'Condo',
      'completed_at': '2020',
      'tenure': 99,
      'address': {
        'district': 'D13',
        'street_name': '12 Meyappa Chettiar Rd',
      },
      'attributes': {
        'area_size': 2561,
        'bathrooms': 2,
        'bedrooms': 3,
        'price': 2561,
      },
    };

    test('parses valid Firebase listing JSON correctly', () {
      final listing = Listing.fromJson(validJson);

      expect(listing.id, 0);
      expect(listing.projectName, 'Parkview Apartments');
      expect(listing.photoUrl, 'https://picsum.photos/id/10/450/300');
      expect(listing.category, 'Condo');
      expect(listing.completedAt, '2020');
      expect(listing.tenure, 99);
      expect(listing.address.district, 'D13');
      expect(listing.address.streetName, '12 Meyappa Chettiar Rd');
      expect(listing.attributes.areaSize, 2561);
      expect(listing.attributes.bathrooms, 2);
      expect(listing.attributes.bedrooms, 3);
      expect(listing.attributes.price, 2561);
    });

    test('defensively parses numbers arriving as floating-point doubles', () {
      final jsonWithDoubles = Map<String, dynamic>.from(validJson);
      jsonWithDoubles['id'] = 0.0;
      jsonWithDoubles['tenure'] = 99.0;
      jsonWithDoubles['completed_at'] = 2020; // number converted to string
      jsonWithDoubles['attributes'] = {
        'area_size': 2561.0,
        'bathrooms': 2.0,
        'bedrooms': 3.0,
        'price': 2561.0,
      };

      final listing = Listing.fromJson(jsonWithDoubles);

      expect(listing.id, 0);
      expect(listing.tenure, 99);
      expect(listing.completedAt, '2020');
      expect(listing.attributes.areaSize, 2561);
      expect(listing.attributes.bathrooms, 2);
    });

    test('throws ParseException when required keys are missing', () {
      final malformedJson = {
        'id': 0,
        // missing project_name, photo, etc.
      };

      expect(
        () => Listing.fromJson(malformedJson),
        throwsA(isA<ParseException>()),
      );
    });

    test('throws ParseException when nested address is invalid', () {
      final jsonWithBadAddress = Map<String, dynamic>.from(validJson);
      jsonWithBadAddress['address'] = {'street_name': 123}; // wrong type

      expect(
        () => Listing.fromJson(jsonWithBadAddress),
        throwsA(isA<ParseException>()),
      );
    });
  });
}
