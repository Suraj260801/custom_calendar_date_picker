library custom_calendar_date_picker;

import 'dart:async';
import 'package:custom_calendar_date_picker/utils/enums.dart';
import 'package:custom_calendar_date_picker/utils/utility.dart';
import 'package:custom_calendar_date_picker/widgets/date_picker_body.dart';
import 'package:custom_calendar_date_picker/widgets/date_picker_header.dart';
import 'package:custom_calendar_date_picker/widgets/form_actions.dart';
import 'package:custom_calendar_date_picker/widgets/week_day_header.dart';
import 'package:flutter/material.dart';


OverlayEntry? _overlayEntry;

OverlayEntry? _overlayBackgroundEntry;

Completer<DateTime?>? _completer;

Future<DateTime?> showCustomCalendarDatePicker({
  required BuildContext context,
  required DateTime selectedDate,
  CalendarDatePickerViewMode viewMode = CalendarDatePickerViewMode.dialog,
  CalendarDatePickerMode mode = CalendarDatePickerMode.month,
  WeekDayFormat weekDayFormat = WeekDayFormat.abbreviated,
  Color? backgroundColor = Colors.transparent,
  bool openSingleMode = false,
  DateTime? firstDate,
  DateTime? lastDate,
  BoxDecoration? boxDecoration,
  String? previousActionIcon,
  String? nextActionIcon,
  String? primaryActionLabel,
  String? secondaryActionLabel,
  Offset? position,
  double? minWidth,
}) async {
  if (!isDialogViewMode(viewMode)) {
    return await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return Container(
          width: minWidth ?? MediaQuery.sizeOf(context).width,
          decoration: boxDecoration ?? _defaultDecoration,
          child: CustomCalendarDatePicker(
              selectedDate: selectedDate,
              firstDate: firstDate,
              lastDate: lastDate,
              mode: mode,
              weekDayFormat: weekDayFormat,
              backgroundColor: backgroundColor ?? Colors.transparent,
              previousActionIcon: previousActionIcon,
              nextActionIcon: nextActionIcon,
              onCancel: () =>
                  _onCancel(viewMode: viewMode, context: context),
              onSubmit: (date) => _onSubmit(
                viewMode: viewMode,
                context: context,
                date: date,
              ),
              openSingleMode: openSingleMode,
            ),
        );
      },
    );
  } else {
    _completer = Completer<DateTime?>();

    _overlayBackgroundEntry = OverlayEntry(
      builder: (_) {
        return Material(
          animationDuration: Duration.zero,
          color: Colors.transparent,
          child: InkWell(
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () => _onClose([_overlayBackgroundEntry, _overlayEntry]),
            child: Container(
              constraints: BoxConstraints.expand(),
              color: Colors.transparent,
            ),
          ),
        );
      },
    );

    _overlayEntry = OverlayEntry(
      builder: (_) {
        return Positioned(
          top: position != null ? position.dy : 0,
          left: position != null ? position.dx : 0,
          child: Container(
            constraints: BoxConstraints(
              minWidth: minWidth ?? 300,
            ),
            decoration: boxDecoration ?? _defaultDecoration,
            child: CustomCalendarDatePicker(
              selectedDate: selectedDate,
              firstDate: firstDate,
              lastDate: lastDate,
              mode: mode,
              weekDayFormat: weekDayFormat,
              backgroundColor: backgroundColor ?? Colors.transparent,
              previousActionIcon: previousActionIcon,
              nextActionIcon: nextActionIcon,
              onCancel: () =>
                  _onCancel(viewMode: viewMode, context: context),
              onSubmit: (date) => _onSubmit(
                viewMode: viewMode,
                context: context,
                date: date,
              ),
              openSingleMode: openSingleMode,
            ),
          ),
        );
      },
    );

    Overlay.of(context).insert(_overlayBackgroundEntry!);
    Overlay.of(context).insert(_overlayEntry!);

    return _completer?.future;
  }
}

