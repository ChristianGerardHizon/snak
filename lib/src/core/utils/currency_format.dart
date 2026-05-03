import 'package:intl/intl.dart';

/// Prefer abbreviated **K** / **M** / **B** when the full peso string exceeds
/// this length (Unicode code units).
const defaultPesoMaxFullCharacterLength = 11;

/// Formats a number as Philippine Peso currency with comma separators.
///
/// Example: 1234.56 -> "₱1,234.56"
String formatCurrency(num amount) {
  final formatter = NumberFormat('#,##0.00', 'en_PH');
  return '₱${formatter.format(amount)}';
}

String _trimTrailingDotZero(String s) {
  if (s.endsWith('.0')) return s.substring(0, s.length - 2);
  return s;
}

/// Grouped peso (locale currency style), e.g. **₱1,234** or **₱1,234.56**.
String formatFullPesoCurrency(
  num amount, {
  int decimalDigits = 0,
  bool spacedSymbol = false,
}) {
  final sym = spacedSymbol ? '₱ ' : '₱';
  return NumberFormat.currency(
    locale: 'en_PH',
    symbol: sym,
    decimalDigits: decimalDigits,
  ).format(amount);
}

/// **K** / **M** / **B** when magnitude ≥ 1000; otherwise same as [formatFullPesoCurrency].
String formatAbbreviatedPesoCurrency(
  num amount, {
  int decimalDigits = 0,
  bool spacedSymbol = false,
}) {
  final sym = spacedSymbol ? '₱ ' : '₱';
  final abs = amount.abs();

  if (abs < 1000) {
    return NumberFormat.currency(
      locale: 'en_PH',
      symbol: sym,
      decimalDigits: decimalDigits,
    ).format(amount);
  }

  final negative = amount.isNegative;
  final sign = negative ? '-' : '';

  final double scaled;
  final String suffix;
  if (abs < 1000000) {
    scaled = abs / 1000;
    suffix = 'K';
  } else if (abs < 1000000000) {
    scaled = abs / 1000000;
    suffix = 'M';
  } else {
    scaled = abs / 1000000000;
    suffix = 'B';
  }

  final body = _trimTrailingDotZero(scaled.toStringAsFixed(1));
  return '$sign$sym$body$suffix';
}

/// Full grouped amount unless the string is longer than [maxFullCharacterLength],
/// then [formatAbbreviatedPesoCurrency]. For width/layout, use [AdaptivePesoAmountText].
String formatDisplayPesoCurrency(
  num amount, {
  int decimalDigits = 0,
  bool spacedSymbol = false,
  int maxFullCharacterLength = defaultPesoMaxFullCharacterLength,
}) {
  final full = formatFullPesoCurrency(
    amount,
    decimalDigits: decimalDigits,
    spacedSymbol: spacedSymbol,
  );
  if (full.length > maxFullCharacterLength) {
    return formatAbbreviatedPesoCurrency(
      amount,
      decimalDigits: decimalDigits,
      spacedSymbol: spacedSymbol,
    );
  }
  return full;
}

/// Extension on num for convenient currency formatting.
extension CurrencyFormat on num {
  /// Formats this number as Philippine Peso currency.
  ///
  /// Example: 1234.56.toCurrency() -> "₱1,234.56"
  String toCurrency() => formatCurrency(this);

  String toDisplayPeso({
    int decimalDigits = 0,
    bool spacedSymbol = false,
    int maxFullCharacterLength = defaultPesoMaxFullCharacterLength,
  }) =>
      formatDisplayPesoCurrency(
        this,
        decimalDigits: decimalDigits,
        spacedSymbol: spacedSymbol,
        maxFullCharacterLength: maxFullCharacterLength,
      );
}
