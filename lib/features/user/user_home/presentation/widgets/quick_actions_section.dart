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

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SavedPlacesCubit, SavedPlacesState>(
      builder: (context, state) {
        if (state is SavedPlacesSuccess &&
            (state.places.isNotEmpty || state.suggestedPlaces.isNotEmpty)) {
          final suggested = state.suggestedPlaces;
          final places = state.places;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
          );
        }
        return const SizedBox.shrink();
      },
    );
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
