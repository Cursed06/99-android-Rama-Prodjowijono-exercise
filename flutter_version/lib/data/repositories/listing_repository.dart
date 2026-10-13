import '../models/listing.dart';
import '../models/listing_detail.dart';

/// Abstract repository contract for retrieving property listing data.
///
/// Decouples the presentation layer (ViewModels) from specific data sources
/// (HTTP, local cache, or mocks in unit tests).
abstract class ListingRepository {
  /// Retrieves a list of property listings.
  Future<List<Listing>> getListings();

  /// Retrieves full details for a specific listing by [id].
  Future<ListingDetail> getListingDetail(int id);
}
