import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/utils/styles.dart';

import 'package:shakshak/features/user/user_home/data/models/ad_model.dart';

class AdsBanner extends StatelessWidget {
  final List<AdModel> ads;

  const AdsBanner({super.key, required this.ads});

  @override
  Widget build(BuildContext context) {
    if (ads.isEmpty) {
      return const SizedBox.shrink();
    }

    return CarouselSlider(
      options: CarouselOptions(
        height: 180.h,
        aspectRatio: 16 / 9,
        viewportFraction: 0.9,
        initialPage: 0,
        enableInfiniteScroll: true,
        reverse: false,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 5),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: true,
        enlargeFactor: 0.2,
        scrollDirection: Axis.horizontal,
      ),
      items: ads.map((ad) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(horizontal: 5.0.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                image: ad?.image != null
                    ? DecorationImage(
                        image: CachedNetworkImageProvider(ad.image!),
                        fit: BoxFit.cover,
                      )
                    : null,
                gradient: ad.image == null
                    ? LinearGradient(
                        colors: ad.gradientColors?.cast<Color>() ??
                            [AppColors.primaryColor, AppColors.secondaryColor],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  if (ad.image != null)
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.6),
                            Colors.transparent
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                    ),
                  if (ad.image == null) ...[
                    Positioned(
                      top: -20,
                      right: -20,
                      child: CircleAvatar(
                        radius: 60.r,
                        backgroundColor: AppColors.whiteColor.withOpacity(0.1),
                      ),
                    ),
                    Positioned(
                      bottom: -30,
                      left: -10,
                      child: CircleAvatar(
                        radius: 50.r,
                        backgroundColor: AppColors.whiteColor.withOpacity(0.1),
                      ),
                    ),
                  ],
                  Padding(
                    padding: EdgeInsets.all(20.0.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          ad.title,
                          style: Styles.textStyle22Bold(context).copyWith(
                            color: AppColors.whiteColor,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          ad.subtitle,
                          style: Styles.textStyle14Medium(context).copyWith(
                            color: AppColors.whiteColor.withOpacity(0.95),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
