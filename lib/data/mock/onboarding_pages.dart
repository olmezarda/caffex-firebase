import 'package:caffex_firebase/data/models/onboarding_page_model.dart';
import 'package:caffex_firebase/core/constants/app_strings.dart';

final List<OnboardingPageModel> onboardingPages = [
  OnboardingPageModel(
    animationAsset: AppStrings.onboarding.animation1,
    title: AppStrings.onboarding.title1,
    subtitle: AppStrings.onboarding.subtitle1,
  ),
  OnboardingPageModel(
    animationAsset: AppStrings.onboarding.animation2,
    title: AppStrings.onboarding.title2,
    subtitle: AppStrings.onboarding.subtitle2,
  ),
  OnboardingPageModel(
    animationAsset: AppStrings.onboarding.animation3,
    title: AppStrings.onboarding.title3,
    subtitle: AppStrings.onboarding.subtitle3,
  ),
];
