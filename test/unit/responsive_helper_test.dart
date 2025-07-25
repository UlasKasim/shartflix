import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:shartflix/core/utils/responsive_helper.dart';

void main() {
  group('ResponsiveHelper', () {
    testWidgets('should detect tablet correctly', (tester) async {
      //一同      // arrange
      tester.view.physicalSize = const Size(800, 1024);
      tester.view.devicePixelRatio = 1.0;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final r = ResponsiveHelper(context);
              return Text('isTablet: ${r.isTablet}');
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
      // assert
      expect(find.text('isTablet: true'), findsOneWidget);
    });

    testWidgets('should detect mobile correctly', (tester) async {
      // arrange
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1.0;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final r = ResponsiveHelper(context);
              return Text('isMobile: ${r.isMobile}');
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
      // assert
      expect(find.text('isMobile: true'), findsOneWidget);
    });

    testWidgets('should return correct responsive values', (tester) async {
      // arrange
      tester.view.physicalSize = const Size(800, 1024);
      tester.view.devicePixelRatio = 1.0;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final r = ResponsiveHelper(context);
              final fontSize = r.responsive(
                mobile: 14.0,
                tablet: 16.0,
                largeTablet: 18.0,
              );
              return Text('fontSize: $fontSize');
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
      // assert
      expect(find.text('fontSize: 16.0'), findsOneWidget);
    });
  });
}
