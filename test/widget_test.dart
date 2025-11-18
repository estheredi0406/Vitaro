import 'package:flutter_test/flutter_test.dart';

import 'package:vitaro/main.dart';

void main() {
  testWidgets('VitaroApp smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // Use 'VitaroApp' instead of 'MyApp'
    await tester.pumpWidget(const VitaroApp());

    // Verify that your app shows the initial loading text.
    // This text comes from the placeholder 'LoadingPage' in your main.dart.
    expect(find.text('Vitaro Loading...'), findsOneWidget);

    // Verify that the old counter text is not present.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsNothing);
  });
}
