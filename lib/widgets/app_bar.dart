import 'package:caffex_firebase/core/constants/app_sizes.dart';
import 'package:caffex_firebase/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final String name;
  final String surname;
  final String gender;

  const CustomAppBar({
    required this.name,
    required this.surname,
    required this.gender,
    super.key,
  });

  String getProfileImage(String? gender) {
    if (gender == 'male') return 'assets/images/male.png';
    return 'assets/images/female.png';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingM,
        vertical: AppSizes.paddingXS,
      ),
      color: Colors.transparent,
      child: Row(
        children: [
          Image.asset(
            'assets/icons/app_icon_cutted.png',
            width: 90,
            height: 90,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(name, style: AppTextStyles.heading2),
                Text(surname, style: AppTextStyles.caption),
              ],
            ),
          ),
          const SizedBox(width: AppSizes.spacingS),
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: ClipOval(
              child: Image.asset(getProfileImage(gender), fit: BoxFit.cover),
            ),
          ),
        ],
      ),
    );
  }
}
