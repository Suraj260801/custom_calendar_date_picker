import 'package:custom_calendar_date_picker/custom_calendar_date_picker.dart';
import 'package:custom_calendar_date_picker/utils/enums.dart';
import 'package:custom_calendar_date_picker/widgets/week_day_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  Widget wrapWithMaterial(Widget child) {
    return MaterialApp(home: Scaffold(body: child));
  }

  testWidgets('renders initial calendar UI', (tester) async {
    final date = DateTime(2026, 3, 15);

    await tester.pumpWidget(
      wrapWithMaterial(CustomCalendarDatePicker(selectedDate: date)),
    );

    // Month label
    expect(find.text('Mar'), findsOneWidget);

    // Weekday header visible (default day mode)
    expect(find.byType(WeekDayHeader), findsOneWidget);

    // Actions visible
    expect(find.text('Submit'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
  });

  testWidgets('weekday header hidden in month mode', (tester) async {
    await tester.pumpWidget(
      wrapWithMaterial(
        CustomCalendarDatePicker(
          selectedDate: DateTime.now(),
          mode: CalendarDatePickerMode.month,
        ),
      ),
    );

    expect(find.byType(WeekDayHeader), findsNothing);
  });

  testWidgets('date selection triggers onSubmit', (tester) async {
    DateTime? selected;

    await tester.pumpWidget(
      wrapWithMaterial(
        CustomCalendarDatePicker(
          selectedDate: DateTime(2026, 3, 15),
          onSubmit: (date) => selected = date,
        ),
      ),
    );

    await tester.tap(find.text('16').first);
    await tester.pump();

    expect(selected, isNotNull);
  });

  testWidgets('month selection triggers submit in single mode', (tester) async {
    DateTime? selected;

    await tester.pumpWidget(
      wrapWithMaterial(
        CustomCalendarDatePicker(
          selectedDate: DateTime(2026, 3, 15),
          mode: CalendarDatePickerMode.month,
          openSingleMode: true,
          onSubmit: (date) => selected = date,
        ),
      ),
    );

    await tester.tap(find.text('Jan'));
    await tester.pump();

    expect(selected, isNotNull);
  });

  testWidgets('cancel button triggers onCancel', (tester) async {
    bool cancelled = false;

    await tester.pumpWidget(
      wrapWithMaterial(
        CustomCalendarDatePicker(
          selectedDate: DateTime.now(),
          onCancel: () => cancelled = true,
        ),
      ),
    );

    await tester.tap(find.text('Cancel'));
    await tester.pump();

    expect(cancelled, true);
  });

  testWidgets('submit button triggers onSubmit', (tester) async {
    DateTime? submitted;

    await tester.pumpWidget(
      wrapWithMaterial(
        CustomCalendarDatePicker(
          selectedDate: DateTime(2026, 3, 15),
          onSubmit: (date) => submitted = date,
        ),
      ),
    );

    await tester.tap(find.text('Submit'));
    await tester.pump();

    expect(submitted, isNotNull);
  });
}
