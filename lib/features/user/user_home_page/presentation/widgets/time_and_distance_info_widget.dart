import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TimeAndDistanceInfoWidget extends StatelessWidget {
  const TimeAndDistanceInfoWidget(
      {super.key, required this.time, required this.distance});

  final String time;
  final String distance;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // النص على اليسار (الوقت)
            Text(
              time != null ? 'Time: $time' : '',
              style: TextStyle(
                fontSize: 13.sp,
              ),
            ),
            // النص على اليمين (المسافة)
            Text(
              distance != null ? 'Distance: $distance km' : '',
              style: TextStyle(
                fontSize: 13.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
