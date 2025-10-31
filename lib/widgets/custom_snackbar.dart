import 'package:flutter/material.dart';

class CustomSnackBar {
  static final _currentSnackBar = ValueNotifier<String?>(null);

  static void show(
    BuildContext context, {
    required String message,
    bool isError = false,
  }) {
    // Don't show if the same message is already displayed
    if (_currentSnackBar.value == message) return;

    _currentSnackBar.value = message;

    final snackBar = SnackBar(
      content: Text(message, style: const TextStyle(color: Colors.white)),
      backgroundColor: isError ? Colors.red : Colors.green,
      duration: const Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar() // hide any previous snackbar
      ..showSnackBar(snackBar).closed.then((_) {
        _currentSnackBar.value = null; // reset when snackbar disappears
      });
  }
}
