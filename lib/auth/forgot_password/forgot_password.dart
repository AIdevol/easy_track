import 'package:app_task/constants/colors.dart';
import 'package:app_task/utilities/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColor,
      appBar: AppBar(
        backgroundColor: appColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).primaryColor),
          onPressed: () => context.go('/login'),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                _buildHeaderText(),
                const SizedBox(height: 24),
                _buildDescriptionText(),
                const SizedBox(height: 40),
                _buildEmailField(),
                const SizedBox(height: 32),
                _buildResetButton(context),
                const SizedBox(height: 16),
                _buildBackToLoginButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderText() {
    return Text(
      'Forgot Password?',
      style: TextStyle(
        color: Theme.of(context).primaryColor,
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildDescriptionText() {
    return Text(
      'Enter your email address below and we\'ll send you instructions to reset your password.',
      style: TextStyle(
        color: Colors.grey[700],
        fontSize: 16,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildEmailField() {
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: const Offset(4, 4),
              blurRadius: 10,
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.8),
              offset: const Offset(-4, -4),
              blurRadius: 10,
            ),
          ],
        ),
        child: CustomTextField(
          hintText: "Enter your email",
          prefixIcon: Icon(Icons.email_outlined),
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            if (!value.contains('@') || !value.contains('.')) {
              return 'Please enter a valid email';
            }
            return null;
          },
        ));
  }

  Widget _buildResetButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: const Offset(4, 4),
            blurRadius: 10,
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.8),
            offset: const Offset(-4, -4),
            blurRadius: 10,
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            // Implement password reset logic
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Password reset instructions sent to your email'),
              ),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Theme.of(context).primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          "Reset Password",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _buildBackToLoginButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: TextStyle(color: Colors.grey[700]),
        ),
        TextButton(
          onPressed: () {
            context.go('/signup');
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
}
