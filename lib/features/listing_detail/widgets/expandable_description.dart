import 'package:flutter/material.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

/// Description section featuring a 5-line clamped paragraph and
/// an expandable "Read more / Show less" toggle.
class ExpandableDescription extends StatelessWidget {
  /// Full description text content.
  final String description;

  /// Whether the full text is currently expanded.
  final bool isExpanded;

  /// Callback to toggle expansion state in the ViewModel.
  final VoidCallback onToggle;

  const ExpandableDescription({
    super.key,
    required this.description,
    required this.isExpanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    if (description.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: AppTextStyles.sectionHeading,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          description,
          style: AppTextStyles.body,
          maxLines: isExpanded ? null : 5,
          overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppSpacing.xs),
        InkWell(
          onTap: onToggle,
          borderRadius: BorderRadius.circular(AppSpacing.xs),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
            child: Text(
              isExpanded ? 'Show less' : 'Read more',
              style: AppTextStyles.link,
            ),
          ),
        ),
      ],
    );
  }
}
