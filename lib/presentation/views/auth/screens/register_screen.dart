import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:final_proj/config/routes/app_routes.dart';
import 'package:final_proj/config/theme/app_colors.dart';
import 'package:final_proj/config/theme/app_text_styles.dart';
import 'package:final_proj/core/base/base_view_model.dart';
import 'package:final_proj/presentation/viewmodels/auth_view_model.dart';
import 'package:final_proj/presentation/widgets/auth/auth_widgets.dart';
import 'package:final_proj/presentation/widgets/common/common_widgets.dart';
import 'package:final_proj/utils/helpers/auth_validators.dart';

/// Register screen
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _agreeToTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    if (_formKey.currentState!.validate() && _agreeToTerms) {
      final viewModel = context.read<AuthViewModel>();
      final success = await viewModel.register(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
      );

      if (mounted && success) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.HOME);
      }
    } else if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please agree to Terms and Conditions'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Text(
                  'Create Account',
                  style: AppTextStyles.headlineLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Join us to manage your finances',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 32),

                // Register form
                Consumer<AuthViewModel>(
                  builder: (context, viewModel, _) {
                    return Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Name field
                          AuthTextField(
                            controller: _nameController,
                            labelText: 'Full Name',
                            hintText: 'Enter your full name',
                            prefixIcon: Icons.person_outlined,
                            validator: (value) =>
                                AuthValidators.validateName(value),
                            enabled: viewModel.state != RequestState.loading,
                          ),
                          const SizedBox(height: 16),

                          // Email field
                          AuthTextField(
                            controller: _emailController,
                            labelText: 'Email',
                            hintText: 'Enter your email',
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: Icons.email_outlined,
                            validator: (value) =>
                                AuthValidators.validateEmail(value),
                            enabled: viewModel.state != RequestState.loading,
                          ),
                          const SizedBox(height: 16),

                          // Password field
                          AuthTextField(
                            controller: _passwordController,
                            labelText: 'Password',
                            hintText: 'Create a strong password',
                            obscureText: !_isPasswordVisible,
                            prefixIcon: Icons.lock_outlined,
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                              child: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            validator: (value) =>
                                AuthValidators.validateRegisterPassword(value),
                            enabled: viewModel.state != RequestState.loading,
                            onChanged: (value) {
                              setState(() {});
                            },
                          ),
                          const SizedBox(height: 12),

                          // Password strength indicator
                          if (_passwordController.text.isNotEmpty)
                            PasswordStrengthIndicator(
                              password: _passwordController.text,
                            ),

                          const SizedBox(height: 16),

                          // Confirm password field
                          AuthTextField(
                            controller: _confirmPasswordController,
                            labelText: 'Confirm Password',
                            hintText: 'Re-enter your password',
                            obscureText: !_isConfirmPasswordVisible,
                            prefixIcon: Icons.lock_outlined,
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isConfirmPasswordVisible =
                                      !_isConfirmPasswordVisible;
                                });
                              },
                              child: Icon(
                                _isConfirmPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            validator: (value) => AuthValidators
                                .validateConfirmPassword(
                                    value, _passwordController.text),
                            enabled: viewModel.state != RequestState.loading,
                          ),
                          const SizedBox(height: 24),

                          // Error message
                          if (viewModel.state == RequestState.error)
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.error.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: AppColors.error.withOpacity(0.3),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.error_outline,
                                    color: AppColors.error,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      viewModel.errorMessage ??
                                          'Registration failed. Please try again.',
                                      style: AppTextStyles.bodySmall
                                          .copyWith(color: AppColors.error),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (viewModel.state == RequestState.error)
                            const SizedBox(height: 24),

                          // Terms checkbox
                          Row(
                            children: [
                              Checkbox(
                                value: _agreeToTerms,
                                onChanged: viewModel.state !=
                                        RequestState.loading
                                    ? (value) {
                                        setState(() {
                                          _agreeToTerms = value ?? false;
                                        });
                                      }
                                    : null,
                                activeColor: AppColors.primary,
                              ),
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'I agree to ',
                                        style: AppTextStyles.bodySmall
                                            .copyWith(
                                                color: AppColors.textPrimary),
                                      ),
                                      TextSpan(
                                        text: 'Terms & Conditions',
                                        style: AppTextStyles.bodySmall.copyWith(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Register button
                          CustomButton(
                            label: viewModel.state == RequestState.loading
                                ? 'Creating Account...'
                                : 'Create Account',
                            onPressed: viewModel.state != RequestState.loading
                                ? _handleRegister
                                : null,
                            isLoading: viewModel.state == RequestState.loading,
                          ),
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: 24),

                // Sign in link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: AppTextStyles.bodyMedium
                          .copyWith(color: AppColors.textSecondary),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(AppRoutes.LOGIN);
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                      ),
                      child: Text(
                        'Sign In',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
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
