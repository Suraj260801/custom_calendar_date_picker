import 'package:flutter/material.dart';

class FormActions extends StatelessWidget {
  const FormActions({
    super.key,
    this.onSecondaryAction,
    this.onPrimaryAction,
    this.primaryActionLabel = 'Apply',
    this.secondaryActionLabel = 'Cancel',
  });
  final VoidCallback? onSecondaryAction;
  final VoidCallback? onPrimaryAction;
  final String primaryActionLabel;
  final String secondaryActionLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: onSecondaryAction,
            child: Text(secondaryActionLabel),
          ),
        ),
        Expanded(
          child: FilledButton(
            onPressed: onPrimaryAction,
            child: Text(primaryActionLabel),
          ),
        ),
      ],
    );
  }
}
