import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/features/driver/new_rides/presentation/view_model/ride_cubit.dart';
import 'package:shakshak/features/driver/new_rides/presentation/view_model/ride_state.dart';
import 'package:shakshak/features/driver/new_rides/presentation/widgets/online_offline_toggle_button.dart';
import 'package:shakshak/features/driver/outstation/presentation/widgets/driver_rides_list_item.dart';

class NewRidesViews extends StatefulWidget {
  const NewRidesViews({super.key});

  @override
  State<NewRidesViews> createState() => _NewRidesViewsState();
}

class _NewRidesViewsState extends State<NewRidesViews> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RideCubit, RideState>(
      listenWhen: (prev, curr) => prev.rides != curr.rides,
      listener: (context, state) {
        // تمرير تلقائي لأول القائمة عند حدوث أي تغيير (زي لما رحلة تطلع فوق)
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut,
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Stack(
            children: [
              // زر الأونلاين في أقصى الجزء العلوي
              Positioned(
                left: 20.w,
                right: 20.w,
                top: 0,
                child: SafeArea(
                  child: Builder(builder: (context) {
                    return OnlineOfflineToggleButton();
                  }),
                ),
              ),

              Positioned.fill(
                top: 60.h, // تعديل الـ top عشان الزرار اللي فوق
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: state.rides.isEmpty
                      ? const Center(child: Text("لا توجد رحلات متاحة حالياً"))
                      : ListView.builder(
                          controller: _scrollController,
                          itemCount: state.rides.length,
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.only(
                              top: 20.h, bottom: 40.h, left: 16.w, right: 16.w),
                          itemBuilder: (context, index) {
                            final ride = state.rides[index];
                            return Padding(
                              padding: EdgeInsets.only(bottom: 12.h),
                              child: DriverRidesListItem(
                                key: ValueKey(ride.id),
                                isOutstation: ride.parcelWeight != null,
                                isNew: state.newRideIds.contains(ride.id),
                                ride: ride,
                              ),
                            );
                          },
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
