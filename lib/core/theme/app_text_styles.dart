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

  /// App bar centered screen title ("Search Results", 16px/600).
  static final TextStyle screenTitle = _base(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    lineHeight: 24,
    color: AppColors.primary,
  );

  /// Prominent price on the detail screen ($2,561, 26px/700).
  static final TextStyle priceLarge = _base(
    fontSize: 26,
    fontWeight: FontWeight.w700,
    lineHeight: 32,
    color: AppColors.primary,
  );

  /// Detail page project name title (18px/600).
  static final TextStyle titleLarge = _base(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    lineHeight: 24,
    color: AppColors.primary,
  );

  /// Section heading for "Property details" and "Description" (17px/600).
  static final TextStyle sectionHeading = _base(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    lineHeight: 24,
    color: AppColors.primary,
  );

  /// Project name heading inside search result cards (16px/700).
  static final TextStyle cardTitle = _base(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    lineHeight: 22,
    color: AppColors.primary,
  );

  /// Price tag inside search result cards ($2,561/mo, 16px/700).
  static final TextStyle cardPrice = _base(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    lineHeight: 22,
    color: AppColors.primary,
  );

  /// Body paragraph style for descriptions (14px/400).
  static final TextStyle body = _base(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    lineHeight: 24,
    color: AppColors.textBody,
  );

  /// Bold variant for specification labels in property details (14px/600).
  static final TextStyle bodyStrong = _base(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    lineHeight: 20,
    color: AppColors.primary,
  );

  /// Subtle caption for address and tenure metadata (12px/400).
  static final TextStyle caption = _base(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    lineHeight: 18,
    color: AppColors.textSecondary,
  );

  /// Stats text for beds, baths, and square footage (14px/400).
  static final TextStyle stat = _base(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    lineHeight: 20,
    color: AppColors.textBody,
  );

  /// Interactive link text ("View on map", 14px/600).
  static final TextStyle link = _base(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    lineHeight: 20,
    color: AppColors.accent,
  );
}
