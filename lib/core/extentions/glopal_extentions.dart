import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension ImagePath on String {
  String get imageToPng => 'assets/images/$this.png';

  String get iconToPng => 'assets/icons/$this.png';

  String get toSvg => 'assets/icons/$this.svg';

  String get toJpg => 'assets/images/$this.jpg';
}

extension ThemeShortCuts on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;
}

extension Emptypadding on num {
  SizedBox get ph => SizedBox(height: toDouble().h);

  SizedBox get pw => SizedBox(width: toDouble().w);
}

extension EmptypaddingSliver on num {
  SliverToBoxAdapter get sliverPh =>
      SliverToBoxAdapter(child: SizedBox(height: toDouble().h));

  SliverToBoxAdapter get sliverPw =>
      SliverToBoxAdapter(child: SizedBox(width: toDouble().w));
}

extension MediaQueryValues on BuildContext {
  double get width => MediaQuery.of(this).size.width;

  double get height => MediaQuery.of(this).size.height;
}
