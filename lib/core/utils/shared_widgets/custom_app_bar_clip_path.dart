import 'package:flutter/material.dart';

class CustomAppBarClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    // Define the center and radii based on the provided calculations
    double cx = size.width * 0.4797256; // Center X
    double cy = size.height * 0.2257130; // Center Y
    double rx = size.width * 1.172870 / 2; // Radius X
    double ry = size.height * 1.544558 / 2; // Radius Y

    // Define an elliptical path
    path.addOval(
        Rect.fromCenter(center: Offset(cx, cy), width: rx * 2, height: ry * 2));

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
