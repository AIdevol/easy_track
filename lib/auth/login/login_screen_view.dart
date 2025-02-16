import 'package:app_task/constants/colors.dart';
import 'package:app_task/constants/images.dart';
import 'package:app_task/utilities/custom_container.dart';
import 'package:app_task/utilities/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class LoginScreenView extends StatefulWidget {
  const LoginScreenView({super.key});

  @override
  State<LoginScreenView> createState() => _LoginScreenViewState();
}

class _LoginScreenViewState extends State<LoginScreenView> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 60),
                _buildAppView(context),
                const SizedBox(height: 40),
                _buildCustomEmailView(context),
                const SizedBox(height: 16),
                _buildCustomPasswordView(context),
                _buildForgotPassword(context),
                const SizedBox(height: 24),
                _buildButtonView(context),
                const SizedBox(height: 16),
                _buildSignUpSection(context),
                const SizedBox(height: 32),
                _buildDivider(),
                const SizedBox(height: 32),
                _buildSocialview(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppView(BuildContext context) {
    return Container(
      height: 120,
      width: 120,
      alignment: Alignment.center,
      child: Image.asset(
        appIcon,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildCustomEmailView(BuildContext context) {
    return CustomTextField(
      hintText: "Email",
      prefixIcon: const Icon(Icons.email_outlined),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        return null;
      },
    );
  }

  Widget _buildCustomPasswordView(BuildContext context) {
    return CustomTextField(
      hintText: "Password",
      obscureText: !_isPasswordVisible,
      prefixIcon: const Icon(Icons.lock_outline),
      suffixIcon: IconButton(
        icon: Icon(
          _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
        ),
        onPressed: () {
          setState(() {
            _isPasswordVisible = !_isPasswordVisible;
          });
        },
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        return null;
      },
    );
  }

  Widget _buildForgotPassword(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          // Navigate to forgot password screen
        },
        child: Text(
          'Forgot Password?',
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
      ),
    );
  }

  Widget _buildButtonView(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          context.go('/home');
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: appColor,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: const Text(
        "Login",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSignUpSection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: TextStyle(color: Colors.grey[700]),
        ),
        TextButton(
          onPressed: () {
            // Navigate to sign up screen
          },
          child: Text(
            'Sign Up',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Row(
      children: const [
        Expanded(child: Divider(color: Colors.white38)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'OR',
            style: TextStyle(color: Colors.white70),
          ),
        ),
        Expanded(child: Divider(color: Colors.white38)),
      ],
    );
  }

  Widget _buildSocialview(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSocialButton(googleIcon, () {}),
        const SizedBox(width: 24),
        _buildSocialButton(appleIcon, () {}),
        const SizedBox(width: 24),
        _buildSocialButton(faceBookIcon, () {}),
      ],
    );
  }

  Widget _buildSocialButton(String icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: SvgPicture.asset(
          icon,
          height: 24,
          width: 24,
        ),
      ),
    );
  }
}
