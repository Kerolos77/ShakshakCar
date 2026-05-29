import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';
import 'package:shakshak/core/utils/styles.dart';
import 'package:shakshak/features/shared/faq/data/models/faqs_model.dart';
import 'package:shakshak/features/shared/faq/presentation/view_models/faqs_cubit.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:shakshak/features/shared/faq/presentation/widgets/faq_item.dart';

class FaqsList extends StatefulWidget {
  const FaqsList({
    super.key,
  });

  @override
  State<FaqsList> createState() => _FaqsListState();
}

class _FaqsListState extends State<FaqsList> {
  @override
  void initState() {
    super.initState();
    context.read<FaqsCubit>().getFaqs();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FaqsCubit, FaqsState>(
      builder: (context, state) {
        if (state is FaqsSuccess) {
          return Expanded(
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
              itemBuilder: (context, index) => FaqItem(
                faq: state.faqsEntity.data![index],
              ),
              separatorBuilder: (context, index) => 12.ph,
              itemCount: state.faqsEntity.data!.length,
            ),
          );
        } else if (state is FaqsLoading) {
          return Expanded(
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
              itemBuilder: (context, index) => Skeletonizer(
                child: FaqItem(
                  faq: Faq(
                    title: 'aaaaaaaaa aaaaaaa aaaaaaaa aaaaaa',
                    description:
                        'aaaaaaaaa aaaaaaa aaaaaaaa aaaaaa aaaaaaaaa aaaaaaa aaaaaaaa aaaaaa aaaaaaaaa aaaaaaa aaaaaaaa aaaaaa',
                  ),
                ),
              ),
              separatorBuilder: (context, index) => 12.ph,
              itemCount: 8,
            ),
          );
        } else if (state is FaqsFailure) {
          return Expanded(
            child: Center(
              child: Text(
                state.errorMessage,
                style: Styles.textStyle18Bold(context),
              ),
            ),
          );
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }
}