bool isDialogViewMode(viewMode)=>viewMode==CalendarDatePickerViewMode.dialog;

void _onCancel({required CalendarDatePickerViewMode viewMode, required BuildContext context}) {
  if (!isDialogViewMode(viewMode)) {
    Navigator.of(context).pop(null);
  } else {
    _completer?.complete(null);
    _onClose([_overlayBackgroundEntry, _overlayEntry]);
  }
}

void _onSubmit({
  required CalendarDatePickerViewMode viewMode,
  required BuildContext context,
  required DateTime date,
}) {
  if (!isDialogViewMode(viewMode)) {
    Navigator.of(context).pop(date);
  } else {
    _completer?.complete(date);
    _onClose([_overlayBackgroundEntry, _overlayEntry]);
  }
}

void _onClose(List<OverlayEntry?> overlays) {
  for (var e in overlays) {
    if (e != null) {
      e.remove();
    }
  }
}

BoxDecoration get _defaultDecoration =>
    BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16));

class CustomCalendarDatePicker extends StatefulWidget {
  final DateTime selectedDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final CalendarDatePickerMode mode;
  final WeekDayFormat weekDayFormat;
  final MonthFormat monthFormat;
  final String? previousActionIcon;
  final String? nextActionIcon;
  final bool? compactView;
  final VoidCallback? onCancel;
  final void Function(DateTime)? onSubmit;
  final Color backgroundColor;
  final bool showActions;
  final String primaryActionLabel;
  final String secondaryActionLabel;
  final bool? openSingleMode;

  const CustomCalendarDatePicker({
    super.key,
    required this.selectedDate,
    this.mode = CalendarDatePickerMode.day,
    this.weekDayFormat = WeekDayFormat.abbreviated,
    this.monthFormat = MonthFormat.abbreviated,
    this.backgroundColor = Colors.transparent,
    this.showActions = false,
    this.primaryActionLabel = 'Submit',
    this.secondaryActionLabel = 'Cancel',
    this.firstDate,
    this.lastDate,
    this.previousActionIcon,
    this.nextActionIcon,
    this.compactView,
    this.onCancel,
    this.onSubmit,
    this.openSingleMode,
  });

  @override
  State<CustomCalendarDatePicker> createState() => _CustomCalendarDatePickerState();
}

class _CustomCalendarDatePickerState extends State<CustomCalendarDatePicker> {
  late DateTime selectedDate;
  late List<String> weekDays;
  late CalendarDatePickerMode currentMode;
  late List<String> months;
  late List<int> years;
  late List<String> monthHeaderLabels;
  late int displayYear;
  int? displayMonth;

