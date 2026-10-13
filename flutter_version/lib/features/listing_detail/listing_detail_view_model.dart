import 'package:flutter/foundation.dart';
import '../../core/error/app_exception.dart';
import '../../core/state/ui_state.dart';
import '../../data/models/listing_detail.dart';
import '../../data/repositories/listing_repository.dart';

/// ViewModel managing state and business logic for the Listing Detail screen.
///
/// Encapsulates retrieval of full listing metadata by [listingId],
/// error handling, and description expansion toggling.
class ListingDetailViewModel extends ChangeNotifier {
  final ListingRepository _repository;

  /// Identifier of the listing to fetch and display.
  final int listingId;

  UiState<ListingDetail> _state = const Loading();

  /// Current visual state of the listing detail screen.
  UiState<ListingDetail> get state => _state;

  bool _isDescriptionExpanded = false;

  /// Whether the full description text is expanded or clamped to 5 lines.
  bool get isDescriptionExpanded => _isDescriptionExpanded;

  /// Creates a [ListingDetailViewModel] with injected repository and [listingId].
  ListingDetailViewModel(this._repository, this.listingId);

  /// Toggles the description between clamped (5 lines) and fully expanded.
  void toggleDescription() {
    _isDescriptionExpanded = !_isDescriptionExpanded;
    notifyListeners();
  }

  /// Loads full listing details by transitioning to [Loading] and querying repository.
  Future<void> load() async {
    _state = const Loading();
    notifyListeners();

    try {
      final detail = await _repository.getListingDetail(listingId);
      _state = Success(detail);
    } on AppException catch (e) {
      _state = Failure(e.message, e);
    } catch (e) {
      _state = Failure('Failed to load listing details: $e', e);
    }
    notifyListeners();
  }
}
