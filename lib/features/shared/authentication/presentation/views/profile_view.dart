import 'package:animate_do/animate_do.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';
import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/router/router_helper.dart';
import 'package:shakshak/core/router/routes.dart';
import 'package:shakshak/core/services/service_locator.dart';
import 'package:shakshak/core/utils/shared_widgets/custom_button.dart';
import 'package:shakshak/core/utils/shared_widgets/custom_cached_network_image.dart';
import 'package:shakshak/core/utils/shared_widgets/show_snack_bar.dart';
import 'package:shakshak/core/utils/styles.dart';
import 'package:shakshak/features/shared/authentication/domain/entities/profile_entity.dart';
import 'package:shakshak/features/shared/authentication/presentation/view_models/auth_cubit/auth_cubit.dart';
import 'package:shakshak/features/shared/base_layout/presentation/views/base_layout_view.dart';
import 'package:shakshak/features/shared/review/presentation/view_models/review_cubit.dart';
import 'package:shakshak/features/shared/review/presentation/views/user_reviews_view.dart';
import 'package:shakshak/features/shared/rides/presentation/view_models/rides_cubit.dart';
import 'package:shakshak/features/shared/shop/presentation/view_models/shop_cubit.dart';
import 'package:shakshak/features/shared/shop/presentation/view_models/shop_state.dart';
import 'package:shakshak/features/shared/shop/presentation/widgets/subscription_countdown_timer.dart';
import 'package:shakshak/generated/l10n.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  String profilePhotoUrl = '';

  @override
  void initState() {
    super.initState();
    context.read<AuthCubit>().getProfile();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildSkeletonLoader() {
    return Skeletonizer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Row of Stat Cards
            Row(
              children: [
                Expanded(
                    child: _buildNewStatCard(context, '00', 'Rides',
                        Icons.directions_car, Colors.grey)),
                12.pw,
                Expanded(
                    child: _buildNewStatCard(
                        context, '0.0', 'Rating', Icons.star, Colors.grey)),
                12.pw,
                Expanded(
                    child: _buildNewStatCard(context, '00.0', 'Wallet',
                        Icons.account_balance_wallet, Colors.grey)),
              ],
            ),
            25.ph,
            // Form Container
            Container(
              padding: EdgeInsets.all(24.r),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(28.r),
                border: Border.all(color: Theme.of(context).dividerColor),
              ),
              child: Column(
                children: [
                  Container(
                    height: 60.h,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                  20.ph,
                  Container(
                    height: 60.h,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                  32.ph,
                  CustomButton(
                      text: S.of(context).save, height: 60, borderRadius: 20),
                ],
              ),
            ),
            40.ph,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayoutView(
      showAppBar: false,
      header: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          final profileModel = context.read<AuthCubit>().profileModel;
          final user = state is GetProfileSuccessState
              ? state.userModel.data
              : profileModel?.data;
          final activePackage = user?.activePackage;
          final isPremium = activePackage != null;

          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isPremium
                    ? [const Color(0xFFD4AF37), AppColors.primaryColor]
                    : [AppColors.primaryColor, const Color(0xFF1A1A1A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(60.r),
              ),
            ),
            child: Stack(
              children: [
                // Decorative Background Circles
                Positioned(
                  top: -50.r,
                  right: -50.r,
                  child: Container(
                    width: 200.r,
                    height: 200.r,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20.r,
                  left: -30.r,
                  child: Container(
                    width: 120.r,
                    height: 120.r,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.03),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                // Content
                Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).padding.top + 10.h),
                    // Custom Integrated AppBar
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(Icons.arrow_back_ios_new_rounded,
                                color: Colors.white, size: 22.r),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.white.withOpacity(0.15),
                              padding: EdgeInsets.all(8.r),
                            ),
                          ),
                          Text(
                            S.of(context).profile,
                            style: Styles.textStyle20Bold(context)
                                .copyWith(color: Colors.white),
                          ),
                          IconButton(
                            onPressed: () =>
                                navigateTo(context, Routes.editProfileView),
                            icon: Icon(Icons.edit_rounded,
                                color: Colors.white, size: 22.r),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.white.withOpacity(0.15),
                              padding: EdgeInsets.all(8.r),
                            ),
                          ),
                        ],
                      ),
                    ),
                    20.ph,
                    FadeInDown(
                      duration: const Duration(milliseconds: 600),
                      child: Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Outer Ring (Gold for premium)
                            Container(
                              width: 140.r,
                              height: 140.r,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isPremium
                                      ? const Color(0xFFD4AF37)
                                      : Colors.white.withOpacity(0.2),
                                  width: isPremium ? 4.r : 2.r,
                                ),
                                boxShadow: isPremium
                                    ? [
                                        BoxShadow(
                                          color: const Color(0xFFD4AF37)
                                              .withOpacity(0.3),
                                          blurRadius: 20,
                                          spreadRadius: 2,
                                        )
                                      ]
                                    : [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 10,
                                          offset: const Offset(0, 5),
                                        )
                                      ],
                              ),
                            ),
                            // Avatar Container
                            Container(
                              width: 125.r,
                              height: 125.r,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Colors.white.withOpacity(0.3),
                                    width: 1),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 15,
                                    offset: const Offset(0, 8),
                                  )
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(65.r),
                                child: (user?.image?.isNotEmpty ?? false)
                                    ? CustomCachedNetworkImage(
                                        imgUrl: user!.image!,
                                        width: 125.r,
                                        height: 125.r,
                                        errorIconSize: 45,
                                      )
                                    : Container(
                                        color: Colors.white.withOpacity(0.1),
                                        child: Icon(Icons.person_rounded,
                                            size: 65.r,
                                            color:
                                                Colors.white.withOpacity(0.5)),
                                      ),
                              ),
                            ),
                            // Premium Icon
                            if (isPremium)
                              Positioned(
                                bottom: 5,
                                right: 5,
                                child: FadeIn(
                                  delay: const Duration(milliseconds: 400),
                                  child: Container(
                                    padding: EdgeInsets.all(8.r),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFD4AF37),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Colors.white, width: 2),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        )
                                      ],
                                    ),
                                    child: Icon(Icons.star_rounded,
                                        color: Colors.white, size: 22.r),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    24.ph,
                    FadeInUp(
                      duration: const Duration(milliseconds: 600),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                user?.name ?? '',
                                style: Styles.textStyle24Bold(context).copyWith(
                                  color: Colors.white,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              if (isPremium) ...[
                                8.pw,
                                Icon(Icons.verified_rounded,
                                    color: const Color(0xFFD4AF37), size: 24.r),
                              ],
                            ],
                          ),
                          8.ph,
                          if (isPremium) ...[
                            Container(
                              margin: EdgeInsets.only(bottom: 12.h),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.w, vertical: 8.h),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20.r),
                                border: Border.all(
                                    color: const Color(0xFFD4AF37)
                                        .withOpacity(0.5)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.stars_rounded,
                                      color: const Color(0xFFD4AF37),
                                      size: 16.r),
                                  8.pw,
                                  Text(
                                    activePackage.name,
                                    style: TextStyle(
                                      color: const Color(0xFFD4AF37),
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          25.ph,
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ReviewCubit(sl(), sl()),
          ),
          BlocProvider(
            create: (context) => RidesCubit(sl()),
          ),
          BlocProvider(
            create: (context) => ShopCubit(
              getPackagesUseCase: sl(),
              buyPackageUseCase: sl(),
              getSubscriptionStatusUseCase: sl(),
            )..getSubscriptionStatus(),
          ),
        ],
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is GetProfileSuccessState) {
              profilePhotoUrl = state.userModel.data?.image ?? '';

              final userId = state.userModel.data?.id ?? 0;
              final isDriver = state.userModel.data?.isDriver == 1;
              context.read<ReviewCubit>().fetchUserReviews(userId: userId);
              context
                  .read<RidesCubit>()
                  .getRides(inCity: 1, isDriver: isDriver);
            } else if (state is UpdateProfileSuccessState) {
              showSnackBar(
                context,
                S.of(context).profileUpdatedSuccessfully,
                S.of(context).doneSuccessfully,
                AppColors.primaryColor,
                ContentType.success,
              );
              context.read<AuthCubit>().getProfile();
            } else if (state is UpdateProfileFailureState) {
              showSnackBar(
                  context,
                  state.errMessage,
                  S.of(context).errorOccurred,
                  AppColors.redColor,
                  ContentType.failure);
            }
          },
          builder: (context, state) {
            if (state is GetProfileLoadingState) {
              return _buildSkeletonLoader();
            }

            final user = context.read<AuthCubit>().profileModel?.data;
            final isPremium = user?.activePackage != null;

            // Debug print to see what's happening
            debugPrint(
                '[DEBUG_SUBSCRIPTION] Profile user: ${user?.name}, isPremium: $isPremium, activePackage: ${user?.activePackage?.name}');
            if (user?.activePackage != null) {
              debugPrint(
                  '[DEBUG_SUBSCRIPTION] Active Package ExpiresAt: ${user?.activePackage?.expiresAt}');
            }

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Builder(builder: (context) {
                    final rewardPoints = user?.rewardPoints ?? 0;
                    final walletAmount = user?.walletAmount ?? '0.0';

                    return Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: BlocBuilder<RidesCubit, RidesState>(
                                builder: (context, state) {
                                  String ridesCount = '0';
                                  if (state is RidesSuccess) {
                                    final data = state.ridesEntity.data;
                                    if (data != null) {
                                      final total =
                                          (data.searching?.length ?? 0) +
                                              (data.placed?.length ?? 0) +
                                              (data.started?.length ?? 0) +
                                              (data.completed?.length ?? 0) +
                                              (data.canceled?.length ?? 0);
                                      ridesCount = total.toString();
                                    }
                                  } else if (state is RidesLoading) {
                                    ridesCount = '...';
                                  }
                                  return _buildNewStatCard(
                                    context,
                                    ridesCount,
                                    S.of(context).rides,
                                    Icons.directions_car_filled_rounded,
                                    AppColors.primaryColor,
                                  );
                                },
                              ),
                            ),
                            12.pw,
                            Expanded(
                              child: BlocBuilder<ReviewCubit, ReviewState>(
                                builder: (context, state) {
                                  String rating = '0.0';
                                  int userId = 0;
                                  String userName = '';
                                  if (state is UserReviewSuccess) {
                                    rating = state.userReviewResponse.data.user
                                        .averageRating
                                        .toStringAsFixed(1);
                                    userId =
                                        state.userReviewResponse.data.user.id;
                                    userName =
                                        state.userReviewResponse.data.user.name;
                                  } else if (state is ReviewLoading) {
                                    rating = '...';
                                  }
                                  return GestureDetector(
                                    onTap: () {
                                      if (userId != 0) {
                                        showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          backgroundColor: Colors.transparent,
                                          builder: (context) => UserReviewsView(
                                            userId: userId,
                                            userName: userName,
                                          ),
                                        );
                                      }
                                    },
                                    child: _buildNewStatCard(
                                      context,
                                      rating,
                                      S.of(context).status,
                                      Icons.star_rounded,
                                      const Color(0xFFFFB800),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        12.ph,
                        Row(
                          children: [
                            Expanded(
                              child: _buildNewStatCard(
                                context,
                                walletAmount,
                                S.of(context).wallet,
                                Icons.account_balance_wallet_rounded,
                                const Color(0xFF10B981),
                              ),
                            ),
                            12.pw,
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  final isDriver = user?.isDriver == 1;
                                  navigateTo(
                                      context,
                                      isDriver
                                          ? Routes.driverStoreView
                                          : Routes.userStoreView);
                                },
                                child: _buildNewStatCard(
                                  context,
                                  rewardPoints.toString(),
                                  S.of(context).rewardPoints,
                                  Icons.stars_rounded,
                                  Colors.orange,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }),
                  30.ph,
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(24.r),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(28.r),
                      border: Border.all(color: Theme.of(context).dividerColor),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.02),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildInfoRow(context, Icons.phone_android_rounded,
                            S.of(context).mobileNumber, user?.phone ?? ''),
                        BlocBuilder<ShopCubit, ShopState>(
                          builder: (context, state) {
                            if (state is ShopLoaded &&
                                state.subscriptionDetails != null) {
                              return Column(
                                children: [
                                  24.ph,
                                  const Divider(),
                                  16.ph,
                                  _buildSubscriptionCard(
                                      context, state.subscriptionDetails!),
                                ],
                              );
                            } else if (user?.activePackage != null) {
                              return Column(
                                children: [
                                  24.ph,
                                  const Divider(),
                                  16.ph,
                                  _buildSubscriptionCardSimple(
                                      context, user!.activePackage!),
                                ],
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ],
                    ),
                  ),
                  40.ph,
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSubscriptionCard(BuildContext context, dynamic subscription) {
    final package = subscription.package;
    final expiresAt = DateTime.tryParse(subscription.expiresAt);

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xFFD4AF37).withOpacity(0.05),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.stars_rounded,
                  color: const Color(0xFFD4AF37), size: 24.r),
              12.pw,
              Text(
                "اشتراك نشط",
                style: Styles.textStyle16Bold(context)
                    .copyWith(color: const Color(0xFFD4AF37)),
              ),
              const Spacer(),
              if (expiresAt != null)
                SubscriptionCountdownTimer(
                  expiresAt: expiresAt,
                  textStyle: Styles.textStyle12SemiBold(context)
                      .copyWith(color: const Color(0xFFD4AF37)),
                ),
            ],
          ),
          12.ph,
          Text(
            package.name,
            style: Styles.textStyle18Bold(context),
          ),
          8.ph,
          Row(
            children: [
              Icon(Icons.calendar_today_rounded,
                  size: 14.r, color: Theme.of(context).hintColor),
              8.pw,
              Text(
                "ينتهي في: ${subscription.expiresAt.split('T').first}",
                style: Styles.textStyle14(context)
                    .copyWith(color: Theme.of(context).hintColor),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionCardSimple(
      BuildContext context, ActivePackage package) {
    debugPrint(
        '[DEBUG_SUBSCRIPTION] Building Simple Card for: ${package.name}');

    DateTime? expiresAt;
    if (package.expiresAt != null) {
      // Handle both "YYYY-MM-DD HH:MM:SS" and ISO formats
      String dateStr = package.expiresAt!.trim();
      if (dateStr.contains(' ') && !dateStr.contains('T')) {
        dateStr = dateStr.replaceAll(' ', 'T');
      }
      expiresAt = DateTime.tryParse(dateStr);
      debugPrint(
          '[DEBUG_SUBSCRIPTION] Parsed Expiry: $expiresAt from raw: ${package.expiresAt}');
    }

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xFFD4AF37).withOpacity(0.05),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.stars_rounded,
                  color: const Color(0xFFD4AF37), size: 24.r),
              12.pw,
              Text(
                "اشتراك نشط",
                style: Styles.textStyle16Bold(context)
                    .copyWith(color: const Color(0xFFD4AF37)),
              ),
              const Spacer(),
              if (expiresAt != null)
                SubscriptionCountdownTimer(
                  expiresAt: expiresAt,
                  textStyle: Styles.textStyle12SemiBold(context)
                      .copyWith(color: const Color(0xFFD4AF37)),
                ),
            ],
          ),
          12.ph,
          Text(
            package.name,
            style: Styles.textStyle18Bold(context),
          ),
          if (package.expiresAt != null) ...[
            8.ph,
            Row(
              children: [
                Icon(Icons.calendar_today_rounded,
                    size: 14.r, color: Theme.of(context).hintColor),
                8.pw,
                Text(
                  "ينتهي في: ${package.expiresAt!.split(' ').first}",
                  style: Styles.textStyle14(context)
                      .copyWith(color: Theme.of(context).hintColor),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(
      BuildContext context, IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(10.r),
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.primaryColor, size: 20.r),
        ),
        16.pw,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Styles.textStyle12(context).copyWith(
                  color: Theme.of(context).hintColor,
                ),
              ),
              4.ph,
              Text(
                value,
                style: Styles.textStyle14SemiBold(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNewStatCard(BuildContext context, String value, String label,
      IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24.r),
        border:
            Border.all(color: Theme.of(context).dividerColor.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20.r, color: color),
          ),
          10.ph,
          Text(value, style: Styles.textStyle18Bold(context)),
          2.ph,
          Text(
            label,
            style: Styles.textStyle12SemiBold(context).copyWith(
              color: Theme.of(context).hintColor,
            ),
          ),
        ],
      ),
    );
  }
}
