import 'package:flutter/material.dart';

/// A collapsible section for organizing form fields.
///
/// Provides an expandable/collapsible container with:
/// - Icon and title header
/// - Expand/collapse toggle
/// - Optional trailing widget
/// - Error state indicator
///
/// Example:
/// ```dart
/// CollapsibleFormSection(
///   title: 'Owner Information',
///   icon: Icons.person_outline,
///   isExpanded: isOwnerExpanded.value,
///   onToggle: () => isOwnerExpanded.value = !isOwnerExpanded.value,
///   child: Column(
///     children: [
///       FormBuilderTextField(name: 'ownerName', ...),
///       FormBuilderTextField(name: 'ownerPhone', ...),
///     ],
///   ),
/// )
/// ```
///
/// With error state:
/// ```dart
/// CollapsibleFormSection(
///   title: 'Contact Details',
///   icon: Icons.contact_phone,
///   isExpanded: isContactExpanded.value,
///   onToggle: () => isContactExpanded.value = !isContactExpanded.value,
///   hasError: hasContactErrors,
///   child: ContactFormFields(),
/// )
/// ```
class CollapsibleFormSection extends StatelessWidget {
  const CollapsibleFormSection({
    super.key,
    required this.title,
    required this.icon,
    required this.isExpanded,
    required this.onToggle,
    required this.child,
    this.trailing,
    this.hasError = false,
    this.maintainState = false,
  });

  /// The section title text.
  final String title;

  /// The icon displayed in the header.
  final IconData icon;

  /// Whether the section is currently expanded.
  final bool isExpanded;

  /// Called when the header is tapped to toggle expansion.
  final VoidCallback onToggle;

  /// The content to display when expanded.
  final Widget child;

  /// Optional widget displayed in the header (before the expand icon).
  final Widget? trailing;

  /// Whether the section has validation errors.
  /// Changes the border and header color to error color.
  final bool hasError;

  /// Whether to maintain the child widget's state when collapsed.
  /// If true, uses Offstage instead of conditionally building.
  final bool maintainState;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderColor =
        hasError ? theme.colorScheme.error : theme.colorScheme.outlineVariant;
    final headerColor =
        hasError ? theme.colorScheme.error : theme.colorScheme.primary;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Icon(icon, size: 20, color: headerColor),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: headerColor,
                      ),
                    ),
                  ),
                  if (trailing != null) trailing!,
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
          if (maintainState)
            Offstage(
              offstage: !isExpanded,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                child: child,
              ),
            )
          else if (isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: child,
            ),
        ],
      ),
    );
  }
}
