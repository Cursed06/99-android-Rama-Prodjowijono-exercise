import 'package:flutter/material.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/listing_detail.dart';

/// Dynamic two-column specifications section rendered from `property_details[]`.
///
/// Ensures flexible rendering according to backend API contracts without
/// hardcoding fixed specification rows.
class PropertyDetailsSection extends StatelessWidget {
  /// Dynamic list of specification entries returned by the API.
  final List<PropertyDetailItem> items;

  const PropertyDetailsSection({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Property details',
          style: AppTextStyles.sectionHeading,
        ),
        const SizedBox(height: AppSpacing.sm),
        ...items.map((item) => _PropertyRow(item: item)),
      ],
    );
  }
}

class _PropertyRow extends StatelessWidget {
  final PropertyDetailItem item;

  const _PropertyRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              item.label,
              style: AppTextStyles.bodyStrong,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            flex: 6,
            child: Text(
              item.text,
              style: AppTextStyles.body,
            ),
          ),
        ],
      ),
    );
  }
}
