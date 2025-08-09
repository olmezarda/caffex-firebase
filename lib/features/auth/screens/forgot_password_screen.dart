import 'package:caffex_firebase/data/services/auth_service.dart';
import 'package:caffex_firebase/features/auth/widgets/auth_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:caffex_firebase/core/constants/app_sizes.dart';
import 'package:caffex_firebase/core/theme/app_colors.dart';
import 'package:caffex_firebase/features/auth/widgets/reusable_auth_form.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  void _sendResetLink() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      AuthSnackbar.showErrorSnackbar('Error', 'Please enter your email.');
      return;
    }

    try {
      await AuthService.sendPasswordResetEmail(email);

      AuthSnackbar.showSuccessSnackbar(
        'Success',
        'Password reset link sent to $email',
      );
    } on FirebaseAuthException catch (e) {
      AuthSnackbar.showErrorSnackbar(
        'Reset Failed',
        e.message ?? 'An error occurred.',
      );
    } catch (e) {
      AuthSnackbar.showErrorSnackbar(
        'Unexpected Error',
        'Something went wrong. Please try again later.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingL),
        child: Center(
          child: SingleChildScrollView(
            child: ReusableAuthForm(
              title: 'Reset Password',
              subtitle: 'Enter your email\nto reset your password',
              actionButtonText: 'Send Reset Link',
              redirectText: "Remember your password? ",
              redirectLabel: 'Sign In',
              onRedirect: () => Get.toNamed('/signin'),
              onActionButton: _sendResetLink,
              onTogglePasswordVisibility: () {},
              emailController: emailController,
              passwordController: TextEditingController(),
              passwordFocusNode: FocusNode(),
              obscurePassword: false,
              showPasswordField: false,
            ),
          ),
        ),
      ),
    );
  }
}
