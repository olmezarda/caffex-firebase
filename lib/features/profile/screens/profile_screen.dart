import 'package:caffex_firebase/core/constants/app_sizes.dart';
import 'package:caffex_firebase/core/theme/app_colors.dart';
import 'package:caffex_firebase/core/theme/app_text_styles.dart';
import 'package:caffex_firebase/data/models/setting_item_model.dart';
import 'package:caffex_firebase/data/services/auth_service.dart';
import 'package:caffex_firebase/data/services/firestore_service.dart';
import 'package:caffex_firebase/features/auth/widgets/auth_snackbar.dart';
import 'package:caffex_firebase/features/profile/widgets/profile_settings_helper.dart';
import 'package:caffex_firebase/widgets/app_bar.dart';
import 'package:caffex_firebase/widgets/loading_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? _profileData;
  bool _loading = true;
  List<SettingItemModel> settings = [];

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    final profile = await FirestoreService().getUserProfile(uid);
    if (mounted) {
      setState(() {
        _profileData = profile;
        _loading = false;
        _setupSettings();
      });
    }
  }

  Future<void> _handleDeleteAccount() async {
    final user = AuthService.currentUser;
    if (user == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    final password = await AuthSettingsHelper.askForPassword(context);
    if (password == null || !mounted) return;

    try {
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );
      await user.reauthenticateWithCredential(credential);
      await user.delete();
      if (!mounted) return;
      AuthSnackbar.showSuccessSnackbar(
        'Account Deleted',
        'Your account has been deleted.',
      );
      Get.offAllNamed('/signup');
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      AuthSnackbar.showErrorSnackbar('Error', e.message ?? e.code);
    }
  }

  void _setupSettings() {
    settings = AuthSettingsHelper.buildSettings(
      context: context,
      onDeleteConfirmed: _handleDeleteAccount,
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
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.paddingM,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('My Profile', style: AppTextStyles.heading1),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: settings.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: AppSizes.dotLarge),
                itemBuilder: (context, index) {
                  final item = settings[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(AppSizes.dotLarge),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: Icon(item.icon, color: AppColors.primary),
                      title: Text(item.title, style: AppTextStyles.body),
                      trailing: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 16,
                      ),
                      onTap: item.onTap,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
