import 'package:shakshak/core/router/routes.dart';
import 'package:shakshak/core/router/router_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';
import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/utils/shared_widgets/custom_drop_down.dart';
import 'package:shakshak/core/utils/styles.dart';
import 'package:shakshak/features/shared/base_layout/presentation/views/base_layout_view.dart';

import 'package:shakshak/core/constants/app_const.dart';
import 'package:shakshak/core/network/local/cache_helper.dart';
import 'package:shakshak/generated/l10n.dart';
import 'package:shakshak/features/shared/settings/presentation/view_models/language_cubit/language_cubit.dart';
import 'package:shakshak/features/shared/settings/presentation/view_models/theme_cubit/theme_cubit.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseLayoutView(
      title: S.of(context).settings,
      horizontalPadding: 16.w,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            20.ph,
            _buildSectionHeader(context, S.of(context).language),
            12.ph,
            _buildSettingContainer(context, [
              _buildSettingItem(
                context,
                title: S.of(context).language,
                icon: Icons.language_rounded,
                iconColor: AppColors.primaryColor,
                trailing: BlocBuilder<LanguageCubit, LanguageState>(
                  buildWhen: (previous, current) =>
                      current is LanguageChangeLangState,
                  builder: (context, state) {
                    var cubit = context.read<LanguageCubit>();
                    return SizedBox(
                      width: 120.w,
                      child: CustomDropDown(
                        items: [S.of(context).arabic, S.of(context).english],
                        value: CacheHelper.getData(
                                  key: AppConstant.kCurrentLanguage,
                                ) ==
                                'ar'
                            ? S.of(context).arabic
                            : S.of(context).english,
                        onChange: (selectedLanguage) {
                          String languageCode =
                              selectedLanguage == S.of(context).arabic
                                  ? 'ar'
                                  : 'en';
                          cubit.changeLanguage(languageCode: languageCode);
                          CacheHelper.saveData(
                              key: AppConstant.kCurrentLanguage,
                              value: languageCode);
                        },
                      ),
                    );
                  },
                ),
              ),
              _buildDivider(context),
              _buildSettingItem(
                context,
                title: S.of(context).lightDarkTheme,
                icon: Icons.palette_outlined,
                iconColor: AppColors.secondaryColor,
                trailing: SizedBox(
                  width: 120.w,
                  child: BlocBuilder<ThemeCubit, ThemeState>(
                    builder: (context, themeState) {
                      final themeCubit = context.read<ThemeCubit>();
                      final isDark = themeState.themeMode == AppThemeMode.dark;
                      return CustomDropDown(
                        items: [S.of(context).light, S.of(context).dark],
                        value:
                            isDark ? S.of(context).dark : S.of(context).light,
                        onChange: (selected) {
                          final mode = selected == S.of(context).dark
                              ? AppThemeMode.dark
                              : AppThemeMode.light;
                          themeCubit.changeTheme(mode);
                        },
                      );
                    },
                  ),
                ),
              ),
            ]),
            25.ph,
            _buildSectionHeader(context, S.of(context).support),
            12.ph,
            _buildSettingContainer(context, [
              _buildSettingItem(
                context,
                title: S.of(context).support,
                icon: Icons.headset_mic_rounded,
                iconColor: Colors.teal,
                onTap: () {
                  // TODO: Navigate to support
                },
              ),
              _buildDivider(context),
              _buildSettingItem(
                context,
                title: S.of(context).deleteAccount,
                icon: Icons.delete_forever_rounded,
                iconColor: AppColors.redColor,
                onTap: () {
                  navigateTo(context, Routes.deleteAccountView);
                },
              ),
            ]),
            40.ph,
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w),
      child: Text(
        title,
        style: Styles.textStyle13SemiBold(context).copyWith(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSettingContainer(BuildContext context, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSettingItem(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color iconColor,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(icon, color: iconColor, size: 22.r),
              ),
              16.pw,
              Expanded(
                child: Text(
                  title,
                  style: Styles.textStyle16Medium(context).copyWith(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
              ),
              if (trailing != null)
                trailing
              else
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14.r,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withOpacity(0.4),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 0.5,
      indent: 56.w,
      endIndent: 16.w,
      color: Theme.of(context).dividerColor.withOpacity(0.1),
    );
  }
}
