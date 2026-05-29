import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/core/utils/styles.dart';
import 'package:shakshak/generated/l10n.dart';

class AnimatedSearchingText extends StatefulWidget {
  const AnimatedSearchingText({super.key});

  @override
  State<AnimatedSearchingText> createState() => _AnimatedSearchingTextState();
}

class _AnimatedSearchingTextState extends State<AnimatedSearchingText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Timer _timer;
  int _currentIndex = 0;

  List<String> get _messages {
    return [
      S.of(context).searchingDrivers,
      S.of(context).sendingRequest,
      S.of(context).findingBestOffers,
      S.of(context).momentPlease,
    ];
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Text(
        _messages[_currentIndex],
        style: Styles.textStyle16SemiBold(context).copyWith(
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
