import 'package:flutter/material.dart';

extension MarginX on Widget {
  Widget marginAll(double value, {Key? key}) => Container(
        key: key,
        margin: EdgeInsets.all(value),
        child: this,
      );

  Widget marginOnly({
    double left = 0.0,
    double top = 0.0,
    double right = 0.0,
    double bottom = 0.0,
    Key? key,
  }) =>
      Container(
        key: key,
        margin:
            EdgeInsets.only(top: top, left: left, bottom: bottom, right: right),
        child: this,
      );

  Widget marginLTRB(
    double left,
    double top,
    double right,
    double bottom, {
    Key? key,
  }) =>
      Container(
        key: key,
        margin: EdgeInsets.fromLTRB(left, top, right, bottom),
        child: this,
      );

  Widget marginSymmetric({
    double vertical = 0.0,
    double horizontal = 0.0,
    Key? key,
  }) =>
      Container(
        key: key,
        margin: EdgeInsets.symmetric(
          vertical: vertical,
          horizontal: horizontal,
        ),
        child: this,
      );
}
