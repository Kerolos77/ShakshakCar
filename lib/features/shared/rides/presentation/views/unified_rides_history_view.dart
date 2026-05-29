import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';
import 'package:shakshak/core/constants/app_const.dart';
import 'package:shakshak/core/network/local/cache_helper.dart';
import 'package:shakshak/core/utils/styles.dart';
import 'package:shakshak/features/shared/base_layout/presentation/views/base_layout_view.dart';
import 'package:shakshak/features/shared/rides/presentation/view_models/rides_cubit.dart';
import 'package:shakshak/features/user/user_home/data/models/new-ride/new_ride_data.dart';
import 'package:shakshak/generated/l10n.dart';
import 'package:shakshak/features/shared/rides/presentation/widgets/ride_history_list_item.dart';

class UnifiedRidesHistoryView extends StatefulWidget {
  final bool isSelectionMode;
  const UnifiedRidesHistoryView({super.key, this.isSelectionMode = false});

  @override
  State<UnifiedRidesHistoryView> createState() =>
      _UnifiedRidesHistoryViewState();
}

class _UnifiedRidesHistoryViewState extends State<UnifiedRidesHistoryView> {
  @override
  void initState() {
    super.initState();
    _fetchRides();
  }

  void _fetchRides() {
    final bool isDriver = CacheHelper.getData(key: AppConstant.kIsDriver) == 1;
    context.read<RidesCubit>().getRides(inCity: null, isDriver: isDriver);
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayoutView(
      title: S.of(context).rides,
      body: BlocBuilder<RidesCubit, RidesState>(
        builder: (context, state) {
          if (state is RidesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is RidesFailure) {
            return Center(child: Text(state.errorMessage));
          } else if (state is RidesSuccess) {
            final allRides = state.ridesEntity.data?.allRides ?? [];
            debugPrint('=== UnifiedRidesHistoryView ===');
            debugPrint('allRides count: ${allRides.length}');
            if (allRides.isEmpty) {
              return Center(child: Text(S.of(context).noData));
            }

            // Split and Sort
            final activeRides = allRides.where((r) => 
              r.status.toLowerCase() != 'completed' && 
              r.status.toLowerCase() != 'canceled'
            ).toList();
            
            final inactiveRides = allRides.where((r) => 
              r.status.toLowerCase() == 'completed' || 
              r.status.toLowerCase() == 'canceled'
            ).toList();

            debugPrint('activeRides count: ${activeRides.length}');
            debugPrint('inactiveRides count: ${inactiveRides.length}');

            // Sort by ID descending (newest first)
            activeRides.sort((a, b) => b.id.compareTo(a.id));
            inactiveRides.sort((a, b) => b.id.compareTo(a.id));

            final combinedList = [...activeRides, ...inactiveRides];
            debugPrint('combinedList count: ${combinedList.length}');

            return ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              itemCount: combinedList.length,
              separatorBuilder: (_, __) => 12.ph,
              itemBuilder: (context, index) => RideHistoryListItem(
                ride: combinedList[index],
                isSelectionMode: widget.isSelectionMode,
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

}
