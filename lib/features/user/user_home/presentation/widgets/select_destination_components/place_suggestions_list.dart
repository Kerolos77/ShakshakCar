import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';
import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/utils/styles.dart';
import 'package:shakshak/generated/l10n.dart';

import 'package:shakshak/features/user/saved_places/domain/entities/saved_place_entity.dart';
import 'package:shakshak/features/user/user_home/data/models/place_model.dart';

class PlaceSuggestionsList extends StatelessWidget {
  final List<PlacePrediction> suggestions;
  final List<SavedPlaceEntity> savedPlaces;
  final VoidCallback? onMapTap;
  final Function(PlacePrediction) onSuggestionTap;
  final Function(SavedPlaceEntity) onSavedPlaceTap;

  const PlaceSuggestionsList({
    super.key,
    required this.suggestions,
    this.savedPlaces = const [],
    required this.onMapTap,
    required this.onSuggestionTap,
    required this.onSavedPlaceTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: suggestions.length + savedPlaces.length + 1,
      itemBuilder: (context, index) {
        if (index < suggestions.length) {
          final place = suggestions[index];
          return _buildSuggestionItem(context, place);
        } else if (index < suggestions.length + savedPlaces.length) {
          final savedPlace = savedPlaces[index - suggestions.length];
          return _buildSavedPlaceItem(context, savedPlace);
        } else {
          return _buildMapAction(context);
        }
      },
    );
  }

  Widget _buildSuggestionItem(BuildContext context, PlacePrediction place) {
    return InkWell(
      onTap: () => onSuggestionTap(place),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Row(
          children: [
            Icon(Icons.location_on, color: Colors.grey[600], size: 20.sp),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place.placeName!,
                    style: Styles.textStyle16Bold(context),
                  ),
                  Text(
                    place.description,
                    style: Styles.textStyle12(context)
                        .copyWith(color: AppColors.greyColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSavedPlaceItem(BuildContext context, SavedPlaceEntity place) {
    return InkWell(
      onTap: () => onSavedPlaceTap(place),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Row(
          children: [
            Icon(Icons.star, color: Colors.amber, size: 20.sp),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place.name,
                    style: Styles.textStyle16Bold(context)
                        .copyWith(color: Colors.blue[800]),
                  ),
                  Text(
                    place.address,
                    style: Styles.textStyle12(context)
                        .copyWith(color: AppColors.greyColor),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapAction(BuildContext context) {
    return InkWell(
      onTap: onMapTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Row(
          children: [
            Icon(Icons.add_location_alt,
                color: AppColors.primaryColor, size: 20.sp),
            10.pw,
            Expanded(
              child: Text(
                S.of(context).chooseOnMap,
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: 18.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
