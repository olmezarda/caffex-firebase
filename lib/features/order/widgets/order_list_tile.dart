import 'package:caffex_firebase/core/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:caffex_firebase/core/theme/app_colors.dart';
import 'package:caffex_firebase/core/theme/app_text_styles.dart';
import 'package:caffex_firebase/data/models/caffe_order_model.dart';

class OrderListTile extends StatelessWidget {
  final CaffeOrderModel orderItem;

  const OrderListTile({super.key, required this.orderItem});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.dotLarge),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(AppSizes.dotLarge),
        leading: Image.asset(
          orderItem.imagePath,
          width: 48,
          height: 48,
          fit: BoxFit.cover,
        ),
        title: Text(orderItem.name, style: AppTextStyles.body),
        subtitle: Text(
          'Quantity: ${orderItem.quantity}\n'
          '\$${(orderItem.price * orderItem.quantity).toStringAsFixed(2)}\n'
          'Address: ${orderItem.address}',
          style: AppTextStyles.caption,
        ),
        trailing: Text('On the way', style: AppTextStyles.button),
      ),
    );
  }
}
