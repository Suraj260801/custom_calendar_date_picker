import 'dart:developer';
import 'package:custom_calendar_date_picker/utils/enums.dart';
import 'package:intl/intl.dart';

bool isDateSelectionAllowed({
  DateTime? firstDate,
  DateTime? lastDate,
  required int year,
  int? month,
  int? day,
}) {
  if (firstDate == null && lastDate == null) {
    return true;
  }

  final selectedDateStr = StringBuffer()..write(year);

  final firstDateStr = StringBuffer();
  final lastDateStr = StringBuffer();

  // Append year strings or empty if null
  firstDateStr.write(firstDate?.year.toString() ?? '');
  lastDateStr.write(lastDate?.year.toString() ?? '');

  // Append month if provided
  if (month != null) {
    selectedDateStr.write(month < 10 ? '0$month' : '$month');

    if (firstDate != null) {
      firstDateStr.write(
        firstDate.month < 10 ? '0${firstDate.month}' : '${firstDate.month}'
      );
    }

    if (lastDate != null) {
      lastDateStr.write(
        lastDate.month < 10 ? '0${lastDate.month}' : '${lastDate.month}'
      );
    }
  }

  // Append day if provided
  if (day != null) {
    selectedDateStr.write(day < 10 ? '0$day' : '$day');

    if (firstDate != null) {
      firstDateStr.write(
        firstDate.day < 10 ? '0${firstDate.day}' : '${firstDate.day}'
      );
    }

    if (lastDate != null) {
      lastDateStr.write(
        lastDate.day < 10 ? '0${lastDate.day}' : '${lastDate.day}'
      );
    }
  }

  try {
    final formattedDate = int.parse(selectedDateStr.toString());
    final formattedFirstDate = firstDateStr.isNotEmpty
        ? int.parse(firstDateStr.toString())
        : null;
    final formattedLastDate = lastDateStr.isNotEmpty
        ? int.parse(lastDateStr.toString())
        : null;

    if ((formattedFirstDate != null && formattedDate < formattedFirstDate) ||
        (formattedLastDate != null && formattedDate > formattedLastDate)) {
      return false;
    }
  } on FormatException {
    log('FormatException while parsing dates in isDateSelectionAllowed.');
    return false;
  } catch (e) {
    log('Error in isDateSelectionAllowed: $e');
    return false;
  }

  return true;
}

/// Determines if a given [date] is in the same, previous, or next month
/// relative to a [refDate].
///
/// This utility function is useful for categorizing dates within a calendar
/// view that spans multiple months. It works by normalizing the month and year
/// of both dates to ensure accurate comparison, regardless of the day or time.
///
/// Throws no exceptions, as the comparison logic is robust for valid [DateTime]
///
/// @param date The date to be categorized.
/// @param refDate The reference date, typically the currently displayed month.
/// @return The [MonthType] (previous, current, or next) of the [date].
MonthType getMonthType(DateTime date, DateTime refDate) {
  // Normalize the dates by setting the day to 1 and time to midnight.
  // This ensures the comparison is based purely on the month and year.
  final normalizedDate = DateTime(date.year, date.month);
  final normalizedNow = DateTime(refDate.year, refDate.month);

  // Compare the month and year of the two dates.
  if (normalizedDate.isAtSameMomentAs(normalizedNow)) {
    return MonthType.current;
  } else if (normalizedDate.isBefore(normalizedNow)) {
    return MonthType.previous;
  } else {
    return MonthType.next;
  }
}

DateTime getLastDayOfMonth(DateTime displayDate){
  return DateTime(displayDate.year,displayDate.month+1,0);
}


DateTime getFirstDayOfMonth(DateTime displayDate){
  return DateTime(displayDate.year,displayDate.month,1);
}

/// determine the last day of the month, and then extracts the day number.
///
/// @param displayDate The date for which to determine the number of days in its month.
/// @returns An integer representing the number of days in the month of the [displayDate].
int getDaysInMonth(DateTime displayDate) {
  // Calling the helper function, which is already robust with DateTime handling.
  DateTime lastDayOfMonth = getLastDayOfMonth(displayDate);
  // Safely extracts the day component from the lastDayOfMonth DateTime object.
  // No exception handling needed here as lastDayOfMonth will always be a valid DateTime.
  return lastDayOfMonth.day;
}

/// Returns the starting weekday of the month for the given [displayDate].
///
/// The returned value is an integer from 0 (Sunday) to 6 (Saturday).
/// This aligns with typical calendar display where Sunday is the first day of the week.
/// The [DateTime.weekday] property returns 1 for Monday through 7 for Sunday,
/// so a modulo 7 operation is used to convert it to 0-based indexing starting Sunday.
///
/// @param displayDate The date within the desired month to find the starting weekday.
/// @returns An integer (0-6) representing the weekday of the first day of the month.
int getStartWeekDay(DateTime displayDate) {
  // Calling the helper function, which creates a valid DateTime for the first day of the month.
  DateTime firstDayOfMonth = getFirstDayOfMonth(displayDate);
  // DateTime.weekday returns 1 for Monday, 7 for Sunday.
  // We apply modulo 7 to convert it to 0 (Sunday) to 6 (Saturday) indexing.
  // Example: If firstDayOfMonth is Monday (1), (1 % 7) = 1.
  // If firstDayOfMonth is Sunday (7), (7 % 7) = 0.
  int startWeekday = (firstDayOfMonth.weekday) % 7;
  // No exception handling needed as firstDayOfMonth will always be a valid DateTime,
  // and the modulo operation is safe with integer inputs.
  return startWeekday;
}

