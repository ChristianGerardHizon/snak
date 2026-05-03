import 'package:flutter/material.dart';

/// A styled section header for forms.
///
/// Displays an icon and title in the primary color,
/// used to visually separate form sections.
///
/// Example:
/// ```dart
/// FormSectionHeader(
///   title: 'Product Information',
///   icon: Icons.inventory_2_outlined,
/// )
/// ```
class FormSectionHeader extends StatelessWidget {
  const FormSectionHeader({
    super.key,
    required this.title,
    required this.icon,
  });

  /// The section title text.
  final String title;

  /// The icon displayed before the title.
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
