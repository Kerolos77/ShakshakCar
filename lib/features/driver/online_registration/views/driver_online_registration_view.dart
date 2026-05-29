import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';
import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/router/router_helper.dart';
import 'package:shakshak/core/router/routes.dart';
import 'package:shakshak/core/utils/shared_widgets/custom_button.dart';
import 'package:shakshak/core/utils/shared_widgets/custom_text_field.dart';
import 'package:shakshak/features/shared/base_layout/presentation/views/base_layout_view.dart';

import 'package:shakshak/generated/l10n.dart';
import 'package:shakshak/core/utils/styles.dart';
import 'package:shakshak/features/driver/online_registration/presentation/view_models/driver_registration_cubit.dart';
import 'package:shakshak/features/driver/online_registration/widgets/custom_online_registration_item.dart';

class DriverOnlineRegistrationView extends StatefulWidget {
  const DriverOnlineRegistrationView({super.key});

  @override
  State<DriverOnlineRegistrationView> createState() =>
      _DriverOnlineRegistrationViewState();
}

class _DriverOnlineRegistrationViewState
    extends State<DriverOnlineRegistrationView> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize with stored birth date if available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.read<DriverRegistrationCubit>();
      if (cubit.storedNationalIdBirthDate != null) {
        setState(() {
          _controller.text = cubit.storedNationalIdBirthDate!;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DriverRegistrationCubit, DriverRegistrationState>(
      listener: (context, state) {
        if (state is DriverRegistrationSuccess) {
          navigateAndFinish(context, Routes.registrationPendingView);
        } else if (state is DriverRegistrationFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: AppColors.redColor,
            ),
          );
        }
      },
      builder: (context, state) {
        final cubit = context.watch<DriverRegistrationCubit>();
        int completedSteps = 0;
        if (cubit.storedNationalIdBirthDate != null) completedSteps++;
        if (cubit.storedCriminalRecordImage != null) completedSteps++;
        if (cubit.storedNationalIdImage != null) completedSteps++;
        if (cubit.storedLicenceImage != null) completedSteps++;
        if (cubit.storedCarLicenceImage != null) completedSteps++;
        if (cubit.storedCarImage != null) completedSteps++;

        const totalSteps = 6;
        final progress = completedSteps / totalSteps;

        return BaseLayoutView(
          title: S.of(context).onlineRegistration,
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProgressHeader(
                    context, completedSteps, totalSteps, progress),
                24.ph,
                Text(
                  S.of(context).personalInformation,
                  style: Styles.textStyle16Bold(context),
                ),
                12.ph,
                CustomTextField(
                  controller: _controller,
                  hint: S.of(context).nationalIdBirthDate,
                  isReadOnly: true,
                  suffix: Icon(
                    Icons.calendar_month,
                    color: AppColors.darkGreyColor,
                    size: 26.r,
                  ),
                  onTap: () async {
                    final now = DateTime.now();
                    final minAgeDate =
                        DateTime(now.year - 20, now.month, now.day);
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: minAgeDate,
                      firstDate: DateTime(1960),
                      lastDate: minAgeDate,
                    );
                    if (pickedDate != null) {
                      _controller.text =
                          pickedDate.toLocal().toString().split(' ')[0];
                      context
                          .read<DriverRegistrationCubit>()
                          .storeNationalIdBirthDate(_controller.text);
                    }
                  },
                ),
                18.ph,
                CustomOnlineRegistrationItem(
                  title: S.of(context).nationalId,
                  icon: Icons.badge_outlined,
                  isCompleted: cubit.storedNationalIdImage != null,
                  onTap: () {
                    navigateTo(context, Routes.nationalIdView);
                  },
                ),
                24.ph,
                Text(
                  S.of(context).licencesAndDocuments,
                  style: Styles.textStyle16Bold(context),
                ),
                12.ph,
                CustomOnlineRegistrationItem(
                  title: S.of(context).criminalRecord,
                  icon: Icons.assignment_ind_outlined,
                  isCompleted: cubit.storedCriminalRecordImage != null,
                  onTap: () {
                    navigateTo(context, Routes.criminalRecordView);
                  },
                ),
                12.ph,
                CustomOnlineRegistrationItem(
                  title: S.of(context).licence,
                  icon: Icons.contact_mail_outlined,
                  isCompleted: cubit.storedLicenceImage != null,
                  onTap: () {
                    navigateTo(context, Routes.licenceView);
                  },
                ),
                12.ph,
                CustomOnlineRegistrationItem(
                  title: S.of(context).carLicence,
                  icon: Icons.drive_eta_outlined,
                  isCompleted: cubit.storedCarLicenceImage != null,
                  onTap: () {
                    navigateTo(context, Routes.carLicenceView);
                  },
                ),
                24.ph,
                Text(
                  S.of(context).vehicleInformation,
                  style: Styles.textStyle16Bold(context),
                ),
                12.ph,
                CustomOnlineRegistrationItem(
                  title: S.of(context).car,
                  icon: Icons.directions_car_filled_outlined,
                  isCompleted: cubit.storedCarImage != null,
                  onTap: () {
                    navigateTo(context, Routes.carView);
                  },
                ),
                40.ph,
                CustomButton(
                  text: state is DriverRegistrationLoading
                      ? S.of(context).submitting
                      : S.of(context).sendDocs,
                  onTap: state is DriverRegistrationLoading
                      ? null
                      : () {
                          context
                              .read<DriverRegistrationCubit>()
                              .submitDriverRegistration();
                        },
                ),
                30.ph,
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProgressHeader(
      BuildContext context, int completed, int total, double progress) {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryColor,
            AppColors.primaryColor.withOpacity(0.8)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                S.of(context).registrationProgress,
                style: Styles.textStyle16SemiBold(context)
                    .copyWith(color: Colors.white),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  "$completed/$total",
                  style: Styles.textStyle14Bold(context)
                      .copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
          16.ph,
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white.withOpacity(0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              minHeight: 10.h,
            ),
          ),
          12.ph,
          Text(
            completed == total
                ? S.of(context).allStepsCompleted
                : S.of(context).completeStepsToBecomeDriver,
            style: Styles.textStyle14(context)
                .copyWith(color: Colors.white.withOpacity(0.9)),
          ),
        ],
      ),
    );
  }
}
