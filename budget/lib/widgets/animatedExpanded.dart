import 'package:flutter/material.dart';

class AnimatedExpanded extends StatefulWidget {
  final Widget child;
  final bool expand;
  final Duration duration;
  final Curve sizeCurve;
  final Axis axis;

  AnimatedExpanded({
    this.expand = false,
    required this.child,
    this.duration = const Duration(milliseconds: 425),
    this.sizeCurve = Curves.fastOutSlowIn,
    this.axis = Axis.vertical,
  });

  @override
  _AnimatedExpandedState createState() => _AnimatedExpandedState();
}

class _AnimatedExpandedState extends State<AnimatedExpanded>
    with SingleTickerProviderStateMixin {
  late AnimationController expandController;
  late Animation<double> sizeAnimation;
  late Animation<double> fadeAnimation;

  @override
  void initState() {
    super.initState();
    prepareAnimations();
    _runExpandCheck();
  }

  void prepareAnimations() {
    expandController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    sizeAnimation = CurvedAnimation(
      parent: expandController,
      curve: widget.sizeCurve,
    );
    fadeAnimation = CurvedAnimation(
      parent: expandController,
      curve: Curves.easeInOut,
    );
  }

  void _runExpandCheck() {
    if (widget.expand) {
      expandController.forward();
    } else {
      expandController.reverse();
    }
  }

  @override
  void didUpdateWidget(covariant AnimatedExpanded oldWidget) {
    super.didUpdateWidget(oldWidget);
    _runExpandCheck();
  }

  @override
  void dispose() {
    expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fadeAnimation,
      child: SizeTransition(
        axis: widget.axis,
        axisAlignment: 1.0,
        sizeFactor: sizeAnimation,
        child: widget.child,
      ),
    );
  }
}

// Animated Switcher may be needed, if old data gets wiped immediately
// we want to keep the old UI when a transition occurs to make it smoother
class AnimatedSizeSwitcher extends StatelessWidget {
  const AnimatedSizeSwitcher({
    required this.child,
    this.sizeCurve = Curves.easeInOutCubicEmphasized,
    this.sizeDuration = const Duration(milliseconds: 800),
    this.switcherDuration = const Duration(milliseconds: 250),
    super.key,
  });
  final Widget child;
  final Curve sizeCurve;
  final Duration sizeDuration;
  final Duration switcherDuration;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: sizeDuration,
      curve: sizeCurve,
      child: AnimatedSwitcher(
        duration: switcherDuration,
        child: child,
      ),
    );
  }
}