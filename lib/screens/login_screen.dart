import 'package:flutter/material.dart';
import 'package:secure_entry_app/utils/colors.dart'; 

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;
  bool rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.06),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.04),
              _buildHeader(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              _buildWelcomeText(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.04),
              _buildEmailField(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              _buildPasswordField(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.015),
              _buildRememberAndForgot(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              _buildLoginButton(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              _buildDivider(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              _buildSocialLogin(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.04),
              _buildSignUpRow(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.gradientStart, AppColors.gradientEnd],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Icon(
            Icons.lock_outline,
            color: Colors.white,
            size: 36,
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeText() {
    return Column(
      children: [
        Text(
          'Welcome Back!',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            letterSpacing: 0.5,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8),
        Text(
          'Sign in to access your secure account',
          style: TextStyle(
            fontSize: 15,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: TextField(
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        style: TextStyle(color: AppColors.textPrimary, fontSize: 16),
        decoration: InputDecoration(
          hintText: 'Email address',
          hintStyle: TextStyle(color: AppColors.textSecondary),
          prefixIcon: Icon(Icons.email_outlined, color: AppColors.primary),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: TextField(
        controller: passwordController,
        obscureText: !isPasswordVisible,
        style: TextStyle(color: AppColors.textPrimary, fontSize: 16),
        decoration: InputDecoration(
          hintText: 'Password',
          hintStyle: TextStyle(color: AppColors.textSecondary),
          prefixIcon: Icon(Icons.lock_outline, color: AppColors.primary),
          suffixIcon: IconButton(
            icon: Icon(
              isPasswordVisible ? Icons.visibility_off : Icons.visibility,
              color: AppColors.textSecondary,
            ),
            onPressed: () {
              setState(() {
                isPasswordVisible = !isPasswordVisible;
              });
            },
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
      ),
    );
  }

  Widget _buildRememberAndForgot() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: Checkbox(
                value: rememberMe,
                onChanged: (value) {
                  setState(() {
                    rememberMe = value ?? false;
                  });
                },
                activeColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
            SizedBox(width: 10),
            Text(
              'Remember me',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            'Forgot Password?',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return Container(
      height: 58,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.gradientStart, AppColors.gradientEnd],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.4),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          'Sign In',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: AppColors.border, thickness: 1)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Or continue with',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(child: Divider(color: AppColors.border, thickness: 1)),
      ],
    );
  }

  Widget _buildSocialLogin() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSocialButton(
          icon: Image.network(
            'https://cdn-icons-png.flaticon.com/512/2991/2991148.png',
            width: 28,
            height: 28,
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.g_mobiledata, size: 28, color: AppColors.textSecondary);
            },
          ),
        ),
        SizedBox(width: 20),
        _buildSocialButton(
          icon: Image.network(
            'https://cdn-icons-png.flaticon.com/512/5968/5968764.png',
            width: 26,
            height: 26,
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.facebook, size: 26, color: AppColors.textSecondary);
            },
          ),
        ),
        SizedBox(width: 20),
        _buildSocialButton(
          icon: Image.network(
            'https://cdn-icons-png.flaticon.com/512/733/733579.png',
            width: 26,
            height: 26,
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.apple, size: 26, color: AppColors.textSecondary);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButton({required Widget icon}) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        onPressed: () {},
        icon: Center(child: icon),
      ),
    );
  }

  Widget _buildSignUpRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account?",
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            ' Sign Up',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}