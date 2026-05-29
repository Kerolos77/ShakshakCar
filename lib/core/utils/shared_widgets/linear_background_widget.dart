import 'package:flutter/material.dart';

import 'package:shakshak/core/resources/app_colors.dart';

class LinearBackgroundWidget extends StatelessWidget {
  const LinearBackgroundWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: AppColors.linearPrimarySecondaryColor)),
    );
  }
}
