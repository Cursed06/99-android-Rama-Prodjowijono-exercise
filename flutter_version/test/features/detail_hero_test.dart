import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ninety_nine_exercise/core/theme/app_colors.dart';
import 'package:ninety_nine_exercise/features/listing_detail/widgets/detail_hero.dart';

void main() {
  group('DetailHero Widget Tests', () {
    testWidgets('renders top and bottom linear gradient overlays with 50% black', (tester) async {
      var backPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DetailHero(
              photoUrl: 'https://example.com/test.jpg',
              listingId: 1,
              onBackPressed: () => backPressed = true,
            ),
          ),
        ),
      );

      // Verify DecoratedBoxes for top and bottom gradients
      final decoratedBoxes = tester.widgetList<DecoratedBox>(
        find.descendant(
          of: find.byType(DetailHero),
          matching: find.byType(DecoratedBox),
        ),
      );

      expect(decoratedBoxes.length, greaterThanOrEqualTo(2));

      final gradients = decoratedBoxes
          .map((box) => box.decoration)
          .whereType<BoxDecoration>()
          .map((dec) => dec.gradient)
          .whereType<LinearGradient>()
          .toList();

      expect(gradients.length, 2);

      // Verify top gradient (topCenter -> bottomCenter)
      final topGradient = gradients.firstWhere(
        (g) => g.begin == Alignment.topCenter && g.end == Alignment.bottomCenter,
      );
      expect(topGradient.colors, [
        AppColors.heroOverlay,
        Colors.transparent,
      ]);

      // Verify bottom gradient (bottomCenter -> topCenter)
      final bottomGradient = gradients.firstWhere(
        (g) => g.begin == Alignment.bottomCenter && g.end == Alignment.topCenter,
      );
      expect(bottomGradient.colors, [
        AppColors.heroOverlay,
        Colors.transparent,
      ]);

      // Verify back button tap triggers callback
      await tester.tap(find.byTooltip('Back'));
      expect(backPressed, isTrue);
    });
  });
}
