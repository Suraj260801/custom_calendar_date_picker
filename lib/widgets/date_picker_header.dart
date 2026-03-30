import 'package:custom_calendar_date_picker/utils/enums.dart';
import 'package:custom_calendar_date_picker/utils/utility.dart';
import 'package:custom_calendar_date_picker/widgets/rotated_svg_icon.dart';
import 'package:flutter/material.dart';

class DatePickerHeader extends StatelessWidget {
  const DatePickerHeader({
    super.key,
    required this.label,
    this.previousActionIcon,
    this.nextActionIcon,
    required this.onPreviousAction,
    required this.onNextAction,
    required this.onLabelTap,
    required this.date,
    required this.mode,
    this.firstDate,
    this.lastDate,
  });
  final String label;
  final String? previousActionIcon;
  final String? nextActionIcon;
  final VoidCallback onPreviousAction;
  final VoidCallback onNextAction;
  final VoidCallback onLabelTap;
  static const iconSize = Size(16, 20);
  final DateTime? firstDate;
  final DateTime? lastDate;
  final DateTime date;
  final CalendarDatePickerMode mode;

@override
  Widget build(BuildContext context) {
    final isMonthMode = mode == CalendarDatePickerMode.month;

    // Pre-calculate button states
    final bool prevEnabled = isMonthMode
        ? _isPreviousYearSelectionAllowed
        : _isPreviousMonthSelectionAllowed;
    final bool nextEnabled = isMonthMode
        ? _isNextYearSelectionAllowed
        : _isNextMonthSelectionAllowed;

    final Color prevIconColor = prevEnabled
        ? Colors.grey
        : Colors.grey.shade400;
    final Color nextIconColor = nextEnabled
        ? Colors.grey
        : Colors.grey.shade400;

    return Row(
      children: [
        /// Previous button
        IconButton(
          onPressed: prevEnabled ? onPreviousAction : null,
          icon: previousActionIcon != null
              ? RotatedSvgIcon(
                  icon: previousActionIcon!,
                  size: iconSize,
                  direction: Direction.up,
                  color: prevIconColor,
                ) // RotatedSvgIcon
              : Icon(Icons.arrow_left, color: prevIconColor),
        ), // IconButton

        /// Label
        Expanded(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onLabelTap,
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ), // Text
            ), // InkWell
          ), // Material
        ), // Expanded

        /// Next button
        IconButton(
          onPressed: nextEnabled ? onNextAction : null,
          icon: nextActionIcon != null
              ? RotatedSvgIcon(
                  icon: nextActionIcon!,
                  size: iconSize,
                  direction: Direction.down,
                  color: nextIconColor,
                ) // RotatedSvgIcon
              : Icon(Icons.arrow_right, color: nextIconColor),
        ), // IconButton
      ],
    ); // Row
  }

  bool get _isPreviousYearSelectionAllowed => isDateSelectionAllowed(
        year: date.year - 1, // Previous year
        firstDate: firstDate,
        lastDate: lastDate,
      );

  bool get _isNextYearSelectionAllowed => isDateSelectionAllowed(
        year: date.year + 1, // Next year
        firstDate: firstDate,
        lastDate: lastDate,
      );

  bool get _isPreviousMonthSelectionAllowed {
    final previousMonthDate = DateTime(date.year, date.month - 1, 1);
    return isDateSelectionAllowed(
      firstDate: firstDate,
      lastDate: lastDate,
      year: previousMonthDate.year,
      month: previousMonthDate.month,
    );
  }

  bool get _isNextMonthSelectionAllowed {
    final nextMonthDate = DateTime(date.year, date.month + 1, 1);
    return isDateSelectionAllowed(
      firstDate: firstDate,
      lastDate: lastDate,
      year: nextMonthDate.year,
      month: nextMonthDate.month,
    );
  }
}
