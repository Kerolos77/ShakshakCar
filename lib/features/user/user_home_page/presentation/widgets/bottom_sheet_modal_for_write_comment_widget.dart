import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/utils/shared_widgets/custom_button.dart';
import 'package:shakshak/generated/l10n.dart';

class BottomSheetModalForWriteCommentWidget extends StatelessWidget {
  const BottomSheetModalForWriteCommentWidget(
      {super.key,
      required this.onPressedClearButton,
      required this.onPressedDoneButton,
      required this.commentFocusNode,
      required this.commentController});

  final Function() onPressedClearButton;
  final Function() onPressedDoneButton;
  final FocusNode commentFocusNode;
  final TextEditingController commentController;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double containerHeight = screenHeight * 0.93;
    return SingleChildScrollView(
      // physics:
      //     AlwaysScrollableScrollPhysics(),
      child: Container(
        width: double.infinity,
        height: containerHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(27.r),
            topRight: Radius.circular(27.r),
          ),
        ),
        child: Column(
          children: [
            // Ø§Ù„Ø¹Ù†Ø§ØµØ± Ø§Ù„Ø£Ø®Ø±Ù‰ ÙÙŠ Ø§Ù„Ù€ BottomSheet Ù‡Ù†Ø§

            // Ø­Ù‚Ù„ Ø§Ù„Ù†Øµ (TextField) Ø¯Ø§Ø®Ù„ Ø§Ù„Ù€ BottomSheet
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    focusNode: commentFocusNode,
                    style: TextStyle(
                      fontSize: 17.sp,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                    controller: commentController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: S.of(context).writeComment,
                      hintStyle: TextStyle(color: Theme.of(context).hintColor),
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 20.0),
                      labelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(18.r),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: AppColors.blackColor),
                        borderRadius: BorderRadius.all(
                          Radius.circular(18.r),
                        ),
                      ),
                      // Ø£ÙŠÙ‚ÙˆÙ†Ø© Clear Ù„Ù…Ø³Ø­ Ø§Ù„ØªØ¹Ù„ÙŠÙ‚Ø§Øª
                      prefixIcon: IconButton(
                        icon: const Icon(
                          Icons.clear,
                        ),
                        onPressed: onPressedClearButton,
                      ),
                      // suffixIcon: _commentController.text.isNotEmpty
                      //     ? IconButton(
                      //         icon: Icon(Icons.clear, color: AppColors.blackColors),
                      //         onPressed: () {
                      //           setState(() {
                      //             _commentController.clear();
                      //           });
                      //         },
                      //       )
                      //     : null,
                    ),
                  ),
                  // CheckboxListTile(
                  //   checkColor: AppColors
                  //       .blackColors,
                  //   title: Text(
                  //     'Ø§Ù„Ù…Ø³Ø§ÙØ±ÙŠÙ† Ø£ÙƒØ«Ø± Ù…Ù† 4 Ø£Ø´Ø®Ø§Øµ',
                  //     style: TextStyle(
                  //       fontSize: 14.sp,
                  //         color: AppColors
                  //             .blackColors),
                  //   ),
                  //   value:
                  //       travelersChecked,
                  //   onChanged:
                  //       (value) {
                  //     setState(() {
                  //       travelersChecked =
                  //           value!;
                  //       _updateComment();
                  //     });
                  //   },
                  //   activeColor: AppColors
                  //       .primaryColor(
                  //           context),
                  //   // ÙŠÙ…ÙƒÙ†Ùƒ ØªØºÙŠÙŠØ± Ù‡Ø°Ø§ Ø§Ù„Ù„ÙˆÙ† Ø¥Ù„Ù‰ Ø§Ù„Ù„ÙˆÙ† Ø§Ù„Ø°ÙŠ ØªÙØ¶Ù„Ù‡
                  // ),
                  // CheckboxListTile(
                  //   checkColor: AppColors
                  //       .blackColors,
                  //   title: Text(
                  //     'Ø­Ù‚Ø§Ø¦Ø¨ Ø³ÙØ±',
                  //     style: TextStyle(
                  //         color: AppColors
                  //             .blackColors),
                  //   ),
                  //   value:
                  //       luggageChecked,
                  //   onChanged:
                  //       (value) {
                  //     setState(() {
                  //       luggageChecked =
                  //           value!;
                  //       _updateComment();
                  //     });
                  //   },
                  //   activeColor:
                  //       AppColors
                  //           .redColor,
                  // ),
                  const SizedBox(height: 20),
                  CustomButton(
                    buttonColor: AppColors.primaryColor,
                    height: 45.h,
                    borderRadius: 18.r,
                    onTap: onPressedDoneButton,
                    text: S.of(context).done,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
