import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ninety_nine_exercise/app.dart';

void main() {
  testWidgets('NinetyNineApp renders smoke test', (tester) async {
    await tester.pumpWidget(
      const NinetyNineApp(
        home: Scaffold(
          body: Center(child: Text('Smoke Test')),
        ),
      ),
    );

    expect(find.text('Smoke Test'), findsOneWidget);
  });
}
