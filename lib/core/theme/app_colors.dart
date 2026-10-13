import 'package:flutter/material.dart';

/// Central design tokens for application colors.
///
/// Kept in a single class so that color updates (e.g. from Figma dev mode)
/// only need to happen in this file rather than across individual widgets.
abstract final class AppColors {
  /// Deep navy used for headings, primary titles, prices, and emphasis.
  static const Color primary = Color(0xFF1A2258);

  /// Muted lavender-grey used for subtitles, districts, and secondary metadata.
  static const Color textSecondary = Color(0xFF787D9C);

  /// Default text color for body paragraphs and specification values.
  static const Color textBody = Color(0xFF1A2258);

  /// Vibrant blue used for actionable links, interactive accents, and loaders.
  static const Color accent = Color(0xFF216BFF);

  /// Pure white used for card backgrounds, top bar surfaces, and sheets.
  static const Color surface = Color(0xFFFFFFFF);

  /// Subtle off-white background behind cards on the listing page.
  static const Color background = Color(0xFFF4F4F7);

  /// Delicate border and divider tint separating sections and app bar.
  static const Color divider = Color(0xFFDDDEE6);

  /// Card drop-shadow tint (0x140B1134 is ~8% opacity; 0x260B1134 is ~15%).
  static const Color shadow = Color(0x260B1134);

  /// Dark gradient overlay behind the hero back button to guarantee legibility.
  static const Color overlayScrim = Color(0x59000000);

  /// Black overlay with 40% opacity for bottom photo gradients.
  static const Color photoOverlay = Color(0x66000000);

  /// Error color for failed network calls and retry prompts.
  static const Color error = Color(0xFFD32F2F);
}
