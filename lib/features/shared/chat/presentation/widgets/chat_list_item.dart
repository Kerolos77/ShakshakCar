import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';
import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/utils/styles.dart';

class ChatListItem extends StatelessWidget {
  const ChatListItem({
    super.key,
    required this.isSent,
    required this.message,
  });

  final dynamic isSent;
  final Map<String, dynamic> message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisAlignment:
            isSent ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (isSent) ...[
            CircleAvatar(
              backgroundColor: AppColors.primaryColor,
              backgroundImage: AssetImage(message["avatar"]),
              radius: 25.r,
            ),
            12.pw,
          ],
          Flexible(
            child: Container(
              margin: EdgeInsets.symmetric(
                vertical: 8.h,
              ),
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: isSent
                    ? AppColors.primaryColor
                    : AppColors.primaryColor.withOpacity(0.6),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.r),
                  topRight: Radius.circular(30.r),
                  bottomLeft: isSent ? Radius.circular(30.r) : Radius.zero,
                  bottomRight: isSent ? Radius.zero : Radius.circular(30.r),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message["text"],
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  6.ph,
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      message["time"],
                      style: Styles.textStyle10(context).copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (!isSent) ...[
            12.pw,
            CircleAvatar(
              backgroundColor: AppColors.primaryColor.withOpacity(0.6),
              backgroundImage: AssetImage(message["avatar"]),
              radius: 25.r,
            ),
          ]
        ],
      ),
    );
  }
}
