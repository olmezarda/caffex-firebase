import 'package:caffex_firebase/features/auth/screens/forgot_password_screen.dart';
import 'package:caffex_firebase/features/auth/screens/form_screen.dart';
import 'package:caffex_firebase/features/auth/screens/signup_screen.dart';
import 'package:caffex_firebase/features/auth/screens/signin_screen.dart';
import 'package:caffex_firebase/features/cart/screens/cart_screen.dart';
import 'package:caffex_firebase/features/home/screens/home_screen.dart';
import 'package:caffex_firebase/features/order/screens/order_screen.dart';
import 'package:caffex_firebase/features/profile/screens/address_update_screen.dart';
import 'package:caffex_firebase/features/profile/screens/feedback_screen.dart';
import 'package:caffex_firebase/features/root/screens/main_scaffold.dart';
import 'package:caffex_firebase/features/root/screens/root_decider_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/theme/app_theme.dart';
import 'features/onboarding/screens/onboarding_screen.dart';
import 'core/routes/app_routes.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.rootDecider,
      getPages: [
        GetPage(
          name: AppRoutes.onboarding,
          page: () => const OnboardingScreen(),
        ),
        GetPage(
          name: AppRoutes.forgotPassword,
          page: () => const ForgotPasswordScreen(),
        ),
        GetPage(name: AppRoutes.signin, page: () => const SignInScreen()),
        GetPage(name: AppRoutes.signup, page: () => const SignUpScreen()),
        GetPage(name: AppRoutes.form, page: () => const FormScreen()),
        GetPage(name: AppRoutes.home, page: () => HomeScreen()),
        GetPage(name: AppRoutes.orders, page: () => const OrderScreen()),
        GetPage(name: AppRoutes.cart, page: () => const CartScreen()),
        GetPage(
          name: AppRoutes.addressUpdate,
          page: () => const AddressUpdateScreen(),
        ),
        GetPage(name: AppRoutes.feedback, page: () => const FeedbackScreen()),
        GetPage(name: AppRoutes.main, page: () => const MainScaffold()),
        GetPage(
          name: AppRoutes.rootDecider,
          page: () => const RootDeciderScreen(),
        ),
      ],
    );
  }
}
