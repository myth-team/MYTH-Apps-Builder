import 'package:flutter/material.dart';
import 'dart:math';

class AnimatedCounter extends StatefulWidget {
  final int target;
  final Duration duration;
  final TextStyle style;
  final String? suffix;

  AnimatedCounter({
    required this.target,
    this.duration = const Duration(milliseconds: 1200),
    required this.style,
    this.suffix,
  });

  @override
  _AnimatedCounterState createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _animation = Tween<double>(begin: 0, end: widget.target.toDouble()).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant AnimatedCounter old) {
    super.didUpdateWidget(old);
    if (old.target != widget.target) {
      _animation = Tween<double>(
        begin: _animation.value,
        end: widget.target.toDouble(),
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Curves.easeOutCubic,
        ),
      );
      _controller
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final value = _animation.value.round();
        return Text(
          '$value${widget.suffix ?? ''}',
          style: widget.style,
        );
      },
    );
  }
}