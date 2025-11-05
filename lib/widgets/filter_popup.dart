import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../utils/flutter_font_styles.dart';

Future<List<String>?> showStatusFilterDialog(
  BuildContext context, {
  List<String>? initialSelected,
}) {
  final List<String> options = ['Approval Pending', 'Approved'];
  final List<String> selected = List.from(initialSelected ?? []);

  return showDialog<List<String>>(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Status', style: AppTextStyles.headingsFont),
                      GestureDetector(
                        onTap: () => Navigator.pop(context, null),
                        child: const Icon(Icons.close, size: 22),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // ✅ Single-selection checkboxes (radio behavior)
                  ...options.map((option) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selected.clear(); // allow only one selection
                          selected.add(option);
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Row(
                          children: [
                            Transform.scale(
                              scale: 1.1,
                              child: Checkbox(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                value: selected.contains(option),
                                activeColor: AppColors.primaryColor,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                visualDensity: VisualDensity.compact,
                                onChanged: (bool? value) {
                                  setState(() {
                                    selected.clear();
                                    if (value == true) {
                                      selected.add(option);
                                    }
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(option, style: AppTextStyles.dateText),
                          ],
                        ),
                      ),
                    );
                  }).toList(),

                  const SizedBox(height: 15),

                  // Buttons Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            side: BorderSide(color: AppColors.primaryColor),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () => Navigator.pop(context, <String>[]),
                          child: Text(
                            'Clear',
                            style: AppTextStyles.headingsFont.copyWith(
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            backgroundColor: AppColors.primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () => Navigator.pop(context, selected),
                          child: Text(
                            'Apply',
                            style: AppTextStyles.headingsFont.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      );
    },
  );
}
