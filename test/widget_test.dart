import 'package:flutter_test/flutter_test.dart';
import 'package:mendly/main.dart';

void main() {
  testWidgets('MendlyApp smoke test renders login', (WidgetTester tester) async {
    await tester.pumpWidget(const MendlyApp());
    await tester.pump();

    // Verify Mendly title and sign in button exist on login screen
    expect(find.text('Mendly'), findsWidgets);
    expect(find.text('Sign In'), findsOneWidget);
  });
}
