import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/utils/styles.dart';
import 'package:shakshak/generated/l10n.dart';

class WriteCommentWidget extends StatelessWidget {
  const WriteCommentWidget(
      {super.key, required this.onTap, required this.commentController});

  final Function()? onTap;
  final TextEditingController commentController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20, left: 20),
      child: TextField(
        style: Styles.textStyle14(context),
        // ØªØ­Ø¯ÙŠØ¯ Ø­Ø¬Ù… Ø§Ù„Ø®Ø·
        controller: commentController,
        readOnly: true,
        maxLines: 1,
        decoration: InputDecoration(
          hintText: S.of(context).writeComment,
          hintStyle: Styles.textStyle14(context)
              .copyWith(color: Theme.of(context).hintColor),
          contentPadding: const EdgeInsets.symmetric(vertical: 20.0),
          labelStyle: Styles.textStyle14(context)
              .copyWith(color: Theme.of(context).colorScheme.onSurface),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(18.r),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.blackColor),
            borderRadius: BorderRadius.all(
              Radius.circular(18.r),
            ),
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            size: 20,
            color: Theme.of(context).iconTheme.color,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
