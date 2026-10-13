import 'package:intl/intl.dart';

/// Formatting utilities for property listings and attributes.
///
/// Ensures consistent presentation across cards and detail pages,
/// such as thousands separators, currency units, and singular/plural labels.
abstract final class Formatters {
  static final NumberFormat _numberFormat = NumberFormat.decimalPattern();

  /// Formats an integer number with thousands separators (e.g. 2561 -> "2,561").
  static String formatNumber(int number) => _numberFormat.format(number);

  /// Formats monthly rental price for search listing cards (e.g. 2561 -> "$2,561/mo").
  static String formatCardPrice(int price) => '\$${formatNumber(price)}/mo';

  /// Formats price for the detail page header (e.g. 2561 -> "$2,561").
  static String formatDetailPrice(int price) => '\$${formatNumber(price)}';

  /// Formats floor area in square feet (e.g. 2561 -> "2,561 sqft").
  static String formatArea(int areaSize) => '${formatNumber(areaSize)} sqft';

  /// Formats bedroom count with singular/plural suffix (e.g. 1 -> "1 Bed", 3 -> "3 Beds").
  static String formatBedrooms(int count) =>
      count == 1 ? '1 Bed' : '$count Beds';

  /// Formats bathroom count with singular/plural suffix (e.g. 1 -> "1 Bath", 2 -> "2 Baths").
  static String formatBathrooms(int count) =>
      count == 1 ? '1 Bath' : '$count Baths';

  /// Formats lease tenure duration (e.g. 99 -> "99 yrs").
  static String formatTenure(int tenure) => '$tenure yrs';

  /// Formats combined address line (e.g. "12 Meyappa Chettiar Rd · D13").
  static String formatAddress(String streetName, String district) =>
      '$streetName · $district';

  /// Formats card metadata subtitle (e.g. "Condo · 2020 · 99 yrs").
  static String formatMeta(String category, String completedAt, int tenure) =>
      '$category · $completedAt · ${formatTenure(tenure)}';

  /// Formats card stats row (e.g. "3 Beds · 2 Baths · 2,561 sqft").
  static String formatStats(int bedrooms, int bathrooms, int areaSize) =>
      '${formatBedrooms(bedrooms)} · ${formatBathrooms(bathrooms)} · ${formatArea(areaSize)}';

  /// Formats price per square foot (e.g. 2561, 2561 -> "$1.00 psf"; 1420000, 1000 -> "$1,420 psf").
  static String formatPricePerSqft(int price, int areaSize) {
    if (areaSize <= 0) return 'Unavailable';
    final psf = price / areaSize;
    if (psf >= 100) {
      return '\$${formatNumber(psf.round())} psf';
    }
    return '\$${psf.toStringAsFixed(2)} psf';
  }
}
