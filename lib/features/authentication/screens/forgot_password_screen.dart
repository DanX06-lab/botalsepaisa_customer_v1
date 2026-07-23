import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:botalsepaisa_customer_v1/core/constants/app_colors.dart';
import '../../../core/constants/design_system.dart';
import 'package:botalsepaisa_customer_v1/shared/widgets/primary_button.dart';
import 'package:botalsepaisa_customer_v1/shared/widgets/custom_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _contactController = TextEditingController();

  @override
  void dispose() {
    _contactController.dispose();
    super.dispose();
  }

  void _onSendOtp() {
    if (_formKey.currentState!.validate()) {
      context.push('/otp-verification');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Forgot Password',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: AppSpacing.sm),
                Text(
                  'Enter your registered mobile number or email to receive an OTP.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: AppSpacing.xl),
                CustomTextField(
                  controller: _contactController,
                  hintText: 'Enter mobile or email',
                  prefixIcon: Icon(Icons.phone_android),
                  validator: (value) => value == null || value.isEmpty ? 'Please enter mobile or email' : null,
                ),
                SizedBox(height: AppSpacing.xxl),
                PrimaryButton(
                  text: 'Send OTP',
                  onPressed: _onSendOtp,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
