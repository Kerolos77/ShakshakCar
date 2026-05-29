import 'package:flutter/material.dart';

import 'package:shakshak/generated/l10n.dart';

class ReviewTags {
  static List<String> getUserTags(BuildContext context) {
    return [
      S.of(context).comfortableCar,
      S.of(context).cleanCar,
      S.of(context).safeDriving,
      S.of(context).politeDriver,
      S.of(context).onTime,
      S.of(context).goodMusic,
      S.of(context).acOn,
    ];
  }

  static List<String> getDriverTags(BuildContext context) {
    return [
      S.of(context).politePassenger,
      S.of(context).waitingOnTime,
      S.of(context).quietPassenger,
      S.of(context).cleanPassenger,
      S.of(context).respectful,
    ];
  }
}


