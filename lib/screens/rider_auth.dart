import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:new_project_app/utils/colors.dart'; 
import 'package:new_project_app/providers/auth_provider.dart';

class RiderAuthScreen extends StatefulWidget {
  const RiderAuthScreen({Key? key}) : super(key: key);

  @override
  State<RiderAuthScreen> createState() => _RiderAuthScreenState();
}

class _RiderAuthScreenState extends State<RiderAuthScreen>
    with TickerProviderStateMixin {
  late AnimationController _heroController;
  late AnimationController _contentController;
  late Animation<double> _heroScaleAnim;
  late Animation<double> _heroFadeAnim;
  late Animation<double> _contentFadeAnim;
  late Animation<Offset> _contentSlideAnim;

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _showOtpField = false;
  bool _isPhoneValid = false;
  String _enteredOtp = '';

  StreamController<ErrorAnimationType> _otpErrorController =
      StreamController<ErrorAnimationType>();

  @override
  void initState() {
    super.initState();
    _heroController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _heroScaleAnim = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _heroController, curve: Curves.elasticOut),
    );
    _heroFadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _heroController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );
    _contentFadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _contentController, curve: Curves.easeOut),
    );
    _contentSlideAnim = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _contentController, curve: Curves.easeOutCubic),
    );

    _heroController.forward().then((_) {
      _contentController.forward();
    });
  }

  @override
  void dispose() {
    _heroController.dispose();
    _contentController.dispose();
    _phoneController.dispose();
    _otpController.dispose();
    _otpErrorController.close();
    super.dispose();
  }

  void _onPhoneChanged(String value) {
    setState(() {
      _isPhoneValid = value.replaceAll(RegExp(r'\D'), '').length >= 10;
    });
  }

  Future<void> _sendOtp() async {
    final phone = _phoneController.text.trim();
    if (!_isPhoneValid) return;

    final auth = context.read<AuthProvider>();
    await auth.sendOtp(phoneNumber: phone, role: UserRole.rider);

    if (mounted && auth.status == AuthStatus.otpSent) {
      setState(() {
        _showOtpField = true;
      });
    }
  }

  Future<void> _verifyOtp() async {
    if (_enteredOtp.length < 6) {
      _otpErrorController.add(ErrorAnimationType.shake);
      return;
    }
    final auth = context.read<AuthProvider>();
    final success = await auth.verifyOtp(otp: _enteredOtp, role: UserRole.rider);
    if (success && mounted) {
      Navigator.of(context).pushReplacementNamed('/rider_home');
    } else if (mounted) {
      _otpErrorController.add(ErrorAnimationType.shake);
    }
  }

  Future<void> _signInWithGoogle() async {
    final auth = context.read<AuthProvider>();
    final success = await auth.signInWithGoogle(role: UserRole.rider);
    if (success && mounted) {
      Navigator.of(context).pushReplacementNamed('/rider_home');
    }
  }

  Future<void> _signInWithApple() async {
    final auth = context.read<AuthProvider>();
    final success = await auth.signInWithApple(role: UserRole.rider);
    if (success && mounted) {
      Navigator.of(context).pushReplacementNamed('/rider_home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: Stack(
        children: [
          _buildBackground(),
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  _buildHeroSection(),
                  const SizedBox(height: 48),
                  _buildAuthCard(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.onboardingGradient,
      ),
      child: Stack(
        children: [
          Positioned(
            top: -80,
            right: -60,
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.12),
              ),
            ),
          ),
          Positioned(
            bottom: -60,
            left: -80,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondary.withOpacity(0.08),
              ),
            ),
          ),
          Positioned(
            top: 200,
            left: -40,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.tertiary.withOpacity(0.06),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return AnimatedBuilder(
      animation: _heroController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _heroFadeAnim,
          child: ScaleTransition(
            scale: _heroScaleAnim,
            child: child,
          ),
        );
      },
      child: Column(
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.primaryGradient,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.4),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                  spreadRadius: 4,
                ),
              ],
            ),
            child: Center(
              child: Icon(
                Icons.directions_car_rounded,
                color: AppColors.white,
                size: 46,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Welcome to Myth',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: AppColors.darkTextPrimary,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your intelligent ride companion',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: AppColors.darkTextSecondary,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthCard() {
    return FadeTransition(
      opacity: _contentFadeAnim,
      child: SlideTransition(
        position: _contentSlideAnim,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.darkSurface,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: AppColors.darkBorder,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowDark,
                blurRadius: 40,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          padding: const EdgeInsets.all(28),
          child: Consumer<AuthProvider>(
            builder: (context, auth, _) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (!_showOtpField) ...[
                    _buildSocialSection(auth),
                    const SizedBox(height: 28),
                    _buildDivider(),
                    const SizedBox(height: 28),
                    _buildPhoneSection(auth),
                  ] else ...[
                    _buildOtpSection(auth),
                  ],
                  if (auth.errorMessage != null) ...[
                    const SizedBox(height: 16),
                    _buildErrorBanner(auth.errorMessage!),
                  ],
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSocialSection(AuthProvider auth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Sign in',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.darkTextPrimary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Choose your preferred sign-in method',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            color: AppColors.darkTextSecondary,
          ),
        ),
        const SizedBox(height: 24),
        _SocialButton(
          label: 'Continue with Google',
          icon: 'https://www.gstatic.com/firebasejs/ui/2.0.0/images/auth/google.svg',
          backgroundColor: AppColors.white,
          textColor: AppColors.grey900,
          isLoading: auth.isGoogleLoading,
          onTap: _signInWithGoogle,
        ),
        const SizedBox(height: 14),
        _SocialButton(
          label: 'Continue with Apple',
          iconWidget: Icon(Icons.apple, size: 22, color: AppColors.white),
          backgroundColor: AppColors.grey900,
          textColor: AppColors.white,
          isLoading: auth.isAppleLoading,
          onTap: _signInWithApple,
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
          child: Divider(color: AppColors.darkBorder, thickness: 1),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'or',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: AppColors.darkTextSecondary,
            ),
          ),
        ),
        Expanded(
          child: Divider(color: AppColors.darkBorder, thickness: 1),
        ),
      ],
    );
  }

  Widget _buildPhoneSection(AuthProvider auth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Phone Number',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.darkTextPrimary,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: AppColors.darkSurfaceElevated,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _isPhoneValid
                  ? AppColors.primary.withOpacity(0.5)
                  : AppColors.darkBorder,
              width: 1.2,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      color: AppColors.darkBorder,
                      width: 1,
                    ),
                  ),
                ),
                child: Text(
                  '+1',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkTextPrimary,
                  ),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _phoneController,
                  onChanged: _onPhoneChanged,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    color: AppColors.darkTextPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: '(555) 000-0000',
                    hintStyle: GoogleFonts.plusJakartaSans(
                      color: AppColors.darkTextSecondary,
                      fontSize: 15,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        _buildPrimaryButton(
          label: 'Send OTP',
          isLoading: auth.isLoading,
          enabled: _isPhoneValid && !auth.isLoading,
          onTap: _sendOtp,
        ),
      ],
    );
  }

  Widget _buildOtpSection(AuthProvider auth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _showOtpField = false;
                  _enteredOtp = '';
                });
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.darkSurfaceElevated,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.darkBorder),
                ),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 16,
                  color: AppColors.darkTextPrimary,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Verify Phone',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkTextPrimary,
                  ),
                ),
                Text(
                  'Sent to ${auth.pendingPhone ?? _phoneController.text}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: AppColors.darkTextSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 32),
        PinCodeTextField(
          appContext: context,
          length: 6,
          controller: _otpController,
          errorAnimationController: _otpErrorController,
          onChanged: (value) {
            setState(() {
              _enteredOtp = value;
            });
          },
          onCompleted: (value) {
            _enteredOtp = value;
          },
          keyboardType: TextInputType.number,
          animationType: AnimationType.fade,
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            borderRadius: BorderRadius.circular(12),
            fieldHeight: 54,
            fieldWidth: 46,
            activeColor: AppColors.primary,
            inactiveColor: AppColors.darkBorder,
            selectedColor: AppColors.primaryLight,
            activeFillColor: AppColors.primarySurface.withOpacity(0.08),
            inactiveFillColor: AppColors.darkSurfaceElevated,
            selectedFillColor: AppColors.primarySurface.withOpacity(0.05),
          ),
          enableActiveFill: true,
          textStyle: GoogleFonts.plusJakartaSans(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.darkTextPrimary,
          ),
          cursorColor: AppColors.primary,
        ),
        const SizedBox(height: 10),
        _buildCountdownRow(auth),
        const SizedBox(height: 24),
        _buildPrimaryButton(
          label: 'Verify OTP',
          isLoading: auth.isLoading,
          enabled: _enteredOtp.length == 6 && !auth.isLoading,
          onTap: _verifyOtp,
        ),
      ],
    );
  }

  Widget _buildCountdownRow(AuthProvider auth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Didn't receive a code? ",
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            color: AppColors.darkTextSecondary,
          ),
        ),
        if (auth.isOtpCountdownActive)
          Text(
            'Resend in ${auth.otpSecondsRemaining}s',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          )
        else
          GestureDetector(
            onTap: () => auth.resendOtp(role: UserRole.rider),
            child: Text(
              'Resend',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
                decoration: TextDecoration.underline,
                decorationColor: AppColors.primary,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPrimaryButton({
    required String label,
    required bool isLoading,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 54,
        decoration: BoxDecoration(
          gradient: enabled ? AppColors.primaryGradient : null,
          color: enabled ? null : AppColors.darkBorder,
          borderRadius: BorderRadius.circular(14),
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.35),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ]
              : [],
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColors.white),
                  ),
                )
              : Text(
                  label,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: enabled ? AppColors.white : AppColors.grey500,
                    letterSpacing: 0.3,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildErrorBanner(String message) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.errorSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.error.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline_rounded, color: AppColors.error, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String label;
  final String? icon;
  final Widget? iconWidget;
  final Color backgroundColor;
  final Color textColor;
  final bool isLoading;
  final VoidCallback onTap;

  const _SocialButton({
    Key? key,
    required this.label,
    this.icon,
    this.iconWidget,
    required this.backgroundColor,
    required this.textColor,
    required this.isLoading,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.darkBorder,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowNeutral,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading) ...[
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(textColor),
                ),
              ),
            ] else ...[
              if (iconWidget != null) iconWidget!,
              if (icon != null)
                Image.network(
                  icon!,
                  width: 20,
                  height: 20,
                  errorBuilder: (_, __, ___) => Icon(
                    Icons.g_mobiledata_rounded,
                    size: 24,
                    color: textColor,
                  ),
                ),
              const SizedBox(width: 12),
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}