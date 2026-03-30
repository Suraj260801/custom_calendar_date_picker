import 'package:flutter/material.dart';

/// A stateless widget that represents a single year cell in a date picker.
///
/// This widget displays the year number and visually highlights it if selected.
/// It also responds to tap gestures, invoking an optional callback to notify
/// the parent widget when the year cell is tapped.
class DatePickerYearCell extends StatelessWidget {
  /// The year value to display in this cell, e.g. 2025.
  final int year;

  /// Whether this year is currently selected.
  final bool selected;

  /// When true, the year text is highlighted with a primary color.
  final bool current;

  /// Callback triggered when the year cell is tapped.
  final VoidCallback? onSelected;

  /// Creates a year cell widget.
  ///
  /// Requires the year to display and an optional tap callback.
  /// The selected flag indicates whether the year is currently selected.
  const DatePickerYearCell({
    super.key,
    required this.year,
    required this.onSelected,
    required this.current,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onSelected,
        child: DecoratedBox(
          decoration: BoxDecoration(border: Border.all(color: _borderColor)),
          child: Text(
            '$year',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: _fontWeight,
                  color: _textColor,
                ),
          ), // Text
        ), // DecoratedBox
      ), // InkWell
    ); // Material
  }

  /// Determines font weight: bold for current or selected month, normal otherwise.
  FontWeight get _fontWeight =>
      current || selected ? FontWeight.w600 : FontWeight.w400;

  /// Text color for the month: primary if current or selected, else default color.
  Color get _textColor =>
      current || selected ? Colors.blue : Colors.black87;

  /// Border color: primary color if selected (but not when current month to avoid overlap), else transparent.
  Color get _borderColor =>
      selected && !current ? Colors.blue : Colors.transparent;
}
