import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/core/utils/styles.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';

class SubscriptionCountdownTimer extends StatefulWidget {
  final DateTime expiresAt;
  final TextStyle? textStyle;
  final bool showLabel;

  const SubscriptionCountdownTimer({
    super.key,
    required this.expiresAt,
    this.textStyle,
    this.showLabel = true,
  });

  @override
  State<SubscriptionCountdownTimer> createState() => _SubscriptionCountdownTimerState();
}

class _SubscriptionCountdownTimerState extends State<SubscriptionCountdownTimer> {
  late Timer _timer;
  late Duration _remainingTime;

  @override
  void initState() {
    super.initState();
    _calculateRemainingTime();
    _startTimer();
  }

  void _calculateRemainingTime() {
    _remainingTime = widget.expiresAt.difference(DateTime.now());
    debugPrint('[DEBUG_TIMER] Remaining: ${_remainingTime.inSeconds}s for ${widget.expiresAt}');
    if (_remainingTime.isNegative) {
      _remainingTime = Duration.zero;
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _calculateRemainingTime();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    if (duration.isNegative || duration == Duration.zero) return "00:00:00";
    
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    
    if (duration.inDays > 0) {
      return "${duration.inDays} يوم و $hours:$minutes:$seconds";
    }
    return "$hours:$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    final bool isCritical = _remainingTime.inHours < 1 && _remainingTime.inDays == 0;
    final Color color = isCritical ? Colors.red : (widget.textStyle?.color ?? Theme.of(context).colorScheme.onSurface);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.showLabel) ...[
          Text(
            "متبقي: ",
            style: Styles.textStyle12(context).copyWith(color: Theme.of(context).hintColor),
          ),
          4.pw,
        ],
        Text(
          _formatDuration(_remainingTime),
          style: (widget.textStyle ?? Styles.textStyle14SemiBold(context)).copyWith(
            color: color,
            fontWeight: isCritical ? FontWeight.bold : null,
          ),
        ),
        if (isCritical) ...[
          4.pw,
          Icon(Icons.timer_outlined, color: Colors.red, size: 14.r),
        ],
      ],
    );
  }
}
