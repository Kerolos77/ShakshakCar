import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';
import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/utils/shared_widgets/custom_button.dart';
import 'package:shakshak/core/utils/shared_widgets/custom_loading_button.dart';
import 'package:shakshak/core/utils/shared_widgets/custom_text_field.dart';
import 'package:shakshak/core/utils/shared_widgets/show_snack_bar.dart';
import 'package:shakshak/core/utils/styles.dart';
import 'package:shakshak/core/utils/validations.dart';
import 'package:shakshak/features/shared/base_layout/presentation/views/base_layout_view.dart';
import 'package:shakshak/features/shared/support_tickets/presentation/cubit/support_ticket_cubit.dart';
import 'package:shakshak/features/shared/support_tickets/presentation/cubit/support_ticket_state.dart';

class CreateTicketView extends StatefulWidget {
  /// إذا كان التكيت مرتبطاً برحلة معينة
  final int? orderId;

  /// موضوع مسبق يُملأ تلقائياً (مثلاً من TripIssueView)
  final String? prefillSubject;

  const CreateTicketView({super.key, this.orderId, this.prefillSubject});

  @override
  State<CreateTicketView> createState() => _CreateTicketViewState();
}

class _CreateTicketViewState extends State<CreateTicketView> {
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _selectedPriority = 'medium';

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
    if (widget.prefillSubject != null) {
      _subjectController.text = widget.prefillSubject!;
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
          // Go back to list and refresh
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
                // Order Badge (if linked to a trip)
                if (widget.orderId != null) ...[
                  _buildOrderBadge(context),
                  20.ph,
                ],

                // Subject Field
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

                // Priority Selector
                Text(
                  'أولوية التكيت',
                  style: Styles.textStyle16Bold(context),
                ),
                8.ph,
                _buildPrioritySelector(context),
                20.ph,

                // Description Field
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

                // Submit Button
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

  Widget _buildOrderBadge(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          Icon(Icons.link_rounded,
              color: AppColors.primaryColor, size: 20.r),
          10.pw,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'مرتبط برحلة',
                style: Styles.textStyle12Regular(context).copyWith(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'رقم الطلب: #${widget.orderId}',
                style: Styles.textStyle14Medium(context),
              ),
            ],
          ),
        ],
      ),
    );
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
              padding:
                  EdgeInsets.symmetric(vertical: 10.h),
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
    if (_formKey.currentState!.validate()) {
      context.read<SupportTicketCubit>().createTicket(
            subject: _subjectController.text.trim(),
            description: _descriptionController.text.trim(),
            orderId: widget.orderId,
            priority: _selectedPriority,
          );
    }
  }
}
