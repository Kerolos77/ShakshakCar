import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakshak/core/utils/styles.dart';
import 'package:shakshak/features/shared/base_layout/presentation/views/base_layout_view.dart';
import 'package:shakshak/features/shared/static_pages/presentation/view_models/static_pages_cubit.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:shakshak/generated/l10n.dart';

class TermsAndConditionsView extends StatefulWidget {
  const TermsAndConditionsView({super.key});

  @override
  State<TermsAndConditionsView> createState() => _TermsAndConditionsViewState();
}

class _TermsAndConditionsViewState extends State<TermsAndConditionsView> {
  @override
  void initState() {
    super.initState();
    context.read<StaticPagesCubit>().getStaticPages(id: 3);
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayoutView(
      title: S.of(context).termsAndConditions,
      body: BlocBuilder<StaticPagesCubit, StaticPagesState>(
        builder: (context, state) {
          if (state is StaticPagesSuccess) {
            return SingleChildScrollView(
              child: Text(
                state.staticPagesModel.data!.content ?? '',
              ),
            );
          } else if (state is StaticPagesLoading) {
            return Skeletonizer(
              child: Text(
                'There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which dont look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isnt anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary, making this the first true generator on the Internet. It uses a dictionary of over 200 Latin words, combined with a handful of model sentence structures, to generate Lorem Ipsum which looks reasonable. The generated Lorem Ipsum is therefore always free from repetition, injected humour, or non-characteristic words etc.',
              ),
            );
          } else if (state is StaticPagesFailure) {
            return Text(
              state.errorMessage,
              style: Styles.textStyle16Medium(context),
            );
          } else {
            return SizedBox.shrink();
          }
        },
      ),
    );
  }
}



