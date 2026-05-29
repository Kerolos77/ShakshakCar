import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';
import 'package:shakshak/core/extentions/padding_extention.dart';
import 'package:shakshak/core/utils/shared_widgets/custom_text_field.dart';
import 'package:shakshak/features/shared/base_layout/presentation/views/base_layout_view.dart';
import 'package:shakshak/generated/l10n.dart';

import 'package:shakshak/core/utils/validations.dart';

import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/router/router_helper.dart';
import 'package:shakshak/core/utils/shared_widgets/custom_button.dart';
import 'package:shakshak/features/driver/online_registration/presentation/view_models/driver_registration_cubit.dart';
import 'package:shakshak/features/driver/online_registration/widgets/custom_image_picker_widget.dart';

class NationalIdView extends StatefulWidget {
  const NationalIdView({super.key});

  @override
  State<NationalIdView> createState() => _NationalIdViewState();
}

class _NationalIdViewState extends State<NationalIdView> {
  XFile? frontImage;
  XFile? backImage;
  XFile? selfieImage;
  final TextEditingController _expireDateNIDController =
      TextEditingController();
  final TextEditingController _nIDController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Initialize with stored data if available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.read<DriverRegistrationCubit>();
      if (cubit.storedNationalIdImage != null) {
        setState(() {
          frontImage = XFile(cubit.storedNationalIdImage!.path);
        });
      }
      if (cubit.storedNationalIdBackImage != null) {
        setState(() {
          backImage = XFile(cubit.storedNationalIdBackImage!.path);
        });
      }
      if (cubit.storedNationalIdSelfieImage != null) {
        setState(() {
          selfieImage = XFile(cubit.storedNationalIdSelfieImage!.path);
        });
      }
      if (cubit.storedNationalIdNumber != null) {
        // We need a controller for ID number if we want to restore it, or proper initial value handling
        // Since CustomTextField uses a controller externally or internal, let's see how it's used.
        // It seems current usage doesn't pass controller for ID number.
        // We should add a controller for ID number.
        _nIDController.text = cubit.storedNationalIdNumber!;
      }
      if (cubit.storedNationalIdExpireDate != null) {
        _expireDateNIDController.text = cubit.storedNationalIdExpireDate!;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    DriverRegistrationCubit cubit = context.read<DriverRegistrationCubit>();
    return BlocConsumer<DriverRegistrationCubit, DriverRegistrationState>(
      listener: (context, state) {
        if (state is NationalIdImageStoredState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(S.of(context).nationalIdStored),
              backgroundColor: Colors.green,
            ),
          );
          navigatePop(context);
        }
      },
      builder: (context, state) {
        return BaseLayoutView(
          title: S.of(context).nationalId,
          body: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(
                    hint: S.of(context).idNumber,
                    keyType: TextInputType.number,
                    controller: _nIDController,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(14),
                    ],
                    validator: Validation.validateNationalId(context),
                    onchange: (value) {
                      if (value != null) {
                        cubit.storeNationalIdNumber(value);
                      }
                    },
                  ),
                  12.ph,
                  CustomTextField(
                    controller: _expireDateNIDController,
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
                        _expireDateNIDController.text = dateString;
                        cubit.storeNationalIdExpireDate(dateString);
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
                    title: S.of(context).selfieWithId,
                    onImagePicked: (file) => selfieImage = file,
                    initialImage: selfieImage,
                  ),
                  30.ph,
                  CustomButton(
                    text: S.of(context).done,
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        if (frontImage != null &&
                            backImage != null &&
                            selfieImage != null) {
                          // Store all National ID images
                          cubit.storeNationalIdImages(
                            front: File(frontImage!.path),
                            back: File(backImage!.path),
                            selfie: File(selfieImage!.path),
                          );
                          navigatePop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(S.of(context).pleaseAddAllImages),
                            ),
                          );
                        }
                      }
                    },
                  ),
                  18.ph,
                ],
              ).paddingSymmetric(horizontal: 16.w),
            ),
          ),
        );
      },
    );
  }
}


