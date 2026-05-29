import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HeaderOfPlaceWidget extends StatelessWidget {
  const HeaderOfPlaceWidget({super.key, required this.header});

  final String header;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Theme.of(context).primaryColor,
      ),
      width: 170.w,
      height: 38.h,
      child: Center(
        child: Text(
          header,
          style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: 13.2.sp),
        ),
      ),
    );
  }
}
