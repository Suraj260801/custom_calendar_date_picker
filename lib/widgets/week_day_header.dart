import 'package:flutter/material.dart';

class WeekDayHeader extends StatelessWidget {
  const WeekDayHeader({
    super.key,
    required this.days,

    this.color = Colors.white,
    this.borderColor = Colors.transparent,
    this.headerPadding = 10,
    this.itemPadding = 4,
    this.dayTextStyle,
  });

  final List<String> days;
  final TextStyle? dayTextStyle;
  final Color color;
  final Color borderColor;
  final double headerPadding;
  final double itemPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: headerPadding),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        color: color,
      ),
      child: Row(
        children: List.generate(
          days.length,
          (index) => Expanded(
            child: Padding(
              key: ValueKey(days[index]),
              padding: EdgeInsetsGeometry.symmetric(vertical: itemPadding),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  days[index],
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    decoration: TextDecoration.none,
                  ).merge(dayTextStyle),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
