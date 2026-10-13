import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ninety_nine_exercise/core/theme/app_theme.dart';
import 'package:ninety_nine_exercise/data/models/listing.dart';
import 'package:ninety_nine_exercise/data/models/listing_detail.dart';
import 'package:ninety_nine_exercise/data/repositories/listing_repository.dart';
import 'package:ninety_nine_exercise/features/listing_detail/listing_detail_page.dart';
import 'package:ninety_nine_exercise/features/listing_detail/listing_detail_view_model.dart';
import 'package:ninety_nine_exercise/features/search_results/search_results_page.dart';
import 'package:ninety_nine_exercise/features/search_results/search_results_view_model.dart';

class MockListingRepository extends Mock implements ListingRepository {}

void main() {
  late MockListingRepository mockRepository;

  const sampleListing = Listing(
    id: 1,
    projectName: 'Marina Bay Suites',
    photoUrl: 'https://example.com/photo.jpg',
    category: 'Condo',
    completedAt: '2022',
    tenure: 99,
    address: Address(district: 'D01', streetName: '2 Keppel Way'),
    attributes: Attributes(areaSize: 1800, bathrooms: 2, bedrooms: 3, price: 6500),
  );

  const sampleDetail = ListingDetail(
    id: 1,
    projectName: 'Marina Bay Suites',
    photoUrl: 'https://example.com/photo.jpg',
    description: 'Luxury bayfront living.',
    address: DetailAddress(
      title: '2 Keppel Way · Condo for Rent',
      subtitle: 'Marina Bay / Downtown (D01)',
      mapCoordinates: MapCoordinates(lat: 1.28, lng: 103.85),
    ),
    attributes: Attributes(areaSize: 1800, bathrooms: 2, bedrooms: 3, price: 6500),
    propertyDetails: [
      PropertyDetailItem(label: 'Price/sqft', text: '\$3,611 psf'),
    ],
  );

  setUp(() {
    mockRepository = MockListingRepository();
    when(() => mockRepository.getListings())
        .thenAnswer((_) async => [sampleListing]);
    when(() => mockRepository.getListingDetail(1))
        .thenAnswer((_) async => sampleDetail);
  });

  testWidgets('full user navigation flow: list -> tap card -> detail -> back to list', (tester) async {
    final searchViewModel = SearchResultsViewModel(mockRepository);

    await tester.pumpWidget(
      MaterialApp(
        navigatorKey: navigatorKey,
        theme: AppTheme.light,
        home: SearchResultsPage(
          viewModel: searchViewModel,
          onListingSelected: (id) {
            // Test default navigation behaviour with mock repository
            final detailViewModel = ListingDetailViewModel(mockRepository, id);
            detailViewModel.load();
            navigatorKey.currentState?.push(
              MaterialPageRoute<void>(
                builder: (_) => ListingDetailPage(
                  listingId: id,
                  viewModel: detailViewModel,
                ),
              ),
            );
          },
        ),
      ),
    );

    // Initial load
    await searchViewModel.load();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Verify search card is displayed
    expect(find.text('Marina Bay Suites'), findsOneWidget);
    expect(find.text('\$6,500/mo'), findsOneWidget);

    // Tap card
    await tester.tap(find.text('Marina Bay Suites'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Verify we navigated to Detail page
    expect(find.text('2 Keppel Way · Condo for Rent'), findsOneWidget);
    expect(find.text('Luxury bayfront living.'), findsOneWidget);
    expect(find.text('\$3.61 psf'), findsOneWidget);

    // Tap back button
    await tester.tap(find.byTooltip('Back'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Verify we returned to the list
    expect(find.text('Search Results'), findsOneWidget);
    expect(find.text('\$6,500/mo'), findsOneWidget);
  });
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
