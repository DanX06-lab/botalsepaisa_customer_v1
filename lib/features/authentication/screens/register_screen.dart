import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:botalsepaisa_customer_v1/core/constants/app_colors.dart';
import '../../../core/constants/design_system.dart';

import 'package:botalsepaisa_customer_v1/shared/widgets/primary_button.dart';
import 'package:botalsepaisa_customer_v1/shared/widgets/custom_text_field.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onRegister() {
    if (_formKey.currentState!.validate()) {
      ref.read(authControllerProvider.notifier).register(
            _nameController.text,
            _mobileController.text,
            _emailController.text,
            _passwordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    ref.listen(authControllerProvider, (previous, next) {
      if (!next.isLoading && next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error.toString()),
            backgroundColor: AppColors.error,
          ),
        );
      } else if (!next.isLoading && next.value != null && previous?.isLoading == true) {
        // Registration success, navigate to login or home depending on flow
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration successful! Please login.'),
            backgroundColor: AppColors.success,
          ),
        );
        context.go('/login');
      }
    });

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
                  'Create Account',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: AppSpacing.sm),
                Text(
                  'Sign up to get started',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: AppSpacing.xl),
                CustomTextField(
                  controller: _nameController,
                  hintText: 'Enter your full name',
                  prefixIcon: Icon(Icons.person_outline),
                  validator: (value) => value == null || value.isEmpty ? 'Please enter your name' : null,
                ),
                SizedBox(height: AppSpacing.md),
                CustomTextField(
                  controller: _mobileController,
                  hintText: 'Enter your mobile number',
                  prefixIcon: Icon(Icons.phone_android),
                  keyboardType: TextInputType.phone,
                  validator: (value) => value == null || value.isEmpty ? 'Please enter mobile number' : null,
                ),
                SizedBox(height: AppSpacing.md),
                CustomTextField(
                  controller: _emailController,
                  hintText: 'Enter your email (optional)',
                  prefixIcon: Icon(Icons.email_outlined),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: AppSpacing.md),
                CustomTextField(
                  controller: _passwordController,
                  hintText: 'Enter your password',
                  prefixIcon: Icon(Icons.lock_outline),
                  obscureText: true,
                  validator: (value) => value == null || value.isEmpty ? 'Please enter a password' : null,
                ),
                SizedBox(height: AppSpacing.md),
                CustomTextField(
                  controller: _confirmPasswordController,
                  hintText: 'Confirm your password',
                  prefixIcon: Icon(Icons.lock_outline),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please confirm your password';
                    if (value != _passwordController.text) return 'Passwords do not match';
                    return null;
                  },
                ),
                SizedBox(height: AppSpacing.xxl),
                PrimaryButton(
                  text: 'Register',
                  isLoading: authState.isLoading,
                  onPressed: _onRegister,
                ),
                SizedBox(height: AppSpacing.xl),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                    TextButton(
                      onPressed: () => context.go('/login'),
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
