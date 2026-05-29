import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/core/constants/app_const.dart';
import 'package:shakshak/core/utils/styles.dart';
import 'package:shakshak/features/driver/home/presentation/view_models/driver_home_cubit.dart';
import 'package:shakshak/generated/l10n.dart';

class OnlineOfflineToggleButton extends StatelessWidget {
  const OnlineOfflineToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DriverHomeCubit, DriverHomeState>(
      builder: (context, state) {
        final isOnline = context.read<DriverHomeCubit>().isOnline;
        
        return Padding(
          padding: EdgeInsets.zero,
          child: GestureDetector(
            onTap: () {
              context
                  .read<DriverHomeCubit>()
                  .driverToggleOnline(value: isOnline ? 0 : 1);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 140.w,
              height: 40.h,
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              decoration: BoxDecoration(
                color: isOnline ? Colors.green : Colors.red,
                boxShadow: AppConstant.shadow,
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: Stack(
                children: [
                  AnimatedAlign(
                    alignment:
                        isOnline ? Alignment.centerRight : Alignment.centerLeft,
                    duration: const Duration(milliseconds: 300),
                    child: Container(
                      width: 48.r,
                      height: 32.r,
                      decoration: BoxDecoration(
                        color: isOnline ? Colors.green : Colors.red,
                        borderRadius: BorderRadius.circular(
                          20.r,
                        ),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.surface,
                          width: 2.r,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        isOnline ? Icons.check : Icons.close,
                        color: Theme.of(context).colorScheme.surface,
                        size: 20.r,
                      ),
                    ),
                  ),
                  Align(
                    alignment:
                        isOnline ? Alignment.centerLeft : Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Text(
                        isOnline ? S.of(context).online : S.of(context).offline,
                        style: Styles.textStyle16Bold(context).copyWith(
                          color: Theme.of(context).colorScheme.surface,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
