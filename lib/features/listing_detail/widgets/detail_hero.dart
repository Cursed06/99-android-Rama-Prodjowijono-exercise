import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

/// Full-bleed hero photograph component with overlaid back navigation.
///
/// Implements status-bar safe area positioning, dark gradient legibility scrim,
/// and smooth [Hero] animation matching the listing card photo tag.
class DetailHero extends StatelessWidget {
  /// Remote URL for the property photograph.
  final String photoUrl;

  /// Listing ID used to pair the [Hero] flight animation with the search card.
  final int listingId;

  /// Callback executed when the back button is pressed.
  final VoidCallback onBackPressed;

  const DetailHero({
    super.key,
    required this.photoUrl,
    required this.listingId,
    required this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSpacing.detailHeroHeight,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Hero(
            tag: 'listing-photo-$listingId',
            child: CachedNetworkImage(
              imageUrl: photoUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: AppSpacing.detailHeroHeight,
              placeholder: (context, url) => Container(
                color: AppColors.background,
                child: const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.accent),
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: AppColors.background,
                child: const Center(
                  child: Icon(
                    Icons.broken_image_outlined,
                    color: AppColors.textSecondary,
                    size: 48,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 90,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.overlayScrim,
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xs),
                child: SizedBox(
                  width: 44,
                  height: 44,
                  child: IconButton(
                    icon: const Icon(
                      Icons.chevron_left_rounded,
                      color: AppColors.surface,
                      size: 28,
                    ),
                    onPressed: onBackPressed,
                    tooltip: 'Back',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
