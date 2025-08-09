import 'package:caffex_firebase/core/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:caffex_firebase/core/theme/app_colors.dart';
import 'package:caffex_firebase/core/theme/app_text_styles.dart';

class CartTotalSection extends StatelessWidget {
  final double totalPrice;
  final VoidCallback onConfirm;

  const CartTotalSection({
    super.key,
    required this.totalPrice,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppSizes.dotLarge,
        horizontal: AppSizes.spacingL,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Total: \$${totalPrice.toStringAsFixed(2)}',
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
            onPressed: onConfirm,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.spacingL,
                vertical: AppSizes.dotLarge,
              ),
            ),
            child: Text(
              'Pay',
              style: AppTextStyles.button.copyWith(color: AppColors.background),
            ),
          ),
        ],
      ),
    );
  }
}
