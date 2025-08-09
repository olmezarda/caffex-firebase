import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {
  static OnboardingController get instance => Get.find();

  final pageController = PageController();
  RxInt currentPageIndex = 0.obs;

  void updatePageIndicator(int index) {
    currentPageIndex.value = index;
  }

  void dotNavigationClick(int index) {
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  void nextPage() {
    final nextIndex = currentPageIndex.value + 1;
    if (nextIndex < 3) {
      dotNavigationClick(nextIndex);
    }
  }

  void skipPage() {
    pageController.animateToPage(
      2,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }
}