  @override
  void initState() {
    super.initState();

    weekDays = initializeWeekDays(format: widget.weekDayFormat);
    months = initializeMonths(format: widget.monthFormat);
    years = initializeYears(
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
    );

    selectedDate = widget.selectedDate;
    currentMode = widget.mode;

    displayYear = selectedDate.year;
    displayMonth = selectedDate.month;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        border: Border.all(color: Colors.transparent),
      ),
      child: IntrinsicWidth(
        child: Column(
          spacing: 12,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /// Header with navigation buttons
            DatePickerHeader(
              label: headerLabel,
              previousActionIcon: widget.previousActionIcon,
              nextActionIcon: widget.nextActionIcon,
              onPreviousAction: onPreviousAction,
              onNextAction: onNextAction,
              onLabelTap: _onLabelTap,
              date: DateTime(displayYear, displayMonth ?? 1, selectedDate.day),
              firstDate: widget.firstDate,
              lastDate: widget.lastDate,
              mode: currentMode,
            ),

            Divider(thickness: 1, color: Colors.grey.shade300),

            /// Weekday header (only in days mode)
            if (isDayMode)
              WeekDayHeader(
                days: weekDays,
                dayTextStyle: TextStyle(color: Colors.grey),
                color: Colors.transparent,
              ),

            /// Calendar body
            DatePickerBody(
              selectedDate: selectedDate,
              displayYear: displayYear,
              displayMonth: displayMonth,
              firstDate: widget.firstDate,
              lastDate: widget.lastDate,
              months: months,
              years: years,
              mode: currentMode,
              onDateChange: onDateSelected,
              onMonthChange: _onMonthChange,
              onYearChange: _onYearChange,
            ),

            /// Actions
            Divider(thickness: 1, color: Colors.grey.shade300),

            FormActions(
              primaryActionLabel: widget.primaryActionLabel,
              secondaryActionLabel: widget.secondaryActionLabel,
              onSecondaryAction: widget.onCancel,
              onPrimaryAction: widget.onSubmit != null
                  ? () => widget.onSubmit!(selectedDate)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  /// Moves calendar view to previous month/year depending on current mode.
  void onPreviousAction() {
    if (isMonthMode) {
      displayYear--;
    } else {
      goPreviousMonth();
    }

    setState(() {});
  }

  /// Moves calendar view to next month/year depending on current mode.
  void onNextAction() {
    if (isMonthMode) {
      displayYear++;
    } else {
      goNextMonth();
    }

    setState(() {});
  }

  /// Helper to decrement month; wraps year back if month is January.
  void goPreviousMonth() {
    if (displayMonth == null) {
      throw ArgumentError('displayMonth cannot be null');
    }

    if (displayMonth == 1) {
      displayYear--;
      displayMonth = 12;
    } else {
      displayMonth = displayMonth! - 1;
    }
  }

  /// Helper to increment month; advances year if month is December.
  void goNextMonth() {
    if (displayMonth == null) {
      throw ArgumentError('displayMonth cannot be null');
    }

    if (displayMonth == 12) {
      displayYear++;
      displayMonth = 1;
    } else {
      displayMonth = displayMonth! + 1;
    }
  }

  /// Gets the header label based on current mode.
  String get headerLabel {
    return isMonthMode ? headerYearLabel : headerMonthLabel;
  }

  /// Returns the displayed year as string.
  String get headerYearLabel => '$displayYear';

  /// Returns the full month name of the displayed month.
  String get headerMonthLabel => months[(displayMonth ?? 1) - 1];

  /// Mode checks
  bool get isMonthMode => currentMode == CalendarDatePickerMode.month;
  bool get isDayMode => currentMode == CalendarDatePickerMode.day;
  bool get isYearMode => currentMode == CalendarDatePickerMode.year;

  /// Handles date selection
  void onDateSelected({required DateTime date}) {
    final bool sameDaySelected = DateUtils.isSameDay(selectedDate, date);

    if (isDayMode && sameDaySelected) return;

    setState(() {
      currentMode = CalendarDatePickerMode.day;
      selectedDate = date;
    });

    widget.onSubmit?.call(selectedDate);
  }

  /// Handles header label taps to cycle through picker modes (year <-> month <-> day).
  void _onLabelTap() {
    setState(() {
      if (currentMode == CalendarDatePickerMode.month) {
        // TODO: Enable year mode when UI is ready
        // currentMode = DatePickerMode.year;
        return;
      } else if (currentMode == CalendarDatePickerMode.day) {
        currentMode = CalendarDatePickerMode.month;
      }
    });
  }

  /// Updates state on year selection: sets display year and switches to months mode.
  void _onYearChange({required int year}) {
    setState(() {
      displayYear = year;
      displayMonth = null;
      currentMode = CalendarDatePickerMode.month;
    });
  }

  /// Updates state on month selection: sets display year/month and switches to days mode.
  void _onMonthChange({required int year, required int month}) {
    if (widget.mode == CalendarDatePickerMode.month &&
        (widget.openSingleMode ?? false)) {
      widget.onSubmit?.call(DateTime(year, month, 1));
    }

    setState(() {
      displayYear = year;
      displayMonth = month;
      currentMode = CalendarDatePickerMode.day;
    });
  }
}
