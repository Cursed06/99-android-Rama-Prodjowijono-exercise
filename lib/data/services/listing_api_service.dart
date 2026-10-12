import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../core/constants/api_constants.dart';
import '../../core/error/app_exception.dart';
import '../models/listing.dart';
import '../models/listing_detail.dart';

/// Remote HTTP service responsible for executing network calls and parsing responses.
class ListingApiService {
  final http.Client _client;

  /// Creates a [ListingApiService] with an injected [http.Client].
  ListingApiService(this._client);

  /// Fetches the list of all property listings.
  ///
  /// Throws [NetworkException] if connection fails or status code is non-200.
  /// Throws [ParseException] if the response body is not a JSON list or items are malformed.
  Future<List<Listing>> fetchListings() async {
    final response = await _get('${ApiConstants.baseUrl}${ApiConstants.listingsPath}');
    final dynamic data = _decodeJson(response.body);

    if (data is! List) {
      throw const ParseException('Expected a list of listings from API');
    }

    return data
        .map((item) => Listing.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Fetches detailed information for a specific listing by [id].
  ///
  /// Throws [NotFoundException] if Firebase returns `null` for a missing key.
  /// Throws [NetworkException] on transport/timeout errors.
  /// Throws [ParseException] if the response format is unexpected.
  Future<ListingDetail> fetchListingDetail(int id) async {
    final response = await _get('${ApiConstants.baseUrl}${ApiConstants.detailPath(id)}');
    final dynamic data = _decodeJson(response.body);

    // Firebase Realtime Database returns HTTP 200 with body "null" for missing keys
    if (data == null) {
      throw const NotFoundException('Listing not found');
    }

    if (data is! Map<String, dynamic>) {
      throw const ParseException('Expected a JSON object for listing detail');
    }

    return ListingDetail.fromJson(data);
  }

  /// Internal helper to execute a GET request with timeout and error mapping.
  Future<http.Response> _get(String url) async {
    try {
      final response = await _client
          .get(Uri.parse(url))
          .timeout(ApiConstants.timeout);

      if (response.statusCode != 200) {
        throw NetworkException('HTTP error ${response.statusCode}');
      }

      return response;
    } on SocketException catch (e) {
      throw NetworkException('No internet connection', e);
    } on TimeoutException catch (e) {
      throw NetworkException('Request timed out', e);
    } on http.ClientException catch (e) {
      throw NetworkException('Network client error: ${e.message}', e);
    } on AppException {
      rethrow;
    } catch (e) {
      throw NetworkException('Unexpected network error: $e', e);
    }
  }

  /// Internal helper to safely decode JSON strings.
  dynamic _decodeJson(String body) {
    try {
      return jsonDecode(body);
    } on FormatException catch (e) {
      throw ParseException('Failed to decode JSON: ${e.message}', e);
    }
  }
}
