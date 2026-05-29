import 'package:flutter/material.dart';

class AdModel {
  final String title;
  final String subtitle;
  final String? image;
  final List<Color>? gradientColors;

  AdModel({
    required this.title,
    required this.subtitle,
    this.image,
    this.gradientColors,
  });
}
