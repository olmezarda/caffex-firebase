import 'package:caffex_firebase/core/constants/app_sizes.dart';
import 'package:caffex_firebase/core/theme/app_colors.dart';
import 'package:caffex_firebase/core/theme/app_text_styles.dart';
import 'package:caffex_firebase/data/models/caffe_order_model.dart';
import 'package:flutter/material.dart';

class CartListTile extends StatelessWidget {
  final CaffeOrderModel caffeOrderModel;
  final VoidCallback onConfirm;
  final VoidCallback onRemove;

  const CartListTile({
    super.key,
    required this.caffeOrderModel,
    required this.onConfirm,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.dotLarge),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          vertical: AppSizes.dotSmall,
          horizontal: AppSizes.spacingM,
        ),
        leading: Image.asset(
          caffeOrderModel.imagePath,
          width: 48,
          height: 48,
          fit: BoxFit.contain,
        ),
        title: Text(caffeOrderModel.name, style: AppTextStyles.body),
        subtitle: Text(
          'Quantity: ${caffeOrderModel.quantity}\n'
          '\$${(caffeOrderModel.price * caffeOrderModel.quantity).toStringAsFixed(2)}\n'
          'Address: ${caffeOrderModel.address}',
          style: AppTextStyles.caption,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.cancel, color: AppColors.error),
              onPressed: onRemove,
            ),
          ],
        ),
      ),
    );
  }
}
