import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocode/geocode.dart';
import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/features/driver/home/presentation/view_models/driver_home_cubit.dart';
import 'package:shakshak/generated/l10n.dart';

class SetDestinationDialog extends StatefulWidget {
  const SetDestinationDialog({super.key});

  @override
  State<SetDestinationDialog> createState() => _SetDestinationDialogState();
}

class _SetDestinationDialogState extends State<SetDestinationDialog> {
  final TextEditingController _addressController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final address = _addressController.text.trim();
    if (address.isEmpty) {
      // Just toggle off
      context.read<DriverHomeCubit>().setDestination(
        isHeadingDestination: false,
      );
      Navigator.pop(context);
      return;
    }

    setState(() => _isLoading = true);

    try {
      GeoCode geoCode = GeoCode();
      Coordinates coordinates = await geoCode.forwardGeocoding(address: address);

      if (!mounted) return;
      if (coordinates.latitude != null && coordinates.longitude != null) {
        context.read<DriverHomeCubit>().setDestination(
          isHeadingDestination: true,
          lat: coordinates.latitude,
          lng: coordinates.longitude,
          address: address,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "تم تفعيل فلتر الوجهة بنجاح",
              style: TextStyle(fontSize: 14.sp),
            ),
            backgroundColor: AppColors.primaryColor,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("لم نتمكن من تحديد الموقع، حاول كتابة عنوان أدق")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("حدث خطأ أثناء البحث عن العنوان")),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "تحديد الوجهة",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "أدخل وجهتك لكي تستقبل الرحلات التي في طريقك فقط:",
            style: TextStyle(fontSize: 14.sp),
          ),
          SizedBox(height: 12.h),
          TextField(
            controller: _addressController,
            decoration: InputDecoration(
              hintText: "مثال: المعادي، القاهرة",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            context.read<DriverHomeCubit>().setDestination(isHeadingDestination: false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("تم إيقاف فلتر الوجهة")),
            );
            Navigator.pop(context);
          },
          child: Text(
            "إلغاء التفعيل",
            style: TextStyle(color: Colors.red),
          ),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          ),
          child: _isLoading
              ? SizedBox(width: 20.r, height: 20.r, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : Text(
                  S.of(context).save,
                  style: TextStyle(color: Colors.white),
                ),
        ),
      ],
    );
  }
}
