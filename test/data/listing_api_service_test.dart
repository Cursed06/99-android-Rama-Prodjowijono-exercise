import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:ninety_nine_exercise/core/constants/api_constants.dart';
import 'package:ninety_nine_exercise/core/error/app_exception.dart';
import 'package:ninety_nine_exercise/data/services/listing_api_service.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late MockHttpClient mockClient;
  late ListingApiService apiService;

  setUp(() {
    mockClient = MockHttpClient();
    apiService = ListingApiService(mockClient);
    registerFallbackValue(Uri());
  });

  group('ListingApiService.fetchListings', () {
    final listingsUri =
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.listingsPath}');

    const sampleListingsJson = '''
    [
      {
        "id": 0,
        "project_name": "Parkview Apartments",
        "photo": "https://picsum.photos/id/10/450/300",
        "category": "Condo",
        "completed_at": "2020",
        "tenure": 99,
        "address": { "district": "D13", "street_name": "12 Meyappa Chettiar Rd" },
        "attributes": { "area_size": 2561, "bathrooms": 2, "bedrooms": 3, "price": 2561 }
      }
    ]
    ''';

    test('returns list of listings when response is 200 OK', () async {
      when(() => mockClient.get(listingsUri))
          .thenAnswer((_) async => http.Response(sampleListingsJson, 200));

      final result = await apiService.fetchListings();

      expect(result.length, 1);
      expect(result.first.id, 0);
      expect(result.first.projectName, 'Parkview Apartments');
    });

    test('throws NetworkException when server returns HTTP 500', () async {
      when(() => mockClient.get(listingsUri))
          .thenAnswer((_) async => http.Response('Internal Server Error', 500));

      expect(
        () => apiService.fetchListings(),
        throwsA(isA<NetworkException>().having(
          (e) => e.message,
          'message',
          contains('500'),
        )),
      );
    });

    test('throws NetworkException when SocketException occurs', () async {
      when(() => mockClient.get(listingsUri))
          .thenThrow(const SocketException('Failed host lookup'));

      expect(
        () => apiService.fetchListings(),
        throwsA(isA<NetworkException>().having(
          (e) => e.message,
          'message',
          contains('No internet'),
        )),
      );
    });

    test('throws NetworkException when request times out', () async {
      when(() => mockClient.get(listingsUri))
          .thenThrow(TimeoutException('Connection timed out'));

      expect(
        () => apiService.fetchListings(),
        throwsA(isA<NetworkException>().having(
          (e) => e.message,
          'message',
          contains('timed out'),
        )),
      );
    });

    test('throws ParseException when response is not a JSON list', () async {
      when(() => mockClient.get(listingsUri))
          .thenAnswer((_) async => http.Response('{"error": "not a list"}', 200));

      expect(
        () => apiService.fetchListings(),
        throwsA(isA<ParseException>()),
      );
    });
  });

  group('ListingApiService.fetchListingDetail', () {
    final detailUri =
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.detailPath(0)}');

    const sampleDetailJson = '''
    {
      "id": 0,
      "project_name": "Parkview Apartments",
      "photo": "https://picsum.photos/id/10/450/300",
      "description": "Sit back and enjoy panorama views...",
      "address": {
        "title": "1 Keppel Bay View · Condo for Rent",
        "subtitle": "Telok Blangah / Harbourfront (D4)",
        "map_coordinates": { "lat": 1.3884286902614, "lng": 103.87432292478 }
      },
      "attributes": { "area_size": 2561, "bathrooms": 2, "bedrooms": 3, "price": 2561 },
      "property_details": [
        { "label": "Price/sqft", "text": "\$1,420 psf" }
      ]
    }
    ''';

    test('returns listing detail when response is 200 OK', () async {
      when(() => mockClient.get(detailUri))
          .thenAnswer((_) async => http.Response(sampleDetailJson, 200));

      final detail = await apiService.fetchListingDetail(0);

      expect(detail.id, 0);
      expect(detail.address.title, '1 Keppel Bay View · Condo for Rent');
    });

    test('throws NotFoundException when Firebase returns null for missing key', () async {
      when(() => mockClient.get(detailUri))
          .thenAnswer((_) async => http.Response('null', 200));

      expect(
        () => apiService.fetchListingDetail(0),
        throwsA(isA<NotFoundException>()),
      );
    });
  });
}
