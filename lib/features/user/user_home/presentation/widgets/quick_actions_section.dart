import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';
import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/utils/styles.dart';
import 'package:shakshak/core/router/router_helper.dart';
import 'package:shakshak/core/router/routes.dart';
import 'package:shakshak/features/user/saved_places/presentation/cubit/saved_places_cubit.dart';
import 'package:shakshak/features/user/saved_places/domain/entities/saved_place_entity.dart';
import 'package:shakshak/features/user/user_home/presentation/view_models/location/location_cubit.dart';

import 'package:shakshak/core/network/dio_helper/dio_helper.dart';
import 'package:shakshak/core/network/local/cache_helper.dart';
import 'package:shakshak/core/constants/app_const.dart';
import 'package:shakshak/generated/l10n.dart';

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SavedPlacesCubit, SavedPlacesState>(
      builder: (context, state) {
        final List<SavedPlaceEntity> suggested = (state is SavedPlacesSuccess) ? state.suggestedPlaces : [];
        final List<SavedPlaceEntity> places = (state is SavedPlacesSuccess) ? state.places : [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                'خدمات سريعة', // Or some translation, but let's stick to simple layout
                style: Styles.textStyle16SemiBold(context),
              ),
            ),
            12.ph,
            // ✨ SHIPMENT STATIC ACTION ✨
            _ActionCard(
              place: SavedPlaceEntity(
                id: '0',
                name: S.of(context).shipPackage,
                address: S.of(context).shipmentDetails,
                lat: 0,
                lng: 0,
              ),
              isSuggested: true,
              iconData: Icons.local_shipping_rounded,
              onTap: () => _handleShipmentTap(context),
            ),
            if (suggested.isNotEmpty || places.isNotEmpty) ...[
              12.ph,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Text(
                  suggested.isNotEmpty ? 'Recommended for you' : 'Saved Places',
                  style: Styles.textStyle16SemiBold(context),
                ),
              ),
              12.ph,
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                itemCount: suggested.length + places.length,
                separatorBuilder: (context, index) => 12.ph,
                itemBuilder: (context, index) {
                  if (index < suggested.length) {
                    final place = suggested[index];
                    return _buildActionCard(
                      context,
                      place: place,
                      isSuggested: true,
                      onTap: () => _handlePlaceTap(context, place),
                    );
                  }
                  final place = places[index - suggested.length];
                  return _buildActionCard(
                    context,
                    place: place,
                    onTap: () => _handlePlaceTap(context, place),
                  );
                },
              ),
            ],
          ],
        );
      },
    );
  }

  void _handleShipmentTap(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
    
    bool isVerified = false;
    try {
      final token = CacheHelper.getData(key: AppConstant.kToken);
      final response = await DioHelper.getData(
        url: 'user/identity-status',
        token: token,
      );
      
      if (response.statusCode == 200 && response.data != null) {
         final resData = response.data['data'];
         if (resData != null && resData['verification_status'] == 'verified') {
           isVerified = true;
         }
      }
    } catch (e) {
      // Ignore API error and fallback to not verified
    }
    
    // ignore: use_build_context_synchronously
    Navigator.pop(context); // hide loading
    
    if (isVerified) {
      // Navigate to Shipment Request Screen
      // ignore: use_build_context_synchronously
      navigateTo(context, Routes.shipmentRequestView);
    } else {
      // Navigate to Verification View directly
      // ignore: use_build_context_synchronously
      navigateTo(context, Routes.userIdentityVerificationView);
    }
  }

  void _handlePlaceTap(BuildContext context, SavedPlaceEntity place) {
    final locationCubit = context.read<LocationCubit>();
    locationCubit.setDestinationFromCoordinates(
      place.lat,
      place.lng,
      manualName: place.name,
    );
    navigateTo(context, Routes.bookRide);
  }

  IconData _getIconForPlace(String name) {
    name = name.toLowerCase();
    if (name.contains('home') || name.contains('بيت'))
      return Icons.home_rounded;
    if (name.contains('work') || name.contains('شغل'))
      return Icons.work_rounded;
    if (name.contains('fav')) return Icons.favorite_rounded;
    if (name.contains('suggest')) return Icons.auto_awesome_rounded;
    return Icons.place_rounded;
  }

  Widget _buildActionCard(
    BuildContext context, {
    required SavedPlaceEntity place,
    bool isSuggested = false,
    required VoidCallback onTap,
  }) {
    return _ActionCard(
      place: place,
      isSuggested: isSuggested,
      onTap: onTap,
      iconData: _getIconForPlace(isSuggested ? 'suggest' : place.name),
    );
  }
}

class _ActionCard extends StatefulWidget {
  final SavedPlaceEntity place;
  final bool isSuggested;
  final VoidCallback onTap;
  final IconData iconData;

  const _ActionCard({
    required this.place,
    required this.isSuggested,
    required this.onTap,
    required this.iconData,
  });

  @override
  State<_ActionCard> createState() => _ActionCardState();
}

class _ActionCardState extends State<_ActionCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutBack,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            color: widget.isSuggested
                ? AppColors.primaryColor.withOpacity(0.08)
                : Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: widget.isSuggested
                  ? Theme.of(context).primaryColor.withOpacity(0.3)
                  : Theme.of(context).dividerColor.withOpacity(0.5),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  gradient: widget.isSuggested
                      ? LinearGradient(
                          colors: [
                            AppColors.primaryColor,
                            AppColors.secondaryColor,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: widget.isSuggested
                      ? null
                      : Theme.of(context).primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  widget.iconData,
                  color: widget.isSuggested
                      ? Theme.of(context).colorScheme.surface
                      : AppColors.primaryColor,
                  size: 24.r,
                ),
              ),
              12.pw,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.place.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Styles.textStyle14SemiBold(context),
                          ),
                        ),
                        if (widget.isSuggested) ...[
                          8.pw,
                          Container(
                            padding:
                                EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Text(
                              'Smart',
                              style: Styles.textStyle10SemiBold(context).copyWith(
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    4.ph,
                    Text(
                      widget.place.address,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Styles.textStyle14Medium(context).copyWith(
                        fontSize: 12.sp,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
