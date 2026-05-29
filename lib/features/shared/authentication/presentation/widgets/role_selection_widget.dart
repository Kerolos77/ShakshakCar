import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';

import 'package:shakshak/generated/l10n.dart';
import 'package:shakshak/features/shared/authentication/presentation/view_models/auth_cubit/auth_cubit.dart';
import 'role_selection_option.dart';

class RoleSelectionWidget extends StatelessWidget {
  const RoleSelectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final cubit = context.read<AuthCubit>();

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RoleSelectionOption(
              text: S.of(context).user,
              details: S.of(context).userDescription,
              value: 'user',
              icon: Icons.person,
              groupValue: cubit.roleSelection,
              onChanged: (value) {
                cubit.selectRoleType(value);
              },
            ),
            30.ph,
            RoleSelectionOption(
              text: S.of(context).driver,
              details: S.of(context).driverDescription,
              value: 'driver',
              icon: Icons.drive_eta_rounded,
              groupValue: cubit.roleSelection,
              onChanged: (value) {
                cubit.selectRoleType(value);
              },
            ),
          ],
        );
      },
    );
  }
}


