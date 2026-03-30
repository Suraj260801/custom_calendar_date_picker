
import 'package:custom_calendar_date_picker/utils/enums.dart';
import 'package:custom_calendar_date_picker/utils/utility.dart';
import 'package:custom_calendar_date_picker/widgets/date_picker_date_cell.dart';
import 'package:custom_calendar_date_picker/widgets/date_picker_month_cell.dart';
import 'package:custom_calendar_date_picker/widgets/date_picker_year_cell.dart';
import 'package:flutter/material.dart';


/// A stateless widget that renders the calendar grid depending on the current picker's mode.
///
/// - In day mode, shows a grid of day cells representing all days in the displayed month.
/// - In month mode, shows a grid of month cells representing all months in the displayed year.
/// - In year mode, shows a list of year cells for year selection.
///
/// Provides callbacks for date, month, and year selections.
/// Supports date range constraints via optional [firstDate] and [lastDate].
class DatePickerBody extends StatelessWidget {
  /// The currently selected date.
  final DateTime selectedDate;

  /// The year currently displayed by the picker.
  final int displayYear;

  /// The month currently displayed by the picker.
  final int? displayMonth;

  /// List of displayed month strings (e.g. 'Jan', 'Feb', ...).
  final List<String> months;

  /// List of years available for selection.
  final List<int> years;

  /// The current mode of the picker (days, months, or years).
  final CalendarDatePickerMode mode;

  /// Optional earliest selectable date.
  final DateTime? firstDate;

  /// Optional latest selectable date.
  final DateTime? lastDate;

  /// Callback when a date is selected.
  final void Function({required DateTime date})? onDateChange;

  /// Callback when a month/year is selected.
  final void Function({required int year, required int month})? onMonthChange;

  /// Callback when a year is selected.
  final void Function({required int year})? onYearChange;

  // Columns count based on mode
  static const int monthModeColumnCount = 3;
  static const int dayModeColumnCount = 7;
  static const int yearModeColumnCount = 1;

  /// Constructs the calendar grid body widget.
  const DatePickerBody({
    super.key,
    required this.selectedDate,
    required this.displayYear,
    required this.months,
    required this.years,
    required this.mode,
    this.firstDate,
    this.lastDate,
    this.onDateChange,
    this.onMonthChange,
    this.onYearChange,
    this.displayMonth,
  });

  @override
  Widget build(BuildContext context) {
    return Table(children: _getTableRows());
  }

  /// Generates TableRow list for Table based on picker mode.
  List<TableRow> _getTableRows() {
    if (isDayMode && displayMonth != null) {
      // Get the list of all days to display, including leading/trailing filler days if applicable.
      final List<DateTime> monthDays = getMonthDaysList(
        DateTime(displayYear, displayMonth!),
      );
      final int totalCount = monthDays.length;
      final int columns = dayModeColumnCount;
      final int rowsCount = (totalCount / columns).ceil();

      // Build all date cells once
      List<Widget> cells = _buildDateCells(days: monthDays);

      // Partition cells into TableRow widgets representing each week
      return List.generate(rowsCount, (index) {
        int start = index * columns;
        final int end = (start + columns) > cells.length
            ? cells.length
            : start + columns;
        return TableRow(children: cells.sublist(start, end));
      }); // List.generate
    } else if (isMonthMode) {
      // Month mode
      final int totalCount = months.length;
      final int columns = monthModeColumnCount;
      final int rowsCount = (totalCount / columns).ceil();

      // Build all month cells once
      List<Widget> cells = _buildMonthCells(months: months);

      // Partition month cells into TableRow widgets
      return List.generate(rowsCount, (index) {
        final int start = index * columns;
        final int end = (start + columns) > cells.length
            ? cells.length
            : start + columns;
        return TableRow(children: cells.sublist(start, end));
      }); // List.generate
    } else {
      // TODO: year view is not finalized yet.
      // Year mode:each year in separate row (single column)
      final int rowsCount = years.length;

      // Build all month cells once
      List<Widget> cells = _buildYearCells(years: years);

      // Partition month cells into TableRow widgets
      return List.generate(
        rowsCount,
        (index) => TableRow(children: [cells[index]]),
      ); // List.generate
    }
  }

