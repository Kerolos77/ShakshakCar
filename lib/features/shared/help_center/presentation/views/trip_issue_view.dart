import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';
import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/utils/shared_widgets/custom_button.dart';
import 'package:shakshak/core/utils/shared_widgets/custom_loading_button.dart';
import 'package:shakshak/core/utils/shared_widgets/custom_text_field.dart';
import 'package:shakshak/core/utils/shared_widgets/ride_destination_widget.dart';
import 'package:shakshak/core/utils/shared_widgets/show_snack_bar.dart';
import 'package:shakshak/core/utils/styles.dart';
import 'package:shakshak/core/utils/validations.dart';
import 'package:shakshak/features/shared/contact_us/domain/usecases/get_contact_us_usecase.dart';
import 'package:shakshak/features/shared/contact_us/domain/usecases/write_us_usecase.dart';
import 'package:shakshak/features/shared/base_layout/presentation/views/base_layout_view.dart';
import 'package:shakshak/features/shared/contact_us/presentation/view_models/contact_us_cubit.dart';
import 'package:shakshak/features/user/user_home/data/models/new-ride/new_ride_data.dart';
import 'package:shakshak/generated/l10n.dart';
import 'package:shakshak/core/services/service_locator.dart';
import 'package:shakshak/core/services/user_storage_service.dart';

class TripIssueView extends StatefulWidget {
  final NewRideData ride;

  const TripIssueView({super.key, required this.ride});

  @override
  State<TripIssueView> createState() => _TripIssueViewState();
}

class _TripIssueViewState extends State<TripIssueView> {
  final TextEditingController descriptionController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ContactUsCubit(sl<GetContactUsUseCase>(), sl<WriteUsUseCase>()),
      child: BaseLayoutView(
        title: S.of(context).reportIssueRecentTrip,
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTripCard(context),
                24.ph,
                Text(
                  S.of(context).describeIssue,
                  style: Styles.textStyle18Bold(context),
                ),
                8.ph,
                CustomTextField(
                  controller: descriptionController,
                  hint: S.of(context).writeComment,
                  maxLiens: 8,
                  autoValidateMode: AutovalidateMode.onUserInteraction,
                  validator: Validation.validateDescription(context),
                ),
                24.ph,
                BlocConsumer<ContactUsCubit, ContactUsState>(
                  listener: (context, state) {
                    if (state is WriteUsSuccess) {
                      showSnackBar(
                        context,
                        "${S.of(context).doneSuccessfully}. ${state.writeUsEntity.message ?? ''}",
                        S.of(context).doneSuccessfully,
                        AppColors.primaryColor,
                        ContentType.success,
                      );
                      Navigator.pop(context);
                    }
                    if (state is WriteUsFailure) {
                      showSnackBar(
                        context,
                        state.errorMessage,
                        S.of(context).errorOccurred,
                        AppColors.redColor,
                        ContentType.failure,
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is! WriteUsLoading) {
                      return CustomButton(
                        text: S.of(context).submit,
                        onTap: () {
                          if (formKey.currentState!.validate()) {
                            // Prepend Order ID to the description for backend tracking
                            final fullMessage =
                                "Trip Issue [ID: ${widget.ride.id}]: ${descriptionController.text}";
                            final userEmail =
                                UserStorageService.getUser()?.email ??
                                    "support@shakshak.com";
                            context.read<ContactUsCubit>().writeUs(
                                  email: userEmail,
                                  description: fullMessage,
                                );
                          }
                        },
                      );
                    } else {
                      return const CustomLoadingButton();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTripCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${S.of(context).transactionId}: ${widget.ride.id}",
                style: Styles.textStyle14Medium(context)
                    .copyWith(color: Colors.grey),
              ),
              Text(
                "${widget.ride.amount} ${S.of(context).currency}",
                style: Styles.textStyle16Bold(context)
                    .copyWith(color: AppColors.primaryColor),
              ),
            ],
          ),
          const Divider(height: 24),
          RideDestinationWidget(
            from: widget.ride.sourceAddress,
            to: widget.ride.destinationAddress,
          ),
        ],
      ),
    );
  }
}
