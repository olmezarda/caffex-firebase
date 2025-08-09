import 'package:caffex_firebase/core/constants/app_sizes.dart';
import 'package:caffex_firebase/core/routes/app_routes.dart';
import 'package:caffex_firebase/core/theme/app_colors.dart';
import 'package:caffex_firebase/data/services/auth_service.dart';
import 'package:caffex_firebase/features/auth/widgets/reusable_auth_form.dart';
import 'package:caffex_firebase/features/auth/widgets/auth_snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordFocusNode = FocusNode();
  bool obscurePassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void onSubmit() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isNotEmpty && password.isNotEmpty) {
      try {
        await AuthService.signUpWithEmail(email, password);
        Get.toNamed(AppRoutes.form);
      } on FirebaseAuthException catch (e) {
        AuthSnackbar.showErrorSnackbar('Error', e.message ?? e.toString());
      }
    } else {
      AuthSnackbar.showErrorSnackbar(
        'Missing Fields',
        'Please fill out all the fields.',
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
              title: 'Sign Up',
              subtitle: 'Create your account\nto continue',
              actionButtonText: 'Sign Up',
              redirectText: "Already have an account?  ",
              redirectLabel: 'Sign In',
              onRedirect: () => Get.toNamed(AppRoutes.signin),
              onActionButton: onSubmit,
              onTogglePasswordVisibility: () {
                setState(() {
                  obscurePassword = !obscurePassword;
                });
              },
              emailController: emailController,
              passwordController: passwordController,
              passwordFocusNode: passwordFocusNode,
              obscurePassword: obscurePassword,
            ),
          ),
        ),
      ),
    );
  }
}
