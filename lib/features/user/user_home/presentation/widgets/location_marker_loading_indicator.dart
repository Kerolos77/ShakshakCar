import 'package:flutter/material.dart';

import 'header_of_place_widget.dart';

class LocationMarkerLoadingIndicator extends StatefulWidget {
  const LocationMarkerLoadingIndicator({Key? key}) : super(key: key);

  @override
  _LocationMarkerLoadingIndicatorState createState() =>
      _LocationMarkerLoadingIndicatorState();
}

class _LocationMarkerLoadingIndicatorState
    extends State<LocationMarkerLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(
          parent: _controller, curve: Curves.fastEaseInToSlowEaseOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
        scale: _animation,
        child: HeaderOfPlaceWidget(
          header: "Loading Location...",
        )
        // const Icon(
        //   Icons.location_on,
        //   color: Colors.red,
        //   size: 50,
        // ),
        );
  }
}
