import 'package:caffex_firebase/core/constants/app_sizes.dart';
import 'package:caffex_firebase/core/theme/app_colors.dart';
import 'package:caffex_firebase/core/theme/app_text_styles.dart';
import 'package:caffex_firebase/data/models/caffe_order_model.dart';
import 'package:caffex_firebase/data/services/firestore_service.dart';
import 'package:caffex_firebase/features/order/widgets/order_list_tile.dart';
import 'package:caffex_firebase/widgets/app_bar.dart';
import 'package:caffex_firebase/widgets/loading_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  Map<String, dynamic>? _profileData;
  bool _loading = true;
  List<CaffeOrderModel> orders = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final profile = await FirestoreService().getUserProfile(uid);
    final userOrders = await FirestoreService().getUserOrders(uid);

    if (mounted) {
      setState(() {
        _profileData = profile;
        orders = userOrders;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading || _profileData == null) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: LoadingIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              name: _profileData!['name'],
              surname: _profileData!['surname'],
              gender: _profileData!['gender'],
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.paddingM,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('My Orders', style: AppTextStyles.heading1),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: orders.isEmpty
                  ? SizedBox(
                      width: 400,
                      height: 400,
                      child: Center(
                        child: Column(
                          children: [
                            Lottie.asset('assets/animations/empty_cart.json'),
                            Text(
                              'Your orders will show up here!',
                              style: AppTextStyles.body,
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(AppSizes.paddingM),
                      itemCount: orders.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: AppSizes.dotLarge),
                      itemBuilder: (context, index) {
                        return OrderListTile(orderItem: orders[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
