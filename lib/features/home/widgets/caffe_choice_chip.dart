import 'package:caffex_firebase/core/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:caffex_firebase/core/theme/app_colors.dart';
import 'package:caffex_firebase/core/theme/app_text_styles.dart';

class CaffeChoiceChip extends StatelessWidget {
  final String label;
  final String imagePath;
  final bool isSelected;
  final VoidCallback onTap;

  const CaffeChoiceChip({
    super.key,
    required this.label,
    required this.imagePath,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      side: BorderSide.none,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.spacingS),
      ),
      showCheckmark: false,
      labelPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      label: IntrinsicWidth(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(imagePath, width: 16, height: 16),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: isSelected
                    ? AppTextStyles.body.copyWith(
                        color: Colors.white,
                        fontSize: 12,
                      )
                    : AppTextStyles.body.copyWith(fontSize: 12),
              ),
            ),
          ],
        ),
      ),
      selected: isSelected,
      onSelected: (_) => onTap(),
      selectedColor: AppColors.primary,
      backgroundColor: AppColors.white,
    );
  }
}
