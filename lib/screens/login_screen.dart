import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ride_swift_app/utils/colors.dart'; 
import 'package:ride_swift_app/screens/home_screen.dart'; 
import 'package:ride_swift_app/screens/register_screen.dart'; 

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
          ),
        ),
        child: Text(
          'Sign In',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Container(height: 1, color: AppColors.divider)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'or continue with',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
        ),
        Expanded(child: Container(height: 1, color: AppColors.divider)),
      ],
    );
  }

  Widget _buildSocialButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSocialButton(
          icon: 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/53/Google_%22G%22_Logo.svg/512px-Google_%22G%22_Logo.svg.png',
          label: 'Google',
          color: const Color(0xFFEA4335),
        ),
        const SizedBox(width: 16),
        _buildSocialButton(
          icon: 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1b/Apple_logo_grey.svg/512px-Apple_logo_grey.svg.png',
          label: 'Apple',
          color: Colors.black87,
        ),
        const SizedBox(width: 16),
        _buildSocialButton(
          icon: 'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b8/2021_Facebook_icon.svg/512px-2021_Facebook_icon.svg.png',
          label: 'Facebook',
          color: const Color(0xFF1877F2),
        ),
      ],
    );
  }

  Widget _buildSocialButton({required String icon, required String label, required Color color}) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              widthWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }
}