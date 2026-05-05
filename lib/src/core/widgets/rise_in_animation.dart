import 'package:flutter/material.dart';

/// Fades a child in while sliding it up from below.
///
/// Pass [index] to stagger multiple siblings — each step adds [stagger] to the
/// start delay so a column of items rises one after another.
class RiseInAnimation extends StatefulWidget {
  const RiseInAnimation({
    super.key,
    required this.child,
    this.index = 0,
    this.duration = const Duration(milliseconds: 300),
    this.stagger = const Duration(milliseconds: 60),
    this.offset = 16,
    this.curve = Curves.easeOutCubic,
  });

  final Widget child;
  final int index;
  final Duration duration;
  final Duration stagger;
  final double offset;
  final Curve curve;

  @override
  State<RiseInAnimation> createState() => _RiseInAnimationState();
}

class _RiseInAnimationState extends State<RiseInAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: widget.duration);

  @override
  void initState() {
    super.initState();
    final delay = widget.stagger * widget.index;
    Future.delayed(delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final curved = CurvedAnimation(parent: _controller, curve: widget.curve);
    return AnimatedBuilder(
      animation: curved,
      builder: (context, child) {
        return Opacity(
          opacity: curved.value,
          child: Transform.translate(
            offset: Offset(0, widget.offset * (1 - curved.value)),
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}
