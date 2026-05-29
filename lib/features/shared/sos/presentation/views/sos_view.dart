import 'dart:ui';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/utils/common_use.dart';
import 'package:shakshak/core/utils/styles.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';

class SOSView extends StatelessWidget {
  const SOSView({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const CustomBackButton(color: Colors.white),
        title: Text(
          'استغاثة - SOS',
          style: Styles.textStyle18Bold(context).copyWith(color: Colors.white),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            // Decorative circles
            Positioned(
              top: -50,
              right: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red.withOpacity(0.15),
                ),
              ),
            ),
            Positioned(
              bottom: 100,
              left: -30,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryColor.withOpacity(0.1),
                ),
              ),
            ),
            
            SafeArea(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                children: [
                  FadeInDown(
                    duration: const Duration(milliseconds: 500),
                    child: _SOSHeader(),
                  ),
                  20.ph,
                  
                  _buildSectionHeader(context, "النجدة والأمن العام"),
                  _buildSOSItem(
                    context,
                    title: "النجدة (بلطجة / ميكروباص / نجدة)",
                    description: "للإبلاغ عن حالات البلطجة، تغيير خط السير، أو طلب نجدة فورية.",
                    number: "122",
                    icon: Icons.local_police,
                    color: Colors.blueAccent,
                  ),
                  
                  _buildSectionHeader(context, "النيابة العامة والبلاغات المصورة"),
                  _buildSOSItem(
                    context,
                    title: "واتساب النيابة العامة",
                    description: "إرسال فيديوهات اعتداء، سرقة، أو تحرش مباشرة للنيابة.",
                    number: "01229869384",
                    icon: Icons.video_library,
                    color: Colors.green,
                    isWhatsApp: true,
                  ),
                  
                  _buildSectionHeader(context, "الصحة والطوارئ الطبية"),
                  _buildSOSItem(
                    context,
                    title: "الإسعاف المصري",
                    description: "طلب سيارة إسعاف فورية لحالات الحوادث أو الإصابات.",
                    number: "123",
                    icon: Icons.medical_services,
                    color: Colors.redAccent,
                  ),
                  _buildSOSItem(
                    context,
                    title: "طوارئ وزارة الصحة",
                    description: "للإبلاغ عن رفض استقبال حالات الطوارئ في المستشفيات الخاصة (مخالفة دستورية).",
                    number: "105",
                    icon: Icons.emergency,
                    color: Colors.orangeAccent,
                  ),
                  
                  _buildSectionHeader(context, "خدمات الطريق والمرور"),
                  _buildSOSItem(
                    context,
                    title: "طوارئ المرور (حوادث الطرق)",
                    description: "للإبلاغ عن الحوادث على الطرق السريعة وطلب ونش أو مساعدة.",
                    number: "01221110000",
                    icon: Icons.traffic,
                    color: Colors.amber,
                  ),
                  
                  _buildSectionHeader(context, "الرقابة وسلامة الغذاء"),
                  _buildSOSItem(
                    context,
                    title: "الهيئة القومية لسلامة الغذاء",
                    description: "للإبلاغ عن مطاعم تقدم أكل فاسد أو غير صالح للاستهلاك.",
                    number: "16528",
                    icon: Icons.restaurant_menu,
                    color: Colors.teal,
                  ),
                  _buildSOSItem(
                    context,
                    title: "واتساب سلامة الغذاء",
                    number: "01555771100",
                    icon: Icons.chat,
                    color: Colors.teal,
                    isWhatsApp: true,
                  ),
                  
                  _buildSectionHeader(context, "مكافحة المخدرات"),
                  _buildSOSItem(
                    context,
                    title: "الخط الساخن لمكافحة المخدرات",
                    description: "للإبلاغ عن تجار المخدرات في منطقتك في سرية تامة.",
                    number: "115",
                    icon: Icons.security,
                    color: Colors.indigo,
                  ),
                  _buildSOSItem(
                    context,
                    title: "مكافحة المخدرات (أراضي)",
                    number: "24884500",
                    icon: Icons.phone_in_talk,
                    color: Colors.indigo,
                  ),

                  _buildSectionHeader(context, "بلاغات التجاوزات"),
                  _buildSOSItem(
                    context,
                    title: "مفتش الداخلية",
                    description: "في حالة تعرضك لتجاوز أو سب من ضابط شرطة، حرر محضراً ثم توجه لمكتب المفتش بمديرية الأمن.",
                    icon: Icons.admin_panel_settings,
                    color: Colors.grey,
                  ),

                  30.ph,
                  Center(
                    child: Opacity(
                      opacity: 0.6,
                      child: Text(
                        "تحيا مصر 🇪🇬",
                        style: Styles.textStyle16Bold(context).copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                  50.ph,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.only(top: 20.h, bottom: 10.h),
      child: FadeInLeft(
        duration: const Duration(milliseconds: 600),
        child: Text(
          title,
          style: Styles.textStyle16Bold(context).copyWith(color: Colors.white70),
        ),
      ),
    );
  }

  Widget _buildSOSItem(
    BuildContext context, {
    required String title,
    String? description,
    String? number,
    required IconData icon,
    required Color color,
    bool isWhatsApp = false,
  }) {
    return FadeInUp(
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10.r),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(icon, color: color, size: 24.r),
                      ),
                      15.pw,
                      Expanded(
                        child: Text(
                          title,
                          style: Styles.textStyle16Bold(context).copyWith(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  if (description != null) ...[
                    10.ph,
                    Text(
                      description,
                      style: Styles.textStyle12SemiBold(context).copyWith(color: Colors.white60),
                    ),
                  ],
                  if (number != null) ...[
                    15.ph,
                    Row(
                      children: [
                        Text(
                          number,
                          style: Styles.textStyle18Bold(context).copyWith(color: color),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () {
                            if (isWhatsApp) {
                              launchWhatsApp(phoneNumber: number);
                            } else {
                              makePhoneCall(phoneNumber: number);
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  isWhatsApp ? Icons.chat : Icons.phone,
                                  color: Colors.white,
                                  size: 16.r,
                                ),
                                8.pw,
                                Text(
                                  isWhatsApp ? "واتساب" : "اتصال",
                                  style: Styles.textStyle14Bold(context).copyWith(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SOSHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(Icons.shield_rounded, color: Colors.redAccent, size: 60.r),
        15.ph,
        Text(
          "سلامتكم تهمنا",
          style: Styles.textStyle22Bold(context).copyWith(color: Colors.white),
        ),
        8.ph,
        Text(
          "دليلك السريع للجهات المختصة في حالات الطوارئ",
          textAlign: TextAlign.center,
          style: Styles.textStyle14SemiBold(context).copyWith(color: Colors.white60),
        ),
      ],
    );
  }
}

class CustomBackButton extends StatelessWidget {
  final Color? color;
  const CustomBackButton({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.pop(context),
      icon: Icon(Icons.arrow_back_ios_new, color: color ?? AppColors.primaryColor, size: 20.r),
    );
  }
}
