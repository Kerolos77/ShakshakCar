import 'package:flutter/material.dart';
import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/utils/styles.dart';

class FailureView extends StatelessWidget {
  const FailureView({
    super.key,
    required this.errorMessage,
  });

  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Lottie.asset(AppAssets.errorLottiePath),
            Text(
              textAlign: TextAlign.center,
              errorMessage,
              style: Styles.textStyle22Bold(context)
                  .copyWith(color: AppColors.secondaryColor),
            ),
          ],
        ),
      ),
    );
  }
}
