// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// class AppColors {
//   // ✅ ShakShak Palette (Urban Purple + Cyan)
//   static const primaryColor = Color(0xff6D28D9); // Brand Primary
//   static const primaryLightColor = Color(0xffF5F3FF); // Light BG / Tint
//
// /*  static const secondaryColor = Color(0xff1784AD);
//   static const secondaryLightColor = Color(0xffACD1D6);*/
//   static const secondaryColor = Color(0xff9333EA); // Brand Secondary
//   static const secondaryLightColor = Color(0xffEDE9FE); // Light Tint
//
//   static const darkGreyColor = Color(0xff4B5563);
//   static const lightGreyColor = Color(0xffE5E7EB);
//   static const borderColor = Color(0xffE5E7EB);
//   static const greyColor = Color(0xff9CA3AF);
//   static const scaffoldColor = Color(0xffF5F3FF);
//
//   static const darkPurpleColor = Color(0xff1E1B4B); // deep indigo (brand depth)
//
//   static const whiteColor = Color(0xffFFFFFF);
//   static const blackColor = Color(0xff0F172A);
//
//   // ✅ نفس الليست زي ما هي — ما غيرتش سطر/منطق
//   static List<Color> linearPrimarySecondaryColor = [
//     whiteColor,
//     primaryColor.withAlpha(200),
//     secondaryColor,
//   ];
//
//   static const redColor = Color(0xffDC2626);
//   static const transparent = Colors.transparent;
//
//   // DARK MODE COLORS
//   static const darkBackground = Color(0xFF0B0F19); // main background
//   static const darkSurface = Color(0xFF121827); // containers, cards
//   static const darkPrimary = Color(0xFF6D28D9); // Brand Purple
//   static const darkPrimaryLight = Color(0xFFA78BFA); // Light Purple for Text
//   static const darkSecondary = Color(0xFF06B6D4); // secondary accent (Cyan)
//   static const darkText = Color(0xFFF5F6FA); // main text
//   static const darkTextSecondary = Color(0xFFB8C0D0); // secondary text
//
//   // ThemeData for light and dark themes
//   static final ThemeData lightTheme = ThemeData(
//     useMaterial3: true,
//     scaffoldBackgroundColor: whiteColor,
//     primaryColor: primaryColor,
//     colorScheme: ColorScheme.fromSeed(
//       seedColor: primaryColor,
//       primary: primaryColor,
//       secondary: secondaryColor,
//       surface: Colors.white,
//       onSurface: blackColor,
//       brightness: Brightness.light,
//     ),
//     fontFamily: 'Cairo',
//     dividerColor: lightGreyColor,
//     appBarTheme: const AppBarTheme(
//       backgroundColor: whiteColor,
//       elevation: 0,
//       centerTitle: true,
//       foregroundColor: blackColor,
//       iconTheme: IconThemeData(color: blackColor),
//     ),
//     textTheme: const TextTheme(
//       bodyLarge: TextStyle(color: blackColor),
//       bodyMedium: TextStyle(color: blackColor),
//       bodySmall: TextStyle(color: blackColor),
//     ),
//     pageTransitionsTheme: const PageTransitionsTheme(
//       builders: {
//         TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
//         TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
//       },
//     ),
//   );
//
//   static final ThemeData darkTheme = ThemeData(
//     useMaterial3: true,
//     scaffoldBackgroundColor: darkBackground,
//     primaryColor: darkPrimary,
//     colorScheme: ColorScheme.fromSeed(
//       seedColor: darkPrimary,
//       brightness: Brightness.dark,
//       primary: darkPrimary,
//       onPrimary: Colors.white,
//       secondary: darkSecondary,
//       onSecondary: Colors.white,
//       surface: darkSurface,
//       onSurface: darkText,
//       error: redColor,
//     ),
//     fontFamily: 'Cairo',
//     appBarTheme: const AppBarTheme(
//       backgroundColor: darkSurface,
//       elevation: 0,
//       centerTitle: true,
//       foregroundColor: darkText,
//       iconTheme: IconThemeData(color: darkText),
//     ),
//     textTheme: const TextTheme(
//       bodyLarge: TextStyle(color: darkText),
//       bodyMedium: TextStyle(color: darkText),
//       bodySmall: TextStyle(color: darkTextSecondary),
//       titleLarge: TextStyle(color: darkText),
//       titleMedium: TextStyle(color: darkText),
//       titleSmall: TextStyle(color: darkTextSecondary),
//       labelLarge: TextStyle(color: darkText),
//       labelMedium: TextStyle(color: darkTextSecondary),
//       labelSmall: TextStyle(color: darkTextSecondary),
//     ),
//     cardColor: darkSurface,
//     dialogBackgroundColor: darkSurface,
//     canvasColor: darkBackground,
//     dividerColor: Color(0xFF1E293B),
//     // Subtle slate divider instead of bright cyan
//     iconTheme: const IconThemeData(color: darkText),
//     inputDecorationTheme: InputDecorationTheme(
//       fillColor: darkSurface,
//       filled: true,
//       hintStyle: TextStyle(color: darkTextSecondary),
//       labelStyle: TextStyle(color: darkText),
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12.r),
//         borderSide: BorderSide(color: Color(0xFF1E293B)),
//       ),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12.r),
//         borderSide: BorderSide(color: Color(0xFF1E293B)),
//       ),
//     ),
//     pageTransitionsTheme: const PageTransitionsTheme(
//       builders: {
//         TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
//         TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
//       },
//     ),
//   );
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppColors {
  // ✅ Brand Palette (Go Fly - Professional UI Palette)
  static const primaryColor =
      Color(0xFFE02060); // Primary Pink (اللون الأساسي للهوية والفرعيات)
  static const primaryLightColor =
      Color(0xFFFFF0F5); // Light Pink Tint (للخلفيات الخفيفة)

  static const secondaryColor =
      Color(0xFFD0FF00); // Accent Lime (زر الإجراء الرئيسي CTA)
  static const secondaryLightColor = Color(0xFFF7FFC2); // Light Lime Tint

  static const routeGreen =
      Color(0xFFB8FF30); // Route Green (رسم الرحلة على الخريطة)

  static const darkGreyColor =
      Color(0xFF404040); // Card Gray (بطاقات الوضع الداكن)
  static const lightGreyColor = Color(0xFFE5E5E5); // Border & Divider color
  static const borderColor = Color(0xFFE5E5E5);
  static const greyColor = Color(0xFF8A8A8A); // Secondary Text Color
  static const scaffoldColor = Color(0xFFF8F8F8); // Light BG

  static const darkPurpleColor = Color(0xFF202020); // Dark BG

  static const whiteColor = Color(0xFFFFFFFF);
  static const blackColor = Color(0xFF111111); // Main Text Color

  // ✅ نفس القائمة مع تحديث الألوان للثيم الجديد
  static List<Color> linearPrimarySecondaryColor = [
    whiteColor,
    primaryColor.withAlpha(200),
    secondaryColor,
  ];

  static const redColor = Color(0xFFDC2626);
  static const transparent = Colors.transparent;

  // 🌙 DARK MODE COLORS (من الجدول بالصورة)
  static const darkBackground = Color(0xFF202020); // Dark BG
  static const darkSurface = Color(0xFF404040); // Card Gray (بطاقات وكروت)
  static const darkPrimary = Color(0xFFE02060); // Primary Pink
  static const darkPrimaryLight =
      Color(0xFFFF6699); // Light Pink for text/accents in dark mode
  static const darkSecondary = Color(0xFFD0FF00); // Accent Lime
  static const darkText = Color(0xFFFFFFFF); // Main text in dark mode
  static const darkTextSecondary = Color(0xFF8A8A8A); // Secondary text

  // ☀️ LIGHT THEME DATA
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: scaffoldColor,
    primaryColor: primaryColor,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      primary: primaryColor,
      secondary: secondaryColor,
      surface: whiteColor,
      onSurface: blackColor,
      brightness: Brightness.light,
    ),
    fontFamily: 'Cairo',
    dividerColor: lightGreyColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: scaffoldColor,
      elevation: 0,
      centerTitle: true,
      foregroundColor: blackColor,
      iconTheme: IconThemeData(color: blackColor),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: blackColor),
      bodyMedium: TextStyle(color: blackColor),
      bodySmall: TextStyle(color: greyColor),
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );

  // 🌙 DARK THEME DATA
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: darkBackground,
    primaryColor: darkPrimary,
    colorScheme: ColorScheme.fromSeed(
      seedColor: darkPrimary,
      brightness: Brightness.dark,
      primary: darkPrimary,
      onPrimary: Colors.white,
      secondary: darkSecondary,
      onSecondary: blackColor,
      surface: darkSurface,
      onSurface: darkText,
      error: redColor,
    ),
    fontFamily: 'Cairo',
    appBarTheme: const AppBarTheme(
      backgroundColor: darkBackground,
      elevation: 0,
      centerTitle: true,
      foregroundColor: darkText,
      iconTheme: IconThemeData(color: darkText),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: darkText),
      bodyMedium: TextStyle(color: darkText),
      bodySmall: TextStyle(color: darkTextSecondary),
      titleLarge: TextStyle(color: darkText),
      titleMedium: TextStyle(color: darkText),
      titleSmall: TextStyle(color: darkTextSecondary),
      labelLarge: TextStyle(color: darkText),
      labelMedium: TextStyle(color: darkTextSecondary),
      labelSmall: TextStyle(color: darkTextSecondary),
    ),
    cardColor: darkSurface,
    dialogBackgroundColor: darkSurface,
    canvasColor: darkBackground,
    dividerColor: Color(0xFF333333),
    iconTheme: const IconThemeData(color: darkText),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: darkSurface,
      filled: true,
      hintStyle: const TextStyle(color: darkTextSecondary),
      labelStyle: const TextStyle(color: darkText),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: Color(0xFF505050)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: Color(0xFF505050)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: darkPrimary),
      ),
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );
}
