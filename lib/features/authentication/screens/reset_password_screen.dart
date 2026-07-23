import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:botalsepaisa_customer_v1/core/constants/app_colors.dart';
import '../../../core/constants/design_system.dart';
import 'package:botalsepaisa_customer_v1/shared/widgets/primary_button.dart';
import 'package:botalsepaisa_customer_v1/shared/widgets/custom_text_field.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onResetPassword() {
    if (_formKey.currentState!.validate()) {
      context.push('/reset-success');
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
                  'Reset Password',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: AppSpacing.sm),
                Text(
                  'Enter your new password below.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: AppSpacing.xl),
                CustomTextField(
                  controller: _newPasswordController,
                  hintText: 'Enter new password',
                  prefixIcon: Icon(Icons.lock_outline),
                  obscureText: true,
                  validator: (value) => value == null || value.isEmpty ? 'Please enter a new password' : null,
                ),
                SizedBox(height: AppSpacing.md),
                CustomTextField(
                  controller: _confirmPasswordController,
                  hintText: 'Confirm new password',
                  prefixIcon: Icon(Icons.lock_outline),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please confirm your password';
                    if (value != _newPasswordController.text) return 'Passwords do not match';
                    return null;
                  },
                ),
                SizedBox(height: AppSpacing.xxl),
                PrimaryButton(
                  text: 'Reset Password',
                  onPressed: _onResetPassword,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
