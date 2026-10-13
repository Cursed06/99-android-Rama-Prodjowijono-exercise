import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/listing_detail.dart';

/// Header section on the detail screen showing price, project title,
/// address lines, map navigation link, and physical attributes.
class PriceHeader extends StatelessWidget {
  /// Detailed listing model data.
  final ListingDetail detail;

  /// Callback executed when tapping the "View on map" action.
  final VoidCallback onViewOnMap;

  const PriceHeader({
    super.key,
    required this.detail,
    required this.onViewOnMap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Formatters.formatDetailPrice(detail.attributes.price),
          style: AppTextStyles.priceLarge,
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          detail.projectName,
          style: AppTextStyles.titleLarge,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          detail.address.title,
          style: AppTextStyles.detailAddress,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          detail.address.subtitle,
          style: AppTextStyles.detailAddress,
        ),
        const SizedBox(height: AppSpacing.sm),
        InkWell(
          onTap: onViewOnMap,
          borderRadius: BorderRadius.circular(AppSpacing.xs),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.location_on_rounded,
                  size: 16,
                  color: AppColors.accent,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  'View on map',
                  style: AppTextStyles.link,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        _StatsRow(detail: detail),
      ],
    );
  }
}

/// Responsive row of bedroom, bathroom, and area size indicators.
class _StatsRow extends StatelessWidget {
  final ListingDetail detail;

  const _StatsRow({required this.detail});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.lg,
      runSpacing: AppSpacing.sm,
      children: [
        _StatItem(
          icon: Icons.bed_outlined,
          label: Formatters.formatBedrooms(detail.attributes.bedrooms),
        ),
        _StatItem(
          icon: Icons.bathtub_outlined,
          label: Formatters.formatBathrooms(detail.attributes.bathrooms),
        ),
        _StatItem(
          icon: Icons.crop_square_outlined,
          label: Formatters.formatArea(detail.attributes.areaSize),
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _StatItem({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(
          label,
          style: AppTextStyles.detailStat,
        ),
      ],
    );
  }
}
