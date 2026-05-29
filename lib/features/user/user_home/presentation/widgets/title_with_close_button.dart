import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // For responsive text size
import 'package:shakshak/generated/l10n.dart';

class TitleWithCloseButton extends StatelessWidget {
  final String title;
  final VoidCallback? onClose;
  final Widget? trailing;

  const TitleWithCloseButton({
    Key? key,
    required this.title,
    this.onClose,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (trailing != null) trailing!,
        if (trailing == null) const SizedBox(width: 48), // Spacer for balance
        Expanded(
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 22.sp, // Reduced slightly for better fit
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        IconButton(
          onPressed: onClose ?? () => Navigator.of(context).pop(),
          icon: CircleAvatar(
            backgroundColor:
                Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Icon(Icons.clear,
                color: Theme.of(context).colorScheme.onSurface, size: 20),
          ),
        ),
      ],
    );
  }
}
