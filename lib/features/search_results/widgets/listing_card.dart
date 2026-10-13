import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/listing.dart';

/// Card component displaying a property listing overview in search results.
///
/// Encapsulates photo loading with cache/placeholder/error handling,
/// formatted property statistics, and an interactive ink splash response.
class ListingCard extends StatelessWidget {
  /// Listing domain model containing property data.
  final Listing listing;

  /// Callback executed when the card is tapped.
  final VoidCallback onTap;

  const ListingCard({
    super.key,
    required this.listing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 12,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _CardPhoto(
                  photoUrl: listing.photoUrl,
                  listingId: listing.id,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  listing.projectName,
                  style: AppTextStyles.cardTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  Formatters.formatAddress(
                    listing.address.streetName,
                    listing.address.district,
                  ),
                  style: AppTextStyles.caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  Formatters.formatMeta(
                    listing.category,
                    listing.completedAt,
                    listing.tenure,
                  ),
                  style: AppTextStyles.caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  Formatters.formatStats(
                    listing.attributes.bedrooms,
                    listing.attributes.bathrooms,
                    listing.attributes.areaSize,
                  ),
                  style: AppTextStyles.stat,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  Formatters.formatCardPrice(listing.attributes.price),
                  style: AppTextStyles.cardPrice,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Inset 16:9 preview photo with rounded corners and shimmer placeholder.
class _CardPhoto extends StatelessWidget {
  final String photoUrl;
  final int listingId;

  const _CardPhoto({
    required this.photoUrl,
    required this.listingId,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.radiusImage),
        child: Hero(
          tag: 'listing-photo-$listingId',
          child: CachedNetworkImage(
            imageUrl: photoUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: AppColors.background,
              child: const Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.accent),
                  ),
                ),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              color: AppColors.background,
              child: const Center(
                child: Icon(
                  Icons.broken_image_outlined,
                  color: AppColors.textSecondary,
                  size: 32,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
