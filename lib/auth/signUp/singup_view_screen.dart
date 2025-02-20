import 'package:app_task/constants/colors.dart';
import 'package:app_task/constants/images.dart';
import 'package:app_task/utilities/custom_container.dart';
import 'package:app_task/utilities/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class SignUpScreenView extends StatefulWidget {
  const SignUpScreenView({super.key});

  @override
  State<SignUpScreenView> createState() => _SignUpScreenViewState();
}

class _SignUpScreenViewState extends State<SignUpScreenView> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

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
                _buildCustomTextField(
                    "Full Name", Icons.person, TextInputType.text),
                const SizedBox(height: 16),
                _buildCustomTextField(
                    "Email", Icons.email_outlined, TextInputType.emailAddress),
                const SizedBox(height: 16),
                _buildCustomTextField(
                    "Phone Number", Icons.phone, TextInputType.phone),
                const SizedBox(height: 16),
                _buildCustomPasswordField("Password", _isPasswordVisible, () {
                  setState(() => _isPasswordVisible = !_isPasswordVisible);
                }),
                const SizedBox(height: 16),
                _buildCustomPasswordField(
                    "Confirm Password", _isConfirmPasswordVisible, () {
                  setState(() =>
                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible);
                }),
                const SizedBox(height: 16),
                _buildCustomTextField("Address", Icons.home, TextInputType.text,
                    maxLines: 3),
                const SizedBox(height: 24),
                _buildTermsAndConditions(),
                const SizedBox(height: 24),
                _buildSignUpButton(context),
                const SizedBox(height: 16),
                _buildLoginSection(context),
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

  Widget _buildCustomTextField(
      String hintText, IconData icon, TextInputType keyboardType,
      {int maxLines = 1}) {
    return CustomTextField(
      hintText: hintText,
      prefixIcon: Icon(icon),
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $hintText';
        }
        return null;
      },
    );
  }

  Widget _buildCustomPasswordField(
      String hintText, bool isVisible, VoidCallback toggleVisibility) {
    return CustomTextField(
      hintText: hintText,
      obscureText: !isVisible,
      prefixIcon: const Icon(Icons.lock_outline),
      suffixIcon: IconButton(
        icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
        onPressed: toggleVisibility,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $hintText';
        }
        return null;
      },
    );
  }

  Widget _buildTermsAndConditions() {
    return Row(
      children: [
        Checkbox(value: true, onChanged: (value) {}),
        Expanded(
          child: Text(
            "I agree to the Terms and Conditions",
            style: TextStyle(color: Colors.grey[700]),
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpButton(BuildContext context) {
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(
        "Sign Up",
        style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor),
      ),
    );
  }

  Widget _buildLoginSection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Already have an account? ",
            style: TextStyle(color: Colors.grey[700])),
        TextButton(
          onPressed: () => context.go('/login'),
          child: Text("Login",
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold)),
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
            child: Text('OR', style: TextStyle(color: Colors.white70))),
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: const Offset(4, 4),
                blurRadius: 10),
            BoxShadow(
                color: Colors.white.withOpacity(0.8),
                offset: const Offset(-4, -4),
                blurRadius: 10),
          ],
        ),
        child: SvgPicture.asset(icon, height: 24, width: 24),
      ),
    );
  }

  Widget _buildAppView(BuildContext context) {
    return Container(
      height: 120,
      width: 120,
      alignment: Alignment.center,
      child: Image.asset(appIcon, fit: BoxFit.contain),
    );
  }
}
