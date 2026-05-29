import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:shakshak/core/utils/shared_widgets/rating_user_form.dart';

class ChooseVehicleListViewWidget extends StatelessWidget {
  ChooseVehicleListViewWidget(
      {super.key,
      required this.pricebike,
      required this.pricetrip,
      required this.priceeconomy,
      required this.PriceProoPlus,
      required this.pricevip,
      required this.callBackFunction});

  dynamic callBackFunction;

  final int pricebike;
  final int pricetrip;
  final int priceeconomy;
  final int PriceProoPlus;
  final int pricevip;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 250.h,
          child: ListtileForm(
            title1: "Scooter\n${pricebike} EGP",
            title2: "Fast Trip\n${pricetrip} EGP",
            title3: "Econemy\n${priceeconomy} EGP",
            title4: "Proo Plus\n${PriceProoPlus} EGP",
            title5: "VIP\n${priceeconomy} EGP",
            title6: "Van\n${priceeconomy} EGP",
            trailing1: IconButton(
                onPressed: () {
                  callBackFunction;
                  showModalBottomSheet(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(27),
                        topLeft: Radius.circular(27),
                      ),
                    ),
                    constraints: const BoxConstraints(
                      maxHeight: 600,
                      minHeight: 400,
                    ),
                    useSafeArea: true,
                    isScrollControlled: true,
                    context: context,
                    builder: (context) {
                      return SingleChildScrollView(
                        child: PriceSelectionBottomSheet(
                          initialPrice: pricebike, // Ù‚Ù… Ø¨ØªØ­Ø¯ÙŠØ¯ Ø§Ù„Ù‚ÙŠÙ…Ø© Ø§Ù„Ù…Ù†Ø§Ø³Ø¨Ø©
                        ),
                      );
                    },
                  );
                },
                icon: Icon(Icons.add)),
            trailing2: IconButton(onPressed: () {}, icon: Icon(Icons.add)),
            trailing3: IconButton(onPressed: () {}, icon: Icon(Icons.add)),
            trailing4: IconButton(onPressed: () {}, icon: Icon(Icons.add)),
            trailing5: IconButton(onPressed: () {}, icon: Icon(Icons.add)),
            trailing6: IconButton(onPressed: () {}, icon: Icon(Icons.add)),
          ),
        ),
      ],
    );
  }
}


