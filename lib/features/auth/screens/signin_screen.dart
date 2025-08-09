import 'package:caffex_firebase/core/constants/app_sizes.dart';
import 'package:caffex_firebase/core/routes/app_routes.dart';
import 'package:caffex_firebase/core/theme/app_colors.dart';
import 'package:caffex_firebase/data/services/auth_service.dart';
import 'package:caffex_firebase/data/services/firestore_service.dart';
import 'package:caffex_firebase/features/auth/widgets/auth_snackbar.dart';
import 'package:caffex_firebase/features/auth/widgets/reusable_auth_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordFocusNode = FocusNode();
  final firestoreService = FirestoreService();

  bool obscurePassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> onSubmit() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      AuthSnackbar.showErrorSnackbar(
        'Missing Fields',
        'Please fill out all the fields.',
      );
      return;
    }

    try {
      await AuthService.signInWithEmail(email, password);

      final user = FirebaseAuth.instance.currentUser;

      final profile = await firestoreService.getUserProfile(user!.uid);

      if (profile != null) {
        Get.offAllNamed(AppRoutes.main);
      } else {
        Get.offAllNamed(
          AppRoutes.form,
          arguments: {'showIncompleteProfileWarning': true},
        );
      }
    } catch (e) {
      AuthSnackbar.showErrorSnackbar(
        'Error',
        'Failed to sign in. Please check your credentials.',
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
              title: 'Sign In',
              subtitle: 'Explore your Caffe With',
              actionButtonText: 'Sign In',
              redirectText: "Don't have an account?  ",
              redirectLabel: 'Sign Up',
              onRedirect: () => Get.toNamed(AppRoutes.signup),
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
              onForgotPassword: () => Get.toNamed(AppRoutes.forgotPassword),
            ),
          ),
        ),
      ),
    );
  }
}
