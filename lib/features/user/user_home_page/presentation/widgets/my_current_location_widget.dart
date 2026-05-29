import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyCurrentLocationWidget extends StatelessWidget {
  MyCurrentLocationWidget({super.key, required this.onPressed});

  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: "My Location",
      mini: true,
      onPressed: onPressed,
      backgroundColor: Theme.of(context).cardColor,
      child: Icon(
        Icons.gps_fixed,
        color: Theme.of(context).iconTheme.color,
        size: 30.w,
      ),
    );
  }
}
