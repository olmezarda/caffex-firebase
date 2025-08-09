import 'package:caffex_firebase/core/constants/app_sizes.dart';
import 'package:caffex_firebase/core/theme/app_colors.dart';
import 'package:caffex_firebase/core/theme/app_text_styles.dart';
import 'package:caffex_firebase/data/models/caffe_model.dart';
import 'package:caffex_firebase/data/models/cart_item_model.dart';
import 'package:caffex_firebase/data/services/firestore_service.dart';
import 'package:caffex_firebase/features/auth/widgets/auth_snackbar.dart';
import 'package:caffex_firebase/features/cart/widgets/cart_manager.dart';
import 'package:caffex_firebase/features/home/screens/caffe_detail_screen.dart';
import 'package:caffex_firebase/features/home/widgets/caffe_show_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CaffeCardBuilder extends StatelessWidget {
  final List<CaffeModel> caffes;
  const CaffeCardBuilder({super.key, required this.caffes});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: caffes.length,
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingM),
        itemBuilder: (context, index) {
          final caffe = caffes[index];
          return GestureDetector(
            onTap: () {
              Get.to(() => CaffeDetailScreen(caffe: caffe));
            },
            child: Container(
              width: 130,
              margin: const EdgeInsets.only(right: AppSizes.spacingS),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppSizes.dotLarge),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(250, 250, 250, 1),
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Card(
                color: AppColors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.dotLarge),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppSizes.paddingXS),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Image.asset(
                          caffe.imagePath,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: AppSizes.spacingS),
                      Text(
                        caffe.name,
                        style: AppTextStyles.body,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSizes.spacingS),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(width: 15),
                          Text(
                            '\$${caffe.price.toStringAsFixed(2)}',
                            style: AppTextStyles.caption,
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.add_circle,
                              color: AppColors.primary,
                            ),
                            onPressed: () async {
                              final quantity =
                                  await CaffeShowDialog.showQuantityDialog(
                                    context,
                                  );
                              if (quantity != null && quantity > 0) {
                                final uid =
                                    FirebaseAuth.instance.currentUser?.uid;
                                if (uid == null) return;

                                final item = CartItem(
                                  caffe: caffe,
                                  quantity: quantity,
                                );

                                await FirestoreService().addItemToCart(
                                  uid,
                                  item,
                                );

                                CartManager().addItem(
                                  caffe,
                                  quantity: quantity,
                                );

                                AuthSnackbar.showSuccessSnackbar(
                                  'Success',
                                  'Your caffe added to the Cart.',
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
