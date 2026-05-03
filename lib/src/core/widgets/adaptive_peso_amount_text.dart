import 'package:flutter/material.dart';

import '../utils/currency_format.dart';

/// Applies [ColorScheme.error] when [amount] is negative; otherwise returns [base].
TextStyle? styleForCurrencyAmount(BuildContext context, num amount, TextStyle? base) {
  if (!amount.isNegative) return base;
  final error = Theme.of(context).colorScheme.error;
  return base?.copyWith(color: error) ?? TextStyle(color: error);
}

/// Peso amount that switches to **K** / **M** / **B** when the full string is
/// “too long” or wider than the layout allows (avoids truncation).
class AdaptivePesoAmountText extends StatelessWidget {
  const AdaptivePesoAmountText({
    super.key,
    required this.amount,
    this.leading = '',
    this.decimalDigits = 0,
    this.spacedSymbol = false,
    this.maxFullCharacterLength = defaultPesoMaxFullCharacterLength,
    this.style,
    this.textAlign,
    this.maxLines = 1,
    this.overflow = TextOverflow.ellipsis,
  });

  final num amount;
  final String leading;
  final int decimalDigits;
  final bool spacedSymbol;
  final int maxFullCharacterLength;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow overflow;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final fullBody = formatFullPesoCurrency(
          amount,
          decimalDigits: decimalDigits,
          spacedSymbol: spacedSymbol,
        );
        final abbrevBody = formatAbbreviatedPesoCurrency(
          amount,
          decimalDigits: decimalDigits,
          spacedSymbol: spacedSymbol,
        );
        final fullText = '$leading$fullBody';
        final abbrevText = '$leading$abbrevBody';

        var useAbbrev = fullText.length > maxFullCharacterLength;

        final maxW = constraints.maxWidth;
        final resolvedStyle = styleForCurrencyAmount(context, amount, style);

        if (!useAbbrev &&
            maxW.isFinite &&
            maxW < double.infinity &&
            maxW > 0) {
          final painter = TextPainter(
            text: TextSpan(text: fullText, style: resolvedStyle),
            textDirection: Directionality.of(context),
            maxLines: maxLines,
          )..layout(maxWidth: double.infinity);
          if (painter.width > maxW) {
            useAbbrev = true;
          }
        }

        return Text(
          useAbbrev ? abbrevText : fullText,
          style: resolvedStyle,
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
        );
      },
    );
  }
}

/// Two peso amounts separated by [separator] (e.g. spent / limit), abbreviating
/// when the combined full string is long or does not fit.
class AdaptivePesoPairText extends StatelessWidget {
  const AdaptivePesoPairText({
    super.key,
    required this.first,
    required this.second,
    this.separator = ' / ',
    this.decimalDigits = 0,
    this.spacedSymbol = false,
    this.maxFullCharacterLength = 24,
    this.style,
    this.textAlign,
    this.overflow = TextOverflow.ellipsis,
  });

  final num first;
  final num second;
  final String separator;
  final int decimalDigits;
  final bool spacedSymbol;
  final int maxFullCharacterLength;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextOverflow overflow;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final f1 = formatFullPesoCurrency(
          first,
          decimalDigits: decimalDigits,
          spacedSymbol: spacedSymbol,
        );
        final f2 = formatFullPesoCurrency(
          second,
          decimalDigits: decimalDigits,
          spacedSymbol: spacedSymbol,
        );
        final fullText = '$f1$separator$f2';

        final a1 = formatAbbreviatedPesoCurrency(
          first,
          decimalDigits: decimalDigits,
          spacedSymbol: spacedSymbol,
        );
        final a2 = formatAbbreviatedPesoCurrency(
          second,
          decimalDigits: decimalDigits,
          spacedSymbol: spacedSymbol,
        );

        var useAbbrev = fullText.length > maxFullCharacterLength;

        final maxW = constraints.maxWidth;
        final cs = Theme.of(context).colorScheme;
        final measureSpan = TextSpan(
          style: style,
          children: [
            TextSpan(
              text: useAbbrev ? a1 : f1,
              style: first.isNegative ? TextStyle(color: cs.error) : null,
            ),
            TextSpan(text: separator),
            TextSpan(
              text: useAbbrev ? a2 : f2,
              style: second.isNegative ? TextStyle(color: cs.error) : null,
            ),
          ],
        );

        if (!useAbbrev &&
            maxW.isFinite &&
            maxW < double.infinity &&
            maxW > 0) {
          final painter = TextPainter(
            text: measureSpan,
            textDirection: Directionality.of(context),
            maxLines: 1,
          )..layout(maxWidth: double.infinity);
          if (painter.width > maxW) {
            useAbbrev = true;
          }
        }

        final displaySpan = TextSpan(
          style: style,
          children: [
            TextSpan(
              text: useAbbrev ? a1 : f1,
              style: first.isNegative ? TextStyle(color: cs.error) : null,
            ),
            TextSpan(text: separator),
            TextSpan(
              text: useAbbrev ? a2 : f2,
              style: second.isNegative ? TextStyle(color: cs.error) : null,
            ),
          ],
        );

        return RichText(
          textAlign: textAlign ?? TextAlign.start,
          maxLines: 1,
          overflow: overflow,
          text: displaySpan,
        );
      },
    );
  }
}
