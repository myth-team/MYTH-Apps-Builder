import 'package:flutter/material.dart';
import 'package:rideflow_app/utils/colors.dart'; 

/// Primary button widget with customizable styling
/// Supports loading states, different sizes, and variants
class PrimaryButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isFullWidth;
  final PrimaryButtonSize size;
  final PrimaryButtonVariant variant;
  final IconData? leadingIcon;
  final IconData? trailingIcon;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isFullWidth = true,
    this.size = PrimaryButtonSize.large,
    this.variant = PrimaryButtonVariant.primary,
    this.leadingIcon,
    this.trailingIcon,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.onPressed != null && !widget.isLoading) {
      _controller.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.onPressed == null || widget.isLoading;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.isLoading ? null : widget.onPressed,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: isDisabled ? 0.6 : 1.0,
          child: Container(
            width: widget.isFullWidth ? double.infinity : null,
            height: _getHeight(),
            padding: EdgeInsets.symmetric(
              horizontal: _getHorizontalPadding(),
            ),
            decoration: BoxDecoration(
              gradient: widget.variant == PrimaryButtonVariant.primary &&
                      !isDisabled
                  ? AppColors.primaryGradient
                  : null,
              color: _getBackgroundColor(isDisabled),
              borderRadius: AppRadius.medium,
              boxShadow: widget.variant == PrimaryButtonVariant.primary &&
                      !isDisabled
                  ? AppShadows.small
                  : null,
              border: widget.variant == PrimaryButtonVariant.outlined
                  ? Border.all(
                      color: isDisabled
                          ? AppColors.textTertiary
                          : AppColors.primary,
                      width: 1.5,
                    )
                  : null,
            ),
            child: Row(
              mainAxisSize:
                  widget.isFullWidth ? MainAxisSize.max : MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.isLoading)
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _getTextColor(),
                      ),
                    ),
                  )
                else ...[
                  if (widget.leadingIcon != null) ...[
                    Icon(
                      widget.leadingIcon,
                      size: _getIconSize(),
                      color: _getTextColor(),
                    ),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    widget.text,
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: _getFontSize(),
                      fontWeight: FontWeight.w600,
                      color: _getTextColor(),
                    ),
                  ),
                  if (widget.trailingIcon != null) ...[
                    const SizedBox(width: 8),
                    Icon(
                      widget.trailingIcon,
                      size: _getIconSize(),
                      color: _getTextColor(),
                    ),
                  ],
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  double _getHeight() {
    switch (widget.size) {
      case PrimaryButtonSize.small:
        return 40.0;
      case PrimaryButtonSize.medium:
        return 48.0;
      case PrimaryButtonSize.large:
        return 56.0;
    }
  }

  double _getHorizontalPadding() {
    switch (widget.size) {
      case PrimaryButtonSize.small:
        return 16.0;
      case PrimaryButtonSize.medium:
        return 20.0;
      case PrimaryButtonSize.large:
        return 24.0;
    }
  }

  double _getFontSize() {
    switch (widget.size) {
      case PrimaryButtonSize.small:
        return 14.0;
      case PrimaryButtonSize.medium:
        return 15.0;
      case PrimaryButtonSize.large:
        return 16.0;
    }
  }

  double _getIconSize() {
    switch (widget.size) {
      case PrimaryButtonSize.small:
        return 18.0;
      case PrimaryButtonSize.medium:
        return 20.0;
      case PrimaryButtonSize.large:
        return 22.0;
    }
  }

  Color _getBackgroundColor(bool isDisabled) {
    switch (widget.variant) {
      case PrimaryButtonVariant.primary:
        return isDisabled ? AppColors.primaryDark : AppColors.primary;
      case PrimaryButtonVariant.secondary:
        return isDisabled ? AppColors.textTertiary : AppColors.secondary;
      case PrimaryButtonVariant.outlined:
        return Colors.transparent;
      case PrimaryButtonVariant.text:
        return Colors.transparent;
    }
  }

  Color _getTextColor() {
    switch (widget.variant) {
      case PrimaryButtonVariant.primary:
        return AppColors.textOnPrimary;
      case PrimaryButtonVariant.secondary:
        return AppColors.textOnPrimary;
      case PrimaryButtonVariant.outlined:
        return isDisabled() ? AppColors.textTertiary : AppColors.primary;
      case PrimaryButtonVariant.text:
        return isDisabled() ? AppColors.textTertiary : AppColors.primary;
    }
  }

  bool isDisabled() {
    return widget.onPressed == null || widget.isLoading;
  }
}

/// Button size options
enum PrimaryButtonSize {
  small,
  medium,
  large,
}

/// Button variant options
enum PrimaryButtonVariant {
  primary,
  secondary,
  outlined,
  text,
}

/// Secondary button variant
class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isFullWidth;
  final PrimaryButtonSize size;
  final IconData? leadingIcon;
  final IconData? trailingIcon;

  const SecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isFullWidth = true,
    this.size = PrimaryButtonSize.large,
    this.leadingIcon,
    this.trailingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
      size: size,
      variant: PrimaryButtonVariant.secondary,
      leadingIcon: leadingIcon,
      trailingIcon: trailingIcon,
    );
  }
}

/// Outlined button variant
class OutlinedPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isFullWidth;
  final PrimaryButtonSize size;
  final IconData? leadingIcon;
  final IconData? trailingIcon;

  const OutlinedPrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isFullWidth = true,
    this.size = PrimaryButtonSize.large,
    this.leadingIcon,
    this.trailingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
      size: size,
      variant: PrimaryButtonVariant.outlined,
      leadingIcon: leadingIcon,
      trailingIcon: trailingIcon,
    );
  }
}