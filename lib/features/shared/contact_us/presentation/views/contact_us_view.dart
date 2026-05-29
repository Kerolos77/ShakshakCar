import 'package:flutter/material.dart';
import 'package:shakshak/core/utils/styles.dart';
import 'package:shakshak/features/shared/base_layout/presentation/views/base_layout_view.dart';

import 'package:shakshak/generated/l10n.dart';
import 'package:shakshak/features/shared/contact_us/presentation/widgets/call_us_body.dart';
import 'package:shakshak/features/shared/contact_us/presentation/widgets/write_us_body.dart';

class ContactUsView extends StatefulWidget {
  const ContactUsView({super.key});

  @override
  State<ContactUsView> createState() => _ContactUsViewState();
}

class _ContactUsViewState extends State<ContactUsView> {
  final PageController _pageController = PageController();
  final ValueNotifier<int> _selectedIndexNotifier = ValueNotifier<int>(0);

  @override
  void dispose() {
    _pageController.dispose();
    _selectedIndexNotifier.dispose();
    super.dispose();
  }

  void _onTap(int index) {
    _selectedIndexNotifier.value = index;
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onPageChanged(int index) {
    _selectedIndexNotifier.value = index;
  }

  @override
  Widget build(BuildContext context) {
    final titles = [
      S.of(context).callUs,
      S.of(context).emailUs,
    ];
    return BaseLayoutView(
      title: S.of(context).contactUs,
      body: Column(
        children: [
          ValueListenableBuilder<int>(
            valueListenable: _selectedIndexNotifier,
            builder: (context, selectedIndex, _) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(titles.length, (index) {
                  final isSelected = index == selectedIndex;
                  return GestureDetector(
                    onTap: () => _onTap(index),
                    child: Text(
                      titles[index],
                      textAlign: TextAlign.center,
                      style: Styles.textStyle16Bold(context).copyWith(
                        color: isSelected
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).colorScheme.onSurface,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w600,
                      ),
                    ),
                  );
                }),
              );
            },
          ),
          const Divider(),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              children: [
                CallUsBody(),
                WriteUsBody(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



