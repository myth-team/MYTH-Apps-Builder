import 'package:flutter/material.dart';
import 'package:ridesync_app/utils/colors.dart'; 

enum ButtonSize { small, medium, large }
enum ButtonVariant { primary, secondary, outline, text }

class PrimaryButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonSize size;
  final ButtonVariant variant;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? icon;
  final IconData? suffixIcon;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final double elevation;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.size = ButtonSize.medium,
    this.variant = ButtonVariant.primary,
    this.isLoading = false,
    this.isFullWidth = true,
    this.icon,
    this.suffixIcon,
    this.width,
    this.height,
    this.borderRadius,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.elevation = 0,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  double get _buttonHeight {
    switch (widget.size) {
      case ButtonSize.small:
        return 40;
      case ButtonSize.medium:
        return 50;
      case ButtonSize.large:
        return 56;
    }
  }

  double get _fontSize {
    switch (widget.size) {
      case ButtonSize.small:
        return 14;
      case ButtonSize.medium:
        return 16;
      case ButtonSize.large:
        return 18;
    }
  }

  EdgeInsets get _padding {
    switch (widget.size) {
      case ButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 16);
      case ButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 24);
      case ButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 32);
    }
  }

  Color get _backgroundColor {
    if (widget.backgroundColor != null) {
      return widget.backgroundColor!;
    }
    switch (widget.variant) {
      case ButtonVariant.primary:
        return AppColors.primary;
      case ButtonVariant.secondary:
        return AppColors.secondary;
      case ButtonVariant.outline:
      case ButtonVariant.text:
        return Colors.transparent;
    }
  }

  Color get _textColor {
    if (widget.textColor != null) {
      return widget.textColor!;
    }
    switch (widget.variant) {
      case ButtonVariant.primary:
      case ButtonVariant.secondary:
        return AppColors.textOnPrimary;
      case ButtonVariant.outline:
      case ButtonVariant.text:
        return AppColors.primary;
    }
  }

  BorderSide? get _border {
    if (widget.borderColor != null) {
      return BorderSide(color: widget.borderColor!);
    }
    switch (widget.variant) {
      case ButtonVariant.primary:
      case ButtonVariant.secondary:
      case ButtonVariant.text:
        return BorderSide.none;
      case ButtonVariant.outline:
        return const BorderSide(color: AppColors.primary, width: 1.5);
    }
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onPressed != null && !widget.isLoading) {
      setState(() => _isPressed = true);
      _animationController.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.onPressed == null || widget.isLoading;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        );
      },
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: widget.isFullWidth 
              ? double.infinity 
              : (widget.width ?? 150),
          height: widget.height ?? _buttonHeight,
          padding: _padding,
          decoration: BoxDecoration(
            color: isDisabled 
                ? _backgroundColor.withAlpha(128)
                : _backgroundColor,
            borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
            border: widget.variant == ButtonVariant.outline 
                ? Border.fromBorderSide(_border!) 
                : null,
            boxShadow: widget.variant == ButtonVariant.primary && !isDisabled
                ? [
                    BoxShadow(
                      color: AppColors.primary.withAlpha(77),
                      blurRadius: widget.elevation > 0 ? widget.elevation : 8,
                      offset: Offset(0, widget.elevation > 0 ? widget.elevation : 4),
                    ),
                  ]
                : null,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.isLoading ? null : widget.onPressed,
              borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
              child: Center(
                child: widget.isLoading
                    ? SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(_textColor),
                        ),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (widget.icon != null) ...[
                            Icon(
                              widget.icon,
                              color: _textColor,
                              size: _fontSize + 4,
                            ),
                            const SizedBox(width: 8),
                          ],
                          Text(
                            widget.text,
                            style: TextStyle(
                              color: isDisabled 
                                  ? _textColor.withAlpha(179)
                                  : _textColor,
                              fontSize: _fontSize,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (widget.suffixIcon != null) ...[
                            const SizedBox(width: 8),
                            Icon(
                              widget.suffixIcon,
                              color: _textColor,
                              size: _fontSize + 4,
                            ),
                          ],
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

class IconButtonWidget extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final double size;
  final Color? backgroundColor;
  final Color? iconColor;
  final BorderRadius? borderRadius;
  final BoxBorder? border;

  const IconButtonWidget({
    super.key,
    required this.icon,
    this.onPressed,
    this.size = 48,
    this.backgroundColor,
    this.iconColor,
    this.borderRadius,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.surface,
        borderRadius: borderRadius ?? BorderRadius.circular(size / 2),
        border: border,
        boxShadow: [
          BoxShadow(
            color: AppColors.grey300.withAlpha(77),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: borderRadius ?? BorderRadius.circular(size / 2),
          child: Center(
            child: Icon(
              icon,
              color: iconColor ?? AppColors.textPrimary,
              size: size * 0.5,
            ),
          ),
        ),
      ),
    );
  }
}

class FloatingActionButtonWidget extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? iconColor;
  final double size;
  final double elevation;

  const FloatingActionButtonWidget({
    super.key,
    required this.icon,
    this.onPressed,
    this.backgroundColor,
    this.iconColor,
    this.size = 56,
    this.elevation = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor ?? AppColors.primary,
        boxShadow: [
          BoxShadow(
            color: (backgroundColor ?? AppColors.primary).withAlpha(77),
            blurRadius: elevation * 2,
            offset: Offset(0, elevation),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(size / 2),
          child: Center(
            child: Icon(
              icon,
              color: iconColor ?? Colors.white,
              size: size * 0.5,
            ),
          ),
        ),
      ),
    );
  }
}