import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shakshak/generated/l10n.dart';

import 'package:shakshak/core/resources/app_colors.dart';
import 'header_of_place_widget.dart';
import 'loading_of_place_header_widget.dart';

class MarkerOfUserOnMapWidget extends StatelessWidget {
  const MarkerOfUserOnMapWidget(
      {super.key,
      required this.buscando,
      required this.header,
      required this.markerHeight});

  final bool buscando;
  final String header;
  final double markerHeight;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: markerHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          buscando == true
              ? HeaderOfPlaceWidget(
                  header: header,
                )
              : LoadingOfPlaceHeaderWidget(),
          Icon(
            Icons.location_on,
            color: AppColors.primaryColor,
            size: 40.r,
          )
          // _getMarker(),
          // Image.asset(
          //   "assets/images/markeruser.png",
          //   height: 150.h,
          // ),
        ],
      ),
    );
  }
}


