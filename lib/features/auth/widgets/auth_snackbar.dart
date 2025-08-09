import 'package:caffex_firebase/core/theme/app_colors.dart';
import 'package:caffex_firebase/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthSnackbar {
  static void showErrorSnackbar(String title, String message) {
    Get.snackbar(
      '',
      '',
      backgroundColor: AppColors.error,
      snackPosition: SnackPosition.TOP,
      titleText: Text(
        title,
        style: AppTextStyles.button.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.background,
        ),
      ),
      messageText: Text(
        message,
        style: AppTextStyles.caption.copyWith(
          fontWeight: FontWeight.w500,
          color: AppColors.background,
        ),
      ),
    );
  }

  static void showSuccessSnackbar(String title, String message) {
    Get.snackbar(
      '',
      '',
      backgroundColor: AppColors.success,
      snackPosition: SnackPosition.TOP,
      titleText: Text(
        title,
        style: AppTextStyles.button.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.background,
        ),
      ),
      messageText: Text(
        message,
        style: AppTextStyles.caption.copyWith(
          fontWeight: FontWeight.w500,
          color: AppColors.background,
        ),
      ),
    );
  }
}
