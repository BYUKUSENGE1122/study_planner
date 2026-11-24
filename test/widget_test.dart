import 'package:flutter_test/flutter_test.dart';
import 'package:study_planner/main.dart';

void main() {
  testWidgets('Study Planner displays the initial goals', (
    WidgetTester tester,
  ) async {
    // Launch our application
    await tester.pumpWidget(const MyStudyPlannerApp());

    // Check application title
    expect(find.text('My Study Planner'), findsOneWidget);

    // Check heading
    expect(find.text('My Study Goals'), findsOneWidget);

    // Check initial study goals
    expect(find.text('Dart Programming'), findsOneWidget);
    expect(find.text('Database Management'), findsOneWidget);
    expect(find.text('Udemy Online Course'), findsOneWidget);
  });
}
