import 'package:caffex_firebase/core/constants/app_sizes.dart';
import 'package:caffex_firebase/core/theme/app_colors.dart';
import 'package:caffex_firebase/core/theme/app_text_styles.dart';
import 'package:caffex_firebase/data/services/firestore_service.dart';
import 'package:caffex_firebase/features/auth/widgets/auth_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final TextEditingController _feedbackController = TextEditingController();
  bool _loading = false;

  Future<void> _sendFeedback() async {
    if (_feedbackController.text.trim().isEmpty) {
      AuthSnackbar.showErrorSnackbar('Error', 'Please enter your feedback.');
      return;
    }

    setState(() => _loading = true);

    try {
      await FirestoreService().addFeedback(_feedbackController.text.trim());

      if (!mounted) return;
      AuthSnackbar.showSuccessSnackbar(
        'Thank you!',
        'Your feedback has been sent.',
      );
      _feedbackController.clear();
    } catch (e) {
      if (!mounted) return;
      AuthSnackbar.showSuccessSnackbar('Error', e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_outlined,
            color: AppColors.dark,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingM),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              Text('Feedback', style: AppTextStyles.heading1),
              const SizedBox(height: AppSizes.spacingL),
              TextField(
                controller: _feedbackController,
                maxLines: 5,
                style: AppTextStyles.caption.copyWith(color: AppColors.dark),
                decoration: InputDecoration(
                  labelText: 'Enter your feedback',
                  labelStyle: AppTextStyles.caption.copyWith(
                    color: AppColors.dark,
                  ),
                  border: const OutlineInputBorder(),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.dark, width: 2),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primary, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.spacingL),
              ElevatedButton(
                onPressed: _loading ? null : _sendFeedback,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: EdgeInsets.symmetric(
                    vertical: AppSizes.paddingM,
                    horizontal: AppSizes.paddingXL,
                  ),
                ),
                child: Text(
                  'Send',
                  style: AppTextStyles.button.copyWith(
                    color: AppColors.background,
                  ),
                ),
              ),
              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }
}
