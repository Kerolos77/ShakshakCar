import 'package:flutter/material.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';
import 'package:shakshak/core/utils/styles.dart';
import 'package:shakshak/features/shared/base_layout/presentation/views/base_layout_view.dart';
import 'package:shakshak/generated/l10n.dart';

import 'package:shakshak/features/shared/faq/presentation/widgets/faqs_list.dart';

class FaqView extends StatelessWidget {
  const FaqView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseLayoutView(
      title: S.of(context).faqs,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).faqs,
            style: Styles.textStyle20Bold(context),
          ),
          Text(
            S.of(context).readFaqsSolution,
            style: Styles.textStyle16(context),
          ),
          16.ph,
          FaqsList(),
        ],
      ),
    );
  }
}

