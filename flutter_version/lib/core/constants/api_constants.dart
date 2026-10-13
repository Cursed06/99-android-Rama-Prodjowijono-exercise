/// Application-wide API constants including endpoint URLs and timeout settings.
abstract final class ApiConstants {
  /// Base URL of the Firebase Realtime Database REST API.
  static const String baseUrl =
      'https://ninetyninedotco-b7299.asia-southeast1.firebasedatabase.app';

  /// Path to retrieve the list of property listings.
  static const String listingsPath = '/listings.json';

  /// Helper method to construct the path for fetching details of a specific listing.
  static String detailPath(int id) => '/details/$id.json';

  /// Default timeout duration for all network calls (10 seconds).
  static const Duration timeout = Duration(seconds: 10);
}
