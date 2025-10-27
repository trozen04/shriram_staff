import 'package:flutter/material.dart';

/// A class for responsive spacing based on screen size.
class AppDimensions {
  // --- VERTICAL SPACING ---
  /// Returns a SizedBox with a height responsive to 0.6% of the screen height.
  static SizedBox h5(BuildContext context) =>
      SizedBox(height: MediaQuery.of(context).size.height * 0.006);

  /// Returns a SizedBox with a height responsive to 1.2% of the screen height.
  static SizedBox h10(BuildContext context) =>
      SizedBox(height: MediaQuery.of(context).size.height * 0.012);

  /// Returns a SizedBox with a height responsive to 2.4% of the screen height.
  static SizedBox h20(BuildContext context) =>
      SizedBox(height: MediaQuery.of(context).size.height * 0.024);

  /// Returns a SizedBox with a height responsive to 3.6% of the screen height.
  static SizedBox h30(BuildContext context) =>
      SizedBox(height: MediaQuery.of(context).size.height * 0.036);

  /// Returns a SizedBox with a height responsive to 6% of the screen height.
  static SizedBox h50(BuildContext context) =>
      SizedBox(height: MediaQuery.of(context).size.height * 0.06);

  /// Returns a SizedBox with a height responsive to 12% of the screen height.
  static SizedBox h100(BuildContext context) =>
      SizedBox(height: MediaQuery.of(context).size.height * 0.12);

  // --- HORIZONTAL SPACING ---
  /// Returns a SizedBox with a width responsive to 2.5% of the screen width.
  static SizedBox w10(BuildContext context) =>
      SizedBox(width: MediaQuery.of(context).size.width * 0.025);
  static SizedBox w20(BuildContext context) =>
      SizedBox(width: MediaQuery.of(context).size.width * 0.05);

}