import 'package:flutter/material.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/listing_detail.dart';

/// Specification section displaying standardized property details.
///
/// Regardless of API variations, guarantees the display of nine key property
/// specifications: Price/sqft, Floor level, Furnishing, Facing, Overlooking View,
/// Built year (TOP), Tenure, Property type, and Last updated.
class PropertyDetailsSection extends StatelessWidget {
  /// Listing detail domain model used to derive and calculate specification rows.
  final ListingDetail? detail;

  /// Optional explicit list of specification items for customization or tests.
  final List<PropertyDetailItem>? items;

  const PropertyDetailsSection({
    super.key,
    this.detail,
    this.items,
  });

  /// Extracts or computes the standardized 9 property details list.
  static List<PropertyDetailItem> computePropertyDetails(ListingDetail detail) {
    String? findRawValue(List<String> candidateLabels) {
      for (final item in detail.propertyDetails) {
        final normalized = item.label.trim().toLowerCase();
        for (final candidate in candidateLabels) {
          if (normalized == candidate.toLowerCase()) {
            return item.text.trim();
          }
        }
      }
      return null;
    }

    // 1. Price/sqft (calculated from price / area_size in code)
    final pricePerSqft = Formatters.formatPricePerSqft(
      detail.attributes.price,
      detail.attributes.areaSize,
    );

    // 2. Floor level
    final floorLevel = findRawValue(['Floor level', 'Floor Level']) ?? 'Unavailable';

    // 3. Furnishing
    final furnishing = findRawValue(['Furnishing']) ?? 'Unavailable';

    // 4. Facing
    final facing = findRawValue(['Facing']) ?? 'Unavailable';

    // 5. Overlooking View
    final overlookingView =
        findRawValue(['Overlooking View', 'Overlooking view', 'View']) ?? 'Unavailable';

    // 6. Built year (TOP)
    final builtYear =
        findRawValue(['Built year (TOP)', 'Built year', 'Built Year', 'TOP']) ?? 'Unavailable';

    // 7. Tenure
    final tenure = findRawValue(['Tenure']) ?? 'Unavailable';

    // 8. Property type (derived from title e.g. "Condo for Rent" -> "Condo", or raw)
    final propertyType = derivePropertyType(detail, findRawValue);

    // 9. Last updated
    final lastUpdated = findRawValue(['Last updated', 'Last Updated']) ?? 'Unavailable';

    return [
      PropertyDetailItem(label: 'Price/sqft', text: pricePerSqft),
      PropertyDetailItem(label: 'Floor level', text: floorLevel),
      PropertyDetailItem(label: 'Furnishing', text: furnishing),
      PropertyDetailItem(label: 'Facing', text: facing),
      PropertyDetailItem(label: 'Overlooking View', text: overlookingView),
      PropertyDetailItem(label: 'Built year (TOP)', text: builtYear),
      PropertyDetailItem(label: 'Tenure', text: tenure),
      PropertyDetailItem(label: 'Property type', text: propertyType),
      PropertyDetailItem(label: 'Last updated', text: lastUpdated),
    ];
  }

  /// Derives human-friendly property type from the address title (e.g. "Condo").
  static String derivePropertyType(
    ListingDetail detail,
    String? Function(List<String>) findRawValue,
  ) {
    final title = detail.address.title;
    final parts = title.split('·');
    if (parts.length > 1) {
      final segment = parts[1].trim();
      final forIndex = segment.toLowerCase().indexOf(' for');
      if (forIndex != -1) {
        final derived = segment.substring(0, forIndex).trim();
        if (derived.isNotEmpty) return derived;
      } else if (segment.isNotEmpty) {
        return segment;
      }
    }
    final rawType = findRawValue(['Property type', 'Property Type']);
    if (rawType != null && rawType.isNotEmpty) {
      return rawType;
    }
    return 'Condo';
  }

  @override
  Widget build(BuildContext context) {
    final displayItems = detail != null
        ? computePropertyDetails(detail!)
        : (items ?? const <PropertyDetailItem>[]);

    if (displayItems.isEmpty) {
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
        ...displayItems.map((item) => _PropertyRow(item: item)),
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
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 6,
            child: Text(
              item.label,
              style: AppTextStyles.propertyDetailLabel,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            flex: 6,
            child: Text(
              item.text,
              style: AppTextStyles.propertyDetailValue,
            ),
          ),
        ],
      ),
    );
  }
}
