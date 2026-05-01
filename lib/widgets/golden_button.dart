import 'package:flutter/material.dart';
import 'package:golden_stay_app/utils/colors.dart'; 

enum GoldenButtonStyle {
  filled,
  outlined,
  text,
}

class GoldenButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final GoldenButtonStyle style;
  final bool isLoading;
  final IconData? icon;
  final double? width;
  final double height;
  final double borderRadius;
  final double fontSize;
  final FontWeight fontWeight;

  const GoldenButton({
    super.key,
    required this.text,
    this.onPressed,
    this.style = GoldenButtonStyle.filled,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height = 56.0,
    this.borderRadius = 12.0,
    this.fontSize = 16.0,
    this.fontWeight = FontWeight.w600,
  });

  @override
  State<GoldenButton> createState() => _GoldenButtonState();
}

class _GoldenButtonState extends State<GoldenButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.isLoading ? null : widget.onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: widget.width,
        height: widget.height,
        transform: Matrix4.identity()..scale(_isPressed ? 0.98 : 1.0),
        transformAlignment: Alignment.center,
        decoration: _buildDecoration(),
        child: Center(
          child: widget.isLoading
              ? _buildLoadingIndicator()
              : _buildContent(),
        ),
      ),
    );
  }

  BoxDecoration _buildDecoration() {
    switch (widget.style) {
      case GoldenButtonStyle.filled:
        return BoxDecoration(
          color: widget.onPressed == null
              ? AppColors.mutedGold.withValues(alpha: 0.5)
              : _isPressed
                  ? AppColors.darkGold
                  : AppColors.primaryGold,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          boxShadow: widget.onPressed != null && !_isPressed
              ? [
                  BoxShadow(
                    color: AppColors.primaryGold.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        );
      case GoldenButtonStyle.outlined:
        return BoxDecoration(
          color: _isPressed
              ? AppColors.primaryGold.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          border: Border.all(
            color: widget.onPressed == null
                ? AppColors.mutedGold
                : AppColors.primaryGold,
            width: 2,
          ),
        );
      case GoldenButtonStyle.text:
        return BoxDecoration(
          color: _isPressed
              ? AppColors.primaryGold.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(widget.borderRadius),
        );
    }
  }

  Widget _buildLoadingIndicator() {
    return SizedBox(
      width: 24,
      height: 24,
      child: CircularProgressIndicator(
        strokeWidth: 2.5,
        valueColor: AlwaysStoppedAnimation<Color>(
          widget.style == GoldenButtonStyle.filled
              ? AppColors.primaryBlack
              : AppColors.primaryGold,
        ),
      ),
    );
  }

  Widget _buildContent() {
    final Color textColor = _getTextColor();
    
    if (widget.icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            widget.icon,
            color: textColor,
            size: widget.fontSize + 4,
          ),
          const SizedBox(width: 10),
          Text(
            widget.text,
            style: TextStyle(
              color: textColor,
              fontSize: widget.fontSize,
              fontWeight: widget.fontWeight,
              letterSpacing: 0.5,
            ),
          ),
        ],
      );
    }
    
    return Text(
      widget.text,
      style: TextStyle(
        color: textColor,
        fontSize: widget.fontSize,
        fontWeight: widget.fontWeight,
        letterSpacing: 0.5,
      ),
    );
  }

  Color _getTextColor() {
    if (widget.onPressed == null) {
      return widget.style == GoldenButtonStyle.filled
          ? AppColors.primaryBlack.withValues(alpha: 0.5)
          : AppColors.mutedGold;
    }
    
    switch (widget.style) {
      case GoldenButtonStyle.filled:
        return AppColors.primaryBlack;
      case GoldenButtonStyle.outlined:
      case GoldenButtonStyle.text:
        return AppColors.primaryGold;
    }
  }
}

class GoldenIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final double size;
  final Color? backgroundColor;
  final Color? iconColor;
  final bool showShadow;

  const GoldenIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.size = 48.0,
    this.backgroundColor,
    this.iconColor,
    this.showShadow = true,
  });

  @override
  State<GoldenIconButton> createState() => _GoldenIconButtonState();
}

class _GoldenIconButtonState extends State<GoldenIconButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: widget.size,
        height: widget.size,
        transform: Matrix4.identity()..scale(_isPressed ? 0.92 : 1.0),
        transformAlignment: Alignment.center,
        decoration: BoxDecoration(
          color: widget.backgroundColor ?? AppColors.primaryGold,
          shape: BoxShape.circle,
          boxShadow: widget.showShadow && !_isPressed
              ? [
                  BoxShadow(
                    color: AppColors.primaryGold.withValues(alpha: 0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Icon(
            widget.icon,
            color: widget.iconColor ?? AppColors.primaryBlack,
            size: widget.size * 0.5,
          ),
        ),
      ),
    );
  }
}