import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/utils/styles.dart';
import 'package:shakshak/generated/l10n.dart';

class WalletCard extends StatelessWidget {
  const WalletCard({
    super.key,
    required this.balance,
    required this.onTopUp,
  });

  final String balance;
  final VoidCallback onTopUp;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryColor,
            AppColors.primaryColor.withBlue(150),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.r),
        child: Stack(
          children: [
            // Decorative background elements
            Positioned(
              right: -30.r,
              top: -30.r,
              child: CircleAvatar(
                radius: 60.r,
                backgroundColor: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withOpacity(0.05),
              ),
            ),
            Positioned(
              left: -20.r,
              bottom: -40.r,
              child: CircleAvatar(
                radius: 80.r,
                backgroundColor: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withOpacity(0.03),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(24.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            S.of(context).totalBalance,
                            style: Styles.textStyle14Medium(context).copyWith(
                              color: Colors.white.withOpacity(0.9),
                              letterSpacing: 0.5,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            '$balance ${S.of(context).currency}',
                            style: Styles.textStyle28Bold(context).copyWith(
                              color: Colors.white,
                              fontSize: 34.sp,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.all(4.r),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.account_balance_wallet,
                          color: Colors.white.withOpacity(0.6),
                          size: 40.r,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 32.h),
                  InkWell(
                    onTap: onTopUp,
                    borderRadius: BorderRadius.circular(16.r),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 12.h),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.add_circle_outline_rounded,
                            color: Theme.of(context).primaryColor,
                            size: 22.r,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            S.of(context).topupWallet,
                            style: Styles.textStyle16Bold(context).copyWith(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
