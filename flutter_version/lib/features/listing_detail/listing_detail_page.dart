import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/state/ui_state.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/error_view.dart';
import '../../core/widgets/loading_view.dart';
import '../../data/models/listing_detail.dart';
import '../../di/service_locator.dart';
import 'listing_detail_view_model.dart';
import 'widgets/detail_hero.dart';
import 'widgets/expandable_description.dart';
import 'widgets/price_header.dart';
import 'widgets/property_details_section.dart';

/// Screen displaying comprehensive details and specifications for a listing.
class ListingDetailPage extends StatelessWidget {
  /// Unique listing identifier.
  final int listingId;

  /// Optional injected ViewModel for testing.
  final ListingDetailViewModel? viewModel;

  const ListingDetailPage({
    super.key,
    required this.listingId,
    this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    if (viewModel != null) {
      return ChangeNotifierProvider<ListingDetailViewModel>.value(
        value: viewModel!,
        child: const _ListingDetailView(),
      );
    }
    return ChangeNotifierProvider<ListingDetailViewModel>(
      create: (_) => getIt<ListingDetailViewModel>(param1: listingId)..load(),
      child: const _ListingDetailView(),
    );
  }
}

class _ListingDetailView extends StatelessWidget {
  const _ListingDetailView();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ListingDetailViewModel>();

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: switch (viewModel.state) {
        Loading() => Scaffold(
            appBar: AppBar(backgroundColor: Colors.transparent),
            body: const LoadingView(),
          ),
        Failure(:final message) => Scaffold(
            appBar: AppBar(backgroundColor: Colors.transparent),
            body: ErrorView(
              message: message,
              onRetry: viewModel.load,
            ),
          ),
        Success(:final data) => _DetailContent(detail: data),
      },
    );
  }
}

class _DetailContent extends StatelessWidget {
  final ListingDetail detail;

  const _DetailContent({required this.detail});

  Future<void> _openMap(BuildContext context) async {
    final coords = detail.address.mapCoordinates;
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${coords.lat},${coords.lng}',
    );

    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched && context.mounted) {
        _showMapErrorSnackBar(context);
      }
    } catch (_) {
      if (context.mounted) {
        _showMapErrorSnackBar(context);
      }
    }
  }

  void _showMapErrorSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Could not open maps application'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ListingDetailViewModel>();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DetailHero(
            photoUrl: detail.photoUrl,
            listingId: detail.id,
            onBackPressed: () => Navigator.of(context).maybePop(),
          ),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppSpacing.maxContentWidth,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenHorizontal,
                  vertical: AppSpacing.lg,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PriceHeader(
                      detail: detail,
                      onViewOnMap: () => _openMap(context),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
                      child: Divider(color: AppColors.divider),
                    ),
                    PropertyDetailsSection(detail: detail),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
                      child: Divider(color: AppColors.divider),
                    ),
                    ExpandableDescription(
                      description: detail.description,
                      isExpanded: viewModel.isDescriptionExpanded,
                      onToggle: viewModel.toggleDescription,
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
