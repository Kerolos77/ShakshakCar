import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';
import 'package:shakshak/core/extentions/padding_extention.dart';
import 'package:shakshak/core/router/router_helper.dart';
import 'package:shakshak/core/utils/shared_widgets/custom_button.dart';
import 'package:shakshak/features/shared/base_layout/presentation/views/base_layout_view.dart';

import 'package:shakshak/generated/l10n.dart';
import 'package:shakshak/features/driver/online_registration/presentation/view_models/driver_registration_cubit.dart';
import 'package:shakshak/features/driver/online_registration/widgets/custom_image_picker_widget.dart';

class CriminalRecordView extends StatefulWidget {
  const CriminalRecordView({super.key});

  @override
  State<CriminalRecordView> createState() => _CriminalRecordViewState();
}

class _CriminalRecordViewState extends State<CriminalRecordView> {
  XFile? selectedImage;

  @override
  void initState() {
    super.initState();
    // Initialize with stored image if available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.read<DriverRegistrationCubit>();
      if (cubit.storedCriminalRecordImage != null) {
        setState(() {
          selectedImage = XFile(cubit.storedCriminalRecordImage!.path);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DriverRegistrationCubit, DriverRegistrationState>(
      listener: (context, state) {
        if (state is CriminalRecordImageStoredState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(S.of(context).criminalRecordStored),
              backgroundColor: Colors.green,
            ),
          );
          navigatePop(context);
        }
      },
      builder: (context, state) {
        return BaseLayoutView(
          title: S.of(context).criminalRecord,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomImagePickerWidget(
                title: "",
                onImagePicked: (file) => selectedImage = file,
                initialImage: selectedImage,
              ),
              30.ph,
              CustomButton(
                text: S.of(context).done,
                onTap: () {
                  if (selectedImage != null) {
                    context
                        .read<DriverRegistrationCubit>()
                        .storeCriminalRecordImage(
                          File(selectedImage!.path),
                        );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(S.of(context).pleaseSelectImage),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
              ),
              18.ph,
            ],
          ).paddingSymmetric(horizontal: 16.w),
        );
      },
    );
  }
}


