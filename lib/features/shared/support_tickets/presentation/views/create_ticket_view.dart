import 'package:animate_do/animate_do.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:shakshak/core/constants/app_const.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';
import 'package:shakshak/core/network/local/cache_helper.dart';
import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/services/service_locator.dart';
import 'package:shakshak/core/utils/shared_widgets/custom_button.dart';
import 'package:shakshak/core/utils/shared_widgets/custom_loading_button.dart';
import 'package:shakshak/core/utils/shared_widgets/custom_text_field.dart';
import 'package:shakshak/core/utils/shared_widgets/ride_destination_widget.dart';
import 'package:shakshak/core/utils/shared_widgets/show_snack_bar.dart';
import 'package:shakshak/core/utils/styles.dart';
import 'package:shakshak/core/utils/validations.dart';
import 'package:shakshak/features/shared/base_layout/presentation/views/base_layout_view.dart';
import 'package:shakshak/features/shared/rides/domain/usecases/get_rides_usecase.dart';
import 'package:shakshak/features/shared/support_tickets/presentation/cubit/support_ticket_cubit.dart';
import 'package:shakshak/features/shared/support_tickets/presentation/cubit/support_ticket_state.dart';
import 'package:shakshak/features/user/user_home/data/models/new-ride/new_ride_data.dart';

class CreateTicketView extends StatefulWidget {
  /// إذا كان التكيت مرتبطاً برحلة معينة مسبقاً
  final int? orderId;

  /// موضوع مسبق يُملأ تلقائياً
  final String? prefillSubject;

  const CreateTicketView({super.key, this.orderId, this.prefillSubject});

  @override
  State<CreateTicketView> createState() => _CreateTicketViewState();
}

class _CreateTicketViewState extends State<CreateTicketView> {
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  int? _selectedOrderId;
  NewRideData? _selectedRide;
  String _selectedPriority = 'medium';

  bool _isLoadingRides = false;
  List<NewRideData> _availableRides = [];
  String? _ridesErrorMsg;

  static const Map<String, String> _priorityLabels = {
    'low': 'منخفضة',
    'medium': 'متوسطة',
    'high': 'عالية',
    'urgent': 'عاجلة',
  };

  static const Map<String, Color> _priorityColors = {
    'low': Color(0xFF4CAF50),
    'medium': Color(0xFF2196F3),
    'high': Color(0xFFFF9800),
    'urgent': Color(0xFFF44336),
  };

  @override
  void initState() {
    super.initState();
    _selectedOrderId = widget.orderId;
    if (widget.prefillSubject != null) {
      _subjectController.text = widget.prefillSubject!;
    }
    // Fetch rides in background so they are ready if user clicks picker
    _fetchRides();
  }

