import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ridesync_app/utils/colors.dart'; 

class OtpInput extends StatefulWidget {
  final int length;
  final Function(String)? onCompleted;
  final Function(String)? onChanged;
  final TextEditingController? controller;
  final bool autoFocus;
  final bool obscureText;
  final Color? filledColor;
  final Color? borderColor;
  final Color? textColor;
  final double width;
  final double height;
  final double spacing;
  final TextStyle? textStyle;
  final BorderRadius? borderRadius;
  final List<TextInputFormatter>? inputFormatters;

  const OtpInput({
    super.key,
    this.length = 4,
    this.onCompleted,
    this.onChanged,
    this.controller,
    this.autoFocus = true,
    this.obscureText = false,
    this.filledColor,
    this.borderColor,
    this.textColor,
    this.width = 50,
    this.height = 60,
    this.spacing = 8,
    this.textStyle,
    this.borderRadius,
    this.inputFormatters,
  });

  @override
  State<OtpInput> createState() => _OtpInputState();
}

class _OtpInputState extends State<OtpInput> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    _controllers = List.generate(
      widget.length,
      (index) => TextEditingController(
        text: widget.controller != null && index < widget.controller!.text.length
            ? widget.controller!.text[index]
            : '',
      ),
    );
    
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
    
    if (widget.controller != null) {
      widget.controller!.addListener(_syncController);
    }
  }

  void _syncController() {
    final text = widget.controller!.text;
    for (var i = 0; i < _controllers.length; i++) {
      if (i < text.length) {
        _controllers[i].text = text[i];
      } else {
        _controllers[i].text = '';
      }
    }
  }

  @override
  void didUpdateWidget(OtpInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.length != widget.length) {
      _disposeControllers();
      _initControllers();
    }
  }

  void _disposeControllers() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    if (widget.controller != null) {
      widget.controller!.removeListener(_syncController);
    }
  }

  void _onChanged(String value, int index) {
    if (value.isNotEmpty && index < widget.length - 1) {
      _focusNodes[index + 1].requestFocus();
    }

    final allCodes = _controllers.map((c) => c.text).join();
    if (widget.onChanged != null) {
      widget.onChanged!(allCodes);
    }

    if (allCodes.length == widget.length && widget.onCompleted != null) {
      widget.onCompleted!(allCodes);
    }

    if (widget.controller != null) {
      widget.controller!.text = allCodes;
    }
  }

  void _onKeyPressed(int index, RawKeyEvent event) {
    if (event is RawKeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _focusNodes[index - 1].requestFocus();
      _controllers[index - 1].clear();
    }
  }

  void clear() {
    for (var controller in _controllers) {
      controller.clear();
    }
    _focusNodes.first.requestFocus();
  }

  void setValue(String value) {
    final codes = value.split('');
    for (var i = 0; i < _controllers.length; i++) {
      if (i < codes.length) {
        _controllers[i].text = codes[i];
      } else {
        _controllers[i].text = '';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.length,
        (index) => Padding(
          padding: EdgeInsets.symmetric(horizontal: widget.spacing / 2),
          child: SizedBox(
            width: widget.width,
            height: widget.height,
            child: RawKeyboardListener(
              focusNode: FocusNode(),
              onKey: (event) => _onKeyPressed(index, event),
              child: TextField(
                controller: _controllers[index],
                focusNode: _focusNodes[index],
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 1,
                obscureText: widget.obscureText,
                autofocus: widget.autoFocus && index == 0,
                style: widget.textStyle ?? TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: widget.textColor ?? AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  counterText: '',
                  filled: true,
                  fillColor: widget.filledColor ?? AppColors.surface,
                  border: OutlineInputBorder(
                    borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: widget.borderColor ?? AppColors.border,
                      width: 1.5,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: widget.borderColor ?? AppColors.border,
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppColors.primary,
                      width: 2,
                    ),
                  ),
                  contentPadding: EdgeInsets.zero,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  ...?widget.inputFormatters,
                ],
                onChanged: (value) => _onChanged(value, index),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }
}

class OtpInputWithTimer extends StatefulWidget {
  final int otpLength;
  final Function(String)? onCompleted;
  final Function(String)? onChanged;
  final VoidCallback? onResendPressed;
  final int resendTimeoutSeconds;
  final String resendText;
  final String resendButtonText;

  const OtpInputWithTimer({
    super.key,
    this.otpLength = 4,
    this.onCompleted,
    this.onChanged,
    this.onResendPressed,
    this.resendTimeoutSeconds = 30,
    this.resendText = 'Resend code in',
    this.resendButtonText = 'Resend',
  });

  @override
  State<OtpInputWithTimer> createState() => _OtpInputWithTimerState();
}

class _OtpInputWithTimerState extends State<OtpInputWithTimer> {
  late int _secondsRemaining;
  late bool _canResend;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _secondsRemaining = widget.resendTimeoutSeconds;
    _canResend = false;
    _controller = TextEditingController();
    _startTimer();
  }

  void _startTimer() {
    Future.delayed(Duration(seconds: 1), () {
      if (mounted && _secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
        _startTimer();
      } else if (mounted) {
        setState(() {
          _canResend = true;
        });
      }
    });
  }

  void _handleResend() {
    if (_canResend && widget.onResendPressed != null) {
      widget.onResendPressed!();
      setState(() {
        _secondsRemaining = widget.resendTimeoutSeconds;
        _canResend = false;
      });
      _startTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OtpInput(
          length: widget.otpLength,
          controller: _controller,
          onCompleted: widget.onCompleted,
          onChanged: widget.onChanged,
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.resendText,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
            if (!_canResend)
              Text(
                ' $_secondsRemaining s',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              )
            else
              GestureDetector(
                onTap: _handleResend,
                child: Text(
                  ' ${widget.resendButtonText}',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}