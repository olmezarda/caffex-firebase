import 'package:caffex_firebase/core/routes/app_routes.dart';
import 'package:caffex_firebase/data/models/setting_item_model.dart';
import 'package:caffex_firebase/data/services/auth_service.dart';
import 'package:caffex_firebase/features/auth/widgets/auth_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthSettingsHelper {
  static List<SettingItemModel> buildSettings({
    required BuildContext context,
    required VoidCallback onDeleteConfirmed,
  }) {
    return [
      SettingItemModel(
        icon: Icons.location_on,
        title: 'Update Address',
        onTap: () => Get.toNamed('/address-update'),
      ),
      SettingItemModel(
        icon: Icons.lock,
        title: 'Reset Password',
        onTap: () async {
          final user = AuthService.currentUser;
          if (user != null && user.email != null) {
            try {
              await AuthService.sendPasswordResetEmail(user.email!);
              if (context.mounted) {
                AuthSnackbar.showSuccessSnackbar(
                  'Success',
                  'Password reset link sent to ${user.email}',
                );
              }
            } catch (e) {
              if (context.mounted) {
                AuthSnackbar.showSuccessSnackbar('Error:', e.toString());
              }
            }
          }
        },
      ),
      SettingItemModel(
        icon: Icons.delete,
        title: 'Delete Account',
        onTap: () => onDeleteConfirmed(),
      ),
      SettingItemModel(
        icon: Icons.shopping_bag,
        title: 'My Orders',
        onTap: () =>
            Get.offAllNamed(AppRoutes.main, arguments: {'tabIndex': 2}),
      ),
      SettingItemModel(
        icon: Icons.shopping_cart,
        title: 'My Carts',
        onTap: () =>
            Get.offAllNamed(AppRoutes.main, arguments: {'tabIndex': 1}),
      ),
      SettingItemModel(
        icon: Icons.feedback,
        title: 'Send Feedback',
        onTap: () => Get.toNamed(AppRoutes.feedback),
      ),
      SettingItemModel(
        icon: Icons.logout,
        title: 'Sign Out',
        onTap: () async {
          try {
            await AuthService.signOut();
            if (context.mounted) {
              AuthSnackbar.showSuccessSnackbar(
                'Signed Out',
                'You have been signed out.',
              );
              Get.offAllNamed('/signin');
            }
          } catch (e) {
            if (context.mounted) {
              AuthSnackbar.showSuccessSnackbar('Error', e.toString());
            }
          }
        },
      ),
    ];
  }

  static Future<String?> askForPassword(BuildContext context) async {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Please enter your password'),
        content: TextField(
          controller: controller,
          obscureText: true,
          decoration: InputDecoration(hintText: 'Password'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(null),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: Text('Confirm'),
          ),
        ],
      ),
    );
  }
}
