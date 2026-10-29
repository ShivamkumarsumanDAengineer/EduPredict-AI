import 'package:flutter_test/flutter_test.dart';
import 'package:edupredict_ai/main.dart';

void main() {
  testWidgets('EduPredictApp launches and displays dashboard', (WidgetTester tester) async {
    await tester.pumpWidget(const EduPredictApp());
    await tester.pumpAndSettle();

    // Verify EduPredict AI header
    expect(find.text('EduPredict AI'), findsWidgets);
    expect(find.text('DASHBOARD'), findsOneWidget);

    // Verify Welcome banner
    expect(find.text('Welcome back, Shivam!'), findsOneWidget);

    // Verify navigation tabs
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Predict'), findsOneWidget);
    expect(find.text('Tracker'), findsOneWidget);
    expect(find.text('Buddy'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
  });
}

