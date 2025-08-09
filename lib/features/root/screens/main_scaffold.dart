import 'package:caffex_firebase/core/routes/app_routes.dart';
import 'package:caffex_firebase/widgets/bottom_nav_bar.dart';
import 'package:caffex_firebase/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:caffex_firebase/data/services/firestore_service.dart';
import 'package:caffex_firebase/features/home/screens/home_screen.dart';
import 'package:caffex_firebase/features/cart/screens/cart_screen.dart';
import 'package:caffex_firebase/features/order/screens/order_screen.dart';
import 'package:caffex_firebase/features/profile/screens/profile_screen.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;
  final _firestoreService = FirestoreService();
  bool _loading = true;
  bool _isMounted = true;

  @override
  void initState() {
    super.initState();
    _checkUserAndProfile();

    final args = Get.arguments;
    if (args != null && args['tabIndex'] is int) {
      _currentIndex = args['tabIndex'];
    }
  }

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  Future<void> _checkUserAndProfile() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      if (_isMounted) Get.offAllNamed(AppRoutes.onboarding);
      return;
    }

    final profile = await _firestoreService.getUserProfile(user.uid);

    if (!_isMounted) return;

    if (profile == null) {
      Get.offAllNamed(
        AppRoutes.form,
        arguments: {'showIncompleteProfileWarning': true},
      );
      return;
    }

    setState(() {
      _loading = false;
    });
  }

  Widget _buildScreen() {
    switch (_currentIndex) {
      case 0:
        return const HomeScreen();
      case 1:
        return const CartScreen();
      case 2:
        return const OrderScreen();
      case 3:
        return const ProfileScreen();
      default:
        return const SizedBox.shrink();
    }
  }

  void _onItemTapped(int index) {
    if (index == _currentIndex) return;
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: LoadingIndicator()));
    }

    return Scaffold(
      body: _buildScreen(),
      bottomNavigationBar: MyBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
