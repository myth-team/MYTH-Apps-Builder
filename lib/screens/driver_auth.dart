import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:new_project_app/utils/colors.dart'; 
import 'package:new_project_app/providers/auth_provider.dart';

// ─────────────────────────────────────────────────────────────────────────────
// DriverAuthScreen — Main entry point
// ─────────────────────────────────────────────────────────────────────────────

class DriverAuthScreen extends StatefulWidget {
  const DriverAuthScreen({Key? key}) : super(key: key);

  @override
  State<DriverAuthScreen> createState() => _DriverAuthScreenState();
}

class _DriverAuthScreenState extends State<DriverAuthScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  _DriverAuthStep _currentStep = _DriverAuthStep.phone;

  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
    _slideController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _goToStep(_DriverAuthStep step) {
    setState(() => _currentStep = step);
    final int index = _DriverAuthStep.values.indexOf(step);
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
    );
    _slideController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            _DriverAuthHeader(currentStep: _currentStep),
            _StepProgressIndicator(currentStep: _currentStep),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  _PhoneStepPage(
                    slideAnimation: _slideAnimation,
                    onNext: () => _goToStep(_DriverAuthStep.otp),
                  ),
                  _OtpStepPage(
                    slideAnimation: _slideAnimation,
                    onNext: () => _goToStep(_DriverAuthStep.documents),
                    onBack: () => _goToStep(_DriverAuthStep.phone),
                  ),
                  _DocumentsStepPage(
                    slideAnimation: _slideAnimation,
                    onNext: () => _goToStep(_DriverAuthStep.profile),
                    onBack: () => _goToStep(_DriverAuthStep.otp),
                  ),
                  _ProfileStepPage(
                    slideAnimation: _slideAnimation,
                    onBack: () => _goToStep(_DriverAuthStep.documents),
                    onComplete: () {
                      Navigator.pushReplacementNamed(context, '/driver_home');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Step Enum
// ─────────────────────────────────────────────────────────────────────────────

enum _DriverAuthStep { phone, otp, documents, profile }

// ─────────────────────────────────────────────────────────────────────────────
// Header
// ─────────────────────────────────────────────────────────────────────────────

class _DriverAuthHeader extends StatelessWidget {
  final _DriverAuthStep currentStep;

  const _DriverAuthHeader({required this.currentStep});

  String get _title {
    switch (currentStep) {
      case _DriverAuthStep.phone:
        return 'Drive with Us';
      case _DriverAuthStep.otp:
        return 'Verify Phone';
      case _DriverAuthStep.documents:
        return 'Upload Documents';
      case _DriverAuthStep.profile:
        return 'Setup Profile';
    }
  }

  String get _subtitle {
    switch (currentStep) {
      case _DriverAuthStep.phone:
        return 'Start earning on your schedule';
      case _DriverAuthStep.otp:
        return 'Enter the code we sent you';
      case _DriverAuthStep.documents:
        return 'We need to verify your credentials';
      case _DriverAuthStep.profile:
        return 'Tell us about you and your vehicle';
    }
  }

  @override
  Widget build(BuildContext context) {
    final double topPad = MediaQuery.of(context).padding.top;
    return Container(
      padding: EdgeInsets.fromLTRB(24, topPad + 16, 24, 24),
      decoration: BoxDecoration(
        gradient: AppColors.onboardingGradient,
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.primaryGradient,
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowPrimary,
                  blurRadius: 16,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Icon(
              Icons.directions_car_rounded,
              color: AppColors.white,
              size: 26,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  child: Text(
                    _title,
                    key: ValueKey(_title),
                    style: TextStyle(
                      color: AppColors.darkTextPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                    ),
                  ),
                ),
                SizedBox(height: 3),
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  child: Text(
                    _subtitle,
                    key: ValueKey(_subtitle),
                    style: TextStyle(
                      color: AppColors.darkTextSecondary,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Step Progress Indicator
// ─────────────────────────────────────────────────────────────────────────────

class _StepProgressIndicator extends StatelessWidget {
  final _DriverAuthStep currentStep;

  const _StepProgressIndicator({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    final steps = [
      _StepInfo(icon: Icons.phone_android_rounded, label: 'Phone'),
      _StepInfo(icon: Icons.lock_rounded, label: 'OTP'),
      _StepInfo(icon: Icons.folder_rounded, label: 'Docs'),
      _StepInfo(icon: Icons.person_rounded, label: 'Profile'),
    ];
    final int currentIndex = _DriverAuthStep.values.indexOf(currentStep);

    return Container(
      color: AppColors.darkSurface,
      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      child: Row(
        children: List.generate(steps.length * 2 - 1, (i) {
          if (i.isOdd) {
            final int stepIndex = i ~/ 2;
            final bool passed = stepIndex < currentIndex;
            return Expanded(
              child: Container(
                height: 2,
                decoration: BoxDecoration(
                  gradient: passed
                      ? AppColors.primaryGradient
                      : LinearGradient(
                          colors: [
                            AppColors.darkBorder,
                            AppColors.darkBorder,
                          ],
                        ),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            );
          }
          final int stepIndex = i ~/ 2;
          final bool isActive = stepIndex == currentIndex;
          final bool isDone = stepIndex < currentIndex;
          return _StepDot(
            info: steps[stepIndex],
            isActive: isActive,
            isDone: isDone,
          );
        }),
      ),
    );
  }
}

class _StepInfo {
  final IconData icon;
  final String label;
  const _StepInfo({required this.icon, required this.label});
}

class _StepDot extends StatelessWidget {
  final _StepInfo info;
  final bool isActive;
  final bool isDone;

  const _StepDot({
    required this.info,
    required this.isActive,
    required this.isDone,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color iconColor;
    if (isDone) {
      bgColor = AppColors.primary;
      iconColor = AppColors.white;
    } else if (isActive) {
      bgColor = AppColors.primarySurface;
      iconColor = AppColors.primary;
    } else {
      bgColor = AppColors.darkSurfaceElevated;
      iconColor = AppColors.grey600;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: bgColor,
            border: Border.all(
              color: isActive ? AppColors.primary : Colors.transparent,
              width: 2,
            ),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: AppColors.shadowPrimary,
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: isDone
                ? Icon(Icons.check_rounded, color: AppColors.white, size: 16)
                : Icon(info.icon, color: iconColor, size: 15),
          ),
        ),
        SizedBox(height: 4),
        Text(
          info.label,
          style: TextStyle(
            color: isActive || isDone
                ? AppColors.primary
                : AppColors.grey600,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Step 1: Phone Entry
// ─────────────────────────────────────────────────────────────────────────────

class _PhoneStepPage extends StatefulWidget {
  final Animation<Offset> slideAnimation;
  final VoidCallback onNext;

  const _PhoneStepPage({
    required this.slideAnimation,
    required this.onNext,
  });

  @override
  State<_PhoneStepPage> createState() => _PhoneStepPageState();
}

class _PhoneStepPageState extends State<_PhoneStepPage> {
  final TextEditingController _phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _selectedCountryCode = '+1';
  bool _isLoading = false;

  final List<_CountryCode> _countryCodes = [
    _CountryCode(code: '+1', flag: '🇺🇸', name: 'US'),
    _CountryCode(code: '+44', flag: '🇬🇧', name: 'UK'),
    _CountryCode(code: '+91', flag: '🇮🇳', name: 'IN'),
    _CountryCode(code: '+61', flag: '🇦🇺', name: 'AU'),
    _CountryCode(code: '+971', flag: '🇦🇪', name: 'AE'),
  ];

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleContinue() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    final auth = context.read<AuthProvider>();
    await auth.sendOtp(
      phoneNumber: '$_selectedCountryCode${_phoneController.text.trim()}',
      role: UserRole.driver,
    );
    if (mounted) {
      setState(() => _isLoading = false);
      widget.onNext();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: widget.slideAnimation,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),
              _SectionLabel(label: 'Mobile Number', icon: Icons.phone_rounded),
              SizedBox(height: 12),
              _PhoneInputField(
                controller: _phoneController,
                countryCodes: _countryCodes,
                selectedCode: _selectedCountryCode,
                onCountryChanged: (code) =>
                    setState(() => _selectedCountryCode = code),
              ),
              SizedBox(height: 24),
              _InfoBanner(
                icon: Icons.info_outline_rounded,
                message:
                    'We\'ll send a verification code to confirm your phone number. Standard rates may apply.',
                color: AppColors.info,
              ),
              SizedBox(height: 32),
              _GradientButton(
                label: 'Send OTP Code',
                icon: Icons.arrow_forward_rounded,
                isLoading: _isLoading,
                onTap: _handleContinue,
              ),
              SizedBox(height: 24),
              _TermsText(),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Step 2: OTP Verification
// ─────────────────────────────────────────────────────────────────────────────

class _OtpStepPage extends StatefulWidget {
  final Animation<Offset> slideAnimation;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const _OtpStepPage({
    required this.slideAnimation,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<_OtpStepPage> createState() => _OtpStepPageState();
}

class _OtpStepPageState extends State<_OtpStepPage> {
  final List<TextEditingController> _otpControllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    for (var c in _otpControllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _fullOtp =>
      _otpControllers.map((c) => c.text).join();

  Future<void> _handleVerify() async {
    if (_fullOtp.length != 6) {
      setState(() => _errorMessage = 'Please enter the complete 6-digit code.');
      return;
    }
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    final auth = context.read<AuthProvider>();
    final bool success = await auth.verifyOtp(
      otp: _fullOtp,
      role: UserRole.driver,
    );
    if (mounted) {
      setState(() => _isLoading = false);
      if (success) {
        widget.onNext();
      } else {
        setState(
            () => _errorMessage = auth.errorMessage ?? 'Invalid OTP. Try again.');
      }
    }
  }

  void _onOtpChanged(String value, int index) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    if (_fullOtp.length == 6) {
      _handleVerify();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: widget.slideAnimation,
      child: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8),
                _SectionLabel(label: 'Enter OTP', icon: Icons.pin_rounded),
                SizedBox(height: 6),
                Text(
                  'Code sent to ${auth.pendingPhone ?? 'your phone'}',
                  style: TextStyle(
                    color: AppColors.darkTextSecondary,
                    fontSize: 13,
                  ),
                ),
                SizedBox(height: 28),
                _OtpInputRow(
                  controllers: _otpControllers,
                  focusNodes: _focusNodes,
                  onChanged: _onOtpChanged,
                  hasError: _errorMessage != null,
                ),
                if (_errorMessage != null) ...[
                  SizedBox(height: 12),
                  _ErrorBanner(message: _errorMessage!),
                ],
                SizedBox(height: 24),
                _OtpCountdownRow(
                  secondsRemaining: auth.otpSecondsRemaining,
                  isActive: auth.isOtpCountdownActive,
                  onResend: () async {
                    setState(() => _errorMessage = null);
                    await auth.resendOtp(role: UserRole.driver);
                  },
                ),
                SizedBox(height: 32),
                _GradientButton(
                  label: 'Verify & Continue',
                  icon: Icons.verified_rounded,
                  isLoading: _isLoading,
                  onTap: _handleVerify,
                ),
                SizedBox(height: 16),
                _BackButton(onTap: widget.onBack),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Step 3: Documents Upload
// ─────────────────────────────────────────────────────────────────────────────

class _DocumentsStepPage extends StatefulWidget {
  final Animation<Offset> slideAnimation;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const _DocumentsStepPage({
    required this.slideAnimation,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<_DocumentsStepPage> createState() => _DocumentsStepPageState();
}

class _DocumentsStepPageState extends State<_DocumentsStepPage> {
  final Map<_DocumentType, _DocumentStatus> _docStatuses = {
    _DocumentType.drivingLicense: _DocumentStatus.pending,
    _DocumentType.vehicleRegistration: _DocumentStatus.pending,
    _DocumentType.insurance: _DocumentStatus.pending,
    _DocumentType.profilePhoto: _DocumentStatus.pending,
  };

  bool get _allUploaded =>
      _docStatuses.values.every((s) => s == _DocumentStatus.uploaded);

  Future<void> _simulateUpload(_DocumentType type) async {
    setState(() => _docStatuses[type] = _DocumentStatus.uploading);
    await Future.delayed(Duration(milliseconds: 1500));
    if (mounted) {
      setState(() => _docStatuses[type] = _DocumentStatus.uploaded);
    }
  }

  @override
  Widget build(BuildContext context) {
    final docConfigs = [
      _DocumentConfig(
        type: _DocumentType.drivingLicense,
        label: 'Driving License',
        subtitle: 'Front & back of your license',
        icon: Icons.badge_rounded,
        color: AppColors.primary,
      ),
      _DocumentConfig(
        type: _DocumentType.vehicleRegistration,
        label: 'Vehicle Registration',
        subtitle: 'Official registration certificate',
        icon: Icons.article_rounded,
        color: AppColors.tertiary,
      ),
      _DocumentConfig(
        type: _DocumentType.insurance,
        label: 'Insurance Document',
        subtitle: 'Valid vehicle insurance',
        icon: Icons.security_rounded,
        color: AppColors.info,
      ),
      _DocumentConfig(
        type: _DocumentType.profilePhoto,
        label: 'Profile Photo',
        subtitle: 'Clear selfie photo of yourself',
        icon: Icons.person_rounded,
        color: AppColors.secondary,
      ),
    ];

    return SlideTransition(
      position: widget.slideAnimation,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            _SectionLabel(
                label: 'Required Documents',
                icon: Icons.folder_open_rounded),
            SizedBox(height: 4),
            Text(
              'Upload clear photos of each document',
              style: TextStyle(
                color: AppColors.darkTextSecondary,
                fontSize: 13,
              ),
            ),
            SizedBox(height: 20),
            ...docConfigs.map((config) => Padding(
                  padding: EdgeInsets.only(bottom: 14),
                  child: _DocumentUploadCard(
                    config: config,
                    status: _docStatuses[config.type]!,
                    onUpload: () => _simulateUpload(config.type),
                  ),
                )),
            SizedBox(height: 8),
            _InfoBanner(
              icon: Icons.shield_outlined,
              message:
                  'Your documents are encrypted and securely stored. Verification typically takes 24-48 hours.',
              color: AppColors.success,
            ),
            SizedBox(height: 24),
            _GradientButton(
              label: _allUploaded ? 'Continue' : 'Skip for Now',
              icon: Icons.arrow_forward_rounded,
              isLoading: false,
              onTap: widget.onNext,
            ),
            SizedBox(height: 16),
            _BackButton(onTap: widget.onBack),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Step 4: Profile Setup
// ─────────────────────────────────────────────────────────────────────────────

class _ProfileStepPage extends StatefulWidget {
  final Animation<Offset> slideAnimation;
  final VoidCallback onBack;
  final VoidCallback onComplete;

  const _ProfileStepPage({
    required this.slideAnimation,
    required this.onBack,
    required this.onComplete,
  });

  @override
  State<_ProfileStepPage> createState() => _ProfileStepPageState();
}

class _ProfileStepPageState extends State<_ProfileStepPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _vehicleModelController = TextEditingController();
  final TextEditingController _vehiclePlateController = TextEditingController();
  final TextEditingController _vehicleYearController = TextEditingController();
  String _selectedVehicleType = 'economy';
  bool _isLoading = false;

  final List<_VehicleTypeOption> _vehicleTypes = [
    _VehicleTypeOption(
        key: 'economy',
        label: 'Economy',
        icon: Icons.directions_car_rounded,
        color: AppColors.vehicleEconomy),
    _VehicleTypeOption(
        key: 'luxury',
        label: 'Luxury',
        icon: Icons.airport_shuttle_rounded,
        color: AppColors.vehicleLuxury),
    _VehicleTypeOption(
        key: 'xl',
        label: 'XL',
        icon: Icons.rv_hookup_rounded,
        color: AppColors.vehicleXL),
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _vehicleModelController.dispose();
    _vehiclePlateController.dispose();
    _vehicleYearController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    final auth = context.read<AuthProvider>();
    final bool success = await auth.completeProfile(
      name: _nameController.text.trim(),
      email: _emailController.text.trim().isEmpty
          ? null
          : _emailController.text.trim(),
      vehicleType: _selectedVehicleType,
      vehiclePlate: _vehiclePlateController.text.trim(),
    );
    if (mounted) {
      setState(() => _isLoading = false);
      if (success) {
        widget.onComplete();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: widget.slideAnimation,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),
              _AvatarPickerWidget(),
              SizedBox(height: 24),
              _SectionLabel(
                  label: 'Personal Info', icon: Icons.person_outline_rounded),
              SizedBox(height: 12),
              _StyledTextField(
                controller: _nameController,
                label: 'Full Name',
                hint: 'Enter your full name',
                icon: Icons.person_rounded,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Name is required' : null,
                inputType: TextInputType.name,
              ),
              SizedBox(height: 14),
              _StyledTextField(
                controller: _emailController,
                label: 'Email (optional)',
                hint: 'your@email.com',
                icon: Icons.email_rounded,
                inputType: TextInputType.emailAddress,
              ),
              SizedBox(height: 24),
              _SectionLabel(
                  label: 'Vehicle Information',
                  icon: Icons.directions_car_rounded),
              SizedBox(height: 12),
              _VehicleTypePicker(
                types: _vehicleTypes,
                selected: _selectedVehicleType,
                onSelected: (key) => setState(() => _selectedVehicleType = key),
              ),
              SizedBox(height: 14),
              _StyledTextField(
                controller: _vehicleModelController,
                label: 'Vehicle Make & Model',
                hint: 'e.g. Toyota Camry',
                icon: Icons.car_repair_rounded,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Vehicle model is required'
                    : null,
              ),
              SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: _StyledTextField(
                      controller: _vehiclePlateController,
                      label: 'License Plate',
                      hint: 'ABC-1234',
                      icon: Icons.confirmation_number_rounded,
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Required'
                          : null,
                      inputType: TextInputType.text,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: _StyledTextField(
                      controller: _vehicleYearController,
                      label: 'Year',
                      hint: '2022',
                      icon: Icons.calendar_today_rounded,
                      inputType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 28),
              _GradientButton(
                label: 'Complete Registration',
                icon: Icons.check_circle_rounded,
                isLoading: _isLoading,
                onTap: _handleSubmit,
              ),
              SizedBox(height: 16),
              _BackButton(onTap: widget.onBack),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared / Reusable Private Widgets
// ─────────────────────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  final IconData icon;

  const _SectionLabel({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.primarySurface,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primary, size: 16),
        ),
        SizedBox(width: 10),
        Text(
          label,
          style: TextStyle(
            color: AppColors.darkTextPrimary,
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.1,
          ),
        ),
      ],
    );
  }
}

class _GradientButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isLoading;
  final VoidCallback onTap;

  const _GradientButton({
    required this.label,
    required this.icon,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        height: 56,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: isLoading
              ? LinearGradient(
                  colors: [AppColors.grey400, AppColors.grey500],
                )
              : AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isLoading
              ? []
              : [
                  BoxShadow(
                    color: AppColors.shadowPrimary,
                    blurRadius: 20,
                    offset: Offset(0, 8),
                  ),
                ],
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColors.white),
                    strokeWidth: 2.5,
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(icon, color: AppColors.white, size: 20),
                  ],
                ),
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  final VoidCallback onTap;

  const _BackButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.darkSurfaceElevated,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.darkBorder, width: 1),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.arrow_back_rounded,
                  color: AppColors.darkTextSecondary, size: 18),
              SizedBox(width: 6),
              Text(
                'Go Back',
                style: TextStyle(
                  color: AppColors.darkTextSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  final IconData icon;
  final String message;
  final Color color;

  const _InfoBanner({
    required this.icon,
    required this.message,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.withAlpha(color, 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.withAlpha(color, 0.3), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 18),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: AppColors.withAlpha(color, 0.9),
                fontSize: 12,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;

  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.errorSurface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.error.withOpacity(0.4), width: 1),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline_rounded, color: AppColors.error, size: 18),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: AppColors.errorDark,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StyledTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final String? Function(String?)? validator;
  final TextInputType inputType;
  final List<TextInputFormatter>? inputFormatters;

  const _StyledTextField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.validator,
    this.inputType = TextInputType.text,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.darkTextSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
        SizedBox(height: 7),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: inputType,
          inputFormatters: inputFormatters,
          style: TextStyle(
            color: AppColors.darkTextPrimary,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: AppColors.grey600,
              fontSize: 14,
            ),
            prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
            filled: true,
            fillColor: AppColors.darkSurfaceElevated,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: AppColors.darkBorder, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: AppColors.darkBorder, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: AppColors.primary, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: AppColors.error, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: AppColors.error, width: 1.5),
            ),
            errorStyle: TextStyle(
              color: AppColors.error,
              fontSize: 11,
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Phone Input Field
// ─────────────────────────────────────────────────────────────────────────────

class _PhoneInputField extends StatelessWidget {
  final TextEditingController controller;
  final List<_CountryCode> countryCodes;
  final String selectedCode;
  final ValueChanged<String> onCountryChanged;

  const _PhoneInputField({
    required this.controller,
    required this.countryCodes,
    required this.selectedCode,
    required this.onCountryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkSurfaceElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.darkBorder, width: 1),
      ),
      child: Row(
        children: [
          _CountryCodePicker(
            countryCodes: countryCodes,
            selected: selectedCode,
            onChanged: onCountryChanged,
          ),
          Container(width: 1, height: 36, color: AppColors.darkBorder),
          Expanded(
            child: TextFormField(
              controller: controller,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(12),
              ],
              style: TextStyle(
                color: AppColors.darkTextPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.5,
              ),
              validator: (v) {
                if (v == null || v.trim().length < 7) {
                  return 'Please enter a valid phone number';
                }
                return null;
              },
              decoration: InputDecoration(
                hintText: '000 000 0000',
                hintStyle:
                    TextStyle(color: AppColors.grey600, letterSpacing: 1.0),
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                errorStyle: TextStyle(
                  color: AppColors.error,
                  fontSize: 11,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CountryCodePicker extends StatelessWidget {
  final List<_CountryCode> countryCodes;
  final String selected;
  final ValueChanged<String> onChanged;

  const _CountryCodePicker({
    required this.countryCodes,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final current = countryCodes.firstWhere((c) => c.code == selected,
        orElse: () => countryCodes.first);
    return GestureDetector(
      onTap: () => _showPicker(context),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(current.flag, style: TextStyle(fontSize: 18)),
            SizedBox(width: 6),
            Text(
              current.code,
              style: TextStyle(
                color: AppColors.darkTextPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 4),
            Icon(Icons.keyboard_arrow_down_rounded,
                color: AppColors.grey500, size: 18),
          ],
        ),
      ),
    );
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.darkSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.only(top: 10, bottom: 16),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.darkBorder,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          ...countryCodes.map((c) => ListTile(
                leading: Text(c.flag, style: TextStyle(fontSize: 22)),
                title: Text(
                  c.name,
                  style: TextStyle(
                    color: AppColors.darkTextPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: Text(
                  c.code,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                onTap: () {
                  onChanged(c.code);
                  Navigator.pop(context);
                },
              )),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// OTP Input Row
// ─────────────────────────────────────────────────────────────────────────────

class _OtpInputRow extends StatelessWidget {
  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;
  final Function(String, int) onChanged;
  final bool hasError;

  const _OtpInputRow({
    required this.controllers,
    required this.focusNodes,
    required this.onChanged,
    required this.hasError,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(6, (i) {
        return _OtpCell(
          controller: controllers[i],
          focusNode: focusNodes[i],
          hasError: hasError,
          onChanged: (v) => onChanged(v, i),
        );
      }),
    );
  }
}

class _OtpCell extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool hasError;
  final ValueChanged<String> onChanged;

  const _OtpCell({
    required this.controller,
    required this.focusNode,
    required this.hasError,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 46,
      height: 56,
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: TextStyle(
          color: hasError ? AppColors.error : AppColors.darkTextPrimary,
          fontSize: 22,
          fontWeight: FontWeight.w800,
        ),
        onChanged: onChanged,
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: hasError
              ? AppColors.errorSurface
              : AppColors.darkSurfaceElevated,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: hasError ? AppColors.error : AppColors.darkBorder,
              width: 1.5,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: hasError ? AppColors.error : AppColors.darkBorder,
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: hasError ? AppColors.error : AppColors.primary,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// OTP Countdown Row
// ─────────────────────────────────────────────────────────────────────────────

class _OtpCountdownRow extends StatelessWidget {
  final int secondsRemaining;
  final bool isActive;
  final VoidCallback onResend;

  const _OtpCountdownRow({
    required this.secondsRemaining,
    required this.isActive,
    required this.onResend,
  });

  String _formatTime(int seconds) {
    final int m = seconds ~/ 60;
    final int s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Didn't receive the code? ",
          style: TextStyle(
            color: AppColors.darkTextSecondary,
            fontSize: 13,
          ),
        ),
        isActive
            ? Text(
                _formatTime(secondsRemaining),
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              )
            : GestureDetector(
                onTap: onResend,
                child: Text(
                  'Resend',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.primary,
                  ),
                ),
              ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Document Upload Card
// ─────────────────────────────────────────────────────────────────────────────

class _DocumentUploadCard extends StatelessWidget {
  final _DocumentConfig config;
  final _DocumentStatus status;
  final VoidCallback onUpload;

  const _DocumentUploadCard({
    required this.config,
    required this.status,
    required this.onUpload,
  });

  @override
  Widget build(BuildContext context) {
    final bool isUploaded = status == _DocumentStatus.uploaded;
    final bool isUploading = status == _DocumentStatus.uploading;

    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isUploaded
            ? AppColors.withAlpha(AppColors.success, 0.08)
            : AppColors.darkSurfaceElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUploaded
              ? AppColors.withAlpha(AppColors.success, 0.4)
              : AppColors.darkBorder,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isUploaded
                  ? AppColors.withAlpha(AppColors.success, 0.15)
                  : AppColors.withAlpha(config.color, 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isUploaded ? Icons.check_circle_rounded : config.icon,
              color: isUploaded ? AppColors.success : config.color,
              size: 22,
            ),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  config.label,
                  style: TextStyle(
                    color: AppColors.darkTextPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  config.subtitle,
                  style: TextStyle(
                    color: AppColors.darkTextSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12),
          GestureDetector(
            onTap: (isUploading || isUploaded) ? null : onUpload,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 250),
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                gradient: isUploaded
                    ? LinearGradient(
                        colors: [AppColors.success, AppColors.successDark])
                    : (isUploading
                        ? LinearGradient(
                            colors: [AppColors.grey400, AppColors.grey500])
                        : AppColors.primaryGradient),
                borderRadius: BorderRadius.circular(10),
              ),
              child: isUploading
                  ? SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(AppColors.white),
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      isUploaded ? 'Done' : 'Upload',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Vehicle Type Picker
// ─────────────────────────────────────────────────────────────────────────────

class _VehicleTypePicker extends StatelessWidget {
  final List<_VehicleTypeOption> types;
  final String selected;
  final ValueChanged<String> onSelected;

  const _VehicleTypePicker({
    required this.types,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Vehicle Type',
          style: TextStyle(
            color: AppColors.darkTextSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
        SizedBox(height: 10),
        Row(
          children: types.map((t) {
            final bool isSelected = t.key == selected;
            return Expanded(
              child: GestureDetector(
                onTap: () => onSelected(t.key),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 250),
                  margin: EdgeInsets.only(
                      right: t == types.last ? 0 : 10),
                  padding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.withAlpha(t.color, 0.15)
                        : AppColors.darkSurfaceElevated,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.withAlpha(t.color, 0.6)
                          : AppColors.darkBorder,
                      width: isSelected ? 1.5 : 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.withAlpha(t.color, 0.2),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ]
                        : [],
                  ),
                  child: Column(
                    children: [
                      Icon(
                        t.icon,
                        color: isSelected ? t.color : AppColors.grey600,
                        size: 22,
                      ),
                      SizedBox(height: 6),
                      Text(
                        t.label,
                        style: TextStyle(
                          color: isSelected
                              ? t.color
                              : AppColors.darkTextSecondary,
                          fontSize: 12,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Avatar Picker Widget
// ─────────────────────────────────────────────────────────────────────────────

class _AvatarPickerWidget extends StatefulWidget {
  const _AvatarPickerWidget();

  @override
  State<_AvatarPickerWidget> createState() => _AvatarPickerWidgetState();
}

class _AvatarPickerWidgetState extends State<_AvatarPickerWidget> {
  bool _hasPhoto = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () => setState(() => _hasPhoto = true),
        child: Stack(
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: _hasPhoto ? null : AppColors.primaryGradient,
                color: _hasPhoto ? AppColors.darkSurfaceElevated : null,
                border: Border.all(
                  color: AppColors.withAlpha(AppColors.primary, 0.5),
                  width: 2.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowPrimary,
                    blurRadius: 16,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Center(
                child: _hasPhoto
                    ? Icon(Icons.person_rounded,
                        color: AppColors.primary, size: 42)
                    : Icon(Icons.add_a_photo_rounded,
                        color: AppColors.white, size: 30),
              ),
            ),
            Positioned(
              bottom: 2,
              right: 2,
              child: Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary,
                  border: Border.all(color: AppColors.darkBackground, width: 2),
                ),
                child: Icon(
                  _hasPhoto ? Icons.edit_rounded : Icons.add_rounded,
                  color: AppColors.white,
                  size: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Terms Text
// ─────────────────────────────────────────────────────────────────────────────

class _TermsText extends StatelessWidget {
  const _TermsText();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text.rich(
        TextSpan(
          text: 'By continuing, you agree to our ',
          style: TextStyle(
            color: AppColors.darkTextSecondary,
            fontSize: 12,
          ),
          children: [
            TextSpan(
              text: 'Terms of Service',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
                decorationColor: AppColors.primary,
              ),
            ),
            TextSpan(text: ' and '),
            TextSpan(
              text: 'Privacy Policy',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
                decorationColor: AppColors.primary,
              ),
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Data Classes
// ─────────────────────────────────────────────────────────────────────────────

class _CountryCode {
  final String code;
  final String flag;
  final String name;

  const _CountryCode({
    required this.code,
    required this.flag,
    required this.name,
  });
}

enum _DocumentType {
  drivingLicense,
  vehicleRegistration,
  insurance,
  profilePhoto,
}

enum _DocumentStatus { pending, uploading, uploaded }

class _DocumentConfig {
  final _DocumentType type;
  final String label;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _DocumentConfig({
    required this.type,
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
}

class _VehicleTypeOption {
  final String key;
  final String label;
  final IconData icon;
  final Color color;

  const _VehicleTypeOption({
    required this.key,
    required this.label,
    required this.icon,
    required this.color,
  });
}