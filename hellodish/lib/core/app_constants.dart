import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFFDB1D1D);
  static const Color background = Color(0xFFF7F9FC);
  static const Color grey = Color(0xFF888B92);
  static const Color blue = Color(0xFF4791F5);
  static const Color lightRed = Color(0xFFEE7873);
  static const Color green = Color(0xFF64D58D);
  static const Color purple = Color(0xFFB198EA);
  static const Color darkGreen = Color(0xFF618264);
  static const Color gold = Color(0xFFD5BC64);
  static const Color teal = Color(0xFF60CBD2);
  static const Color lightGrey = Color(0xFF9B9B9B);
  static const Color white = Colors.white;
  static const Color black = Colors.black;
}

class AppTextStyles {
  static const String fontFamily = 'Poppins';

  static const TextStyle heading1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
  );

  static const TextStyle heading2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
  );

  static const TextStyle body = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.black,
  );

  static const TextStyle bodyGrey = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.grey,
  );

  static const TextStyle button = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );

  static const TextStyle label = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.grey,
  );
}

class AppStrings {
  static const String baseUrl = 'https://nonaquatic-shu-xerically.ngrok-free.dev/app';
  static const String appName = 'HELLODISH';
}