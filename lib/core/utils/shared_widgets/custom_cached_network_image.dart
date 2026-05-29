import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../generated/assets.dart';

class CustomCachedNetworkImage extends StatelessWidget {
  const CustomCachedNetworkImage({
    super.key,
    required this.imgUrl,
    required this.width,
    required this.height,
    required this.errorIconSize,
    this.loadingImgPadding = 0,
    this.fit = BoxFit.cover,
  });

  final String imgUrl;
  final double width;
  final double height;
  final double errorIconSize;
  final double loadingImgPadding;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      fadeInCurve: Curves.easeIn,
      fadeInDuration: const Duration(seconds: 1),
      imageUrl: imgUrl,
      imageBuilder: (context, imageProvider) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: fit,
          ),
        ),
      ),
      placeholder: (context, url) => Center(
        child: Container(
          width: width,
          height: height,
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Opacity(
                opacity: 0.2,
                child: Padding(
                  padding: EdgeInsets.all(loadingImgPadding.r),
                  child: Image.asset(
                    Assets.imagesLoading,
                    width: width,
                  ),
                )),
          ),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        decoration: const BoxDecoration(),
        child: Icon(
          Icons.error_outline,
          color: Colors.red,
          size: errorIconSize.r,
        ),
      ),
    );
  }
}

class CustomCachedNetworkImage2 extends StatelessWidget {
  const CustomCachedNetworkImage2({
    super.key,
    required this.imgUrl,
    required this.width,
    required this.height,
    required this.errorIconSize,
    this.loadingImgPadding = 20,
    this.fit = BoxFit.cover,
  });

  final String imgUrl;
  final double width;
  final double height;
  final double errorIconSize;
  final double loadingImgPadding;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      fadeInCurve: Curves.easeIn,
      fadeInDuration: const Duration(seconds: 1),
      imageUrl: imgUrl,
      imageBuilder: (context, imageProvider) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black38,
              spreadRadius: -5,
              offset: Offset(0, 0),
              blurRadius: 10,
            ),
          ],
          image: DecorationImage(
            image: imageProvider,
            fit: fit,
          ),
        ),
      ),
      placeholder: (context, url) => Center(
        child: Container(
          width: width,
          height: height,
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Opacity(
                opacity: 0.2,
                child: Padding(
                  padding: EdgeInsets.all(loadingImgPadding.w),
                  child: Image.asset(
                    Assets.imagesLoading,
                    width: width,
                  ),
                )),
          ),
        ),
      ),
      errorWidget: (context, url, error) => Center(
        child: Container(
          width: width,
          height: height,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black38,
                spreadRadius: -5,
                offset: Offset(0, 0),
                blurRadius: 10,
              ),
            ],
          ),
          child: Icon(
            Icons.error_outline,
            color: Colors.red,
            size: errorIconSize,
          ),
        ),
      ),
    );
  }
}
