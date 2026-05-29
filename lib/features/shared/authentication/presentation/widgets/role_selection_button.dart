import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/utils/shared_widgets/show_snack_bar.dart';

import 'package:shakshak/core/router/router_helper.dart';
import 'package:shakshak/core/router/routes.dart';
import 'package:shakshak/core/utils/shared_widgets/custom_button.dart';
import 'package:shakshak/generated/l10n.dart';
import 'package:shakshak/features/shared/authentication/presentation/view_models/auth_cubit/auth_cubit.dart';

class RoleSelectionButton extends StatelessWidget {
  const RoleSelectionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: S.of(context).next,
      onTap: () {
        if (context.read<AuthCubit>().roleSelection == '') {
          showSnackBar(
            context,
            S.of(context).pleaseChooseRole,
            S.of(context).error,
            AppColors.redColor,
            ContentType.failure,
          );
        } else {
          navigateTo(context, Routes.loginView);
        }
      },
    );
  }
}


