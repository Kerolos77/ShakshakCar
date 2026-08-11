import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/core/utils/styles.dart';

class TicketStatusBadge extends StatelessWidget {
  final String status;

  const TicketStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final config = _getConfig(status);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: config['color'].withOpacity(0.12),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: config['color'].withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.r,
            height: 6.r,
            decoration: BoxDecoration(
              color: config['color'],
              shape: BoxShape.circle,
            ),
          ),
          4.horizontalSpace,
          Text(
            config['label'],
            style: Styles.textStyle12Regular(context).copyWith(
              color: config['color'],
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getConfig(String status) {
    switch (status) {
      case 'open':
        return {'color': const Color(0xFF2196F3), 'label': 'مفتوح'};
      case 'in_review':
        return {'color': const Color(0xFFFF9800), 'label': 'قيد المراجعة'};
      case 'resolved':
        return {'color': const Color(0xFF4CAF50), 'label': 'تم الحل'};
      case 'closed':
        return {'color': const Color(0xFF9E9E9E), 'label': 'مغلق'};
      default:
        return {'color': const Color(0xFF9E9E9E), 'label': status};
    }
  }
}
