import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

/// A pre-configured currency input field for forms.
///
/// Provides consistent currency formatting with Philippine Peso (₱)
/// and numeric validation.
///
/// Example:
/// ```dart
/// CurrencyInputField(
///   name: 'price',
///   label: 'Price',
///   required: true,
///   enabled: !isSaving.value,
/// )
/// ```
class CurrencyInputField extends StatelessWidget {
  const CurrencyInputField({
    super.key,
    required this.name,
    required this.label,
    this.initialValue,
    this.enabled = true,
    this.required = false,
    this.requiredErrorText,
    this.numericErrorText = 'Must be a number',
    this.helperText,
    this.onChanged,
  });

  /// The form field name.
  final String name;

  /// The label for the input field.
  final String label;

  /// Initial value as a string.
  final String? initialValue;

  /// Whether the field is enabled.
  final bool enabled;

  /// Whether the field is required.
  final bool required;

  /// Custom error text for required validation.
  final String? requiredErrorText;

  /// Custom error text for numeric validation.
  final String numericErrorText;

  /// Optional helper text displayed below the field.
  final String? helperText;

  /// Called when the value changes.
  final void Function(String?)? onChanged;

  @override
  Widget build(BuildContext context) {
    final validators = <FormFieldValidator<String>>[];

    if (required) {
      validators.add(
        FormBuilderValidators.required(
          errorText: requiredErrorText ?? '$label is required',
        ),
      );
    }

    validators.add(
      FormBuilderValidators.numeric(errorText: numericErrorText),
    );

    return FormBuilderTextField(
      name: name,
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: required ? '$label *' : label,
        border: const OutlineInputBorder(),
        prefixText: '₱ ',
        helperText: helperText,
      ),
      enabled: enabled,
      keyboardType: TextInputType.number,
      validator: FormBuilderValidators.compose(validators),
      onChanged: onChanged,
    );
  }
}

/// A pre-configured numeric input field for forms.
///
/// Provides consistent numeric validation without currency formatting.
///
/// Example:
/// ```dart
/// NumericInputField(
///   name: 'quantity',
///   label: 'Quantity',
///   enabled: !isSaving.value,
/// )
/// ```
class NumericInputField extends StatelessWidget {
  const NumericInputField({
    super.key,
    required this.name,
    required this.label,
    this.initialValue,
    this.enabled = true,
    this.required = false,
    this.requiredErrorText,
    this.numericErrorText = 'Must be a number',
    this.helperText,
    this.onChanged,
  });

  /// The form field name.
  final String name;

  /// The label for the input field.
  final String label;

  /// Initial value as a string.
  final String? initialValue;

  /// Whether the field is enabled.
  final bool enabled;

  /// Whether the field is required.
  final bool required;

  /// Custom error text for required validation.
  final String? requiredErrorText;

  /// Custom error text for numeric validation.
  final String numericErrorText;

  /// Optional helper text displayed below the field.
  final String? helperText;

  /// Called when the value changes.
  final void Function(String?)? onChanged;

  @override
  Widget build(BuildContext context) {
    final validators = <FormFieldValidator<String>>[];

    if (required) {
      validators.add(
        FormBuilderValidators.required(
          errorText: requiredErrorText ?? '$label is required',
        ),
      );
    }

    validators.add(
      FormBuilderValidators.numeric(errorText: numericErrorText),
    );

    return FormBuilderTextField(
      name: name,
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: required ? '$label *' : label,
        border: const OutlineInputBorder(),
        helperText: helperText,
      ),
      enabled: enabled,
      keyboardType: TextInputType.number,
      validator: FormBuilderValidators.compose(validators),
      onChanged: onChanged,
    );
  }
}
