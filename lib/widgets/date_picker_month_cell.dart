import 'package:flutter/material.dart';

/// A tappable widget representing a single month in a date picker.
///
/// Displays the month name and visually indicates its status:
/// - Highlights the currently selected month with a border and text color.
/// - Highlights the current calendar month (today's month) with bold text and color.
/// - Applies opacity to fade out months if needed.
///
/// The widget notifies the parent when tapped via the [onSelected] callback.
class DatePickerMonthCell extends StatelessWidget {
  /// The display name of the month, e.g., "Jan", "February".
  final String month;

  /// Whether this month corresponds to the current month (e.g., today's month).
  final bool current;

  /// Whether this month is currently selected.
  final bool selected;

  /// Whether this cell is enabled and belongs to current year.
  final bool enabled;

  /// Called when the month cell is tapped.
  final VoidCallback? onSelected;

  /// Creates a month cell widget with visual states and tap handling.
  const DatePickerMonthCell({
    super.key,
    required this.month,
    this.onSelected,
    this.enabled = true,
    this.selected = false,
    this.current = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        hoverColor: Colors.blue.shade100,
        onTap: onSelected,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: _backgroundColor,
            // Show a colored border around the selected month.
            border: Border.all(color: _borderColor, width: 1.5),
            borderRadius: BorderRadius.circular(8),
          ), // BoxDecoration
          padding: const EdgeInsets.symmetric(vertical: 12),
          margin: EdgeInsets.all(1),
          child: Text(
            month,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: _fontWeight,
                  color: _textColor,
                ),
          ), // Text
        ), // Container
      ), // InkWell
    ); // Material
  }

  Color get _backgroundColor =>
      selected ? Colors.blue : Colors.transparent;

  /// Determines font weight: bold for current or selected month, normal otherwise.
  FontWeight get _fontWeight =>
      current || selected ? FontWeight.w600 : FontWeight.w400;

  /// Text color for the month: primary if current or selected, else default color.
  Color get _textColor => enabled
      ? selected
          ? Colors.white
          : current
              ? Colors.blue
              : Colors.grey
      : Colors.grey.shade400;

  /// Border color: primary color if selected (but not when current month to avoid overlap), else transparent.
  Color get _borderColor =>
      current ? Colors.blue : Colors.transparent;
}