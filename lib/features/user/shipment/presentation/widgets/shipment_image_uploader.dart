import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';
import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/generated/l10n.dart';

class ShipmentImageUploader extends StatelessWidget {
  final File? packageImage;
  final bool isImageError;
  final VoidCallback onTakePhoto;
  final VoidCallback onPickImage;
  final VoidCallback onRemoveImage;

  const ShipmentImageUploader({
    super.key,
    required this.packageImage,
    required this.isImageError,
    required this.onTakePhoto,
    required this.onPickImage,
    required this.onRemoveImage,
  });

  void _showPickerBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: Text(S.of(context).camera),
              onTap: () {
                Navigator.pop(context);
                onTakePhoto();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text(S.of(context).gallery),
              onTap: () {
                Navigator.pop(context);
                onPickImage();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: packageImage != null ? null : () => _showPickerBottomSheet(context),
      child: Container(
        height: 120.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isImageError
                ? AppColors.redColor
                : AppColors.primaryColor.withValues(alpha: 0.3),
            width: 1.0,
          ),
        ),
        child: packageImage != null
            ? Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: Image.file(
                        packageImage!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8.h,
                    right: 8.w,
                    child: GestureDetector(
                      onTap: onRemoveImage,
                      child: Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 20.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_a_photo,
                      color: AppColors.primaryColor, size: 40.sp),
                  8.ph,
                  Text(
                    S.of(context).uploadPackageImage,
                    style: TextStyle(color: AppColors.primaryColor),
                  ),
                ],
              ),
      ),
    );
  }
}
