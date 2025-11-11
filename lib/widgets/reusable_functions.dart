import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:shree_ram_staff/widgets/primary_and_outlined_button.dart';
import '../Constants/app_dimensions.dart';
import '../utils/app_colors.dart';
import '../utils/flutter_font_styles.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:intl/intl.dart';

String formatAmount(dynamic amount) {
  if (amount == null) return '';
  try {
    final number = amount is String ? double.parse(amount) : amount.toDouble();
    final formatter = NumberFormat('#,##0', 'en_IN');
    return '₹ ${formatter.format(number)}';
  } catch (e) {
    return '₹ ${amount.toString()}';
  }
}

class CustomRoundedButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry? borderRadius;

  const CustomRoundedButton({
    super.key,
    required this.child,
    required this.onTap,
    this.backgroundColor,
    this.height,
    this.padding,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final double defaultHeight =
        height ?? MediaQuery.of(context).size.height * 0.055;
    final double width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: defaultHeight,
        padding: padding ?? EdgeInsets.symmetric(horizontal: width * 0.055),
        decoration: BoxDecoration(
          color:
              backgroundColor ??
              AppColors.primaryColor.withAlpha((0.16 * 255).toInt()),
          borderRadius: borderRadius ?? BorderRadius.circular(30),
        ),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}

class ProfileRow extends StatelessWidget {
  final String label;
  final dynamic value;

  const ProfileRow({
    super.key,
    required this.label,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    // Convert dynamic to displayable string and handle null/empty cases
    String displayValue;
    if (value == null ||
        (value is String && value.trim().isEmpty) ||
        (value.toString().trim().isEmpty)) {
      displayValue = '~';
    } else {
      displayValue = value.toString();
    }

    final width = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * 0.008,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label (fixed width)
          SizedBox(
            width: width * 0.35, // fixed width for label
            child: Text(
              label,
              style: AppTextStyles.bodyText,
            ),
          ),

          // Value (max width with ellipsis)
          Expanded(
            child: Container(
              constraints: BoxConstraints(maxWidth: width * 0.55),
              child: Text(
                displayValue,
                style: AppTextStyles.profileDataText,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomConfirmationDialog {
  static Future<bool> show({
    required BuildContext context,
    required String title,
    required String description,
    String confirmText = 'Yes',
    String cancelText = 'No',
    Color confirmColor = AppColors.logoutColor,
    Color cancelColor = AppColors.logoutColor,
  }) async {
    final size = MediaQuery.of(context).size;
    final double padding = size.width * 0.05;
    final double spacing = size.height * 0.015;
    final double buttonHeight = size.height * 0.055;
    final double maxDialogHeight = size.height * 0.5;

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxDialogHeight),
            child: SingleChildScrollView(
              padding: EdgeInsets.all(padding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.headingsFont.copyWith(
                      fontSize: size.width * 0.045,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: spacing),
                  Text(
                    description,
                    style: AppTextStyles.bodyText.copyWith(
                      fontSize: size.width * 0.037,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: spacing * 2),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: buttonHeight,
                          child: PrimaryButton(
                            text: cancelText,
                            onPressed: () => Navigator.pop(context, false),
                            buttonColor: cancelColor,
                            isLogout: false,
                          ),
                        ),
                      ),
                      SizedBox(width: padding),
                      Expanded(
                        child: SizedBox(
                          height: buttonHeight,
                          child: PrimaryButton(
                            text: confirmText,
                            onPressed: () => Navigator.pop(context, true),
                            isLogout: confirmColor == AppColors.logoutColor,
                            isLogoutText: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    return result ?? false;
  }
}

class ReusableDropdown extends StatelessWidget {
  final List<String> items;
  final String? value;
  final Function(String?) onChanged;
  final String? Function(String?)? validator;
  final String? hintText;

  const ReusableDropdown({
    super.key,
    required this.items,
    required this.value,
    required this.onChanged,
    this.validator,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      icon: const Icon(Icons.keyboard_arrow_down_outlined),
      decoration: InputDecoration(
        isDense: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.035,
          vertical: MediaQuery.of(context).size.height * 0.015,
        ),
        errorStyle: const TextStyle(
          height: 1, // reduce vertical gap
          color: Colors.red,
        ),
        errorMaxLines: 2,
      ),
      initialValue: value,
      items: items
          .map(
            (item) => DropdownMenuItem<String>(
              value: item,
              child: Text(item, style: AppTextStyles.hintText),
            ),
          )
          .toList(),
      onChanged: onChanged,
      validator: validator,
      hint: Text(
        '${hintText!.isNotEmpty ? hintText : 'Select option'}',
        style: AppTextStyles.hintText,
      ),
    );
  }
}

class ReusablePopup extends StatelessWidget {
  final String title;
  final String message;
  final String buttonText;
  final VoidCallback onButtonPressed;
  final double height;
  final double width;

  const ReusablePopup({
    super.key,
    required this.title,
    required this.message,
    required this.buttonText,
    required this.onButtonPressed,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.2,
          vertical: height * 0.035,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: AppTextStyles.popupTitle),
            AppDimensions.h20(context),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyText,
              maxLines: 3,
            ),
            AppDimensions.h20(context),
            PrimaryButton(text: 'okay', onPressed: onButtonPressed),
          ],
        ),
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final String title;
  final IconData? icon;
  final String? imagePath;
  final VoidCallback ontap;

  const ActionButton({
    super.key,
    required this.title,
    this.icon,
    this.imagePath,
    required this.ontap,
  }) : assert(
         icon != null || imagePath != null,
         'Either icon or imagePath must be provided',
       );

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: ontap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.035,
          vertical: height * 0.02,
        ),
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withAlpha((0.16 * 255).toInt()),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (imagePath != null)
              Image.asset(
                imagePath!,
                height: height * 0.07,
                width: height * 0.07,
                fit: BoxFit.contain,
              )
            else
              Icon(icon, size: height * 0.07, color: AppColors.primaryColor),
            AppDimensions.h10(context),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.linkText,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class ReportTable extends StatelessWidget {
  final data;
  const ReportTable({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final headerTextStyle = AppTextStyles.profileDataText;
    final cellTextStyle = AppTextStyles.bodyText;

    return Table(
      columnWidths: const {
        0: FlexColumnWidth(1.5),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(1),
        3: FlexColumnWidth(1),
      },
      children: [
        TableRow(
          children: [
            TableHeaderCell(text: 'Item', textStyle: headerTextStyle),
            TableHeaderCell(text: 'Qty In', textStyle: headerTextStyle),
            TableHeaderCell(text: 'Qty Out', textStyle: headerTextStyle),
            TableHeaderCell(text: 'Stock Left', textStyle: headerTextStyle),
          ],
        ),
        ...data.map(
          (row) => TableRow(
            children: [
              TableCellWidget(text: row['item']!, textStyle: cellTextStyle),
              TableCellWidget(text: row['qtyIn']!, textStyle: cellTextStyle),
              TableCellWidget(text: row['qtyOut']!, textStyle: cellTextStyle),
              TableCellWidget(
                text: row['stockLeft']!,
                textStyle: cellTextStyle,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class TableHeaderCell extends StatelessWidget {
  final String text;
  final TextStyle textStyle;

  const TableHeaderCell({
    super.key,
    required this.text,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(text, style: textStyle),
    );
  }
}

class TableCellWidget extends StatelessWidget {
  final String text;
  final TextStyle textStyle;

  const TableCellWidget({
    super.key,
    required this.text,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: textStyle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        softWrap: false,
      ),
    );
  }
}

class ReusableTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final String? initialValue; // <-- add this
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final bool readOnly;
  final int maxLines;
  final VoidCallback? onTap;
  final String? actionLabel;
  final VoidCallback? onActionTap;
  final IconData? actionIcon;
  final VoidCallback? onIconTap;

  const ReusableTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.initialValue,
    this.onChanged,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.textCapitalization = TextCapitalization.none,
    this.readOnly = false,
    this.maxLines = 1,
    this.onTap,
    this.actionLabel,
    this.onActionTap,
    this.actionIcon,
    this.onIconTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label + Optional Action Button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTextStyles.label),
            if (onActionTap != null)
              InkWell(
                onTap: onActionTap,
                borderRadius: BorderRadius.circular(8),
                child: Row(
                  children: [
                    if (actionIcon != null)
                      Icon(actionIcon, size: 18, color: Colors.red),
                    if (actionLabel != null) ...[
                      const SizedBox(width: 4),
                      Text(actionLabel!, style: AppTextStyles.underlineText),
                    ],
                  ],
                ),
              )
            else if (actionIcon != null && onIconTap != null)
              InkWell(
                onTap: onIconTap,
                child: Icon(actionIcon, color: Colors.redAccent, size: 20),
              ),
          ],
        ),

        AppDimensions.h5(context),

        // Text Field
        TextFormField(
          controller: controller,
          initialValue: controller == null ? initialValue : null, // <-- use initialValue if controller is not provided
          onChanged: onChanged,
          validator: validator,
          keyboardType: keyboardType,
          readOnly: readOnly,
          maxLines: maxLines,
          onTap: onTap,
          textCapitalization: textCapitalization,
          inputFormatters: [
            if (keyboardType == TextInputType.phone) ...[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              LengthLimitingTextInputFormatter(10),
            ],
            if (keyboardType == TextInputType.number)
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
          ],
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.hintText,
            filled: true,
            fillColor: readOnly
                ? AppColors.readOnlyFillColor
                : Colors.white,
            contentPadding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.035,
              vertical: MediaQuery.of(context).size.height * 0.015,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.cardBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.borderColor.withOpacity(0.5),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.primaryColor,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ReusableNotificationCard extends StatelessWidget {
  final String title;
  final bool isRead;
  final String date;
  final double height;
  final double width;

  const ReusableNotificationCard({
    super.key,
    required this.title,
    this.isRead = false,
    required this.date,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.035,
        vertical: height * 0.015,
      ),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.bottomBorder)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(title, style: AppTextStyles.label)),
              if (!isRead)
                Icon(Icons.circle, size: 10, color: AppColors.primaryColor),
            ],
          ),
          AppDimensions.h10(context),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(formatToDayTime(date), style: AppTextStyles.dateAndTime),
              Text(timeAgoSinceDate(date), style: AppTextStyles.timeLeft),
            ],
          ),
        ],
      ),
    );
  }
}

///Date Functions
String formatReadableDate(DateTime? date) {
  if (date == null) return '';

  // Convert to Indian Standard Time (UTC+5:30)
  final istDate = date.toUtc().add(const Duration(hours: 5, minutes: 30));

  // Format as: 23 September, 2025
  return DateFormat('d MMMM, yyyy').format(istDate);
}

///ReusableSearchField

class ReusableSearchField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final void Function(String)? onChanged;

  const ReusableSearchField({
    super.key,
    required this.controller,
    this.hintText = 'Search...',
    this.prefixIcon = Icons.search,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTextStyles.searchFieldFont,
        prefixIcon: Icon(prefixIcon, color: AppColors.primaryColor),
        filled: true,
        fillColor: AppColors.primaryColor.withAlpha((0.16 * 255).toInt()),
        contentPadding: EdgeInsets.symmetric(
          horizontal: width * 0.035,
          vertical: height * 0.01,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(61),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

/// A reusable function to pick a date and return it as [DateTime].

Future<DateTime?> pickDate({
  required BuildContext context,
  DateTime? initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
}) async {
  final DateTime now = DateTime.now();

  final results = await showCalendarDatePicker2Dialog(
    context: context,
    config: CalendarDatePicker2WithActionButtonsConfig(
      dayBorderRadius: BorderRadius.circular(8),
      selectedDayHighlightColor: Colors.teal,
      yearTextStyle: const TextStyle(fontWeight: FontWeight.w600),
      selectedYearTextStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      weekdayLabels: const ['S', 'M', 'T', 'W', 'T', 'F', 'S'],
      controlsTextStyle: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
      okButtonTextStyle: const TextStyle(
        color: Colors.teal,
        fontWeight: FontWeight.bold,
        fontSize: 15,
      ),
      cancelButtonTextStyle: const TextStyle(color: Colors.grey, fontSize: 15),
    ),
    dialogSize: const Size(320, 400),
    borderRadius: BorderRadius.circular(16),
    value: [initialDate ?? now],
  );

  return results?.first;
}

Future<DateTimeRange?> pickDateRange({
  required BuildContext context,
  DateTimeRange? initialRange,
  DateTime? firstDate,
  DateTime? lastDate,
}) async {
  final DateTime now = DateTime.now();

  // Default range: today to today
  final List<DateTime?> initialDates = [
    initialRange?.start ?? now,
    initialRange?.end ?? now,
  ];

  final results = await showCalendarDatePicker2Dialog(
    context: context,
    config: CalendarDatePicker2WithActionButtonsConfig(
      calendarType: CalendarDatePicker2Type.range,
      dayBorderRadius: BorderRadius.circular(8),
      selectedDayHighlightColor: AppColors.primaryColor,
      yearTextStyle: AppTextStyles.linkText,
      selectedYearTextStyle: AppTextStyles.linkText.copyWith(
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      weekdayLabels: const ['S', 'M', 'T', 'W', 'T', 'F', 'S'],
      controlsTextStyle: AppTextStyles.bodyText,
      okButtonTextStyle: AppTextStyles.linkText,
      cancelButtonTextStyle: AppTextStyles.cardText,
    ),
    dialogSize: const Size(320, 400),
    borderRadius: BorderRadius.circular(16),
    value: initialDates,
  );

  if (results == null ||
      results.length < 2 ||
      results[0] == null ||
      results[1] == null) {
    return null;
  }

  return DateTimeRange(start: results[0]!, end: results[1]!);
}

/// Optional helper to format the date as string (e.g., 'dd-MM-yy')
String formatDate(DateTime? date) {
  return date != null ? DateFormat('dd-MM-yy').format(date) : 'Date';
}

String formatDateRange(DateTimeRange? range) {
  if (range == null) return 'From ~ To';
  final String from = DateFormat('dd-MM-yy').format(range.start);
  final String to = DateFormat('dd-MM-yy').format(range.end);
  return '$from ~ $to';
}

class CustomFAB extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final Color? backgroundColor;
  final Color? iconColor;
  final double? padding;
  final Alignment alignment;

  const CustomFAB({
    super.key,
    required this.onTap,
    this.icon = Icons.add,
    this.backgroundColor,
    this.iconColor,
    this.padding,
    this.alignment = Alignment.bottomRight,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Align(
      alignment: alignment,
      child: Padding(
        padding: EdgeInsets.only(right: width * 0.05, bottom: width * 0.05),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(100),
          child: Container(
            padding: EdgeInsets.all(padding ?? width * 0.04),
            decoration: BoxDecoration(
              color: backgroundColor ?? AppColors.primaryColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor ?? Colors.white),
          ),
        ),
      ),
    );
  }
}

class StaffTable extends StatelessWidget {
  final List<dynamic> data;

  const StaffTable({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final headerTextStyle = AppTextStyles.bodyText;
    final cellTextStyle = AppTextStyles.bodyText;

    return Table(
      border: TableBorder.all(
        color: Colors.transparent,
        width: 0,
      ),
      columnWidths: const {
        0: FlexColumnWidth(1.5),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(1),
      },
      children: [
        TableRow(
          children: [
            TableHeaderCell(text: 'Staff Name', textStyle: headerTextStyle),
            TableHeaderCell(text: 'Total Present', textStyle: headerTextStyle),
            TableHeaderCell(text: 'Total Absent', textStyle: headerTextStyle),
          ],
        ),
        ...data.map(
              (row) => TableRow(
            children: [
              TableCellWidget(
                text: row['name'].toString(),
                textStyle: AppTextStyles.profileDataText,
              ),
              TableCellWidget(
                text: (row['totalPresent'] ?? 0).toString(),
                textStyle: cellTextStyle,
              ),
              TableCellWidget(
                text: (row['totalAbsent'] ?? 0).toString(),
                textStyle: cellTextStyle,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CustomIconButton extends StatelessWidget {
  final String text;
  final String? imagePath;
  final IconData? iconData;
  final VoidCallback onTap;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? iconColor;
  final TextStyle? textStyle;
  final double borderRadius;
  final bool showIconOnRight;

  const CustomIconButton({
    super.key,
    required this.text,
    this.imagePath,
    this.iconData,
    required this.onTap,
    this.width,
    this.height,
    this.backgroundColor,
    this.iconColor,
    this.textStyle,
    this.borderRadius = 30,
    this.showIconOnRight = false,
  });

  @override
  Widget build(BuildContext context) {
    final double w = width ?? MediaQuery.of(context).size.width;
    final double h = height ?? MediaQuery.of(context).size.height;

    final Widget? iconWidget = imagePath != null
        ? Image.asset(imagePath!, height: h * 0.025)
        : iconData != null
        ? Icon(
            iconData,
            size: h * 0.022,
            color: iconColor ?? AppColors.primaryColor,
          )
        : null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: w * 0.06,
          vertical: h * 0.015,
        ),
        decoration: BoxDecoration(
          color:
              backgroundColor ??
              AppColors.primaryColor.withAlpha((0.16 * 255).toInt()),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!showIconOnRight && iconWidget != null) ...[
              iconWidget,
              AppDimensions.w10(context),
            ],
            Text(text, style: textStyle ?? AppTextStyles.dateText),
            if (showIconOnRight && iconWidget != null) ...[
              AppDimensions.w10(context),
              iconWidget,
            ],
          ],
        ),
      ),
    );
  }
}

String formatToIST(String? utcDateString) {
  if (utcDateString == null || utcDateString.isEmpty) return '';

  try {
    // Parse as UTC
    final utcDate = DateTime.parse(utcDateString).toUtc();

    // Convert to IST (UTC +5:30)
    final istDate = utcDate.add(const Duration(hours: 5, minutes: 30));

    // Format to dd-MM-yy
    return DateFormat('dd-MM-yy').format(istDate);
  } catch (e) {
    // fallback if parsing fails
    return '~';
  }
}

String formatToISTFull(String? utcDateString) {
  if (utcDateString == null || utcDateString.isEmpty) return '~';

  try {
    final utcDate = DateTime.parse(utcDateString).toUtc();
    final istDate = utcDate.add(const Duration(hours: 5, minutes: 30));
    return DateFormat('dd/MM/yyyy').format(istDate);
  } catch (e) {
    return '~';
  }
}


/// Converts ISO 8601 date string to "Monday, 4:41 PM" format
String formatToDayTime(String isoDate) {
  try {
    final dateTime = DateTime.parse(isoDate).toLocal(); // convert to local
    return DateFormat('EEEE, h:mm a').format(dateTime); // Monday, 4:41 PM
  } catch (e) {
    return '';
  }
}

/// Returns relative time from current IST time, e.g. "2 hours ago", "1 day ago"
String timeAgoSinceDate(String isoDate) {
  try {
    final dateTime = DateTime.parse(isoDate).toLocal(); // convert UTC to local time
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inDays < 30) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else {
      final months = difference.inDays ~/ 30;
      return '$months month${months > 1 ? 's' : ''} ago';
    }
  } catch (e) {
    return '';
  }
}
