import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ninety_nine_exercise/data/models/listing.dart';
import 'package:ninety_nine_exercise/data/models/listing_detail.dart';
import 'package:ninety_nine_exercise/data/repositories/listing_repository_impl.dart';
import 'package:ninety_nine_exercise/data/services/listing_api_service.dart';

class MockListingApiService extends Mock implements ListingApiService {}

void main() {
  late MockListingApiService mockApiService;
  late ListingRepositoryImpl repository;

  setUp(() {
    mockApiService = MockListingApiService();
    repository = ListingRepositoryImpl(mockApiService);
  });

  group('ListingRepositoryImpl', () {
    const mockListing = Listing(
      id: 0,
      projectName: 'Test Parkview',
      photoUrl: 'https://example.com/photo.jpg',
      category: 'Condo',
      completedAt: '2020',
      tenure: 99,
      address: Address(streetName: '12 Test St', district: 'D13'),
      attributes: Attributes(areaSize: 2561, bathrooms: 2, bedrooms: 3, price: 2561),
    );

    const mockDetail = ListingDetail(
      id: 0,
      projectName: 'Test Parkview',
      photoUrl: 'https://example.com/photo.jpg',
      description: 'Test description',
      address: DetailAddress(
        title: '1 Keppel Bay',
        subtitle: 'Harbourfront',
        mapCoordinates: MapCoordinates(lat: 1.38, lng: 103.87),
      ),
      attributes: Attributes(areaSize: 2561, bathrooms: 2, bedrooms: 3, price: 2561),
      propertyDetails: [PropertyDetailItem(label: 'Floor', text: 'High')],
    );

    test('getListings delegates directly to apiService.fetchListings', () async {
      when(() => mockApiService.fetchListings())
          .thenAnswer((_) async => [mockListing]);

      final result = await repository.getListings();

      expect(result, [mockListing]);
      verify(() => mockApiService.fetchListings()).called(1);
    });

    test('getListingDetail delegates directly to apiService.fetchListingDetail', () async {
      when(() => mockApiService.fetchListingDetail(0))
          .thenAnswer((_) async => mockDetail);

      final result = await repository.getListingDetail(0);

      expect(result, mockDetail);
      verify(() => mockApiService.fetchListingDetail(0)).called(1);
    });
  });
}
