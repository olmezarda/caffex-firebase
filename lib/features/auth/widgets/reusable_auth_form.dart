import 'package:flutter/material.dart';
import 'package:caffex_firebase/core/constants/app_sizes.dart';
import 'package:caffex_firebase/core/theme/app_colors.dart';
import 'package:caffex_firebase/core/theme/app_text_styles.dart';

class ReusableAuthForm extends StatelessWidget {
  final String title;
  final String subtitle;
  final String actionButtonText;
  final String redirectText;
  final String redirectLabel;
  final VoidCallback onActionButton;
  final VoidCallback onRedirect;
  final VoidCallback onTogglePasswordVisibility;
  final VoidCallback? onForgotPassword;

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final FocusNode passwordFocusNode;
  final bool obscurePassword;
  final bool showPasswordField;

  const ReusableAuthForm({
    super.key,
    required this.title,
    required this.subtitle,
    required this.actionButtonText,
    required this.redirectText,
    required this.redirectLabel,
    required this.onActionButton,
    required this.onRedirect,
    required this.onTogglePasswordVisibility,
    this.onForgotPassword,
    required this.emailController,
    required this.passwordController,
    required this.passwordFocusNode,
    required this.obscurePassword,
    this.showPasswordField = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.heading1),
                const SizedBox(height: AppSizes.spacingXS),
                Text(subtitle, style: AppTextStyles.caption),
              ],
            ),
            Container(
              width: 155,
              height: 155,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/icons/app_icon_cutted.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.spacingL),
        TextField(
          controller: emailController,
          onSubmitted: (_) {
            if (showPasswordField) {
              FocusScope.of(context).requestFocus(passwordFocusNode);
            }
          },
          style: AppTextStyles.caption.copyWith(color: AppColors.dark),
          decoration: InputDecoration(
            labelText: 'Email',
            labelStyle: AppTextStyles.caption.copyWith(color: AppColors.dark),
            border: const OutlineInputBorder(),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.dark, width: 2),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        if (showPasswordField) ...[
          const SizedBox(height: AppSizes.spacingM),
          TextField(
            controller: passwordController,
            focusNode: passwordFocusNode,
            obscureText: obscurePassword,
            style: AppTextStyles.caption.copyWith(color: AppColors.dark),
            decoration: InputDecoration(
              labelText: 'Password',
              labelStyle: AppTextStyles.caption.copyWith(color: AppColors.dark),
              border: const OutlineInputBorder(),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.dark, width: 2),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.primary, width: 2),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.dark,
                ),
                onPressed: onTogglePasswordVisibility,
              ),
            ),
          ),
        ],
        const SizedBox(height: AppSizes.spacingL),
        ElevatedButton(
          onPressed: onActionButton,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(vertical: AppSizes.paddingM),
          ),
          child: Text(
            actionButtonText,
            style: AppTextStyles.button.copyWith(color: AppColors.background),
          ),
        ),
        const SizedBox(height: AppSizes.spacingL),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              redirectText,
              style: AppTextStyles.caption.copyWith(color: AppColors.dark),
            ),
            GestureDetector(
              onTap: onRedirect,
              child: Text(
                redirectLabel,
                style: AppTextStyles.button.copyWith(fontSize: 14),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.spacingS),
        if (onForgotPassword != null)
          Padding(
            padding: const EdgeInsets.only(top: AppSizes.spacingXS),
            child: Align(
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: onForgotPassword,
                child: Text(
                  'Forgot Password?',
                  style: AppTextStyles.button.copyWith(fontSize: 14),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
