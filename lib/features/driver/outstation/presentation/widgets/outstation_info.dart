import 'package:flutter/material.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';

import '../../../../../core/utils/styles.dart';
import '../../../../../generated/l10n.dart';
import 'package:shakshak/features/user/user_home/domain/entities/new_ride_data_entity.dart';

class OutstationInfo extends StatelessWidget {
  const OutstationInfo({required this.ride});

  final NewRideDataEntity ride;

  bool _hasValue(String? v) =>
      v != null && v.isNotEmpty && v != '0' && v != '0.0';

  @override
  Widget build(BuildContext context) {
    if (!_hasValue(ride.parcelWeight)) return const SizedBox.shrink();

    return Column(
      children: [
        12.ph,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${S.of(context).weight} ${ride.parcelWeight} KG',
              style: Styles.textStyle14SemiBold(context),
            ),
            if (_hasValue(ride.parcelDimension))
              Text(
                '${S.of(context).dimension} ${ride.parcelDimension}',
                style: Styles.textStyle14SemiBold(context),
              ),
          ],
        ),
      ],
    );
  }
}
