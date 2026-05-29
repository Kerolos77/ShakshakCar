import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/utils/shared_widgets/show_snack_bar.dart';
import 'package:shakshak/features/shared/base_layout/presentation/views/base_layout_view.dart';
import 'package:shakshak/features/shared/review/presentation/view_models/review_cubit.dart';
import 'package:shakshak/features/shared/review/presentation/widgets/review_form.dart';

import 'package:shakshak/core/services/service_locator.dart';
import 'package:shakshak/generated/l10n.dart';

class ReviewView extends StatefulWidget {
  final int orderId;
  final bool isDriver;
  final double initialRating;

  const ReviewView({
    super.key,
    required this.orderId,
    this.isDriver = true,
    this.initialRating = 0.0,
  });

  @override
  State<ReviewView> createState() => _ReviewViewState();
}

class _ReviewViewState extends State<ReviewView> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReviewCubit(sl(), sl()),
      child: BaseLayoutView(
        title: S.of(context).review,
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: ReviewForm(
            orderId: widget.orderId,
            isDriver: widget.isDriver,
            initialRating: widget.initialRating,
          ),
        ),
      ),
    );
  }
}
