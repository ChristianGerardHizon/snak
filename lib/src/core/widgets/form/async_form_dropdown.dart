import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// A dropdown field that handles async data loading states.
///
/// Wraps [FormBuilderTypeAhead] with automatic handling of
/// loading and error states from [AsyncValue].
///
/// Example:
/// ```dart
/// AsyncFormDropdown<ProductCategory>(
///   name: 'category',
///   label: 'Category',
///   asyncData: categoriesAsync,
///   displayString: (category) => category.name,
///   enabled: !isSaving.value,
///   prefixIcon: Icons.category_outlined,
/// )
/// ```
class AsyncFormDropdown<T> extends StatelessWidget {
  const AsyncFormDropdown({
    super.key,
    required this.name,
    required this.label,
    required this.asyncData,
    required this.displayString,
    this.initialValue,
    this.enabled = true,
    this.prefixIcon,
    this.valueTransformer,
    this.validator,
    this.searchPredicate,
    this.itemBuilder,
    this.subtitleBuilder,
    this.onChanged,
    this.loadingText = 'Loading...',
    this.errorText = 'Failed to load',
  });

  /// The form field name.
  final String name;

  /// The label for the input field.
  final String label;

  /// The async data source.
  final AsyncValue<List<T>> asyncData;

  /// Function to get display string from item.
  final String Function(T item) displayString;

  /// Initial selected value.
  final T? initialValue;

  /// Whether the field is enabled.
  final bool enabled;

  /// Optional prefix icon.
  final IconData? prefixIcon;

  /// Transforms the value before saving to form state.
  /// Commonly used to extract ID from object: `(item) => item?.id`
  final dynamic Function(T?)? valueTransformer;

  /// Optional validator.
  final String? Function(T?)? validator;

  /// Custom search predicate. Defaults to displayString contains query.
  final bool Function(T item, String query)? searchPredicate;

  /// Custom item builder for suggestions.
  final Widget Function(BuildContext, T)? itemBuilder;

  /// Builder for subtitle text in default item builder.
  final String? Function(T)? subtitleBuilder;

  /// Called when selection changes.
  final void Function(T?)? onChanged;

  /// Text shown while loading.
  final String loadingText;

  /// Text shown on error.
  final String errorText;

  @override
  Widget build(BuildContext context) {
    void clearFieldValue() {
      final field = FormBuilder.of(context)?.fields[name];
      field?.didChange(null);
      onChanged?.call(null);
    }

    return asyncData.when(
      data: (items) => FormBuilderTypeAhead<T>(
        name: name,
        initialValue: initialValue,
        selectionToTextTransformer: displayString,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
          suffixIcon: IconButton(
            tooltip: 'Clear',
            onPressed: enabled ? clearFieldValue : null,
            icon: const Icon(Icons.clear),
          ),
        ),
        enabled: enabled,
        suggestionsCallback: (query) {
          if (query.isEmpty) return items;
          final lowerQuery = query.toLowerCase();
          return items.where((item) {
            if (searchPredicate != null) {
              return searchPredicate!(item, lowerQuery);
            }
            return displayString(item).toLowerCase().contains(lowerQuery);
          }).toList();
        },
        itemBuilder: itemBuilder ??
            (context, item) {
              final subtitle = subtitleBuilder?.call(item);
              return ListTile(
                title: Text(displayString(item)),
                subtitle: subtitle != null && subtitle.isNotEmpty
                    ? Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodySmall,
                      )
                    : null,
                dense: true,
              );
            },
        valueTransformer: valueTransformer,
        validator: validator,
        onChanged: onChanged,
      ),
      loading: () => TextField(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
          suffixIcon: const SizedBox(
            width: 20,
            height: 20,
            child: Padding(
              padding: EdgeInsets.all(12),
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        ),
        enabled: false,
      ),
      error: (_, __) => TextField(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
          errorText: errorText,
        ),
        enabled: false,
      ),
    );
  }
}
