import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/core/utils/styles.dart';
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:shakshak/features/user/user_home/data/models/price_model.dart';
import 'package:shakshak/features/user/user_home/data/models/services_deteles_model.dart';
import 'package:shakshak/features/user/user_home/data/models/services_model.dart';
import 'package:shakshak/generated/l10n.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/services/user_storage_service.dart';

import 'package:shakshak/features/user/user_home/presentation/view_models/user_home/user_home_cubit.dart';
import 'package:shakshak/features/user/user_home/presentation/view_models/user_home/user_home_state.dart';
import 'ride_actions_bar.dart';
import 'ride_services_list.dart';

class BookRideSheetContent extends StatefulWidget {
  final ScrollController scrollController;
  final int selectedServiceIndex;
  final String selectedPaymentMethod;
  final double currentOffer;
  final double minPriceLimit;
  final double maxPriceLimit;
  final Function(int, String) onServiceSelected;
  final VoidCallback onIncreasePrice;
  final VoidCallback onDecreasePrice;
  final ValueChanged<double> onSliderChanged;
  final Function(String) onResetPrice;
  final ValueChanged<String> onPaymentChanged;
  final bool useWallet;
  final ValueChanged<bool> onWalletToggled;
  final VoidCallback onConfirmTap;
  final bool isInCity;
  final DateTime scheduledDate;
  final int passengerCount;
  final ValueChanged<DateTime> onDateChanged;
  final ValueChanged<int> onPassengerCountChanged;

  const BookRideSheetContent({
    super.key,
    required this.scrollController,
    required this.selectedServiceIndex,
    required this.selectedPaymentMethod,
    required this.currentOffer,
    required this.minPriceLimit,
    required this.maxPriceLimit,
    required this.onServiceSelected,
    required this.onIncreasePrice,
    required this.onDecreasePrice,
    required this.onSliderChanged,
    required this.onResetPrice,
    required this.onPaymentChanged,
    required this.useWallet,
    required this.onWalletToggled,
    required this.onConfirmTap,
    required this.isInCity,
    required this.scheduledDate,
    required this.passengerCount,
    required this.onDateChanged,
    required this.onPassengerCountChanged,
  });

  @override
  State<BookRideSheetContent> createState() => _BookRideSheetContentState();
}

class _BookRideSheetContentState extends State<BookRideSheetContent> {
  @override
  void initState() {
    context.read<UserHomeCubit>().getServices(widget.isInCity);
    _dateController.text =
        DateFormat('yyyy-MM-dd HH:mm').format(widget.scheduledDate);
    super.initState();
  }

