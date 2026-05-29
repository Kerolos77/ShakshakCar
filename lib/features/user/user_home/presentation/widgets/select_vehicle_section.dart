import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';
import 'package:shakshak/core/utils/styles.dart';

import 'package:shakshak/features/user/user_home/data/models/price_model.dart';
import 'package:shakshak/features/user/user_home/data/models/services_model.dart';
import 'package:shakshak/generated/l10n.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:shakshak/features/user/user_home/presentation/view_models/user_home/user_home_cubit.dart';
import 'package:shakshak/features/user/user_home/presentation/view_models/user_home/user_home_state.dart';
import 'vehicle_item_widget.dart';

class SelectVehicleSection extends StatefulWidget {
  SelectVehicleSection({super.key, this.isInCity = true});

  bool isInCity;

  @override
  State<SelectVehicleSection> createState() => _SelectVehicleSectionState();
}

class _SelectVehicleSectionState extends State<SelectVehicleSection> {
  @override
  void initState() {
    super.initState();
    // context.read<UserHomeCubit>().getServices(widget.isInCity);
  }

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(S.of(context).selectVehicle,
            style: Styles.textStyle16SemiBold(context)),
        12.ph,
        BlocBuilder<UserHomeCubit, UserHomeState>(
          buildWhen: (previous, current) =>
              current is ServicesLoading ||
              current is ServicesSuccess ||
              current is ServicesFailure,
          builder: (context, state) {
            if (state is ServicesSuccess) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children:
                      List.generate(state.servicesModel.data!.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: VehicleItemWidget(
                        service: state.servicesModel.data![index],
                        price: PriceModel(km: 0, price: "0", min: "0"),
                        isSelected: selectedIndex == index,
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                      ),
                    );
                  }),
                ),
              );
              // return SingleChildScrollView(
              //   scrollDirection: Axis.horizontal,
              //   child: Row(
              //     children:
              //         List.generate(state.servicesModel.data!.length, (index) {
              //       return Padding(
              //         padding: EdgeInsets.only(
              //             right: index == state.servicesModel.data!.length - 1
              //                 ? 0
              //                 : 12.w),
              //         child: VehicleItemWidget(
              //           service: state.servicesModel.data![index],
              //           isSelected: selectedIndex == index,
              //           onTap: () => setState(() => selectedIndex = index),
              //         ),
              //       );
              //     }),
              //   ),
              // );
            } else if (state is ServicesLoading) {
              return Row(
                children: List.generate(3, (index) {
                  return Row(
                    children: [
                      Skeletonizer(
                        child: VehicleItemWidget(
                          price: PriceModel(km: 0, price: "0", min: "0"),
                          service: ServiceData(
                              image: '',
                              id: 0,
                              name: 'test',
                              offerRate: 'aaaaaaaaaaa',
                              serviceType: 'aaaaaaaaaaaa'),
                          isSelected: selectedIndex == index,
                          onTap: () {
                            setState(() {
                              selectedIndex = index;
                            });
                          },
                        ),
                      ),
                      if (index != 2) 12.pw,
                    ],
                  );
                }),
              );
            } else if (state is ServicesFailure) {
              return Center(
                child: SizedBox(
                  height: 50.h,
                  child: Text(
                    state.errorMessage,
                    style: Styles.textStyle16(context),
                  ),
                ),
              );
            } else {
              return SizedBox();
            }
          },
        ),
      ],
    );
  }
}
