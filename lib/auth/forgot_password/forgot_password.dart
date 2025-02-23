import 'package:app_task/utilities/custom_container.dart';
import 'package:app_task/utilities/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'bloc/forgot_password_bloc.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _otpController;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _otpController = TextEditingController();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _emailController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isDisposed) {
      return const SizedBox.shrink();
    }

    return BlocProvider(
      create: (context) => ForgotPasswordBloc(),
      child: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
        listener: (context, state) {
          if (_isDisposed) return;

          if (state is ForgotPasswordError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is ForgotPasswordSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('OTP verified successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            context.go('/resetPass');
          }
        },
        builder: (context, state) {
          if (_isDisposed) {
            return const SizedBox.shrink();
          }

          return Scaffold(
            backgroundColor: Colors.grey[100],
            appBar: _buildAppBar(context),
            body: Stack(
              children: [
                _buildMainContent(context, state),
                if (state is ForgotPasswordLoading)
                  Container(
                    color: Colors.black26,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Theme.of(context).primaryColor),
        onPressed: () => context.go('/login'),
      ),
    );
  }

  Widget _buildMainContent(BuildContext context, ForgotPasswordState state) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildLockIcon(),
              const SizedBox(height: 24),
              _buildHeaderText(),
              const SizedBox(height: 12),
              if (state is! ForgotPasswordOTPSent) ...[
                _buildEmailDescription(),
                const SizedBox(height: 32),
                _buildEmailField(),
                const SizedBox(height: 24),
                _buildResetButton(context),
              ] else ...[
                _buildOTPDescription(),
                const SizedBox(height: 32),
                _buildOTPFields(context),
                const SizedBox(height: 16),
                _buildTimer(state as ForgotPasswordOTPSent),
                const SizedBox(height: 24),
                _buildVerifyButton(context),
                if ((state as ForgotPasswordOTPSent).remainingSeconds == 0)
                  _buildResendButton(context),
              ],
              const SizedBox(height: 24),
              _buildBackToLoginButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLockIcon() {
    return Icon(
      Icons.lock_outline,
      size: 80,
      color: Theme.of(context).primaryColor,
    );
  }

  Widget _buildHeaderText() {
    return Text(
      'Forgot Password?',
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).primaryColor,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildEmailDescription() {
    return Text(
      'Enter your registered email address. We\'ll send you a code to reset your password.',
      style: TextStyle(
        color: Colors.grey[600],
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
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: CustomTextField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        hintText: 'Enter your email',
        prefixIcon: Icon(Icons.email_outlined, color: Theme.of(context).primaryColor),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your email';
          }
          if (!value.contains('@') || !value.contains('.')) {
            return 'Please enter a valid email';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildResetButton(BuildContext context) {
    return CustomContainer(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
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
      onTap: () {
        if (!_isDisposed && _formKey.currentState!.validate()) {
          context
              .read<ForgotPasswordBloc>()
              .add(SendResetEmail(_emailController.text));
        }
      },
      child: const Center(
        child: Text(
          "Send Reset Code",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildOTPDescription() {
    return Column(
      children: [
        Text(
          'Enter Verification Code',
          style: TextStyle(
            color: Colors.grey[800],
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'We\'ve sent a 6-digit code to your email',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        Text(
          _emailController.text,
          style: const TextStyle(
            color: Colors.blue,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildOTPFields(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: PinCodeTextField(
        appContext: context,
        length: 6,
        controller: _otpController,
        obscureText: false,
        animationType: AnimationType.fade,
        keyboardType: TextInputType.number,
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(12),
          fieldHeight: 56,
          fieldWidth: 44,
          activeFillColor: Colors.white,
          inactiveFillColor: Colors.white,
          selectedFillColor: Colors.white,
          activeColor: Colors.blue,
          inactiveColor: Colors.grey[300],
          selectedColor: Colors.blue,
        ),
        animationDuration: const Duration(milliseconds: 300),
        enableActiveFill: true,
        errorAnimationController: null,
        onCompleted: (value) {
          if (!_isDisposed) {
            context.read<ForgotPasswordBloc>().add(VerifyOTP(value));
          }
        },
        onChanged: (value) {},
        beforeTextPaste: (text) {
          return true;
        },
        boxShadows: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );
  }

  Widget _buildTimer(ForgotPasswordOTPSent state) {
    return Text(
      'Resend code in ${state.remainingSeconds} seconds',
      style: TextStyle(
        color: Colors.grey[600],
        fontSize: 14,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildVerifyButton(BuildContext context) {
    return CustomContainer(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
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
      borderRadius: 8,
      onTap: () {
        if (!_isDisposed && _otpController.text.length == 6) {
          context.read<ForgotPasswordBloc>().add(VerifyOTP(_otpController.text));
          context.go('/home');
        }
      },
      backgroundColor: Theme.of(context).primaryColor,
      child: const Center(
        child: Text(
          "Verify Code",
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildResendButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        if (!_isDisposed) {
          setState(() {
            _otpController.clear();
          });
          context.read<ForgotPasswordBloc>().add(const ResendOTP());
        }
      },
      child: Text(
        'Resend Code',
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildBackToLoginButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Remember your password? ",
          style: TextStyle(color: Colors.grey[600]),
        ),
        TextButton(
          onPressed: () => context.go('/login'),
          child: Text(
            'Login',
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