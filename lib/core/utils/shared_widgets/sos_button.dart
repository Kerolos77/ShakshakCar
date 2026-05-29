import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shakshak/core/router/routes.dart';

class SOSButton extends StatelessWidget {
  final String phoneNumber;

  const SOSButton({
    super.key,
    this.phoneNumber = '112', // Default universal emergency
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(Routes.sosView),
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: const BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.sos,
              color: Colors.white,
              size: 24.r,
            ),
            Text(
              'SOS',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 10.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
