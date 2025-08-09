import 'package:caffex_firebase/core/theme/app_colors.dart';
import 'package:caffex_firebase/core/theme/app_text_styles.dart';
import 'package:caffex_firebase/data/models/caffe_order_model.dart';
import 'package:caffex_firebase/features/auth/widgets/auth_snackbar.dart';
import 'package:caffex_firebase/features/cart/widgets/cart_list_tile.dart';
import 'package:caffex_firebase/data/services/firestore_service.dart';
import 'package:caffex_firebase/widgets/app_bar.dart';
import 'package:caffex_firebase/widgets/loading_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:caffex_firebase/features/cart/widgets/cart_total_section.dart';
import 'package:caffex_firebase/core/constants/app_sizes.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<CaffeOrderModel> cartItems = [];
  Map<String, dynamic>? _profileData;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  double get totalPrice {
    double total = 0;
    for (final item in cartItems) {
      total += item.price * item.quantity;
    }
    return total;
  }

  Future<void> _onPayPressed() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      AuthSnackbar.showErrorSnackbar('Error', 'User not found.');
      return;
    }

    try {
      for (final orderItem in cartItems) {
        await FirestoreService().addOrder(uid: uid, order: orderItem);
      }

      await FirestoreService().clearUserCart(uid);

      setState(() {
        cartItems.clear();
      });

      AuthSnackbar.showSuccessSnackbar('Success', 'Your order is on the way.');
    } catch (e) {
      AuthSnackbar.showErrorSnackbar('Error', e.toString());
    }
  }

  Future<void> _loadData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final profile = await FirestoreService().getUserProfile(uid);
    final cart = await FirestoreService().getUserCart(uid);

    final convertedCart = cart.map((cartItem) {
      return CaffeOrderModel(
        id: cartItem.caffe.id,
        name: cartItem.caffe.name,
        price: cartItem.caffe.price,
        imagePath: cartItem.caffe.imagePath,
        quantity: cartItem.quantity,
        address: profile?['address'] ?? '',
      );
    }).toList();

    if (mounted) {
      setState(() {
        _profileData = profile;
        cartItems = convertedCart;
        _loading = false;
      });
    }
  }

  void _addToOrder(CaffeOrderModel orderItem) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    await FirestoreService().addOrder(uid: uid, order: orderItem);

    final updatedCart = await FirestoreService().getUserCart(uid);
    final profile = await FirestoreService().getUserProfile(uid);

    final convertedCart = updatedCart.map((cartItem) {
      return CaffeOrderModel(
        id: cartItem.caffe.id,
        name: cartItem.caffe.name,
        price: cartItem.caffe.price,
        imagePath: cartItem.caffe.imagePath,
        quantity: cartItem.quantity,
        address: profile?['address'] ?? '',
      );
    }).toList();

    await FirestoreService().removeItemFromCart(uid, orderItem.id);

    if (mounted) {
      setState(() {
        cartItems = convertedCart;
        _profileData = profile;
      });
    }

    AuthSnackbar.showSuccessSnackbar(
      'Added to Order',
      '${orderItem.name} is on your order screen.',
    );
  }

  void _removeFromCart(CaffeOrderModel orderItem) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    await FirestoreService().removeItemFromCart(uid, orderItem.id);

    final updatedCart = await FirestoreService().getUserCart(uid);
    final profile = await FirestoreService().getUserProfile(uid);

    final convertedCart = updatedCart.map((cartItem) {
      return CaffeOrderModel(
        id: cartItem.caffe.id,
        name: cartItem.caffe.name,
        price: cartItem.caffe.price,
        imagePath: cartItem.caffe.imagePath,
        quantity: cartItem.quantity,
        address: profile?['address'] ?? '',
      );
    }).toList();

    if (mounted) {
      setState(() {
        cartItems = convertedCart;
        _profileData = profile;
      });
    }

    AuthSnackbar.showErrorSnackbar(
      'Deleted From Cart',
      '${orderItem.name} deleted from cart',
    );
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
            const SizedBox(height: AppSizes.spacingM),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.spacingM,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('My Carts', style: AppTextStyles.heading1),
              ),
            ),
            const SizedBox(height: AppSizes.spacingM),
            Expanded(
              child: cartItems.isEmpty
                  ? SizedBox(
                      width: 400,
                      height: 400,
                      child: Center(
                        child: Column(
                          children: [
                            Lottie.asset('assets/animations/empty_cart.json'),
                            Text(
                              'Let\'s explore your caffe journey with CaffeX!',
                              style: AppTextStyles.body,
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(AppSizes.spacingM),
                      itemCount: cartItems.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: AppSizes.spacingM),
                      itemBuilder: (context, index) {
                        final orderItem = cartItems[index];
                        return CartListTile(
                          caffeOrderModel: orderItem,
                          onConfirm: () => _addToOrder(orderItem),
                          onRemove: () => _removeFromCart(orderItem),
                        );
                      },
                    ),
            ),
            if (cartItems.isNotEmpty)
              CartTotalSection(
                totalPrice: totalPrice,
                onConfirm: _onPayPressed,
              ),
          ],
        ),
      ),
    );
  }
}
