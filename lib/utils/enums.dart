enum CalendarDatePickerMode { day, month, year }

enum WeekDayFormat {
  full("EEEE"),
  abbreviated("EEE"),
  shortest("EE");

  final String format;

  const WeekDayFormat(this.format);
}

enum MonthFormat {
  full("MMM"),
  abbreviated("MMM");

  final String format;

  const MonthFormat(this.format);
}

enum CalendarDatePickerViewMode{
  dialog,
  bottomSheet
}

enum MonthType { current, previous, next }

enum CalendarMode { week, month, hidden }