  /// Builds date cells wrapped in square aspect ratio, with styling and callbacks.
  List<Widget> _buildDateCells({required List<DateTime> days}) {
    return List.generate(
      days.length,
      (index) => AspectRatio(
        aspectRatio: 1,
        child: DatePickerDateCell(
          date: days[index],
          current: DateUtils.isSameDay(days[index], DateTime.now()),
          selected: DateUtils.isSameDay(days[index], selectedDate),
          onSelected: () => _onDateSelected(
            year: days[index].year,
            month: days[index].month,
            day: days[index].day,
          ),
          enabled: _enabled(days[index]),
        ), // DatePickerDateCell
      ), // AspectRatio
    ); // List.generate
  }

  /// Builds month cells in a grid with selection, opacity, and taps.
  List<Widget> _buildMonthCells({required List<String> months}) {
    return List.generate(
      months.length,
      (index) => DatePickerMonthCell(
        month: months[index],
        onSelected: () => _onMonthSelected(year: displayYear, month: index + 1),
        selected:
            selectedDate.year == displayYear && selectedDate.month == index + 1,
        current: DateUtils.isSameMonth(
          DateTime(displayYear, index + 1),
          DateTime.now(),
        ),
        enabled: _isDateSelectionAllowed(year: displayYear, month: index + 1),
      ), // DatePickerMonthCell
    ); // List.generate
  }

  /// Builds year cells with selection and tap callbacks.
  List<Widget> _buildYearCells({required List<int> years}) {
    return List.generate(
      years.length,
      (index) => DatePickerYearCell(
        year: years[index],
        onSelected: () => _onYearSelected(years[index]),
        selected: years[index] == selectedDate.year,
        current: years[index] == DateTime.now().year,
      ), // DatePickerYearCell
    ); // List.generate
  }

  bool _enabled(DateTime date) {
    return _isMonthTypeCurrent(date) &&
        _isDateSelectionAllowed(
          year: date.year,
          month: date.month,
          day: date.day,
        );
  }

  void _onDateSelected({
    required int year,
    required int month,
    required int day,
  }) {
    DateTime date = DateTime(year, month, day);
    if (onDateChange != null &&
        _isMonthTypeCurrent(date) &&
        _isDateSelectionAllowed(year: year, month: month, day: day)) {
      onDateChange!(date: date);
    }
  }

  void _onMonthSelected({required int year, required int month}) {
    if (onMonthChange != null &&
        _isDateSelectionAllowed(year: year, month: month)) {
      onMonthChange!(year: year, month: month);
    }
  }

  void _onYearSelected(int year) {
    if (onYearChange != null && _isDateSelectionAllowed(year: year)) {
      onYearChange!(year: year);
    }
  }

  /// Checks if the selection of the specified date/year/month is allowed based on the range.
  bool _isDateSelectionAllowed({required int year, int? month, int? day}) {
    if (firstDate == null && lastDate == null) {
      return true;
    }
    return isDateSelectionAllowed(
      firstDate: firstDate,
      lastDate: lastDate,
      year: year,
      month: month,
      day: day,
    );
  }

  /// Checks if the given date belongs to the currently displayed month.
  bool _isMonthTypeCurrent(DateTime date) {
    MonthType monthType = getMonthType(
      date,
      DateTime(displayYear, displayMonth ?? 1),
    );
    return monthType == MonthType.current;
  }

  /// Returns true if picker is currently in day view mode.
  bool get isDayMode => mode == CalendarDatePickerMode.day;

  /// Returns true if picker is currently in month view mode.
  bool get isMonthMode => mode == CalendarDatePickerMode.month;

  /// Returns true if picker is currently in year view mode.
  bool get isYearMode => mode == CalendarDatePickerMode.year;
}