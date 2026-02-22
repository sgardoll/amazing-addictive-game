import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindsort/main.dart';

void main() {
  testWidgets('MindSort app launches', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MindSortApp()));
    await tester.pumpAndSettle();
    expect(find.text('MindSort'), findsOneWidget);
  });
}
