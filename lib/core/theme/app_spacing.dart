/// Spacing, dimension, and radius tokens following the 4-point design system scale.
///
/// Prevents magic numbers in UI layouts and ensures visual rhythm across screens.
abstract final class AppSpacing {
  /// 2px extra micro spacing
  static const double xxs = 2.0;

  /// 4px micro spacing (e.g. icon-to-label gaps).
  static const double xs = 4.0;

  /// 8px small spacing (e.g. between subtitle and address line).
  static const double sm = 8.0;

  /// 12px medium spacing (e.g. inside listing card padding).
  static const double md = 12.0;

  /// 16px standard gutter and item gap.
  static const double lg = 16.0;

  /// 24px section spacing.
  static const double xl = 24.0;

  /// 32px major section and hero separation.
  static const double xxl = 32.0;

  /// Corner radius for listing cards (4px).
  static const double radiusCard = 4.0;

  /// Corner radius for card preview photos (4px).
  static const double radiusImage = 4.0;

  /// Standard horizontal screen padding for detail page (16px).
  static const double screenHorizontal = 16.0;

  /// Horizontal padding around list cards (12px).
  static const double cardHorizontal = 12.0;

  /// Gap between vertical list cards (8px).
  static const double cardGap = 8.0;

  /// Detail hero image default height (280px).
  static const double detailHeroHeight = 280.0;

  /// Maximum content width when running on tablet screens.
  static const double maxContentWidth = 600.0;
}
