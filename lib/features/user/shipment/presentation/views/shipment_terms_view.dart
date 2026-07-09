import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';
import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/generated/l10n.dart';

class ShipmentTermsView extends StatelessWidget {
  const ShipmentTermsView({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';

    final String title = S.of(context).termsLink;

    final List<Map<String, dynamic>> arTerms = [
      {
        'title': '1. أكواد التحقق الأمنية (OTP)',
        'desc': 'لحماية شحنتك، يتم إنشاء أكواد تحقق (OTP) لعملية الاستلام والتسليم. يلتزم المرسل والمستلم بتأكيد الأكواد مع السائق لإكمال الرحلة بنجاح.',
        'icon': Icons.security,
      },
      {
        'title': '2. المواد المحظورة والممنوعة',
        'desc': 'يُمنع منعاً باتاً شحن أو نقل أي مواد تخالف القوانين المحلية، بما في ذلك المواد القابلة للاشتعال، الأسلحة، المواد المخدرة، العملات النقدية، أو البضائع المهربة.',
        'icon': Icons.block,
      },
      {
        'title': '3. المسؤولية والتعويض',
        'desc': 'يكون السائق مسؤولاً عن سلامة الطرد منذ استلامه وتأكيد كود الاستلام وحتى تسليمه للمستلم. المنصة لا تتحمل مسؤولية تلف المواد الثمينة أو القابلة للكسر غير المغلفة جيداً.',
        'icon': Icons.gavel,
      },
      {
        'title': '4. مطابقة البيانات والأوزان',
        'desc': 'يجب أن تتطابق أبعاد ووزن الشحنة الحقيقية مع البيانات المدخلة في طلب الشحن. يحق للسائق إلغاء الرحلة إذا تبين عدم مطابقة المواصفات الفعلية.',
        'icon': Icons.scale,
      },
    ];

    final List<Map<String, dynamic>> enTerms = [
      {
        'title': '1. Security Verification Codes (OTP)',
        'desc': 'To secure your shipment, OTP verification codes are generated for pickup and delivery. Sender and receiver must confirm these codes with the driver.',
        'icon': Icons.security,
      },
      {
        'title': '2. Prohibited and Illegal Items',
        'desc': 'It is strictly forbidden to ship or transport items violating local laws, including flammable materials, weapons, drugs, cash, or contraband.',
        'icon': Icons.block,
      },
      {
        'title': '3. Liability & Compensation',
        'desc': 'The driver is responsible for package safety from pickup confirmation until handover. The platform is not liable for fragile or valuable items not packed properly.',
        'icon': Icons.gavel,
      },
      {
        'title': '4. Accuracy of Dimensions & Weight',
        'desc': 'Actual package dimensions and weight must match the values entered. Drivers reserve the right to cancel if cargo specifications are mismatched.',
        'icon': Icons.scale,
      },
    ];

    final terms = isArabic ? arTerms : enTerms;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: AppColors.primaryColor.withValues(alpha: 0.15),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppColors.primaryColor,
                    size: 28.sp,
                  ),
                  12.pw,
                  Expanded(
                    child: Text(
                      isArabic
                          ? 'يرجى قراءة شروط الخدمة بعناية قبل تأكيد طلب الشحن.'
                          : 'Please read the terms of service carefully before confirming shipment request.',
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            24.ph,
            ...terms.map((item) {
              return Card(
                margin: EdgeInsets.only(bottom: 16.h),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  side: BorderSide(
                    color: Colors.grey.shade200,
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withValues(alpha: 0.05),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          item['icon'] as IconData,
                          color: AppColors.primaryColor,
                          size: 22.sp,
                        ),
                      ),
                      16.pw,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['title'] as String,
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            8.ph,
                            Text(
                              item['desc'] as String,
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: Colors.grey.shade600,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            20.ph,
          ],
        ),
      ),
    );
  }
}
