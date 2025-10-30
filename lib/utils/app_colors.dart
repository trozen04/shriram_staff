import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryColor = Color(0xFF431B62);
  static const Color primaryColorLight = Color(0xFF8937C8);
  static const Color backgroundColor = Colors.white;
  static const Color bodyTextColor = Color(0xFF3D3D3D);
  static const Color labelColor = Color(0xFF1D1D1D);
  static const Color headingsColor = Color(0xFF1C1C1C);
  static const Color errorColor = Colors.redAccent;
  static const Color navbarNotSelected = Color(0xFFC7C7C7);
  static const Color cardBorder = Color(0xFFCCCCCC);
  static const Color pendingColor = Color(0xFFCBBD00);
  static const Color logoutColor = Color(0xFFCC0000);
  static const Color readOnlyFillColor = Color(0xFFE5E5E5);
  static const Color bottomBorder = Color(0xFFEBEBEB);
  static const Color successColor = Color(0xFF07D000);
  static const Color opacityColorBlack = Color(0xFF939393);
  static const Color dividerColor = Color(0xFFDDDDDD);

  static const Color textColor = Colors.black87;
  static const Color hintColor = Colors.grey;
  static const Color borderColor = Colors.grey;
}

class AppGradients {
  static const LinearGradient purpleGradient = LinearGradient(
    colors: [
      AppColors.primaryColorLight,
      AppColors.primaryColor,
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}