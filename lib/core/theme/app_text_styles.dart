import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  static final TextStyle heading1 = GoogleFonts.playfairDisplay(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.dark,
  );

  static final TextStyle heading2 = GoogleFonts.playfairDisplay(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.dark,
  );

  static final TextStyle body = GoogleFonts.poppins(
    fontSize: 16,
    color: Colors.black87,
  );

  static final TextStyle caption = GoogleFonts.poppins(
    fontSize: 14,
    color: Colors.grey,
  );

  static final TextStyle button = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.yellow,
  );
}
