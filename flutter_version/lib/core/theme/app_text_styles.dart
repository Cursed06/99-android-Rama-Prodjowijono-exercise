import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Typography tokens based on Avenir Next font styling.
///
/// Follows the 99.co design system specifications. Uses Avenir Next
/// as the primary typeface (available natively on iOS/macOS) with
/// fallbacks for environments where Avenir Next is not pre-installed.
abstract final class AppTextStyles {
  /// Primary font family from Figma design specs.
  static const String fontFamily = 'Avenir Next';

  /// Fallback font families if Avenir Next is not pre-installed (e.g. default Android).
  static const List<String> fontFallback = ['Nunito Sans', 'sans-serif'];

  /// Base text style builder with Avenir Next font family and proportional line height.
  static TextStyle _base({
    required double fontSize,
    required FontWeight fontWeight,
    required double lineHeight,
    required Color color,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontFamilyFallback: fontFallback,
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: lineHeight / fontSize,
      color: color,
    );
  }

  /// App bar centered screen title ("Search Results", 16px/600, line height 16).
  static final TextStyle screenTitle = _base(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    lineHeight: 16,
    color: AppColors.primary,
  );

  /// Prominent price on the detail screen ($2,561, 23px/700, line height 23).
  static final TextStyle priceLarge = _base(
    fontSize: 23,
    fontWeight: FontWeight.w700,
    lineHeight: 23,
    color: AppColors.primary,
  );

  /// Detail page project name title (19px/600, line height 19).
  static final TextStyle titleLarge = _base(
    fontSize: 19,
    fontWeight: FontWeight.w600,
    lineHeight: 19,
    color: AppColors.primary,
  );

  /// Section heading for "Property details" and "Description" (19px/600, line height 19).
  static final TextStyle sectionHeading = _base(
    fontSize: 19,
    fontWeight: FontWeight.w600,
    lineHeight: 19,
    color: AppColors.primary,
  );

  /// Project name heading inside search result cards (16px/600, line height 16).
  static final TextStyle cardTitle = _base(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    lineHeight: 16,
    color: AppColors.primary,
  );

  /// Price tag inside search result cards ($2,561/mo, 16px/700, line height 16).
  static final TextStyle cardPrice = _base(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    lineHeight: 16,
    color: AppColors.primary,
  );

  /// Body paragraph style for descriptions (16px/400, line height 28).
  static final TextStyle body = _base(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    lineHeight: 28,
    color: AppColors.textBody,
  );

  /// Bold variant for specification labels in property details (14px/600).
  static final TextStyle bodyStrong = _base(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    lineHeight: 20,
    color: AppColors.primary,
  );

  /// Label for property details specification rows (16px/500, line height 16).
  static final TextStyle propertyDetailLabel = _base(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    lineHeight: 16,
    color: AppColors.primary,
  );

  /// Value for property details specification rows (16px/400, line height 16).
  static final TextStyle propertyDetailValue = _base(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    lineHeight: 16,
    color: AppColors.primary,
  );

  /// Detail page address title and subtitle lines (14px/400, line height 14).
  static final TextStyle detailAddress = _base(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    lineHeight: 14,
    color: AppColors.textSecondary,
  );

  /// Subtle caption for card address and tenure metadata (12px/500, line height 12).
  static final TextStyle caption = _base(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    lineHeight: 12,
    color: AppColors.textSecondary,
  );

  /// Card stats text for beds, baths, and square footage (14px/400, line height 14).
  static final TextStyle stat = _base(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    lineHeight: 14,
    color: AppColors.textBody,
  );

  /// Detail page quick stats for beds, baths, and square footage (16px/400, line height 16).
  static final TextStyle detailStat = _base(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    lineHeight: 16,
    color: AppColors.textBody,
  );

  /// Interactive link text ("View on map", "Read more", 14px/600, line height 14).
  static final TextStyle link = _base(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    lineHeight: 14,
    color: AppColors.accent,
  );
}
