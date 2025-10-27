import 'package:flutter/material.dart';
import 'package:shree_ram_staff/utils/image_assets.dart';

import '../utils/app_colors.dart';
import '../utils/flutter_font_styles.dart';

class ReusableAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final List<Widget>? actions;
  final Color backgroundColor;
  final bool centerTitle;

  const ReusableAppBar({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.actions,
    this.backgroundColor = Colors.white,
    this.centerTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: showBackButton
          ? GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Image.asset(
          ImageAssets.backButton,
          width: screenWidth * 0.06,
        ),
      )
          : null,
      title: Text(
        title,
        style: AppTextStyles.appbarTitle,
        overflow: TextOverflow.ellipsis,
      ),
      centerTitle: centerTitle,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