/// Calculates the number of days belonging to the previous, current, and next
/// months to be displayed on a calendar grid for a given [displayDate].
///
/// This function determines how many days from the previous and next months
/// are needed to complete the calendar week layout for the [displayDate]'s month.
///
/// The returned map contains three entries:
/// - [MonthType.previous]: Number of days from the previous month to display.
/// - [MonthType.current]: Number of days in the [displayDate]'s month.
/// - [MonthType.next]: Number of days from the next month to display.
///
/// Throws a [FormatException] if the [displayDate] is invalid or outside
/// a reasonable range.
List<DateTime> getMonthDaysList(DateTime displayDate) {
  // The weekday of the first day of the [displayDate]'s month.
  // (e.g., 0 for Sunday, 1 for Monday, ..., 6 for Saturday).
  ///
  // This determines how many days from the previous month are needed
  // to align the first day of the month with the start of a week.
  int previousMonthDays = getStartWeekDay(displayDate);

  // The number of days in the [displayDate]'s month.
  int currentMonthDays = getDaysInMonth(displayDate);

  // Calculate the number of cells already occupied by previous and current month days.
  final previousAndCurrentMonthDays = previousMonthDays + currentMonthDays;

  // Calculates the total no of day including previousAndCurrentMonthDays and next month days.
  // if previousAndCurrentMonthDays is multiple of 7 then it's value will be either 28 or 35.
  // if previousAndCurrentMonthDays is not multiple of 7 then we have to make it multiple of 7.
  // To do so we must fill last incomplete row by adding 7-(previousAndCurrentMonthDays%7) no of cells
  // to previousAndCurrentMonthDays.
  // if 7-(totalDaysShown%7) is again multiple of 7 then make it zero by taking modulo.
  int totalNoOfDays =
      previousAndCurrentMonthDays + (7 - (previousAndCurrentMonthDays % 7)) % 7;

  // Calculates the number of remaining cells to fill the last incomplete row
  // containing next month days.
  final nextMonthDays = totalNoOfDays - previousAndCurrentMonthDays;

  List<DateTime> days = [];

  // Previous month days
  for (int i = previousMonthDays - 1; i >= 0; i--) {
    days.add(DateTime(displayDate.year, displayDate.month, -i));
  }

  // Current month days
  for (int i = 1; i <= currentMonthDays; i++) {
    days.add(DateTime(displayDate.year, displayDate.month, i));
  }

  // Next month days
  for (int i = 1; i <= nextMonthDays; i++) {
    days.add(DateTime(displayDate.year, displayDate.month + 1, i));
  }

  return days;
}

List<String> initializeWeekDays({WeekDayFormat format = WeekDayFormat.full}) {
  final List<String> weekDays = [];

  try {
    final DateTime now = DateTime.now();

    // DateTime.weekday returns 1 for Monday, 7 for Sunday
    int currentDayOfWeek = now.weekday;

    // Find the previous Sunday (start of the week)
    DateTime firstDayOfWeek = now.subtract(
      Duration(days: currentDayOfWeek % 7),
    );

    for (int i = 0; i < 7; i++) {
      // Add i days to the first day of the week
      final weekDayDate = firstDayOfWeek.add(Duration(days: i));

      String day = DateFormat(format.format).format(weekDayDate);

      weekDays.add(day);
    }
  } catch (e) {
    // Handle the exception
    log('Error initializing weekdays: $e');
    return [];
  }

  return weekDays;
}

/// Initializes a list of month names localized by the optional format string.
List<String> initializeMonths({MonthFormat format = MonthFormat.full}) {
  final List<String> months = [];

  try {
    for (int i = 1; i <= 12; i++) {
      // Create a DateTime object for each month
      final monthDate = DateTime(DateTime.now().year, i);

      // Format month name (e.g., "January", "February")
      months.add(DateFormat(format.format).format(monthDate));
    }

    return months;
  } on FormatException catch (e) {
    log('FormatException while initializing months: $e');
    return [];
  } catch (e) {
    log('Unexpected error initializing months: $e');
    return [];
  }
}

/// Generates a list of years within the specified range.
List<int> initializeYears({
  required DateTime? firstDate,
  required DateTime? lastDate,
}) {
  final DateTime today = DateTime.now();

  // Default: 100 years before current year
  final int firstYear = firstDate?.year ?? (today.year - 100);

  // Default: 100 years after current year
  final int lastYear = lastDate?.year ?? (today.year + 100);

  // Generate list of years
  return List<int>.generate(
    lastYear - firstYear + 1,
    (index) => firstYear + index,
  );
}