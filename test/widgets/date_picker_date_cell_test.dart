import 'package:custom_calendar_date_picker/widgets/date_picker_date_cell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  Widget wrapWithMaterial(Widget child) {
    return MaterialApp(home: Scaffold(body: child));
  }

  testWidgets('displays correct day text', (WidgetTester tester) async {
    final date = DateTime(2026, 3, 15);

    await tester.pumpWidget(wrapWithMaterial(DatePickerDateCell(date: date)));

    expect(find.text('15'), findsOneWidget);
  });

  testWidgets('calls onSelected when tapped', (WidgetTester tester) async {
  bool tapped = false;

  await tester.pumpWidget(
    wrapWithMaterial(
      DatePickerDateCell(
        date: DateTime.now(),
        onSelected: () => tapped = true,
      ),
    ),
  );

  await tester.tap(find.byType(DatePickerDateCell));
  await tester.pump();

  expect(tapped, true);
});

testWidgets('applies selected styles correctly', (WidgetTester tester) async {
  await tester.pumpWidget(
    wrapWithMaterial(
      DatePickerDateCell(
        date: DateTime.now(),
        selected: true,
      ),
    ),
  );

  final container = tester.widget<Container>(
    find.descendant(
      of: find.byType(DatePickerDateCell),
      matching: find.byType(Container),
    ),
  );

  final decoration = container.decoration as BoxDecoration;

  expect(decoration.color, Colors.blue);

  final text = tester.widget<Text>(find.text('${DateTime.now().day}'));
  expect(text.style?.color, Colors.white);
});

testWidgets('applies current date styles correctly', (WidgetTester tester) async {
  final today = DateTime.now();

  await tester.pumpWidget(
    wrapWithMaterial(
      DatePickerDateCell(
        date: today,
        current: true,
      ),
    ),
  );

  final container = tester.widget<Container>(
    find.descendant(
      of: find.byType(DatePickerDateCell),
      matching: find.byType(Container),
    ),
  );

  final decoration = container.decoration as BoxDecoration;

  expect((decoration.border as Border).top.color, Colors.blue);

  final text = tester.widget<Text>(find.text('${today.day}'));
  expect(text.style?.color, Colors.blue);
});

testWidgets('applies disabled styles correctly', (WidgetTester tester) async {
  final date = DateTime(2026, 3, 10);

  await tester.pumpWidget(
    wrapWithMaterial(
      DatePickerDateCell(
        date: date,
        enabled: false,
      ),
    ),
  );

  final text = tester.widget<Text>(find.text('10'));
  expect(text.style?.color, Colors.grey.shade300);
});

testWidgets('default state shows grey text', (WidgetTester tester) async {
  final date = DateTime(2026, 3, 8);

  await tester.pumpWidget(
    wrapWithMaterial(
      DatePickerDateCell(
        date: date,
      ),
    ),
  );

  final text = tester.widget<Text>(find.text('8'));
  expect(text.style?.color, Colors.grey);
});

testWidgets('selected takes priority over current styles', (tester) async {
  final today = DateTime.now();

  await tester.pumpWidget(
    wrapWithMaterial(
      DatePickerDateCell(
        date: today,
        selected: true,
        current: true,
      ),
    ),
  );

  final text = tester.widget<Text>(find.text('${today.day}'));

  // Selected should override → white text
  expect(text.style?.color, Colors.white);
});
}
