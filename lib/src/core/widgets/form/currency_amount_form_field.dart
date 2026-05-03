import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

/// Accepts only digits and at most one decimal point with up to two fractional digits.
/// Commas (e.g. pasted values) are ignored.
class CurrencyAmountInputFormatter extends TextInputFormatter {
  const CurrencyAmountInputFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(',', '');
    if (text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    final buf = StringBuffer();
    var seenDot = false;
    var afterDot = 0;
    for (var i = 0; i < text.length; i++) {
      final c = text[i];
      if (c == '.') {
        if (seenDot) continue;
        seenDot = true;
        buf.write(c);
      } else if (c.compareTo('0') >= 0 && c.compareTo('9') <= 0) {
        if (seenDot) {
          if (afterDot >= 2) continue;
          afterDot++;
        }
        buf.write(c);
      }
    }

    final out = buf.toString();
    var offset = newValue.selection.baseOffset;
    if (offset > out.length) offset = out.length;
    return TextEditingValue(
      text: out,
      selection: TextSelection.collapsed(offset: offset),
    );
  }
}

double? tryParseCurrencyAmount(String? raw) {
  if (raw == null || raw.isEmpty || raw == '.') return null;
  return double.tryParse(raw.replaceAll(',', ''));
}

/// Currency amount entry for FormBuilder: ₱ prefix, strict decimal money shape, optional accent.
class FormBuilderCurrencyAmountField extends StatelessWidget {
  const FormBuilderCurrencyAmountField({
    super.key,
    required this.name,
    this.initialValue,
    this.enabled = true,
    this.accentColor,
    this.label = 'Amount',
    this.requiredErrorText,
  });

  final String name;
  final String? initialValue;
  final bool enabled;
  final Color? accentColor;
  final String label;
  final String? requiredErrorText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = accentColor ?? theme.colorScheme.primary;
    final fill = accent.withValues(alpha: 0.10);
    final headline = theme.textTheme.headlineSmall?.copyWith(
      fontWeight: FontWeight.w700,
      color: theme.colorScheme.onSurface,
    );
    final prefixStyle = theme.textTheme.titleLarge?.copyWith(
      fontWeight: FontWeight.w600,
      color: accent,
    );

    return FormBuilderTextField(
      name: name,
      initialValue: initialValue,
      enabled: enabled,
      style: headline,
      textAlign: TextAlign.end,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: const [CurrencyAmountInputFormatter()],
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(
          errorText: requiredErrorText ?? '$label is required',
        ),
        (value) {
          final n = tryParseCurrencyAmount(value);
          if (n == null) return 'Enter a valid amount';
          if (n < 0.01) return 'Amount must be at least 0.01';
          return null;
        },
      ]),
      decoration: InputDecoration(
        labelText: '$label *',
        hintText: '0.00',
        filled: true,
        fillColor: fill,
        prefixText: '₱ ',
        prefixStyle: prefixStyle,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: accent.withValues(alpha: 0.35)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: accent.withValues(alpha: 0.35)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: accent, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: theme.colorScheme.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      ),
    );
  }
}
