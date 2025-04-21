import 'package:flutter/material.dart';

class Responsive {
  static double getFontSize(double screenWidth, double baseSize) {
    if (screenWidth < 400) return baseSize * 0.8;
    if (screenWidth < 600) return baseSize * 0.9;
    return baseSize;
  }

  static EdgeInsets getPadding(double screenWidth) {
    return EdgeInsets.symmetric(
      horizontal: screenWidth < 600 ? 16 : 24,
      vertical: screenWidth < 600 ? 8 : 16,
    );
  }
    static double getWidth(double pixels, BuildContext context) {
    return MediaQuery.of(context).size.width * (pixels / 375); // 375 is base design width
  }

  static double getHeight(double pixels, BuildContext context) {
    return MediaQuery.of(context).size.height * (pixels / 812); // 812 is base design height
  }

  static double getFontSizeContext(double pixels, BuildContext context) {
    return getWidth(pixels, context);
  }

  

}