  final TextEditingController _dateController = TextEditingController();

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant BookRideSheetContent oldWidget) {
    if (oldWidget.scheduledDate != widget.scheduledDate) {
      _dateController.text =
          DateFormat('yyyy-MM-dd HH:mm').format(widget.scheduledDate);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.r),
          topRight: Radius.circular(30.r),
        ),
        boxShadow: [
          BoxShadow(
            color:
                Theme.of(context).colorScheme.onSurface.withOpacity(0.15),
            blurRadius: 15.r,
            offset: Offset(0, -5.h),
          ),
        ],
      ),
      child: BlocBuilder<UserHomeCubit, UserHomeState>(
        buildWhen: (previous, current) =>
            current is ServicesLoading ||
            current is GetPriceLoading ||
            current is GetPriceSuccess ||
            current is ServicesFailure ||
            current is GetPriceFailure,
        builder: (context, state) {
          if (state is ServicesLoading || state is GetPriceLoading) {
            return Skeletonizer(
              enabled: true,
              child: Column(
                children: [
                  Expanded(
                    child: RideServicesList(
                      scrollController: widget.scrollController,
                      services: List.generate(
                        5,
                        (index) => ServicesDetailsModel(
                          service: ServiceData(
                            id: index,
                            name: "Service Name",
                            serviceType: "Type",
                            offerRate: "10%",
                            image: "",
                          ),
                          price: PriceModel(
                            price: "00.00",
                            km: 10,
                            min: "15",
                          ),
                        ),
                      ),
                      selectedServiceIndex: -1,
                      onServiceSelected: (_, __) {},
                      currentOffer: 0.0,
                      minPriceLimit: 0.0,
                      maxPriceLimit: 0.0,
                      onIncreasePrice: () {},
                      onDecreasePrice: () {},
                      onSliderChanged: (_) {},
                      onResetPrice: (_) {},
                      isInCity: widget.isInCity,
                    ),
                  ),
                  RideActionsBar(
                    selectedPaymentMethod: widget.selectedPaymentMethod,
                    onPaymentChanged: widget.onPaymentChanged,
                    useWallet: widget.useWallet,
                    onWalletToggled: widget.onWalletToggled,
                    onConfirmTap: widget.onConfirmTap,
                    isLoading: state is NewRideRequestLoading,
                  ),
                ],
              ),
            );
          } else if (state is GetPriceSuccess) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: RideServicesList(
                    scrollController: widget.scrollController,
                    services: state.servicesDetails,
                    selectedServiceIndex: widget.selectedServiceIndex,
                    onServiceSelected: widget.onServiceSelected,
                    currentOffer: widget.currentOffer,
                    minPriceLimit: widget.minPriceLimit,
                    maxPriceLimit: widget.maxPriceLimit,
                    onIncreasePrice: widget.onIncreasePrice,
                    onDecreasePrice: widget.onDecreasePrice,
                    onSliderChanged: widget.onSliderChanged,
                    onResetPrice: widget.onResetPrice,
                    isInCity: widget.isInCity,
                  ),
                ),
                SizedBox(height: 10.h),
                _buildScheduleAndPassengers(context),
                RideActionsBar(
                  selectedPaymentMethod: widget.selectedPaymentMethod,
                  onPaymentChanged: widget.onPaymentChanged,
                  useWallet: widget.useWallet,
                  onWalletToggled: widget.onWalletToggled,
                  onConfirmTap: widget.onConfirmTap,
                  isLoading: state is NewRideRequestLoading,
                ),
              ],
            );
          }
          if (state is ServicesFailure ||
              state is GetPriceFailure ||
              context.read<UserHomeCubit>().servicesDetails.isEmpty) {
            String error = "Sorry No services found try again later";
            if (state is ServicesFailure) {
              error = state.errorMessage;
            } else if (state is GetPriceFailure) {
              error = state.errorMessage;
            }
            return ListView(
              controller: widget.scrollController,
              children: [
                SizedBox(height: 50.h),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 80.r,
                        color: Colors.redAccent,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        S.of(context).errorOccurred,
                        style: Styles.textStyle20Bold(context),
                      ),
                      SizedBox(height: 8.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Text(
                          error,
                          textAlign: TextAlign.center,
                          style: Styles.textStyle16(context)
                              .copyWith(color: Theme.of(context).hintColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildScheduleAndPassengers(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Column(
        children: [
          Row(
            children: [
              // Simplified Schedule Picker
              Expanded(
                child: InkWell(
                  onTap: () {
                    picker.DatePicker.showDateTimePicker(
                      context,
                      showTitleActions: true,
                      minTime: DateTime.now(),
                      onConfirm: (date) => widget.onDateChanged(date),
                      currentTime: widget.scheduledDate,
                      locale:
                          Localizations.localeOf(context).languageCode == 'ar'
                              ? picker.LocaleType.ar
                              : picker.LocaleType.en,
                      theme: picker.DatePickerTheme(
                        headerColor: Theme.of(context).cardColor,
                        backgroundColor: Theme.of(context).cardColor,
                        itemStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.sp,
                        ),
                        doneStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        cancelStyle: TextStyle(
                          color: Theme.of(context).hintColor,
                          fontSize: 16.sp,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      color:
                          Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.darkSecondary
                            : Theme.of(context)
                                .primaryColor
                                .withOpacity(0.5),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.access_time_filled,
                            color: Theme.of(context).primaryColor, size: 20.sp),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            DateFormat('MMM dd, HH:mm')
                                .format(widget.scheduledDate),
                            style: Styles.textStyle14(context),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              // Simplified Passenger Counter
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.darkSecondary
                          : Theme.of(context)
                              .primaryColor
                              .withOpacity(0.5)),
                ),
                child: Row(
                  children: [
                    _buildCounterBtn(
                      icon: Icons.remove,
                      onTap: widget.passengerCount > 1
                          ? () => widget.onPassengerCountChanged(
                              widget.passengerCount - 1)
                          : null,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Row(
                        children: [
                          Icon(Icons.person,
                              size: 16.sp, color: Theme.of(context).hintColor),
                          SizedBox(width: 4.w),
                          Text(
                            widget.passengerCount.toString(),
                            style: Styles.textStyle16Bold(context),
                          ),
                        ],
                      ),
                    ),
                    _buildCounterBtn(
                      icon: Icons.add,
                      onTap: widget.passengerCount < 6
                          ? () => widget.onPassengerCountChanged(
                              widget.passengerCount + 1)
                          : null,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              // Smart Female Only Toggle
              if (UserStorageService.getUser()?.gender == 'female')
              BlocBuilder<UserHomeCubit, UserHomeState>(
                builder: (context, state) {
                  final cubit = context.read<UserHomeCubit>();
                  final isActive = cubit.isFemaleOnly;
                  return InkWell(
                    onTap: () => cubit.toggleFemaleOnly(!isActive),
                    borderRadius: BorderRadius.circular(12.r),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.w, vertical: 10.h),
                      decoration: BoxDecoration(
                        color: isActive
                            ? Colors.pinkAccent.withOpacity(0.1)
                            : Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: isActive
                              ? Colors.pinkAccent
                              : Theme.of(context).dividerColor,
                        ),
                      ),
                      child: Icon(
                        Icons.female,
                        color: isActive
                            ? Colors.pinkAccent
                            : Theme.of(context).hintColor,
                        size: 20.sp,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCounterBtn({required IconData icon, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(6.r),
        decoration: BoxDecoration(
          color: onTap == null
              ? Colors.transparent
              : Theme.of(context).colorScheme.surface,
          shape: BoxShape.circle,
          boxShadow: onTap == null
              ? null
              : [
                  BoxShadow(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2))
                ],
        ),
        child: Icon(icon,
            size: 18.sp,
            color: onTap == null
                ? Theme.of(context).disabledColor
                : Theme.of(context).colorScheme.onSurface),
      ),
    );
  }
}
