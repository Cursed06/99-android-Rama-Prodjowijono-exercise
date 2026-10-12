import '../models/listing.dart';
import '../models/listing_detail.dart';
import '../services/listing_api_service.dart';
import 'listing_repository.dart';

/// Concrete implementation of [ListingRepository] backed by [ListingApiService].
///
/// In this exercise, it delegates directly to remote endpoints. In a production
/// application, this layer would also manage local cache policies, offline sync,
/// and data transformation.
class ListingRepositoryImpl implements ListingRepository {
  final ListingApiService _apiService;

  /// Creates a [ListingRepositoryImpl] with the required [ListingApiService].
  ListingRepositoryImpl(this._apiService);

  @override
  Future<List<Listing>> getListings() => _apiService.fetchListings();

  @override
  Future<ListingDetail> getListingDetail(int id) =>
      _apiService.fetchListingDetail(id);
}
