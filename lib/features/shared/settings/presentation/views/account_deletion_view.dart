import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';
import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/utils/shared_widgets/custom_button.dart';
import 'package:shakshak/core/utils/styles.dart';
import 'package:shakshak/features/shared/base_layout/presentation/views/base_layout_view.dart';
import 'package:shakshak/generated/l10n.dart';

class AccountDeletionView extends StatefulWidget {
  const AccountDeletionView({super.key});

  @override
  State<AccountDeletionView> createState() => _AccountDeletionViewState();
}

class _AccountDeletionViewState extends State<AccountDeletionView> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return BaseLayoutView(
      title: S.of(context).deleteAccount,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          children: [
            40.ph,
            Container(
              padding: EdgeInsets.all(24.r),
              decoration: BoxDecoration(
                color: AppColors.redColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.warning_rounded,
                color: AppColors.redColor,
                size: 60.r,
              ),
            ),
            32.ph,
            Text(
              S.of(context).deleteAccountWarningTitle,
              textAlign: TextAlign.center,
              style: Styles.textStyle20Bold(context),
            ),
            16.ph,
            Text(
              S.of(context).deleteAccountWarningMessage,
              textAlign: TextAlign.center,
              style: Styles.textStyle16Medium(context).copyWith(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withOpacity(0.6),
              ),
            ),
            const Spacer(),
            CustomButton(
              onTap: _isLoading ? null : _handleDeletion,
              text: S.of(context).permanentlyDelete,
              buttonColor: AppColors.redColor,
              isLoading: _isLoading,
            ),
            12.ph,
            CustomButton(
              onTap: () => Navigator.pop(context),
              text: S.of(context).cancel,
              buttonColor: Colors.transparent,
              textColor: Theme.of(context).textTheme.bodyLarge?.color,
              borderColor: Theme.of(context).dividerColor,
            ),
            40.ph,
          ],
        ),
      ),
    );
  }

  void _handleDeletion() {
    setState(() => _isLoading = true);
    // TODO: Connect to AuthRepo.deleteAccount()
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _isLoading = false);
        // Show success and logout
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).doneSuccessfully)),
        );
        Navigator.pop(context);
      }
    });
  }
}
