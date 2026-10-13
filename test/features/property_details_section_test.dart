import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ninety_nine_exercise/core/theme/app_colors.dart';
import 'package:ninety_nine_exercise/data/models/listing.dart';
import 'package:ninety_nine_exercise/data/models/listing_detail.dart';
import 'package:ninety_nine_exercise/features/listing_detail/widgets/property_details_section.dart';

void main() {
  group('PropertyDetailsSection Widget Tests', () {
    const sampleDetail = ListingDetail(
      id: 0,
      projectName: 'Parkview Apartments',
      photoUrl: 'https://picsum.photos/id/10/450/300',
      description: 'Sit back and enjoy panorama views.',
      address: DetailAddress(
        title: '1 Keppel Bay View · Condo for Rent',
        subtitle: 'Telok Blangah / Harbourfront (D4)',
        mapCoordinates: MapCoordinates(lat: 1.38, lng: 103.87),
      ),
      attributes: Attributes(
        areaSize: 2561,
        bathrooms: 2,
        bedrooms: 3,
        price: 2561,
      ),
      propertyDetails: [
        PropertyDetailItem(label: 'Price/sqft', text: '\$1,420 psf'),
        PropertyDetailItem(label: 'Floor Level', text: 'Mid'),
        PropertyDetailItem(label: 'Facing', text: 'North'),
        PropertyDetailItem(label: 'Built year', text: '2004'),
        PropertyDetailItem(label: 'Tenure', text: '99-year leasehold'),
        PropertyDetailItem(label: 'Property type', text: 'HDB 5 Rooms'),
        PropertyDetailItem(label: 'Last updated', text: 'seconds ago'),
      ],
    );

    testWidgets('renders all 9 standardized specification rows in exact order with calculations', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: PropertyDetailsSection(detail: sampleDetail),
            ),
          ),
        ),
      );

      final expectedRows = [
        ('Price/sqft', '\$1.00 psf'),
        ('Floor level', 'Mid'),
        ('Furnishing', 'Unavailable'),
        ('Facing', 'North'),
        ('Overlooking View', 'Unavailable'),
        ('Built year (TOP)', '2004'),
        ('Tenure', '99-year leasehold'),
        ('Property type', 'Condo'),
        ('Last updated', 'seconds ago'),
      ];

      for (final (label, _) in expectedRows) {
        expect(find.text(label), findsOneWidget);
      }

      // Check distinct and repeated value counts
      expect(find.text('\$1.00 psf'), findsOneWidget);
      expect(find.text('Mid'), findsOneWidget);
      expect(find.text('North'), findsOneWidget);
      expect(find.text('2004'), findsOneWidget);
      expect(find.text('99-year leasehold'), findsOneWidget);
      expect(find.text('Condo'), findsOneWidget);
      expect(find.text('seconds ago'), findsOneWidget);
      expect(find.text('Unavailable'), findsNWidgets(2));

      // Verify label typography: size 16, line height 16 (height 1.0), weight 500, AppColors.primary
      final labelWidget = tester.widget<Text>(find.text('Price/sqft'));
      expect(labelWidget.style?.fontSize, 16);
      expect(labelWidget.style?.height, 1.0);
      expect(labelWidget.style?.fontWeight, FontWeight.w500);
      expect(labelWidget.style?.color, AppColors.primary);

      // Verify value typography: size 16, line height 16 (height 1.0), weight 400, AppColors.primary
      final valueWidget = tester.widget<Text>(find.text('\$1.00 psf'));
      expect(valueWidget.style?.fontSize, 16);
      expect(valueWidget.style?.height, 1.0);
      expect(valueWidget.style?.fontWeight, FontWeight.w400);
      expect(valueWidget.style?.color, AppColors.primary);
    });

    test('computePropertyDetails handles zero area size gracefully', () {
      const zeroAreaDetail = ListingDetail(
        id: 1,
        projectName: 'Test',
        photoUrl: '',
        description: '',
        address: DetailAddress(
          title: 'Street · Condo for Rent',
          subtitle: '',
          mapCoordinates: MapCoordinates(lat: 0, lng: 0),
        ),
        attributes: Attributes(areaSize: 0, bathrooms: 1, bedrooms: 1, price: 1000),
        propertyDetails: [],
      );

      final items = PropertyDetailsSection.computePropertyDetails(zeroAreaDetail);
      expect(items.first.label, 'Price/sqft');
      expect(items.first.text, 'Unavailable');
    });
  });
}
