import 'package:caffex_firebase/core/constants/app_sizes.dart';
import 'package:caffex_firebase/core/theme/app_colors.dart';
import 'package:caffex_firebase/core/theme/app_text_styles.dart';
import 'package:caffex_firebase/data/models/caffe_model.dart';
import 'package:caffex_firebase/data/models/cart_item_model.dart';
import 'package:caffex_firebase/data/services/firestore_service.dart';
import 'package:caffex_firebase/features/auth/widgets/auth_snackbar.dart';
import 'package:caffex_firebase/features/cart/widgets/cart_manager.dart';
import 'package:caffex_firebase/features/home/widgets/caffe_show_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CaffeListTile extends StatelessWidget {
  const CaffeListTile({super.key, required this.topSellers});

  final List<CaffeModel> topSellers;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: topSellers.length,
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingM),
        itemBuilder: (context, index) {
          final caffe = topSellers[index];
          return Container(
            margin: const EdgeInsets.only(bottom: AppSizes.spacingM),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                vertical: AppSizes.spacingXS,
                horizontal: AppSizes.paddingS,
              ),
              leading: Image.asset(caffe.imagePath, width: 48, height: 48),
              title: Text(caffe.name, style: AppTextStyles.body),
              subtitle: Text(
                '\$${caffe.price.toStringAsFixed(2)}',
                style: AppTextStyles.caption,
              ),
              trailing: IconButton(
                icon: const Icon(Icons.add_circle, color: AppColors.primary),
                onPressed: () async {
                  final quantity = await CaffeShowDialog.showQuantityDialog(
                    context,
                  );
                  if (quantity != null && quantity > 0) {
                    final uid = FirebaseAuth.instance.currentUser?.uid;
                    if (uid == null) return;

                    final item = CartItem(caffe: caffe, quantity: quantity);

                    await FirestoreService().addItemToCart(uid, item);

                    CartManager().addItem(caffe, quantity: quantity);

                    AuthSnackbar.showSuccessSnackbar(
                      'Success',
                      'Your caffe added to the Cart.',
                    );
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
