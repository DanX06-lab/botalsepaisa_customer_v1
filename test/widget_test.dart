import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:botalsepaisa_customer_v1/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: BotalSePaisaApp()));

    // Verify that our counter starts at 0.
    expect(find.text('BotalSePaisa Customer App'), findsOneWidget);
  });
}
