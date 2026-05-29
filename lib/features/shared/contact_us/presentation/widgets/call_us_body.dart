import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';
import 'package:shakshak/core/extentions/padding_extention.dart';
import 'package:shakshak/core/utils/common_use.dart';
import 'package:shakshak/core/utils/styles.dart';
import 'package:shakshak/features/shared/contact_us/presentation/view_models/contact_us_cubit.dart';
import 'package:shakshak/generated/l10n.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CallUsBody extends StatefulWidget {
  const CallUsBody({
    super.key,
  });

  @override
  State<CallUsBody> createState() => _CallUsBodyState();
}

class _CallUsBodyState extends State<CallUsBody> {
  @override
  void initState() {
    super.initState();
    context.read<ContactUsCubit>().getContactUs();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContactUsCubit, ContactUsState>(
      builder: (context, state) {
        if (state is ContactUsSuccess) {
          return Column(
            children: [
              InkWell(
                onTap: () {
                  makePhoneCall(
                      phoneNumber: state.contactUsEntity.data!.phone ?? '');
                },
                borderRadius: BorderRadius.circular(16.r),
                child: Row(
                  children: [
                    Icon(
                      Icons.call,
                      color: Colors.black,
                      size: 26.r,
                    ),
                    6.pw,
                    Text(
                      S.of(context).call,
                      style: Styles.textStyle18Bold(context),
                    )
                  ],
                ).paddingSymmetric(horizontal: 8.w, vertical: 4.h),
              ),
              Divider(),
              InkWell(
                onTap: () {
                  openMapLink(
                      context, state.contactUsEntity.data!.email1 ?? '');
                },
                borderRadius: BorderRadius.circular(16.r),
                child: Row(
                  children: [
                    Icon(
                      Icons.place,
                      color: Colors.black,
                      size: 26.r,
                    ),
                    6.pw,
                    Text(
                      S.of(context).location,
                      style: Styles.textStyle18Bold(context),
                    )
                  ],
                ).paddingSymmetric(horizontal: 8.w, vertical: 4.h),
              ),
            ],
          );
        } else if (state is ContactUsLoading) {
          return Skeletonizer(
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    makePhoneCall(phoneNumber: '+201000000000');
                  },
                  borderRadius: BorderRadius.circular(16.r),
                  child: Row(
                    children: [
                      Icon(
                        Icons.call,
                        color: Colors.black,
                        size: 26.r,
                      ),
                      6.pw,
                      Text(
                        S.of(context).call,
                        style: Styles.textStyle18Bold(context),
                      )
                    ],
                  ).paddingSymmetric(horizontal: 8.w, vertical: 4.h),
                ),
                Divider(),
                InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(16.r),
                  child: Row(
                    children: [
                      Icon(
                        Icons.place,
                        color: Colors.black,
                        size: 26.r,
                      ),
                      6.pw,
                      Text(
                        S.of(context).location,
                        style: Styles.textStyle18Bold(context),
                      )
                    ],
                  ).paddingSymmetric(horizontal: 8.w, vertical: 4.h),
                ),
              ],
            ),
          );
        } else if (state is ContactUsFailure) {
          return Center(
              child: Text(
            state.errorMessage,
            style: Styles.textStyle18Bold(context),
          ));
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }
}
