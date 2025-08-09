import 'package:caffex_firebase/core/constants/app_sizes.dart';
import 'package:caffex_firebase/core/theme/app_colors.dart';
import 'package:caffex_firebase/core/theme/app_text_styles.dart';
import 'package:caffex_firebase/data/services/firestore_service.dart';
import 'package:caffex_firebase/features/auth/widgets/auth_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:caffex_firebase/core/routes/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final _firestoreService = FirestoreService();
  String? selectedGender;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;

    if (args != null && args['showIncompleteProfileWarning'] == true) {
      Future.delayed(const Duration(milliseconds: 300), () {
        AuthSnackbar.showErrorSnackbar(
          'Missing Profile Information',
          'Please fill out the form to continue.',
        );
      });
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    surnameController.dispose();
    addressController.dispose();
    super.dispose();
  }

  void onSubmit() async {
    final name = nameController.text.trim();
    final surname = surnameController.text.trim();
    final address = addressController.text.trim();
    final gender = selectedGender;

    if (name.isNotEmpty &&
        surname.isNotEmpty &&
        address.isNotEmpty &&
        gender != null) {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        try {
          await _firestoreService.saveUserProfile(
            uid: user.uid,
            name: name,
            surname: surname,
            address: address,
            gender: gender,
          );

          Get.offAllNamed(AppRoutes.main);
        } catch (e) {
          AuthSnackbar.showErrorSnackbar('Error', e.toString());
        }
      } else {
        AuthSnackbar.showErrorSnackbar(
          'User Not Found',
          'Please sign up first before filling the form.',
        );
        Get.offAllNamed(AppRoutes.signup);
      }
    } else {
      AuthSnackbar.showErrorSnackbar(
        'Missing Fields',
        'Please fill out all the fields.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        AuthSnackbar.showErrorSnackbar(
          'Action Not Allowed',
          'Please complete the form to continue.',
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.paddingL),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Fill Form', style: AppTextStyles.heading1),
                            const SizedBox(height: AppSizes.spacingXS),
                            Text(
                              'Let us know you better',
                              style: AppTextStyles.caption,
                            ),
                          ],
                        ),
                        Container(
                          width: 170,
                          height: 170,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                'assets/icons/app_icon_cutted.png',
                              ),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSizes.spacingL),
                    Text(
                      'Select Gender',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.dark,
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<String>(
                            title: Text(
                              'Male',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.dark,
                              ),
                            ),
                            value: 'male',
                            groupValue: selectedGender,
                            onChanged: (value) {
                              setState(() {
                                selectedGender = value;
                              });
                            },
                            fillColor: WidgetStateProperty.resolveWith<Color>((
                              states,
                            ) {
                              if (states.contains(WidgetState.selected)) {
                                return AppColors.primary;
                              }
                              return AppColors.dark;
                            }),
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<String>(
                            title: Text(
                              'Female',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.dark,
                              ),
                            ),
                            value: 'female',
                            groupValue: selectedGender,
                            onChanged: (value) {
                              setState(() {
                                selectedGender = value;
                              });
                            },
                            fillColor: WidgetStateProperty.resolveWith<Color>((
                              states,
                            ) {
                              if (states.contains(WidgetState.selected)) {
                                return AppColors.primary;
                              }
                              return AppColors.dark;
                            }),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSizes.spacingM),
                    TextField(
                      controller: nameController,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.dark,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Name',
                        labelStyle: AppTextStyles.caption.copyWith(
                          color: AppColors.dark,
                        ),
                        border: const OutlineInputBorder(),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.dark,
                            width: 2,
                          ),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.primary,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSizes.spacingM),
                    TextField(
                      controller: surnameController,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.dark,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Surname',
                        labelStyle: AppTextStyles.caption.copyWith(
                          color: AppColors.dark,
                        ),
                        border: const OutlineInputBorder(),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.dark,
                            width: 2,
                          ),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.primary,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSizes.spacingM),
                    TextField(
                      controller: addressController,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.dark,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Address',
                        labelStyle: AppTextStyles.caption.copyWith(
                          color: AppColors.dark,
                        ),
                        border: const OutlineInputBorder(),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.dark,
                            width: 2,
                          ),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.primary,
                            width: 2,
                          ),
                        ),
                      ),
                      maxLines: 5,
                    ),
                    const SizedBox(height: AppSizes.spacingL),
                    ElevatedButton(
                      onPressed: onSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSizes.paddingM,
                        ),
                      ),
                      child: Text(
                        'Continue',
                        style: AppTextStyles.button.copyWith(
                          color: AppColors.background,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
