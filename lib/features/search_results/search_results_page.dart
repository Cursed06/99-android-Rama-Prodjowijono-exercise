import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/state/ui_state.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/empty_view.dart';
import '../../core/widgets/error_view.dart';
import '../../core/widgets/loading_view.dart';
import '../../data/models/listing.dart';
import '../../di/service_locator.dart';
import 'search_results_view_model.dart';
import 'widgets/listing_card.dart';

/// Search Results page displaying property listings fetched from remote API.
class SearchResultsPage extends StatelessWidget {
  /// Optional injected ViewModel, allowing direct mocking in widget tests.
  final SearchResultsViewModel? viewModel;

  /// Callback executed when the user taps on a listing card.
  final ValueChanged<int>? onListingSelected;

  const SearchResultsPage({
    super.key,
    this.viewModel,
    this.onListingSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (viewModel != null) {
      return ChangeNotifierProvider<SearchResultsViewModel>.value(
        value: viewModel!,
        child: _SearchResultsView(onListingSelected: onListingSelected),
      );
    }
    return ChangeNotifierProvider<SearchResultsViewModel>(
      create: (_) => getIt<SearchResultsViewModel>()..load(),
      child: _SearchResultsView(onListingSelected: onListingSelected),
    );
  }
}

class _SearchResultsView extends StatelessWidget {
  final ValueChanged<int>? onListingSelected;

  const _SearchResultsView({this.onListingSelected});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SearchResultsViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results', style: AppTextStyles.screenTitle),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Divider(height: 1.0, color: AppColors.divider),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppSpacing.maxContentWidth,
          ),
          child: switch (viewModel.state) {
            Loading() => const LoadingView(),
            Failure(:final message) => ErrorView(
                message: message,
                onRetry: viewModel.load,
              ),
            Success(:final data) => data.isEmpty
                ? EmptyView(onRetry: viewModel.load)
                : _ListingList(
                    listings: data,
                    onRefresh: viewModel.refresh,
                    onListingSelected: onListingSelected,
                  ),
          },
        ),
      ),
    );
  }
}

class _ListingList extends StatelessWidget {
  final List<Listing> listings;
  final Future<void> Function() onRefresh;
  final ValueChanged<int>? onListingSelected;

  const _ListingList({
    required this.listings,
    required this.onRefresh,
    this.onListingSelected,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.accent,
      onRefresh: onRefresh,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.cardHorizontal,
          vertical: AppSpacing.lg,
        ),
        itemCount: listings.length,
        separatorBuilder: (context, index) =>
            const SizedBox(height: AppSpacing.cardGap),
        itemBuilder: (context, index) {
          final listing = listings[index];
          return ListingCard(
            listing: listing,
            onTap: () => onListingSelected?.call(listing.id),
          );
        },
      ),
    );
  }
}
