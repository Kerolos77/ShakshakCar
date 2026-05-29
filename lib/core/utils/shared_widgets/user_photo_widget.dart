/*
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'custom_cached_network_image.dart';

class UserPhotoWidget extends StatelessWidget {
  const UserPhotoWidget({
    super.key,
    required this.img,
  });

  final String img;

  @override
  Widget build(BuildContext context) {
    return Container(
        clipBehavior: Clip.hardEdge,
        width: 70.r,
        height: 70.r,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black38,
              spreadRadius: -5,
              offset: Offset(0, 0),
              blurRadius: 10,
            )
          ],
        ),
        child: CustomCachedNetworkImage(
          imgUrl: img,
          width: 70.r,
          height: 70.r,
          errorIconSize: 20.r,
        ));
  }
}
*/
