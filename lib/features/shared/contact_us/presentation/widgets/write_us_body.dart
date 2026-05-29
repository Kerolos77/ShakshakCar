import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';
import 'package:shakshak/core/utils/shared_widgets/custom_button.dart';
import 'package:shakshak/core/utils/shared_widgets/custom_text_field.dart';
import 'package:shakshak/core/utils/styles.dart';
import 'package:shakshak/generated/l10n.dart';

import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/utils/shared_widgets/custom_loading_button.dart';
import 'package:shakshak/core/utils/shared_widgets/show_snack_bar.dart';
import 'package:shakshak/core/utils/validations.dart';
import 'package:shakshak/generated/assets.dart';
import 'package:shakshak/features/shared/contact_us/presentation/view_models/contact_us_cubit.dart';
import 'package:shakshak/core/services/user_storage_service.dart';

class WriteUsBody extends StatefulWidget {
  const WriteUsBody({super.key});

  @override
  State<WriteUsBody> createState() => _WriteUsBodyState();
}

class _WriteUsBodyState extends State<WriteUsBody> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final user = UserStorageService.getUser();
    if (user != null && user.email != null) {
      emailController.text = user.email!;
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context).writeUs,
              style: Styles.textStyle20Bold(context),
            ),
            Text(
              S.of(context).describeIssue,
              style: Styles.textStyle16(context),
            ),
            16.ph,
            CustomTextField(
              controller: emailController,
              hint: S.of(context).email,
              autoValidateMode: AutovalidateMode.onUserInteraction,
              validator: Validation.validateEmail(context),
              keyType: TextInputType.emailAddress,
              prefix: Padding(
                padding: EdgeInsets.all(8.r),
                child: SvgPicture.asset(Assets.svgEmail),
              ),
            ),
            12.ph,
            CustomTextField(
              controller: descriptionController,
              hint: S.of(context).describeFeedback,
              maxLiens: 6,
              autoValidateMode: AutovalidateMode.onUserInteraction,
              validator: Validation.validateDescription(context),
              keyType: TextInputType.text,
            ),
            20.ph,
            BlocConsumer<ContactUsCubit, ContactUsState>(
              listener: (context, state) {
                if (state is WriteUsSuccess) {
                  showSnackBar(
                      context,
                      state.writeUsEntity.message ?? '',
                      S.of(context).doneSuccessfully,
                      AppColors.primaryColor,
                      ContentType.success);
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
                        context.read<ContactUsCubit>().writeUs(
                              email: emailController.text,
                              description: descriptionController.text,
                            );
                      }
                    },
                  );
                } else {
                  return const CustomLoadingButton();
                }
              },
            ),
            20.ph,
          ],
        ),
      ),
    );
  }
}
