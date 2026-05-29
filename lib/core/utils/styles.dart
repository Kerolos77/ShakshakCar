import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Styles {
  static TextStyle textStyle8(BuildContext context) => TextStyle(
        fontSize: 8.sp,
        fontWeight: FontWeight.w400,
        color: Theme.of(context).textTheme.bodyLarge?.color,
      );

  static TextStyle textStyle12SemiBold(BuildContext context) => TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w600,
        color: getPrimaryColor(context),
      );

  static TextStyle textStyle14Medium(BuildContext context) => TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
      );

  static TextStyle textStyle14Bold(BuildContext context) => TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w700,
        color: Theme.of(context).textTheme.bodyLarge?.color,
      );

  static TextStyle textStyle18SemiBold(BuildContext context) => TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).textTheme.bodyLarge?.color,
      );

  static TextStyle textStyle28Bold(BuildContext context) => TextStyle(
        fontSize: 28.sp,
        fontWeight: FontWeight.w700,
        color: Theme.of(context).colorScheme.secondary,
      );

  static TextStyle textStyle14(BuildContext context) => TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: Theme.of(context).textTheme.bodyLarge?.color,
      );

  static TextStyle textStyle14SemiBold(BuildContext context) => TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
      );

  static TextStyle textStyle13SemiBold(BuildContext context) => TextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
      );

  static TextStyle textStyle12(BuildContext context) => TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        color: getPrimaryColor(context),
      );

  static TextStyle textStyle12Medium(BuildContext context) => TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
        color: Theme.of(context).colorScheme.secondary,
      );

  static TextStyle textStyle12Bold(BuildContext context) => TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w700,
        color: getPrimaryColor(context),
      );

  static TextStyle textStyle10(BuildContext context) => TextStyle(
        fontSize: 10.sp,
        fontWeight: FontWeight.w400,
        color: Theme.of(context).colorScheme.error,
      );

  static TextStyle textStyle10SemiBold(BuildContext context) => TextStyle(
        fontSize: 10.sp,
        fontWeight: FontWeight.w600,
        color: getPrimaryColor(context),
      );

  static TextStyle textStyle11SemiBold(BuildContext context) => TextStyle(
        fontSize: 11.sp,
        fontWeight: FontWeight.w600,
        color: getPrimaryColor(context),
      );

  static TextStyle textStyle16(BuildContext context) => TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
        color: Theme.of(context).textTheme.bodyLarge?.color,
      );

  static TextStyle textStyle16Regular(BuildContext context) => TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
        color: Theme.of(context).textTheme.bodyLarge?.color,
      );

  static TextStyle textStyle22Bold(BuildContext context) => TextStyle(
        fontSize: 22.sp,
        fontWeight: FontWeight.w700,
        color: Theme.of(context).colorScheme.onPrimary,
      );

  static TextStyle textStyle22Medium(BuildContext context) => TextStyle(
        fontSize: 22.sp,
        fontWeight: FontWeight.w500,
        color: Theme.of(context).colorScheme.secondary,
      );

  static TextStyle textStyle20Bold(BuildContext context) => TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.w700,
        color: Theme.of(context).textTheme.bodyLarge?.color,
      );

  static TextStyle textStyle18Bold(BuildContext context) => TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w700,
        color: Theme.of(context).textTheme.bodyLarge?.color,
      );

  static TextStyle textStyle16Bold(BuildContext context) => TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w700,
        color: Theme.of(context).textTheme.bodyLarge?.color,
      );

  static TextStyle textStyle16SemiBold(BuildContext context) => TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).textTheme.bodyLarge?.color,
      );

  static TextStyle textStyle16Medium(BuildContext context) => TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
      );

  static TextStyle textStyle32Bold(BuildContext context) => TextStyle(
        fontSize: 32.sp,
        fontWeight: FontWeight.w700,
        color: Theme.of(context).textTheme.bodyLarge?.color,
      );

  static TextStyle textStyle30Bold(BuildContext context) => TextStyle(
        fontSize: 30.sp,
        fontWeight: FontWeight.w700,
        color: Theme.of(context).textTheme.bodyLarge?.color,
      );

  static TextStyle textStyle24Bold(BuildContext context) => TextStyle(
        fontSize: 24.sp,
        fontWeight: FontWeight.w700,
        color: Theme.of(context).textTheme.bodyLarge?.color,
      );

  static Color getPrimaryColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Theme.of(context).colorScheme.onPrimaryContainer
        : Theme.of(context).primaryColor;
  }
}
