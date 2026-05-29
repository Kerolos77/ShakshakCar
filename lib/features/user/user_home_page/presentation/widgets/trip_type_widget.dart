import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/core/resources/app_colors.dart';

import 'package:shakshak/features/user/user_home_page/data/models/trip_type_model.dart';

class TripTypeWidget extends StatefulWidget {
  const TripTypeWidget({
    super.key,
    required this.tripTypeModel,
    required this.isSelected, // New parameter to handle selection state
    required this.onTap, // New callback to handle taps
  });

  final TripTypeModel tripTypeModel;
  final bool isSelected;
  final VoidCallback onTap; // Callback when tapped

  @override
  State<TripTypeWidget> createState() => _TripTypeWidgetState();
}

class _TripTypeWidgetState extends State<TripTypeWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap, // Call the onTap callback when the widget is tapped
      child: Container(
        width: 100.w,
        decoration: BoxDecoration(
          color: widget.isSelected
              ? Theme.of(context).colorScheme.secondary
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: EdgeInsets.all(3.r),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Padding(
                        padding: EdgeInsets.only(left: 5.w),
                        child: Icon(
                          Icons.car_rental,
                          color: AppColors.primaryColor,
                          // widget.tripTypeModel.image,
                          size: 30.r,
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional.center,
                      child: Padding(
                        padding: EdgeInsets.only(left: 5.w),
                        child: Text(
                          widget.tripTypeModel.type,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              widget.isSelected
                  ? Flexible(
                      child: InkWell(
                        onTap: () {}, // Keep this for any other action
                        child: Icon(
                          Icons.info_outline,
                          color: AppColors.primaryColor,
                          size: 20.r,
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
