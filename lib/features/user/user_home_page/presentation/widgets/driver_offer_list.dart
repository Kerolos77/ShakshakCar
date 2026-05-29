import 'package:flutter/material.dart';

import 'package:shakshak/features/user/user_home_page/data/models/driver_offer.dart';
import 'offer_card.dart';

class DriverOfferList extends StatelessWidget {
  final List<DriverOffer> offers;
  final Function(DriverOffer) onAcceptOffer;
  final Function(DriverOffer) onRefuseOffer;

  DriverOfferList({
    required this.offers,
    required this.onAcceptOffer,
    required this.onRefuseOffer,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: offers.map((offer) {
        return OfferCard(
          offer: offer,
          onAccept: () => onAcceptOffer(offer),
          onRefuse: () => onRefuseOffer(offer),
        );
      }).toList(),
    );
  }
}