  Future<void> _fetchRides() async {
    setState(() {
      _isLoadingRides = true;
      _ridesErrorMsg = null;
    });

    try {
      final bool isDriver =
          CacheHelper.getData(key: AppConstant.kIsDriver) == 1;
      final useCase = sl<GetSharedRidesUseCase>();
      final result =
          await useCase(GetSharedRidesParams(inCity: null, isDriver: isDriver));

      result.fold(
        (failure) {
          if (mounted) {
            setState(() {
              _isLoadingRides = false;
              _ridesErrorMsg = failure.message;
            });
          }
        },
        (ridesEntity) {
          final list = ridesEntity.data?.allRides ?? [];
          list.sort((a, b) => b.id.compareTo(a.id));
          if (mounted) {
            setState(() {
              _availableRides = list;
              _isLoadingRides = false;
              // If orderId was passed, match full ride object for UI
              if (_selectedOrderId != null && _selectedRide == null) {
                try {
                  _selectedRide =
                      list.firstWhere((r) => r.id == _selectedOrderId);
                } catch (_) {}
              }
            });
          }
        },
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingRides = false;
          _ridesErrorMsg = e.toString();
        });
      }
    }
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SupportTicketCubit, SupportTicketState>(
      listener: (context, state) {
        if (state is TicketCreatedSuccess) {
          showSnackBar(
            context,
            'تم إرسال تذكرة الدعم بنجاح. رقم التكيت: ${state.ticket.ticketNumber}',
            'تم بنجاح',
            AppColors.primaryColor,
            ContentType.success,
          );
          if (context.mounted) Navigator.pop(context, true);
        }
        if (state is SupportTicketError) {
          showSnackBar(
            context,
            state.message,
            'حدث خطأ',
            AppColors.redColor,
            ContentType.failure,
          );
        }
      },
      child: BaseLayoutView(
        title: 'إنشاء تكيت دعم',
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Mandatory Ride Selector Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'الرحلة المتعلقة بالمشكلة *',
                      style: Styles.textStyle16Bold(context),
                    ),
                    if (_selectedOrderId != null)
                      TextButton.icon(
                        onPressed: () => _openRidePickerBottomSheet(context),
                        icon: Icon(Icons.swap_horiz_rounded,
                            size: 18.r, color: AppColors.primaryColor),
                        label: Text(
                          'تغيير الرحلة',
                          style: Styles.textStyle12Regular(context).copyWith(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
                8.ph,
                _buildRideSelectorCard(context),
                24.ph,

                // 2. Subject Field
                Text(
                  'موضوع المشكلة',
                  style: Styles.textStyle16Bold(context),
                ),
                8.ph,
                CustomTextField(
                  controller: _subjectController,
                  hint: 'مثال: مشكلة في الدفع أو تأخير السائق',
                  autoValidateMode: AutovalidateMode.onUserInteraction,
                  validator: Validation.validateDescription(context),
                ),
                20.ph,

                // 3. Priority Selector
                Text(
                  'أولوية التكيت',
                  style: Styles.textStyle16Bold(context),
                ),
                8.ph,
                _buildPrioritySelector(context),
                20.ph,

                // 4. Description Field
                Text(
                  'تفاصيل المشكلة',
                  style: Styles.textStyle16Bold(context),
                ),
                8.ph,
                CustomTextField(
                  controller: _descriptionController,
                  hint:
                      'اشرح مشكلتك بالتفصيل حتى يتمكن فريق الدعم من مساعدتك...',
                  maxLiens: 8,
                  autoValidateMode: AutovalidateMode.onUserInteraction,
                  validator: Validation.validateDescription(context),
                ),
                32.ph,

                // 5. Submit Button
                BlocBuilder<SupportTicketCubit, SupportTicketState>(
                  builder: (context, state) {
                    if (state is SupportTicketLoading) {
                      return const CustomLoadingButton();
                    }
                    return CustomButton(
                      text: 'إرسال التكيت',
                      onTap: _submitTicket,
                    );
                  },
                ),
                20.ph,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRideSelectorCard(BuildContext context) {
    if (_selectedOrderId != null) {
      return Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.primaryColor.withOpacity(0.4), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    'رقم الرحلة: #$_selectedOrderId',
                    style: Styles.textStyle14Bold(context)
                        .copyWith(color: AppColors.primaryColor),
                  ),
                ),
                if (_selectedRide != null)
                  Text(
                    '${_selectedRide!.amount} ج.م',
                    style: Styles.textStyle16Bold(context)
                        .copyWith(color: AppColors.primaryColor),
                  ),
              ],
            ),
            if (_selectedRide != null) ...[
              12.ph,
              const Divider(height: 1),
              12.ph,
              RideDestinationWidget(
                from: _selectedRide!.sourceAddress,
                to: _selectedRide!.destinationAddress,
              ),
              10.ph,
              Row(
                children: [
                  Icon(Icons.access_time_rounded,
                      size: 13.r,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.4)),
                  4.pw,
                  Text(
                    DateFormat('yyyy/MM/dd - hh:mm a')
                        .format(_selectedRide!.createdAt),
                    style: Styles.textStyle12Regular(context).copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      );
    }

    // No ride selected yet -> Prompt Card
    return InkWell(
      onTap: () => _openRidePickerBottomSheet(context),
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
              color: AppColors.primaryColor.withOpacity(0.5),
              width: 1.5,
              style: BorderStyle.solid),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.directions_car_filled_rounded,
                  color: AppColors.primaryColor, size: 26.r),
            ),
            14.pw,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'اختر الرحلة المتعلقة بالمشكلة *',
                    style: Styles.textStyle14Bold(context)
                        .copyWith(color: AppColors.primaryColor),
                  ),
                  4.ph,
                  Text(
                    'اضغط هنا لتحديد الرحلة لسرعة المراجعة والحل',
                    style: Styles.textStyle12Regular(context).copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded,
                size: 16.r, color: AppColors.primaryColor),
          ],
        ),
      ),
    );
  }

  void _openRidePickerBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) {
        return StatefulBuilder(
          builder: (context, setBottomSheetState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
              ),
              child: Column(
                children: [
                  // BottomSheet Drag handle
                  12.ph,
                  Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                  12.ph,
                  // Header
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'اختر الرحلة',
                          style: Styles.textStyle18Bold(context),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(bottomSheetContext),
                          icon: const Icon(Icons.close_rounded),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),

                  // Rides List Body
                  Expanded(
                    child: Builder(
                      builder: (context) {
                        if (_isLoadingRides) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (_ridesErrorMsg != null) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(_ridesErrorMsg!,
                                    style: Styles.textStyle14Medium(context)),
                                12.ph,
                                ElevatedButton(
                                  onPressed: () {
                                    setBottomSheetState(() {
                                      _fetchRides();
                                    });
                                  },
                                  child: const Text('إعادة المحاولة'),
                                ),
                              ],
                            ),
                          );
                        }
                        if (_availableRides.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.history_rounded,
                                    size: 50.r, color: Colors.grey),
                                12.ph,
                                Text(
                                  'لا توجد رحلات سابقة',
                                  style: Styles.textStyle16Bold(context),
                                ),
                              ],
                            ),
                          );
                        }

                        return ListView.separated(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 16.h),
                          itemCount: _availableRides.length,
                          separatorBuilder: (_, __) => 12.ph,
                          itemBuilder: (context, index) {
                            final ride = _availableRides[index];
                            final isSelected = ride.id == _selectedOrderId;

                            return InkWell(
                              onTap: () {
                                setState(() {
                                  _selectedOrderId = ride.id;
                                  _selectedRide = ride;
                                  if (_subjectController.text.trim().isEmpty) {
                                    _subjectController.text =
                                        'مشكلة في رحلة #${ride.id}';
                                  }
                                });
                                Navigator.pop(bottomSheetContext);
                              },
                              borderRadius: BorderRadius.circular(16.r),
                              child: Container(
                                padding: EdgeInsets.all(14.r),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(16.r),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primaryColor
                                        : Theme.of(context).dividerColor,
                                    width: isSelected ? 2 : 1,
                                  ),
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: AppColors.primaryColor
                                                .withOpacity(0.15),
                                            blurRadius: 8,
                                            offset: const Offset(0, 3),
                                          )
                                        ]
                                      : null,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            if (isSelected) ...[
                                              Icon(Icons.check_circle_rounded,
                                                  color: AppColors.primaryColor,
                                                  size: 18.r),
                                              6.pw,
                                            ],
                                            Text(
                                              'رقم الرحلة: #${ride.id}',
                                              style: Styles.textStyle14Bold(
                                                      context)
                                                  .copyWith(
                                                color: isSelected
                                                    ? AppColors.primaryColor
                                                    : null,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          '${ride.amount} ج.م',
                                          style: Styles.textStyle16Bold(context)
                                              .copyWith(
                                            color: AppColors.primaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    10.ph,
                                    RideDestinationWidget(
                                      from: ride.sourceAddress,
                                      to: ride.destinationAddress,
                                    ),
                                    8.ph,
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          DateFormat('yyyy/MM/dd - hh:mm a')
                                              .format(ride.createdAt),
                                          style: Styles.textStyle12Regular(
                                                  context)
                                              .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface
                                                .withOpacity(0.5),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8.w, vertical: 2.h),
                                          decoration: BoxDecoration(
                                            color: _getStatusColor(ride.status)
                                                .withOpacity(0.12),
                                            borderRadius:
                                                BorderRadius.circular(6.r),
                                          ),
                                          child: Text(
                                            _getLocalizedStatus(ride.status),
                                            style: Styles.textStyle10Regular(
                                                    context)
                                                .copyWith(
                                              color:
                                                  _getStatusColor(ride.status),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'canceled':
        return Colors.red;
      case 'started':
      case 'accepted':
      case 'placed':
        return Colors.blue;
      default:
        return Colors.orange;
    }
  }

  String _getLocalizedStatus(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return 'مكتملة';
      case 'canceled':
        return 'ملغاة';
      case 'started':
        return 'جاري التنفيذ';
      case 'accepted':
        return 'مقبولة';
      default:
        return status;
    }
  }

  Widget _buildPrioritySelector(BuildContext context) {
    return Row(
      children: _priorityLabels.entries.map((entry) {
        final isSelected = _selectedPriority == entry.key;
        final color = _priorityColors[entry.key]!;
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _selectedPriority = entry.key),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: EdgeInsets.only(
                  right: entry.key == 'urgent' ? 0 : 8.w),
              padding: EdgeInsets.symmetric(vertical: 10.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? color.withOpacity(0.12)
                    : Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                  color: isSelected ? color : Theme.of(context).dividerColor,
                  width: isSelected ? 1.5 : 1,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.flag_rounded,
                    color: isSelected ? color : Colors.grey,
                    size: 18.r,
                  ),
                  4.ph,
                  Text(
                    entry.value,
                    style: Styles.textStyle12Regular(context).copyWith(
                      color: isSelected ? color : Colors.grey,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  void _submitTicket() {
    // 1. Mandatory Ride Check
    if (_selectedOrderId == null) {
      showSnackBar(
        context,
        'يرجى اختيار الرحلة المتعلقة بالمشكلة أولاً',
        'تحديد رحلة مطلوب',
        AppColors.redColor,
        ContentType.failure,
      );
      _openRidePickerBottomSheet(context);
      return;
    }

    // 2. Validate Form
    if (_formKey.currentState!.validate()) {
      context.read<SupportTicketCubit>().createTicket(
            subject: _subjectController.text.trim(),
            description: _descriptionController.text.trim(),
            orderId: _selectedOrderId,
            priority: _selectedPriority,
          );
    }
  }
}
