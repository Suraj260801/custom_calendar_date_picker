import 'package:custom_calendar_date_picker/widgets/week_day_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  Widget wrapWithMaterial(Widget child) {
    return MaterialApp(home: Scaffold(body: child));
  }

  testWidgets('displays all weekday labels', (WidgetTester tester) async {
    final days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

    await tester.pumpWidget(wrapWithMaterial(WeekDayHeader(days: days)));

    for (final day in days) {
      expect(find.text(day), findsOneWidget);
    }
  });

  testWidgets('renders correct number of day items', (tester) async {
  final days = ['Mon', 'Tue', 'Wed'];

  await tester.pumpWidget(
    wrapWithMaterial(
      WeekDayHeader(days: days),
    ),
  );

  expect(find.byType(Expanded), findsNWidgets(3));
});

testWidgets('applies default text style', (tester) async {
  await tester.pumpWidget(
    wrapWithMaterial(
      WeekDayHeader(days: ['Mon']),
    ),
  );

  final text = tester.widget<Text>(find.text('Mon'));

  expect(text.style?.color, Colors.grey);
  expect(text.style?.fontSize, 14);
});

testWidgets('merges custom text style correctly', (tester) async {
  await tester.pumpWidget(
    wrapWithMaterial(
      WeekDayHeader(
        days: ['Tue'],
        dayTextStyle: const TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );

  final text = tester.widget<Text>(find.text('Tue'));

  expect(text.style?.color, Colors.red);
  expect(text.style?.fontWeight, FontWeight.bold);
});

testWidgets('applies background color', (tester) async {
  await tester.pumpWidget(
    wrapWithMaterial(
      WeekDayHeader(
        days: ['Wed'],
        color: Colors.black,
      ),
    ),
  );

  final container = tester.widget<Container>(
    find.byType(Container).first,
  );

  final decoration = container.decoration as BoxDecoration;

  expect(decoration.color, Colors.black);
});

testWidgets('applies border color', (tester) async {
  await tester.pumpWidget(
    wrapWithMaterial(
      WeekDayHeader(
        days: ['Thu'],
        borderColor: Colors.blue,
      ),
    ),
  );

  final container = tester.widget<Container>(
    find.byType(Container).first,
  );

  final decoration = container.decoration as BoxDecoration;

  expect((decoration.border as Border).top.color, Colors.blue);
});

testWidgets('applies header padding correctly', (tester) async {
  await tester.pumpWidget(
    wrapWithMaterial(
      WeekDayHeader(
        days: ['Fri'],
        headerPadding: 20,
      ),
    ),
  );

  final container = tester.widget<Container>(
    find.byType(Container).first,
  );

  expect(container.padding, const EdgeInsets.symmetric(vertical: 20));
});

testWidgets('applies item padding correctly', (tester) async {
  await tester.pumpWidget(
    wrapWithMaterial(
      WeekDayHeader(
        days: ['Sat','Sun','Mon','Tue','Wed','Thu','Fri'],
        itemPadding: 12,
      ),
    ),
  );

  final paddingWidget = tester.widget<Padding>(
    find.byKey(ValueKey('Sat')),
  );

  expect(
    paddingWidget.padding,
    const EdgeInsets.symmetric(vertical: 12),
  );
});
}
