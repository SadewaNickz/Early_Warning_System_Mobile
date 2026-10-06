import 'package:flutter_test/flutter_test.dart';
import 'package:ews_mobile/main.dart';

void main() {
  testWidgets('EwsApp loads smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const EwsApp());
    expect(find.byType(EwsApp), findsOneWidget);
  });
}
