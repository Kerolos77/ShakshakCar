import 'package:animate_do/animate_do.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/utils/shared_widgets/custom_button.dart';
import 'package:shakshak/core/utils/shared_widgets/custom_loading_button.dart';
import 'package:shakshak/core/utils/shared_widgets/custom_text_field.dart';
import 'package:shakshak/core/utils/shared_widgets/show_snack_bar.dart';
import 'package:shakshak/core/utils/styles.dart';
import 'package:shakshak/features/shared/review/data/models/review_tags.dart';
import 'package:shakshak/features/shared/review/presentation/view_models/review_cubit.dart';
import 'package:shakshak/generated/l10n.dart';

import 'rating_section.dart';

class ReviewForm extends StatefulWidget {
  final int orderId;
  final bool isDriver;
  final double initialRating;

  const ReviewForm({
    super.key,
    required this.orderId,
    this.isDriver = false,
    this.initialRating = 0.0,
  });

  @override
  State<ReviewForm> createState() => _ReviewFormState();
}

class _ReviewFormState extends State<ReviewForm> {
  final TextEditingController commentController = TextEditingController();
  late double rating;
  final formKey = GlobalKey<FormState>();
  List<String> selectedTags = [];
  String _lastComment = '';

  @override
  void initState() {
    super.initState();
    rating = widget.initialRating > 0 ? widget.initialRating : 3.0;
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  void toggleTag(String tag) {
    setState(() {
      if (selectedTags.contains(tag)) {
        selectedTags.remove(tag);
      } else {
        selectedTags.add(tag);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final tags = widget.isDriver
        ? ReviewTags.getDriverTags(context)
        : ReviewTags.getUserTags(context);

    return BlocListener<ReviewCubit, ReviewState>(
        listener: (context, state) {
          if (state is ReviewSuccess) {
            Navigator.pop(context, {
              'rating': rating,
              'comment': _lastComment,
              'msg': state.reviewModel.msg,
            });
          } else if (state is ReviewFailure) {
            showSnackBar(
              context,
              state.errorMessage,
              S.of(context).errorOccurred,
              AppColors.redColor,
              ContentType.failure,
            );
          }
        },
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FadeInDown(
                duration: const Duration(milliseconds: 500),
                child: Text(
                  S.of(context).rateYourExperience,
                  style: Styles.textStyle20Bold(context),
                ),
              ),
              SizedBox(height: 30.h),
              FadeInDown(
                duration: const Duration(milliseconds: 600),
                child: RatingSection(
                  rating: rating,
                  onRatingUpdate: (rat) {
                    setState(() {
                      rating = rat;
                    });
                  },
                ),
              ),
              SizedBox(height: 30.h),
              // Tags Section
              FadeInDown(
                duration: const Duration(milliseconds: 650),
                child: Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  alignment: WrapAlignment.center,
                  children: tags.map((tag) {
                    final isSelected = selectedTags.contains(tag);
                    return FilterChip(
                      label: Text(tag),
                      selected: isSelected,
                      onSelected: (_) => toggleTag(tag),
                      selectedColor:
                          Theme.of(context).primaryColor.withOpacity(0.2),
                      checkmarkColor: Theme.of(context).primaryColor,
                      labelStyle: TextStyle(
                        color: isSelected
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).textTheme.bodyMedium?.color,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      backgroundColor: Theme.of(context).canvasColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r),
                        side: BorderSide(
                          color: isSelected
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).dividerColor,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 30.h),
              FadeInDown(
                duration: const Duration(milliseconds: 700),
                child: CustomTextField(
                  controller: commentController,
                  hint: S.of(context).writeYourReview,
                  maxLiens: 5,
                  keyType: TextInputType.multiline,
                ),
              ),
              SizedBox(height: 50.h),
              BlocBuilder<ReviewCubit, ReviewState>(
                builder: (context, state) {
                  return FadeInUp(
                    duration: const Duration(milliseconds: 800),
                    child: state is ReviewLoading
                        ? const CustomLoadingButton()
                        : CustomButton(
                            text: S.of(context).submit,
                            onTap: () {
                              if (formKey.currentState!.validate()) {
                                // Combine tags and comment
                                String finalComment = commentController.text;
                                if (selectedTags.isNotEmpty) {
                                  final tagsString = selectedTags.join(', ');
                                  if (finalComment.isNotEmpty) {
                                    finalComment = '$tagsString\n$finalComment';
                                  } else {
                                    finalComment = tagsString;
                                  }
                                }

                                _lastComment = finalComment;

                                context.read<ReviewCubit>().submitReview(
                                      rate: rating.toInt(),
                                      comment: finalComment,
                                      orderId: widget.orderId,
                                    );
                              }
                            },
                            buttonColor: Theme.of(context).primaryColor,
                          ),
                  );
                },
              ),
            ],
          ),
        ));
  }
}
