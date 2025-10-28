import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  static final TextStyle heading = GoogleFonts.poppins(
    fontSize: 30,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryColor,
  );

  static final TextStyle subheading = GoogleFonts.poppins(
    fontSize: 16,
    color: AppColors.hintColor,
    height: 1.5,
  );
  static final TextStyle appbarName = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.backgroundColor,
  );

  static final TextStyle buttonText = GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static final TextStyle linkText = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryColor,
  );

  static final TextStyle priceTitle = GoogleFonts.dmSans(
    fontSize: 10,
    color: AppColors.bodyTextColor,
    fontWeight: FontWeight.w400,
  );
  static final TextStyle bodyText = GoogleFonts.dmSans(
    fontSize: 12,
    color: AppColors.bodyTextColor,
    fontWeight: FontWeight.w400,
  );
  static final TextStyle cardText = GoogleFonts.dmSans(
    fontSize: 12,
    color: AppColors.bodyTextColor,
    fontWeight: FontWeight.w500,
  );
  static final TextStyle grandTotalText = GoogleFonts.dmSans(
    fontSize: 12,
    color: AppColors.bodyTextColor,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle hintText = GoogleFonts.dmSans(
    fontSize: 14,
    color: AppColors.bodyTextColor,
    fontWeight: FontWeight.w400,
  );

  static final TextStyle profileDataText = GoogleFonts.dmSans(
    fontSize: 14,
    color: AppColors.bodyTextColor,
    fontWeight: FontWeight.w500,
  );

  static TextStyle errorText = const TextStyle(
    color: AppColors.errorColor,   // e.g., Colors.red
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.3,                  // line height
  );
  static TextStyle navbar = const TextStyle(
    color: AppColors.navbarNotSelected,   // e.g., Colors.red
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle label = GoogleFonts.poppins(
    fontSize: 14,
    color: AppColors.labelColor,
    fontWeight: FontWeight.w400,
  );

  static final TextStyle headingsFont = GoogleFonts.poppins(
    fontSize: 16,
    color: AppColors.headingsColor,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle statusFont = GoogleFonts.poppins(
    fontSize: 10,
    color: AppColors.pendingColor,
    fontWeight: FontWeight.w400,
  );

  static final TextStyle cardHeading = GoogleFonts.poppins(
    fontSize: 16,
    color: AppColors.labelColor,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle priceText = GoogleFonts.poppins(
    fontSize: 16,
    color: AppColors.primaryColor,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle searchFieldFont = GoogleFonts.poppins(
    fontSize: 14,
    color: AppColors.primaryColor,
    fontWeight: FontWeight.w400,
  );

  static final TextStyle dateText = GoogleFonts.poppins(
    fontSize: 12,
    color: AppColors.primaryColor,
    fontWeight: FontWeight.w400,
  );
  static final TextStyle appbarTitle = GoogleFonts.poppins(
    fontSize: 16,
    color: AppColors.labelColor,
    fontWeight: FontWeight.w600,
  );
  static final TextStyle popupTitle = GoogleFonts.poppins(
    fontSize: 20,
    color: AppColors.labelColor,
    fontWeight: FontWeight.w600,
  );
  static final TextStyle underlineText = GoogleFonts.poppins(
    fontSize: 12,
    color: AppColors.primaryColor,
    fontWeight: FontWeight.w400,
    decoration: TextDecoration.underline,
  );
  static final TextStyle outlinedButtonText = GoogleFonts.poppins(
    fontSize: 16,
    color: AppColors.primaryColor,
    fontWeight: FontWeight.w600,
  );
  static final TextStyle dateAndTime = GoogleFonts.poppins(
    fontSize: 12,
    color: AppColors.labelColor,
    fontWeight: FontWeight.w400,
  );

  static final TextStyle timeLeft = GoogleFonts.poppins(
    fontSize: 10,
    color: AppColors.labelColor,
    fontWeight: FontWeight.w400,
  );


}