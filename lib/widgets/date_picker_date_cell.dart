import 'package:flutter/material.dart';


/// A stateless widget representing a single date cell in a calendar view.
///
/// This widget visually distinguishes various states:
/// - Highlights the current day with a background color.
/// - Outlines the selected date with a border.
/// - Applies opacity to dates outside the current month for faded effect.
///
/// The cell reacts to tap gestures by invoking an optional callback, typically used
/// to notify the parent widget when a new date is selected.
class DatePickerDateCell extends StatelessWidget {
  /// The date this cell represents.
  final DateTime date;

  /// Whether this cell's date is currently selected.
  final bool selected;

  /// Whether this date is today's date.
  final bool current;

  /// Callback triggered when the cell is tapped.
  final VoidCallback? onSelected;

  /// Whether this cell is enabled and belongs to current month.
  final bool enabled;

  /// Constructs a date cell widget.
  const DatePickerDateCell({
    super.key,
    required this.date,
    this.selected = false,
    this.current = false,
    this.enabled = true,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ), // RoundedRectangleBorder
        hoverColor: Colors.blue.shade100,
        onTap: onSelected,
        child: Container(
          margin: EdgeInsets.all(1),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            // Highlight background if this is today's date.
            color: _backgroundColor,
            // Show a colored border around the selected date.
            border: Border.all(color: _borderColor),
            borderRadius: BorderRadius.circular(8),
          ), // BoxDecoration
          // Fade dates that do not belong to the current month.
          child: Text(
            '${date.day}',
            style: TextStyle(
              fontWeight: _fontWeight,
              color: _textColor,
              height: 1,
            ),
            textAlign: TextAlign.center,
          ), // Text
        ), // Container
      ), // InkWell
    ); // Material
  }

  /// Background color for the cell: primary color for today's date, else transparent.
  Color get _backgroundColor =>
      selected ? Colors.blue : Colors.transparent;

  /// Determines font weight: bold for current or selected month, normal otherwise.
  FontWeight get _fontWeight => selected ? FontWeight.w600 : FontWeight.w400;

  /// Text color for the day number depending on whether it's today or normal day.
  Color get _textColor => enabled
      ? selected
          ? Colors.white
          : current
              ? Colors.blue
              : Colors.grey
      : Colors.grey.shade300;

  /// Border color for the cell: primary color if selected, else transparent.
  Color get _borderColor =>
      current ? Colors.blue : Colors.transparent;
}
