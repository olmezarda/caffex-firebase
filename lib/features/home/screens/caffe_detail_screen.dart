import 'package:caffex_firebase/data/models/cart_item_model.dart';
import 'package:caffex_firebase/data/services/firestore_service.dart';
import 'package:caffex_firebase/features/auth/widgets/auth_snackbar.dart';
import 'package:caffex_firebase/features/cart/widgets/cart_manager.dart';
import 'package:caffex_firebase/features/home/widgets/caffe_show_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:caffex_firebase/core/theme/app_colors.dart';
import 'package:caffex_firebase/core/theme/app_text_styles.dart';
import 'package:caffex_firebase/core/constants/app_sizes.dart';
import 'package:caffex_firebase/data/models/caffe_model.dart';
import 'package:get/get.dart';

class CaffeDetailScreen extends StatelessWidget {
  final CaffeModel caffe;
  const CaffeDetailScreen({super.key, required this.caffe});

  @override
  Widget build(BuildContext context) {
    final descriptionLines = caffe.description
        .trim()
        .split('\n')
        .where((line) => line.isNotEmpty)
        .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.dark),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            top: AppSizes.paddingXL,
            right: AppSizes.paddingL,
            left: AppSizes.paddingL,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 250,
                child: Image.asset(caffe.imagePath, fit: BoxFit.contain),
              ),
              const SizedBox(height: AppSizes.spacingXL),
              Text(caffe.name, style: AppTextStyles.heading1),
              const SizedBox(height: AppSizes.spacingXL),
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: descriptionLines
                      .map(
                        (line) => Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSizes.dotLarge,
                          ),
                          child: Text(
                            '• ${line.trim()}',
                            style: AppTextStyles.body,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: AppSizes.spacingXL),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppSizes.dotLarge),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppSizes.paddingM),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${caffe.price.toStringAsFixed(2)}',
                        style: AppTextStyles.caption.copyWith(fontSize: 24),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.add_circle,
                          size: 32,
                          color: AppColors.primary,
                        ),
                        onPressed: () async {
                          final quantity =
                              await CaffeShowDialog.showQuantityDialog(context);
                          if (quantity != null && quantity > 0) {
                            final uid = FirebaseAuth.instance.currentUser?.uid;
                            if (uid == null) return;

                            final item = CartItem(
                              caffe: caffe,
                              quantity: quantity,
                            );

                            await FirestoreService().addItemToCart(uid, item);

                            CartManager().addItem(caffe, quantity: quantity);

                            AuthSnackbar.showSuccessSnackbar(
                              'Success',
                              'Your caffe added to the Cart.',
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
