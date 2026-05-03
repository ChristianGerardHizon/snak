import 'package:flutter/material.dart';

/// Rounded pill button with white border, used on Snak onboarding screens.
class SnakPillButton extends StatelessWidget {
  const SnakPillButton({
    super.key,
    required this.label,
    required this.labelColor,
    required this.width,
    required this.height,
    required this.onPressed,
  });

  final String label;
  final Color labelColor;
  final double width;
  final double height;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cornerRadius = height * 0.5;
    final pillShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(cornerRadius),
    );
    final fontSize = (height * 0.42).clamp(16.0, 26.0);
    final letterSpacing = fontSize * 0.09;
    final enabled = onPressed != null;

    return Opacity(
      opacity: enabled ? 1 : 0.45,
      child: SizedBox(
        width: width,
        height: height,
        child: Material(
          color: Colors.transparent,
          shape: pillShape,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: enabled ? onPressed : null,
            customBorder: pillShape,
            child: Ink(
              decoration: BoxDecoration(
                color: labelColor,
                borderRadius: BorderRadius.circular(cornerRadius),
                border: Border.all(color: Colors.white, width: 2.5),
                boxShadow: enabled
                    ? [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.22),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        letterSpacing: letterSpacing,
                        fontSize: fontSize,
                        height: 1.0,
                      ) ??
                      TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        letterSpacing: letterSpacing,
                        fontSize: fontSize,
                        height: 1.0,
                      ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
