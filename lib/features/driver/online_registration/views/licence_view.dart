import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';
import 'package:shakshak/core/extentions/padding_extention.dart';
import 'package:shakshak/features/shared/base_layout/presentation/views/base_layout_view.dart';

import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/router/router_helper.dart';
import 'package:shakshak/core/utils/shared_widgets/custom_button.dart';
import 'package:shakshak/core/utils/shared_widgets/custom_text_field.dart';
import 'package:shakshak/generated/l10n.dart';
import 'package:shakshak/features/driver/online_registration/presentation/view_models/driver_registration_cubit.dart';
import 'package:shakshak/features/driver/online_registration/widgets/custom_image_picker_widget.dart';

class LicenceView extends StatefulWidget {
  const LicenceView({super.key});

  @override
  State<LicenceView> createState() => _LicenceViewState();
}

class _LicenceViewState extends State<LicenceView> {
  XFile? frontImage;
  XFile? backImage;
  XFile? selfieImage;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize with stored data if available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.read<DriverRegistrationCubit>();
      if (cubit.storedLicenceImage != null) {
        setState(() {
          frontImage = XFile(cubit.storedLicenceImage!.path);
        });
      }
      if (cubit.storedLicenceBackImage != null) {
        setState(() {
          backImage = XFile(cubit.storedLicenceBackImage!.path);
        });
      }
      if (cubit.storedLicenceSelfieImage != null) {
        setState(() {
          selfieImage = XFile(cubit.storedLicenceSelfieImage!.path);
        });
      }
      if (cubit.storedLicenceExpireDate != null) {
        _controller.text = cubit.storedLicenceExpireDate!;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DriverRegistrationCubit, DriverRegistrationState>(
      listener: (context, state) {
        if (state is LicenceImageStoredState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(S.of(context).licenceStored),
              backgroundColor: Colors.green,
            ),
          );
          navigatePop(context);
        }
      },
      builder: (context, state) {
        return BaseLayoutView(
          title: S.of(context).licence,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(
                  controller: _controller,
                  hint: S.of(context).selectExpireDate,
                  isReadOnly: true,
                  suffix: Icon(
                    Icons.calendar_month,
                    color: AppColors.darkGreyColor,
                    size: 26.r,
                  ),
                  onTap: () async {
                    final now = DateTime.now();
                    final today = DateTime(now.year, now.month, now.day);
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: today,
                      firstDate: today,
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      final dateString =
                          pickedDate.toLocal().toString().split(' ')[0];
                      _controller.text = dateString;
                      context
                          .read<DriverRegistrationCubit>()
                          .storeLicenceExpireDate(dateString);
                    }
                  },
                ),
                20.ph,
                CustomImagePickerWidget(
                  title: S.of(context).frontSide,
                  onImagePicked: (file) => frontImage = file,
                  initialImage: frontImage,
                ),
                20.ph,
                CustomImagePickerWidget(
                  title: S.of(context).backSide,
                  onImagePicked: (file) => backImage = file,
                  initialImage: backImage,
                ),
                20.ph,
                CustomImagePickerWidget(
                  title: S.of(context).selfieWithLicense,
                  onImagePicked: (file) => selfieImage = file,
                  initialImage: selfieImage,
                ),
                30.ph,
                CustomButton(
                  text: S.of(context).done,
                  onTap: () {
                    if (frontImage != null &&
                        backImage != null &&
                        selfieImage != null) {
                      // Store all licence images
                      context
                          .read<DriverRegistrationCubit>()
                          .storeLicenceImages(
                            front: File(frontImage!.path),
                            back: File(backImage!.path),
                            selfie: File(selfieImage!.path),
                          );
                      navigatePop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(S.of(context).pleaseAddAllImages)),
                      );
                    }
                  },
                ),
                18.ph,
              ],
            ).paddingSymmetric(horizontal: 16.w),
          ),
        );
      },
    );
  }
}


