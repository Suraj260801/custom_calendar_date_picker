import 'package:custom_calendar_date_picker/widgets/date_picker_year_cell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

main(){
  Widget wrapWithMaterial(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: child,
    ),
  );
}

testWidgets('displays correct year text', (WidgetTester tester) async {
  await tester.pumpWidget(
    wrapWithMaterial(
      DatePickerYearCell(
        year: 2026,
        onSelected: () {},
        current: false,
      ),
    ),
  );

  expect(find.text('2026'), findsOneWidget);
});

testWidgets('calls onSelected when tapped', (WidgetTester tester) async {
  bool tapped = false;

  await tester.pumpWidget(
    wrapWithMaterial(
      DatePickerYearCell(
        year: 2025,
        current: false,
        onSelected: () => tapped = true,
      ),
    ),
  );

  await tester.tap(find.byType(DatePickerYearCell));
  await tester.pump();

  expect(tapped, true);
});

testWidgets('applies selected styles correctly', (WidgetTester tester) async {
  await tester.pumpWidget(
    wrapWithMaterial(
      DatePickerYearCell(
        year: 2024,
        selected: true,
        current: false,
        onSelected: () {},
      ),
    ),
  );

  final text = tester.widget<Text>(find.text('2024'));
  expect(text.style?.color, Colors.blue);
  expect(text.style?.fontWeight, FontWeight.w600);

  final box = tester.widget<DecoratedBox>(
    find.byType(DecoratedBox),
  );

  final decoration = box.decoration as BoxDecoration;
  expect((decoration.border as Border).top.color, Colors.blue);
});

testWidgets('applies current styles correctly', (WidgetTester tester) async {
  await tester.pumpWidget(
    wrapWithMaterial(
      DatePickerYearCell(
        year: 2023,
        current: true,
        onSelected: () {},
      ),
    ),
  );

  final text = tester.widget<Text>(find.text('2023'));
  expect(text.style?.color, Colors.blue);
  expect(text.style?.fontWeight, FontWeight.w600);

  final box = tester.widget<DecoratedBox>(
    find.byType(DecoratedBox),
  );

  final decoration = box.decoration as BoxDecoration;
  expect((decoration.border as Border).top.color, Colors.transparent);
});

testWidgets('default state styles are correct', (WidgetTester tester) async {
  await tester.pumpWidget(
    wrapWithMaterial(
      DatePickerYearCell(
        year: 2022,
        current: false,
        onSelected: () {},
      ),
    ),
  );

  final text = tester.widget<Text>(find.text('2022'));

  expect(text.style?.color, Colors.black87);
  expect(text.style?.fontWeight, FontWeight.w400);
});

testWidgets('selected + current does not show border', (tester) async {
  await tester.pumpWidget(
    wrapWithMaterial(
      DatePickerYearCell(
        year: 2021,
        selected: true,
        current: true,
        onSelected: () {},
      ),
    ),
  );

  final text = tester.widget<Text>(find.text('2021'));

  // Still bold + blue
  expect(text.style?.color, Colors.blue);
  expect(text.style?.fontWeight, FontWeight.w600);

  final box = tester.widget<DecoratedBox>(
    find.byType(DecoratedBox),
  );

  final decoration = box.decoration as BoxDecoration;

  // Border should NOT appear
  expect((decoration.border as Border).top.color, Colors.transparent);
});

testWidgets('tap does nothing when onSelected is null', (tester) async {
  await tester.pumpWidget(
    wrapWithMaterial(
      DatePickerYearCell(
        year: 2020,
        current: false,
        onSelected: null,
      ),
    ),
  );

  await tester.tap(find.byType(DatePickerYearCell));
  await tester.pump();

  // No crash = pass
  expect(find.text('2020'), findsOneWidget);
});
}