import 'package:caffex_firebase/core/constants/app_sizes.dart';
import 'package:caffex_firebase/core/theme/app_colors.dart';
import 'package:caffex_firebase/core/theme/app_text_styles.dart';
import 'package:caffex_firebase/data/services/firestore_service.dart';
import 'package:caffex_firebase/features/auth/widgets/auth_snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddressUpdateScreen extends StatefulWidget {
  const AddressUpdateScreen({super.key});

  @override
  State<AddressUpdateScreen> createState() => _AddressUpdateScreenState();
}

class _AddressUpdateScreenState extends State<AddressUpdateScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _addressController = TextEditingController();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentAddress();
  }

  Future<void> _loadCurrentAddress() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final profile = await FirestoreService().getUserProfile(uid);
    if (profile != null && profile['address'] != null) {
      _addressController.text = profile['address'];
    }
  }

  Future<void> _saveAddress() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    try {
      await FirestoreService().updateUserAddress(
        uid,
        _addressController.text.trim(),
      );

      if (!mounted) return;
      AuthSnackbar.showSuccessSnackbar(
        'Success',
        'Address updated successfully.',
      );
    } catch (e) {
      if (!mounted) return;
      AuthSnackbar.showSuccessSnackbar('Error', e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_outlined,
            color: AppColors.dark,
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingM),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              Text('Update Address', style: AppTextStyles.heading1),
              const SizedBox(height: AppSizes.spacingL),
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _addressController,
                  maxLines: 5,
                  style: AppTextStyles.caption.copyWith(color: AppColors.dark),
                  decoration: InputDecoration(
                    labelText: 'Address',
                    labelStyle: AppTextStyles.caption.copyWith(
                      color: AppColors.dark,
                    ),
                    border: const OutlineInputBorder(),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.dark, width: 2),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.primary,
                        width: 2,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Address cannot be empty';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: AppSizes.spacingL),
              ElevatedButton(
                onPressed: _loading ? null : _saveAddress,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: EdgeInsets.symmetric(
                    vertical: AppSizes.paddingM,
                    horizontal: AppSizes.paddingXL,
                  ),
                ),
                child: Text(
                  'Save',
                  style: AppTextStyles.button.copyWith(
                    color: AppColors.background,
                  ),
                ),
              ),
              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }
}
