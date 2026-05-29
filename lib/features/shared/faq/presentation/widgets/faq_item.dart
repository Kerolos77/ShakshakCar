import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/core/constants/app_const.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';
import 'package:shakshak/core/extentions/padding_extention.dart';
import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/utils/styles.dart';

import 'package:shakshak/features/shared/faq/domain/entities/faqs_entity.dart';

class FaqItem extends StatefulWidget {
  const FaqItem({super.key, required this.faq});

  final FaqEntity faq;

  @override
  State<FaqItem> createState() => _FaqItemState();
}

class _FaqItemState extends State<FaqItem> {
  final ExpandableController expandableController = ExpandableController();

  @override
  Widget build(BuildContext context) {
    return ExpandablePanel(
      controller: expandableController,
      header: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: AppConstant.shadow,
          borderRadius: BorderRadius.circular(
            12.r,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.faq.title ?? '',
                    style: Styles.textStyle16SemiBold(context),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      expandableController.expanded =
                          !expandableController.expanded;
                    });
                  },
                  icon: Icon(
                    expandableController.expanded == false
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_up,
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      collapsed: SizedBox(),
      expanded: Column(
        children: [
          Container(
            width: MediaQuery.sizeOf(context).width,
            margin: EdgeInsets.only(
              top: 10.h,
            ),
            padding: EdgeInsets.symmetric(),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: AppConstant.shadow,
              borderRadius: BorderRadius.circular(
                12.r,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.r),
              child: Text(
                widget.faq.description ?? '',
                style: Styles.textStyle16SemiBold(context).copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.6)),
              ),
            ),
          ),
          8.ph,
        ],
      ).paddingSymmetric(horizontal: 12.w),
      theme: ExpandableThemeData(
        hasIcon: false,
        iconColor: AppColors.primaryColor,
        tapBodyToExpand: false,
        tapBodyToCollapse: false,
        tapHeaderToExpand: false,
        iconSize: 26.r,
      ),
    );
  }
}
