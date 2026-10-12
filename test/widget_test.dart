import 'package:flutter_test/flutter_test.dart';
import 'package:ninety_nine_exercise/app.dart';

void main() {
  testWidgets('NinetyNineApp renders home title smoke test', (tester) async {
    await tester.pumpWidget(const NinetyNineApp());

    expect(find.text('Search Results'), findsOneWidget);
  });
}
