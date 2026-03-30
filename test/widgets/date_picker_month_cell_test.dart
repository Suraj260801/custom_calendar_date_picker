import 'package:custom_calendar_date_picker/widgets/date_picker_month_cell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  Widget wrapWithMaterial(Widget child) {
    return MaterialApp(home: Scaffold(body: child));
  }

  testWidgets('displays correct month text', (WidgetTester tester) async {
    await tester.pumpWidget(
      wrapWithMaterial(DatePickerMonthCell(month: 'Jan')),
    );

    expect(find.text('Jan'), findsOneWidget);
  });

  testWidgets('calls onSelected when tapped', (WidgetTester tester) async {
  bool tapped = false;

  await tester.pumpWidget(
    wrapWithMaterial(
      DatePickerMonthCell(
        month: 'Feb',
        onSelected: () => tapped = true,
      ),
    ),
  );

  await tester.tap(find.byType(DatePickerMonthCell));
  await tester.pump();

  expect(tapped, true);
});

testWidgets('applies selected styles correctly', (WidgetTester tester) async {
  await tester.pumpWidget(
    wrapWithMaterial(
      DatePickerMonthCell(
        month: 'Mar',
        selected: true,
      ),
    ),
  );

  final container = tester.widget<Container>(
    find.descendant(
      of: find.byType(DatePickerMonthCell),
      matching: find.byType(Container),
    ),
  );

  final decoration = container.decoration as BoxDecoration;

  expect(decoration.color, Colors.blue);

  final text = tester.widget<Text>(find.text('Mar'));
  expect(text.style?.color, Colors.white);
});

testWidgets('applies current month styles correctly', (WidgetTester tester) async {
  await tester.pumpWidget(
    wrapWithMaterial(
      DatePickerMonthCell(
        month: 'Apr',
        current: true,
      ),
    ),
  );

  final container = tester.widget<Container>(
    find.descendant(
      of: find.byType(DatePickerMonthCell),
      matching: find.byType(Container),
    ),
  );

  final decoration = container.decoration as BoxDecoration;

  expect((decoration.border as Border).top.color, Colors.blue);

  final text = tester.widget<Text>(find.text('Apr'));
  expect(text.style?.color, Colors.blue);
  expect(text.style?.fontWeight, FontWeight.w600);
});

testWidgets('applies disabled styles correctly', (WidgetTester tester) async {
  await tester.pumpWidget(
    wrapWithMaterial(
      DatePickerMonthCell(
        month: 'May',
        enabled: false,
      ),
    ),
  );

  final text = tester.widget<Text>(find.text('May'));
  expect(text.style?.color, Colors.grey.shade400);
});

testWidgets('default state styles are correct', (WidgetTester tester) async {
  await tester.pumpWidget(
    wrapWithMaterial(
      DatePickerMonthCell(
        month: 'Jun',
      ),
    ),
  );

  final text = tester.widget<Text>(find.text('Jun'));

  expect(text.style?.color, Colors.grey);
  expect(text.style?.fontWeight, FontWeight.w400);
});

testWidgets('selected takes priority over current styles', (tester) async {
  await tester.pumpWidget(
    wrapWithMaterial(
      DatePickerMonthCell(
        month: 'Jul',
        selected: true,
        current: true,
      ),
    ),
  );

  final text = tester.widget<Text>(find.text('Jul'));

  // Selected should override → white text
  expect(text.style?.color, Colors.white);

  final container = tester.widget<Container>(
    find.descendant(
      of: find.byType(DatePickerMonthCell),
      matching: find.byType(Container),
    ),
  );

  final decoration = container.decoration as BoxDecoration;

  // Background should be blue (selected)
  expect(decoration.color, Colors.blue);
});

testWidgets('border is shown only for current month', (tester) async {
  await tester.pumpWidget(
    wrapWithMaterial(
      DatePickerMonthCell(
        month: 'Aug',
        current: true,
      ),
    ),
  );

  final container = tester.widget<Container>(
    find.descendant(
      of: find.byType(DatePickerMonthCell),
      matching: find.byType(Container),
    ),
  );

  final decoration = container.decoration as BoxDecoration;

  expect((decoration.border as Border).top.color, Colors.blue);
});
}
