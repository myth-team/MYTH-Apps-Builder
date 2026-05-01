import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:golden_stay_app/utils/colors.dart'; 

enum CustomTextFieldStyle {
  filled,
  outlined,
  minimal,
}

class CustomTextField extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final int maxLines;
  final int? maxLength;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters;
  final CustomTextFieldStyle style;
  final FocusNode? focusNode;
  final EdgeInsetsGeometry? contentPadding;
  final bool autofocus;
  final Color? fillColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? labelColor;
  final Color? hintColor;
  final Color? textColor;
  final double borderRadius;
  final double? width;
  final double height;
  final bool showLabel;
  final bool showCounter;

  const CustomTextField({
    super.key,
    this.labelText,
    this.hintText,
    this.helperText,
    this.errorText,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.validator,
    this.inputFormatters,
    this.style = CustomTextFieldStyle.filled,
    this.focusNode,
    this.contentPadding,
    this.autofocus = false,
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.labelColor,
    this.hintColor,
    this.textColor,
    this.borderRadius = 12.0,
    this.width,
    this.height = 56.0,
    this.showLabel = true,
    this.showCounter = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    } else {
      _focusNode.removeListener(_handleFocusChange);
    }
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.showLabel && widget.labelText != null) ...[
            Text(
              widget.labelText!,
              style: TextStyle(
                color: widget.labelColor ?? AppColors.primaryGold,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
          ],
          _buildTextField(),
          if (widget.helperText != null && widget.errorText == null) ...[
            const SizedBox(height: 6),
            Text(
              widget.helperText!,
              style: TextStyle(
                color: AppColors.mutedGold.withValues(alpha: 0.8),
                fontSize: 12,
              ),
            ),
          ],
          if (widget.errorText != null) ...[
            const SizedBox(height: 6),
            Text(
              widget.errorText!,
              style: const TextStyle(
                color: Colors.redAccent,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTextField() {
    final defaultFillColor = widget.fillColor ?? AppColors.lightBlack;
    final defaultBorderColor = widget.borderColor ?? AppColors.lightBlack;
    final defaultFocusedBorderColor = widget.focusedBorderColor ?? AppColors.primaryGold;
    final defaultLabelColor = widget.labelColor ?? AppColors.primaryGold;
    final defaultHintColor = widget.hintColor ?? AppColors.mutedGold.withValues(alpha: 0.6);
    final defaultTextColor = widget.textColor ?? AppColors.pureWhite;

    EdgeInsetsGeometry effectivePadding = widget.contentPadding ?? 
        const EdgeInsets.symmetric(horizontal: 16, vertical: 16);

    switch (widget.style) {
      case CustomTextFieldStyle.filled:
        return Container(
          height: widget.height,
          decoration: BoxDecoration(
            color: widget.enabled ? defaultFillColor : AppColors.darkBlack,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: Border.all(
              color: _isFocused ? defaultFocusedBorderColor : defaultBorderColor,
              width: _isFocused ? 2.0 : 1.0,
            ),
          ),
          child: TextFormField(
            controller: widget.controller,
            focusNode: _focusNode,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            obscureText: widget.obscureText,
            enabled: widget.enabled,
            readOnly: widget.readOnly,
            maxLines: widget.maxLines,
            maxLength: widget.maxLength,
            autofocus: widget.autofocus,
            onChanged: widget.onChanged,
            onFieldSubmitted: widget.onSubmitted,
            onTap: widget.onTap,
            validator: widget.validator,
            inputFormatters: widget.inputFormatters,
            style: TextStyle(
              color: defaultTextColor,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            cursorColor: AppColors.primaryGold,
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: TextStyle(
                color: defaultHintColor,
                fontSize: 16,
              ),
              prefixIcon: widget.prefixIcon,
              suffixIcon: widget.suffixIcon,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              contentPadding: effectivePadding,
              counterText: widget.showCounter ? null : '',
              counterStyle: const TextStyle(
                color: AppColors.mutedGold,
              ),
            ),
          ),
        );

      case CustomTextFieldStyle.outlined:
        return Container(
          height: widget.height,
          decoration: BoxDecoration(
            color: widget.enabled ? (widget.fillColor ?? Colors.transparent) : AppColors.darkBlack.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: Border.all(
              color: widget.errorText != null 
                  ? Colors.redAccent 
                  : (_isFocused ? defaultFocusedBorderColor : defaultBorderColor),
              width: _isFocused ? 2.0 : 1.0,
            ),
          ),
          child: TextFormField(
            controller: widget.controller,
            focusNode: _focusNode,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            obscureText: widget.obscureText,
            enabled: widget.enabled,
            readOnly: widget.readOnly,
            maxLines: widget.maxLines,
            maxLength: widget.maxLength,
            autofocus: widget.autofocus,
            onChanged: widget.onChanged,
            onFieldSubmitted: widget.onSubmitted,
            onTap: widget.onTap,
            validator: widget.validator,
            inputFormatters: widget.inputFormatters,
            style: TextStyle(
              color: defaultTextColor,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            cursorColor: AppColors.primaryGold,
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: TextStyle(
                color: defaultHintColor,
                fontSize: 16,
              ),
              prefixIcon: widget.prefixIcon,
              suffixIcon: widget.suffixIcon,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              contentPadding: effectivePadding,
              counterText: widget.showCounter ? null : '',
              counterStyle: const TextStyle(
                color: AppColors.mutedGold,
              ),
            ),
          ),
        );

      case CustomTextFieldStyle.minimal:
        return TextFormField(
          controller: widget.controller,
          focusNode: _focusNode,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          obscureText: widget.obscureText,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          maxLines: widget.maxLines,
          maxLength: widget.maxLength,
          autofocus: widget.autofocus,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          onTap: widget.onTap,
          validator: widget.validator,
          inputFormatters: widget.inputFormatters,
          style: TextStyle(
            color: defaultTextColor,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          cursorColor: AppColors.primaryGold,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(
              color: defaultHintColor,
              fontSize: 16,
            ),
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.suffixIcon,
            border: UnderlineInputBorder(
              borderSide: BorderSide(
                color: defaultBorderColor,
                width: 1.0,
              ),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: defaultBorderColor,
                width: 1.0,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: defaultFocusedBorderColor,
                width: 2.0,
              ),
            ),
            errorBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.redAccent,
                width: 1.0,
              ),
            ),
            contentPadding: effectivePadding,
            counterText: widget.showCounter ? null : '',
            counterStyle: const TextStyle(
              color: AppColors.mutedGold,
            ),
          ),
        );
    }
  }
}

class CustomSearchField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final VoidCallback? onFilterTap;
  final bool showFilterButton;
  final bool autofocus;
  final double borderRadius;

  const CustomSearchField({
    super.key,
    this.controller,
    this.hintText = 'Search hotels, cities...',
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.onFilterTap,
    this.showFilterButton = true,
    this.autofocus = false,
    this.borderRadius = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.lightBlack,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: AppColors.primaryGold.withValues(alpha: 0.3),
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            alignment: Alignment.center,
            child: Icon(
              Icons.search,
              color: AppColors.primaryGold,
              size: 24,
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              autofocus: autofocus,
              onChanged: onChanged,
              onSubmitted: onSubmitted,
              onTap: onTap,
              style: const TextStyle(
                color: AppColors.pureWhite,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              cursorColor: AppColors.primaryGold,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  color: AppColors.mutedGold.withValues(alpha: 0.6),
                  fontSize: 16,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          if (showFilterButton) ...[
            GestureDetector(
              onTap: onFilterTap,
              child: Container(
                width: 56,
                height: 56,
                alignment: Alignment.center,
                child: Icon(
                  Icons.tune,
                  color: AppColors.primaryGold,
                  size: 24,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class CustomDateField extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final DateTime? selectedDate;
  final ValueChanged<DateTime>? onDateSelected;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String? errorText;
  final bool enabled;
  final double borderRadius;

  const CustomDateField({
    super.key,
    this.labelText,
    this.hintText,
    this.selectedDate,
    this.onDateSelected,
    this.firstDate,
    this.lastDate,
    this.errorText,
    this.enabled = true,
    this.borderRadius = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (labelText != null) ...[
          Text(
            labelText!,
            style: const TextStyle(
              color: AppColors.primaryGold,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
        ],
        GestureDetector(
          onTap: enabled ? () => _selectDate(context) : null,
          child: Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: enabled ? AppColors.lightBlack : AppColors.darkBlack,
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: errorText != null 
                    ? Colors.redAccent 
                    : AppColors.lightBlack,
                width: 1.0,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: AppColors.primaryGold,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    selectedDate != null
                        ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                        : (hintText ?? 'Select date'),
                    style: TextStyle(
                      color: selectedDate != null 
                          ? AppColors.pureWhite 
                          : AppColors.mutedGold.withValues(alpha: 0.6),
                      fontSize: 16,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: AppColors.mutedGold,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 6),
          Text(
            errorText!,
            style: const TextStyle(
              color: Colors.redAccent,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: firstDate ?? DateTime.now(),
      lastDate: lastDate ?? DateTime.now().add(const Duration(days: 365 * 2)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primaryGold,
              onPrimary: AppColors.primaryBlack,
              surface: AppColors.lightBlack,
              onSurface: AppColors.pureWhite,
            ),
            dialogBackgroundColor: AppColors.primaryBlack,
          ),
          child: child!,
        );
      },
    );
    if (picked != null && onDateSelected != null) {
      onDateSelected!(picked);
    }
  }
}