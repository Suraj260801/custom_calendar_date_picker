import 'package:flutter/material.dart';
/// to a base left arrow SVG.
class RotatedSvgIcon extends StatelessWidget {
  /// Direction the arrow should point (default: left).
  final Direction direction;

  /// Size of the arrow icon (default: 24x24).
  final Size size;

  /// Optional color tint applied to the SVG using ColorFilter.
  final Color? color;

  /// Path to the base left arrow SVG asset.
  ///
  /// This single asset is rotated to create all arrow directions, reducing bund
  final String icon;

  /// Creates a rotatable svg icon from a single left arrow SVG.
  const RotatedSvgIcon({
    super.key,
    required this.icon,
    this.direction = Direction.left,
    this.size = const Size(24, 24),
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: direction.rotationAngle,
      child: Icon(Icons.arrow_upward,),
    ); // RotatedBox
  }
}

/// Enum defining supported arrow directions for [RotatedSvgIcon].
enum Direction {
  up(0),
  left(1),
  down(2),
  right(3);

  final int rotationAngle;
  const Direction(this.rotationAngle);
}
