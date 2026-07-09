import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';

import 'package:shakshak/core/utils/shared_widgets/dashed_border.dart';
import 'package:shakshak/core/utils/styles.dart';
import 'package:shakshak/generated/l10n.dart';

class CustomImagePickerWidget extends StatefulWidget {
  final String title;
  final ValueChanged<XFile?> onImagePicked;
  final XFile? initialImage;
  final bool cameraOnly;

  const CustomImagePickerWidget({
    super.key,
    required this.title,
    required this.onImagePicked,
    this.initialImage,
    this.cameraOnly = false,
  });

  @override
  State<CustomImagePickerWidget> createState() =>
      _CustomImagePickerWidgetState();
}

class _CustomImagePickerWidgetState extends State<CustomImagePickerWidget> {
  XFile? _selectedImage;

  @override
  void initState() {
    super.initState();
    _selectedImage = widget.initialImage;
  }

  @override
  void didUpdateWidget(covariant CustomImagePickerWidget oldWidget) {
    if (widget.initialImage != oldWidget.initialImage) {
      _selectedImage = widget.initialImage;
    }
    super.didUpdateWidget(oldWidget);
  }

  Future<void> _showImageSourceBottomSheet() async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      builder: (context) => SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(S.of(context).pleaseSelect,
                  style: Styles.textStyle18Bold(context)),
              12.ph,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSourceButton(Icons.camera_alt, S.of(context).camera,
                      ImageSource.camera),
                  12.pw,
                  _buildSourceButton(Icons.photo_library, S.of(context).gallery,
                      ImageSource.gallery),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSourceButton(IconData icon, String label, ImageSource source) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        _pickImage(source);
      },
      borderRadius: BorderRadius.circular(12.r),
      child: Padding(
        padding: EdgeInsets.all(8.r),
        child: Column(
          children: [
            Icon(icon,
                color: Theme.of(context).colorScheme.onSurface, size: 28.r),
            Text(label, style: Styles.textStyle16(context)),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(
        source: source,
        imageQuality: 50,
        maxWidth: 2000,
        maxHeight: 2000,
      );
      if (image != null) {
        setState(() => _selectedImage = image);
        widget.onImagePicked(image);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).errorOccurredWith(e.toString()))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.title, style: Styles.textStyle16Bold(context)),
        12.ph,
        GestureDetector(
          onTap: widget.cameraOnly
              ? () => _pickImage(ImageSource.camera)
              : _showImageSourceBottomSheet,
          child: _selectedImage == null
              ? DashedBorder(
                  color: Theme.of(context).dividerColor,
                  strokeWidth: 2.w,
                  dashLength: 8.w,
                  dashGap: 4.w,
                  borderRadius: 12.r,
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.sizeOf(context).height * 0.3,
                    padding: EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 100.w,
                          height: 100.h,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.onSurface,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Icon(Icons.upload_file,
                              size: 50.r,
                              color: Theme.of(context).colorScheme.surface),
                        ),
                        12.ph,
                        Text(S.of(context).addPhoto,
                            style: Styles.textStyle16SemiBold(context)),
                      ],
                    ),
                  ),
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Image.file(
                    File(_selectedImage!.path),
                    width: double.infinity,
                    height: MediaQuery.sizeOf(context).height * 0.3,
                    fit: BoxFit.cover,
                  ),
                ),
        ),
      ],
    );
  }
}
