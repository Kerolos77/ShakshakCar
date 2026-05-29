import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // For responsive text size
import 'package:shakshak/generated/l10n.dart';

class TitleWithCloseButton extends StatelessWidget {
  final String title;
  final VoidCallback? onClose;

  const TitleWithCloseButton({
    Key? key,
    required this.title,
    this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 25.sp, // Responsive text using ScreenUtil
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        IconButton(
          onPressed: onClose ??
              () {
                Navigator.of(context).pop();
              },
          icon: CircleAvatar(
            child: Icon(
              Icons.clear,
            ),
          ),
        ),
      ],
    );
  }
}
