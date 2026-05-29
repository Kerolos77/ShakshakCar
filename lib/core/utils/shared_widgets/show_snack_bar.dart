import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:shakshak/core/resources/app_colors.dart';

void showSnackBar(BuildContext context, String message, String title,
    Color? color, ContentType contentType) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      title: title,
      message: message,
      contentType: contentType,
      color:
          contentType == ContentType.success ? AppColors.primaryColor : color,
    ),
  ));
}
