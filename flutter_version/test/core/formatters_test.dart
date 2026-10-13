import 'package:flutter_test/flutter_test.dart';
import 'package:ninety_nine_exercise/core/utils/formatters.dart';

void main() {
  group('Formatters', () {
    test('formatCardPrice formats rental price with dollar sign and /mo', () {
      expect(Formatters.formatCardPrice(2561), '\$2,561/mo');
      expect(Formatters.formatCardPrice(500), '\$500/mo');
      expect(Formatters.formatCardPrice(1000000), '\$1,000,000/mo');
    });

    test('formatDetailPrice formats price without /mo', () {
      expect(Formatters.formatDetailPrice(2561), '\$2,561');
    });

    test('formatArea formats square footage with thousands separators', () {
      expect(Formatters.formatArea(2561), '2,561 sqft');
      expect(Formatters.formatArea(850), '850 sqft');
    });

    test('formatBedrooms handles singular and plural counts', () {
      expect(Formatters.formatBedrooms(1), '1 Bed');
      expect(Formatters.formatBedrooms(2), '2 Beds');
      expect(Formatters.formatBedrooms(3), '3 Beds');
    });

    test('formatBathrooms handles singular and plural counts', () {
      expect(Formatters.formatBathrooms(1), '1 Bath');
      expect(Formatters.formatBathrooms(2), '2 Baths');
    });

    test('formatTenure formats tenure in years', () {
      expect(Formatters.formatTenure(99), '99 yrs');
      expect(Formatters.formatTenure(999), '999 yrs');
    });

    test('formatAddress joins street and district with middot', () {
      expect(
        Formatters.formatAddress('12 Meyappa Chettiar Rd', 'D13'),
        '12 Meyappa Chettiar Rd · D13',
      );
    });

    test('formatMeta joins category, completed year, and tenure', () {
      expect(
        Formatters.formatMeta('Condo', '2020', 99),
        'Condo · 2020 · 99 yrs',
      );
    });

    test('formatStats joins beds, baths, and area size', () {
      expect(
        Formatters.formatStats(3, 2, 2561),
        '3 Beds · 2 Baths · 2,561 sqft',
      );
      expect(
        Formatters.formatStats(1, 1, 550),
        '1 Bed · 1 Bath · 550 sqft',
      );
    });

    test('formatPricePerSqft formats rental and sale PSF properly', () {
      expect(Formatters.formatPricePerSqft(2561, 2561), '\$1.00 psf');
      expect(Formatters.formatPricePerSqft(6500, 1800), '\$3.61 psf');
      expect(Formatters.formatPricePerSqft(1420000, 1000), '\$1,420 psf');
      expect(Formatters.formatPricePerSqft(2500, 0), 'Unavailable');
    });
  });
}
