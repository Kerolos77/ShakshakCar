import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/services/service_locator.dart';
import 'package:shakshak/features/driver/store/presentation/view_models/driver_store_cubit.dart';
import 'package:shakshak/features/driver/store/presentation/view_models/driver_store_state.dart';
import 'package:shakshak/features/shared/authentication/presentation/view_models/auth_cubit/auth_cubit.dart';
import 'package:shakshak/generated/l10n.dart';


class DriverStoreView extends StatelessWidget {
  const DriverStoreView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<DriverStoreCubit>()..fetchPackages(),
      child: const _DriverStoreContent(),
    );
  }
}

class _DriverStoreContent extends StatelessWidget {
  const _DriverStoreContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).driverStore,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
        ),
        centerTitle: true,
      ),
      body: BlocListener<DriverStoreCubit, DriverStoreState>(
        listener: (context, state) {
          if (state is DriverStoreBuySuccess) {
            final msg = state.message == 'package_purchased_success'
                ? S.of(context).packagePurchasedSuccess
                : state.message;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(msg),
                  backgroundColor: AppColors.primaryColor),
            );
            context.read<AuthCubit>().getProfile(); // refresh points
          } else if (state is DriverStoreBuyError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        child: Column(
          children: [
            _buildPointsHeader(),
            Expanded(
              child: BlocBuilder<DriverStoreCubit, DriverStoreState>(
                builder: (context, state) {
                  if (state is DriverStoreLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is DriverStoreError) {
                    return Center(child: Text(state.message));
                  } else if (state is DriverStoreLoaded) {
                    final packages = state.packages;
                    if (packages.isEmpty) {
                      return Center(child: Text(S.of(context).noPackagesAvailable));
                    }
                    return ListView.builder(
                      padding: EdgeInsets.all(16.r),
                      itemCount: packages.length,
                      itemBuilder: (context, index) {
                        final pkg = packages[index];
                        return _PackageCard(package: pkg);
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPointsHeader() {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final profile = context.read<AuthCubit>().profileModel?.data;
        final points = profile?.rewardPoints ?? 0;
        final activePackage = profile?.activePackage;

        return Column(
          children: [
            Container(
              margin: EdgeInsets.all(16.r),
              padding: EdgeInsets.all(20.r),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16.r),
                border:
                    Border.all(color: AppColors.primaryColor.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.stars_rounded, color: Colors.orange, size: 40.r),
                  SizedBox(width: 12.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        S.of(context).yourCurrentPoints,
                        style: TextStyle(
                            fontSize: 14.sp, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "$points ${S.of(context).point}",
                        style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (activePackage != null)
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16.r, vertical: 8.r),
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: const Color(0xFFD4AF37).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                      color: const Color(0xFFD4AF37).withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.check_circle,
                            color: const Color(0xFFD4AF37), size: 24.r),
                        SizedBox(width: 8.w),
                        Text(
                          S.of(context).alreadySubscribedToPackage,
                          style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFD4AF37)),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      "${S.of(context).currentPackage}: ${activePackage.name}",
                      style: TextStyle(
                          fontSize: 14.sp, fontWeight: FontWeight.w600),
                    ),
                    if (activePackage.expiresAt != null)
                      Text(
                        "${S.of(context).expirationDate}: ${activePackage.expiresAt?.split(' ').first}",
                        style:
                            TextStyle(fontSize: 12.sp, color: Colors.grey[700]),
                      ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}

class _PackageCard extends StatelessWidget {
  final dynamic package;

  const _PackageCard({required this.package});

  @override
  Widget build(BuildContext context) {
    final hasActivePackage =
        context.read<AuthCubit>().profileModel?.data?.activePackage != null;

    return Card(
      margin: EdgeInsets.only(bottom: 16.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (package.image != null && package.image!.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Image.network(
                      package.image!,
                      width: 60.r,
                      height: 60.r,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Icon(Icons.card_giftcard,
                          size: 40.r, color: Colors.grey),
                    ),
                  )
                else
                  Container(
                    width: 60.r,
                    height: 60.r,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(Icons.card_giftcard,
                        size: 30.r, color: Colors.grey[600]),
                  ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        package.name,
                        style: TextStyle(
                            fontSize: 18.sp, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        "${S.of(context).discountPercentage}: %${package.discountPercentage}",
                        style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.green,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "${S.of(context).validFor} ${package.validDays} ${S.of(context).days}",
                        style:
                            TextStyle(fontSize: 12.sp, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (package.description != null &&
                package.description!.isNotEmpty) ...[
              SizedBox(height: 12.h),
              Text(
                package.description!,
                style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
              ),
            ],
            SizedBox(height: 16.h),
            if (!hasActivePackage)
              Row(
                children: [
                  if (package.pricePoints != null && package.pricePoints! > 0)
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _buy(context, 'points'),
                        icon:
                            Icon(Icons.stars, color: Colors.orange, size: 18.r),
                        label: Text("${package.pricePoints} ${S.of(context).point}",
                            style: TextStyle(
                                fontSize: 12.sp, color: Colors.black)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          side: BorderSide(color: Colors.orange),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r)),
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                        ),
                      ),
                    ),
                  if (package.pricePoints != null &&
                      package.pricePoints! > 0 &&
                      package.priceMoney != null &&
                      package.priceMoney! > 0)
                    SizedBox(width: 8.w),
                  if (package.priceMoney != null && package.priceMoney! > 0)
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _buy(context, 'cash'),
                        icon: Icon(Icons.account_balance_wallet,
                            color: Colors.white, size: 18.r),
                        label: Text("${package.priceMoney} ${S.of(context).currency}",
                            style: TextStyle(fontSize: 12.sp)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r)),
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                        ),
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  void _buy(BuildContext context, String method) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(S.of(context).confirmPurchase),
        content: Text(
            S.of(context).confirmPackagePurchaseMethod(method == 'points' ? S.of(context).pointsMethod : S.of(context).walletMethod)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(S.of(context).cancel, style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<DriverStoreCubit>().buyPackage(package.id, method);
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor),
            child: Text(S.of(context).confirm, style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
