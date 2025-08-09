import 'package:caffex_firebase/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:caffex_firebase/core/routes/app_routes.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

class RootDeciderScreen extends StatefulWidget {
  const RootDeciderScreen({super.key});

  @override
  State<RootDeciderScreen> createState() => _RootDeciderScreenState();
}

class _RootDeciderScreenState extends State<RootDeciderScreen> {
  @override
  void initState() {
    super.initState();
    _decideNavigation();
  }

  void _decideNavigation() async {
    await Future.delayed(const Duration(seconds: 2));
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Get.offAllNamed(AppRoutes.main);
    } else {
      Get.offAllNamed(AppRoutes.onboarding);
    }

    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: LoadingIndicator()));
  }
}
