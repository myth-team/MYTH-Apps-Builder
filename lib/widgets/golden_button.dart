import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:golden_stay_app/utils/colors.dart'; 

enum GoldenButtonStyle {
  primary,
  secondary,
  outline,
}

class GoldenButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final GoldenButtonStyle style;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? icon;
  final double? height;
  final double? width;

  const GoldenButton({
    super.key,
    required this.text,
    this.onPressed,
    this.style = GoldenButtonStyle.primary,
    this.isLoading = false,
    this.isFullWidth = false,
    this.icon,
    this.height,
    this.width,
  });

  @override
  State<GoldenButton> createState() => _GoldenButtonState();
}

class _GoldenButtonState extends State<GoldenButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onPressed != null && !widget.isLoading) {
      setState(() => _isPressed = true);
      _controller.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.onPressed == null || widget.isLoading;
    
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.isLoading ? null : widget.onPressed,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: Container(
          height: widget.height ?? 56,
          width: widget.isFullWidth ? double.infinity : widget.width,
          decoration: BoxDecoration(
            gradient: widget.style == GoldenButtonStyle.primary && !isDisabled
                ? AppColors.goldGradient
                : null,
            color: _getBackgroundColor(isDisabled),
            borderRadius: BorderRadius.circular(16),
            border: widget.style == GoldenButtonStyle.outline
                ? Border.all(
                    color: isDisabled
                        ? AppColors.textMuted
                        : AppColors.primary,
                    width: 2,
                  )
                : null,
            boxShadow: widget.style == GoldenButtonStyle.primary && !isDisabled
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: widget.isLoading
                ? SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        widget.style == GoldenButtonStyle.primary
                            ? AppColors.background
                            : AppColors.primary,
                      ),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.icon != null) ...[
                        Icon(
                          widget.icon,
                          size: 20,
                          color: _getTextColor(isDisabled),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        widget.text,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: _getTextColor(isDisabled),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Color _getBackgroundColor(bool isDisabled) {
    switch (widget.style) {
      case GoldenButtonStyle.primary:
        return isDisabled ? AppColors.textMuted : AppColors.primary;
      case GoldenButtonStyle.secondary:
        return isDisabled
            ? AppColors.surfaceLight
            : AppColors.surface;
      case GoldenButtonStyle.outline:
        return Colors.transparent;
    }
  }

  Color _getTextColor(bool isDisabled) {
    switch (widget.style) {
      case GoldenButtonStyle.primary:
        return isDisabled ? AppColors.textSecondary : AppColors.background;
      case GoldenButtonStyle.secondary:
        return isDisabled ? AppColors.textMuted : AppColors.textPrimary;
      case GoldenButtonStyle.outline:
        return isDisabled ? AppColors.textMuted : AppColors.primary;
    }
  }
}