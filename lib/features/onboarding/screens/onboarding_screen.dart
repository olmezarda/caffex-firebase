import 'package:caffex_firebase/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import 'package:caffex_firebase/core/constants/app_sizes.dart';
import 'package:caffex_firebase/core/theme/app_text_styles.dart';
import 'package:caffex_firebase/core/theme/app_colors.dart';
import 'package:caffex_firebase/data/mock/onboarding_pages.dart';
import 'package:caffex_firebase/features/onboarding/widgets/onboarding_controller.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingController());

    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: controller.pageController,
            itemCount: onboardingPages.length,
            onPageChanged: controller.updatePageIndicator,
            itemBuilder: (context, index) {
              final page = onboardingPages[index];
              return Padding(
                padding: const EdgeInsets.all(AppSizes.paddingL),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      page.animationAsset,
                      height: AppSizes.onboardingLottieHeight,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: AppSizes.spacingL),
                    Text(
                      page.title,
                      style: AppTextStyles.heading1,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSizes.spacingM),
                    Text(
                      page.subtitle,
                      style: AppTextStyles.caption,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),

          Positioned(
            top: AppSizes.topSkipButton,
            right: AppSizes.rightSkipButton,
            child: TextButton(
              onPressed: controller.skipPage,
              child: Text("Skip", style: AppTextStyles.button),
            ),
          ),

          Positioned(
            bottom: AppSizes.bottomDotIndicator + 80,
            left: 0,
            right: 0,
            child: Obx(() {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(onboardingPages.length, (index) {
                  final isActive = controller.currentPageIndex.value == index;
                  return GestureDetector(
                    onTap: () => controller.dotNavigationClick(index),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: isActive ? AppSizes.dotLarge : AppSizes.dotSmall,
                      height: isActive ? AppSizes.dotLarge : AppSizes.dotSmall,
                      decoration: BoxDecoration(
                        color: isActive ? AppColors.primary : AppColors.light,
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                }),
              );
            }),
          ),

          Obx(() {
            final isLastPage =
                controller.currentPageIndex.value == onboardingPages.length - 1;

            return isLastPage
                ? Positioned(
                    bottom: AppSizes.bottomDotIndicator,
                    left: AppSizes.paddingL,
                    right: AppSizes.paddingL,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSizes.spacingM,
                        ),
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppSizes.spacingS,
                          ),
                        ),
                      ),
                      onPressed: () {
                        Get.toNamed(AppRoutes.signup);
                      },
                      child: Text(
                        "Get Started",
                        style: AppTextStyles.button.copyWith(
                          color: AppColors.background,
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}
