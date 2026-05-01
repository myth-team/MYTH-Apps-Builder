import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ride_swift_app/utils/colors.dart'; 

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  bool _isPhoneSubmitted = false;
  bool _isOtpSent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Icon(Icons.directions_car, size: 80, color: AppColors.primary),
              const SizedBox(height: 16),
              Text('RideSwift', textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              const SizedBox(height: 8),
              Text('Get there safely', textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: AppColors.textSecondary)),
              const Spacer(),
              if (!_isPhoneSubmitted) _buildPhoneInput(),
              if (_isPhoneSubmitted && !_isOtpSent) _buildOtpInput(),
              if (_isOtpSent) _buildVerifiedView(),
              const SizedBox(height: 24),
              _buildSocialLogin(),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneInput() {
    return Column(
      children: [
        TextField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            labelText: 'Phone Number',
            prefixText: '+1 ',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: AppColors.surface,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 56,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: AppColors.textOnPrimary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            onPressed: () => setState(() => _isPhoneSubmitted = true),
            child: const Text('Send Code', style: TextStyle(fontSize: 16)),
          ),
        ),
      ],
    );
  }

  Widget _buildOtpInput() {
    return Column(
      children: [
        TextField(
          controller: _otpController,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(6)],
          decoration: InputDecoration(
            labelText: 'Verification Code',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: AppColors.surface,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 56,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: AppColors.textOnPrimary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            onPressed: () => setState(() => _isOtpSent = true),
            child: const Text('Verify', style: TextStyle(fontSize: 16)),
          ),
        ),
        const SizedBox(height: 8),
        TextButton(onPressed: () => setState(() => _isPhoneSubmitted = false), child: const Text('Change Number')),
      ],
    );
  }

  Widget _buildVerifiedView() {
    return Column(
      children: [
        Icon(Icons.check_circle, size: 64, color: AppColors.success),
        const SizedBox(height: 16),
        Text('Verified!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        const SizedBox(height: 8),
        Text('Setting up your account...', style: TextStyle(color: AppColors.textSecondary)),
      ],
    );
  }

  Widget _buildSocialLogin() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(children: [Expanded(child: Divider(color: AppColors.divider)), Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Text('OR', style: TextStyle(color: AppColors.textSecondary))), Expanded(child: Divider(color: AppColors.divider))]),
        const SizedBox(height: 24),
        _SocialButton(icon: Icons.g_mobiledata, label: 'Continue with Google', color: AppColors.error),
        const SizedBox(height: 12),
        _SocialButton(icon: Icons.apple, label: 'Continue with Apple', color: AppColors.textPrimary),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _SocialButton({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          side: BorderSide(color: AppColors.divider),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: AppColors.surface,
        ),
        icon: Icon(icon, size: 28),
        label: Text(label, style: const TextStyle(fontSize: 16)),
        onPressed: () {},
      ),
    );
  }
}