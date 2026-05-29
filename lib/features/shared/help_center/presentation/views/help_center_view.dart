import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';
import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/router/route_args.dart';
import 'package:shakshak/core/router/router_helper.dart';
import 'package:shakshak/core/router/routes.dart';
import 'package:shakshak/core/services/service_locator.dart';
import 'package:shakshak/core/utils/styles.dart';
import 'package:shakshak/features/shared/base_layout/presentation/views/base_layout_view.dart';
import 'package:shakshak/features/shared/contact_us/domain/usecases/get_contact_us_usecase.dart';
import 'package:shakshak/features/shared/contact_us/domain/usecases/write_us_usecase.dart';
import 'package:shakshak/features/shared/contact_us/presentation/view_models/contact_us_cubit.dart';
import 'package:shakshak/features/shared/faq/presentation/view_models/faqs_cubit.dart';
import 'package:shakshak/generated/l10n.dart';

class HelpCenterView extends StatelessWidget {
  const HelpCenterView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => ContactUsCubit(
                sl<GetContactUsUseCase>(), sl<WriteUsUseCase>())),
        BlocProvider(create: (context) => FaqsCubit(sl())),
      ],
      child: BaseLayoutView(
        title: S.of(context).help, // Assuming 'help' exists or using literal
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeInDown(
                duration: const Duration(milliseconds: 500),
                child: _buildTripHelpSection(context),
              ),
              24.ph,
              FadeInDown(
                duration: const Duration(milliseconds: 600),
                child: _buildCategoriesSection(context),
              ),
              24.ph,
              FadeInDown(
                duration: const Duration(milliseconds: 700),
                child: _buildContactSection(context),
              ),
              40.ph,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTripHelpSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).getHelpWithTrip ?? "مساعدة في رحلة",
          style: Styles.textStyle18Bold(context),
        ),
        12.ph,
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: Theme.of(context).dividerColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.history_rounded,
                    color: AppColors.primaryColor, size: 24.r),
              ),
              16.pw,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      S.of(context).recentRides ?? "الرحلات الأخيرة",
                      style: Styles.textStyle16Medium(context),
                    ),
                    Text(
                      S.of(context).reportIssueRecentTrip ??
                          "أبلغ عن مشكلة في رحلة سابقة",
                      style: Styles.textStyle14(context).copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.6)),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => navigateTo(context, Routes.ridesView,
                    extra: RidesViewArgs(isSelectionMode: true)),
                icon: Icon(Icons.arrow_forward_ios_rounded,
                    size: 16.r,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.4)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoriesSection(BuildContext context) {
    final categories = [
      {
        'title': S.of(context).accountSupport ?? "دعم الحساب",
        'icon': Icons.person_outline,
        'color': Colors.blue
      },
      {
        'title': S.of(context).paymentSupport ?? "مشاكل الدفع",
        'icon': Icons.payment_rounded,
        'color': Colors.green
      },
      {
        'title': S.of(context).safetyCenter ?? "مركز الأمان",
        'icon': Icons.security_rounded,
        'color': Colors.red
      },
      {
        'title': S.of(context).appGuide ?? "دليل استخدام التطبيق",
        'icon': Icons.menu_book_rounded,
        'color': Colors.orange
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).helpCategories ?? "فئات المساعدة",
          style: Styles.textStyle18Bold(context),
        ),
        12.ph,
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.h,
            childAspectRatio: 1.5,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final cat = categories[index];
            return InkWell(
              onTap: () => navigateTo(context, Routes.faqView),
              borderRadius: BorderRadius.circular(16.r),
              child: Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: (cat['color'] as Color).withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                      color: (cat['color'] as Color).withOpacity(0.1)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(cat['icon'] as IconData,
                        color: cat['color'] as Color, size: 28.r),
                    Text(
                      cat['title'] as String,
                      style: Styles.textStyle14Medium(context),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildContactSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).stillNeedHelp ?? "مازلت بحاجة للمساعدة؟",
          style: Styles.textStyle18Bold(context),
        ),
        12.ph,
        // _buildContactItem(
        //   context,
        //   title: S.of(context).liveChat ?? "المحادثة المباشرة",
        //   subtitle:
        //       S.of(context).chatWithSupport ?? "تحدث مع فريق الدعم عبر واتساب",
        //   icon: Icons.chat_rounded,
        //   color: Colors.teal,
        //   onTap: () async {
        //     const whatsappUrl =
        //         "https://wa.me/201015091490"; // Example number or fetch from API
        //     if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
        //       await launchUrl(Uri.parse(whatsappUrl),
        //           mode: LaunchMode.externalApplication);
        //     }
        //   },
        // ),
        // 8.ph,
        _buildContactItem(
          context,
          title: S.of(context).callUs,
          subtitle:
              S.of(context).callSupportTeam ?? "تحدث هاتفياً مع أحد ممثلينا",
          icon: Icons.call_rounded,
          color: Colors.blue,
          onTap: () => navigateTo(context, Routes.contactUsView),
        ),
        8.ph,
        _buildContactItem(
          context,
          title: S.of(context).emailUs,
          subtitle: S.of(context).sendSupportEmail ??
              "أرسل لنا تفاصيل مشكلتك وسنرد عليك",
          icon: Icons.email_rounded,
          color: Colors.purple,
          onTap: () => navigateTo(context, Routes.contactUsView),
        ),
      ],
    );
  }

  Widget _buildContactItem(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24.r),
            ),
            16.pw,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Styles.textStyle16Bold(context)),
                  Text(
                    subtitle,
                    style: Styles.textStyle14(context).copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.6)),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded,
                size: 14.r,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withOpacity(0.4)),
          ],
        ),
      ),
    );
  }
}
