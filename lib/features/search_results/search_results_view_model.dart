import 'package:flutter/foundation.dart';
import '../../core/error/app_exception.dart';
import '../../core/state/ui_state.dart';
import '../../data/models/listing.dart';
import '../../data/repositories/listing_repository.dart';

/// ViewModel managing state and business logic for the Search Results screen.
///
/// Follows the MVVM pattern by exposing an immutable [UiState] to observing
/// widgets and coordinating asynchronous data retrieval from [ListingRepository].
class SearchResultsViewModel extends ChangeNotifier {
  final ListingRepository _repository;

  UiState<List<Listing>> _state = const Loading();

  /// Current visual state of the listings search screen.
  UiState<List<Listing>> get state => _state;

  /// Creates a [SearchResultsViewModel] with an injected [ListingRepository].
  SearchResultsViewModel(this._repository);

  /// Loads listings by transitioning to [Loading] and querying the repository.
  Future<void> load() async {
    _state = const Loading();
    notifyListeners();

    await _fetchListings();
  }

  /// Refreshes listings (e.g. from pull-to-refresh) without resetting to full-screen loading.
  Future<void> refresh() async {
    await _fetchListings();
  }

  /// Internal helper to execute the data query and map exceptions to UI failure states.
  Future<void> _fetchListings() async {
    try {
      final listings = await _repository.getListings();
      _state = Success(listings);
    } on AppException catch (e) {
      _state = Failure(e.message, e);
    } catch (e) {
      _state = Failure('An unexpected error occurred: $e', e);
    }
    notifyListeners();
  }
}
