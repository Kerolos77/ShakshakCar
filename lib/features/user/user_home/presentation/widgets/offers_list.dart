import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../domain/entities/new_ride_data_entity.dart';
import '../../data/models/trip_offer_model.dart';
import 'offer_item.dart';
import 'waiting_for_drivers_widget.dart';

class OffersList extends StatelessWidget {
  final List<TripOfferModel> offers;
  final NewRideDataEntity originalRideData;

  const OffersList({
    super.key,
    required this.offers,
    required this.originalRideData,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint("🎨 OffersList Rendering with ${offers.length} offers");

    if (offers.isEmpty) {
      return const SliverToBoxAdapter(child: WaitingForDriversWidget());
    }

    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return Column(
              children: [
                OfferItem(
                  key: ValueKey(offers[index].id),
                  offer: offers[index],
                  originalRideData: originalRideData,
                ),
                if (index < offers.length - 1) 12.h.toInt().toSizedBox,
              ],
            );
          },
          childCount: offers.length,
        ),
      ),
    );
  }
}

extension on int {
  Widget get toSizedBox => SizedBox(height: toDouble());
}
