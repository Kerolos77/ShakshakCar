import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/utils/styles.dart';

class MapMarkerHelper {
  // ✅ Cache للـ Markers الثابتة (دائرة / مربع) — بالأندكس: 'color_shape'
  static final Map<String, BitmapDescriptor> _circleMarkerCache = {};

  // ✅ Cache للـ Info Markers (duration + distance)
  static final Map<String, BitmapDescriptor> _infoMarkerCache = {};

  // ✅ Cache لأيقونة السيارة - بالأندكس: 'hex_color'
  static final Map<String, BitmapDescriptor> _carMarkerCache = {};

  static Future<BitmapDescriptor> createCircleMarkerBitmap(Color color,
      {bool isSquare = false}) async {
    // نبني مفتاح فريد للـ Cache
    final cacheKey = '${color.value}_${isSquare ? 'square' : 'circle'}';

    // لو موجود في الـ Cache نرجعه فوراً بدون أي عمليات
    if (_circleMarkerCache.containsKey(cacheKey)) {
      return _circleMarkerCache[cacheKey]!;
    }

    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = color;
    final Paint borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;
    final Paint shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    const double radius = 18.0;
    const double canvasSize = (radius * 2) + 20;
    const Offset center = Offset(canvasSize / 2, canvasSize / 2);

    // Shadow
    if (isSquare) {
      canvas.drawRect(
        Rect.fromCenter(
            center: center + const Offset(0, 3),
            width: radius * 1.8,
            height: radius * 1.8),
        shadowPaint,
      );
    } else {
      canvas.drawCircle(center + const Offset(0, 3), radius, shadowPaint);
    }

    // Shape
    if (isSquare) {
      canvas.drawRect(
        Rect.fromCenter(
            center: center, width: radius * 1.8, height: radius * 1.8),
        paint,
      );
      canvas.drawRect(
        Rect.fromCenter(
            center: center, width: radius * 1.8, height: radius * 1.8),
        borderPaint,
      );
      canvas.drawRect(
        Rect.fromCenter(center: center, width: 8, height: 8),
        Paint()..color = Colors.white,
      );
    } else {
      canvas.drawCircle(center, radius, paint);
      canvas.drawCircle(center, radius, borderPaint);
      canvas.drawCircle(center, 6, Paint()..color = Colors.white);
    }

    final ui.Image image = await pictureRecorder.endRecording().toImage(
          canvasSize.toInt(),
          canvasSize.toInt(),
        );
    final ByteData? data =
        await image.toByteData(format: ui.ImageByteFormat.png);
    final descriptor = BitmapDescriptor.fromBytes(data!.buffer.asUint8List());

    // نحفظه في الـ Cache عشان المرة الجاية
    _circleMarkerCache[cacheKey] = descriptor;
    return descriptor;
  }

  static Future<BitmapDescriptor> createCustomMarkerBitmap(
      BuildContext context, String duration, String distance) async {
    final cacheKey = '${duration}_$distance';

    if (_infoMarkerCache.containsKey(cacheKey)) {
      return _infoMarkerCache[cacheKey]!;
    }

    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = Colors.white;
    final Paint borderPaint = Paint()
      ..color = AppColors.primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    final Paint shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);

    const double padding = 25.0;
    const double triangleHeight = 20.0;

    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    textPainter.text = TextSpan(
      children: [
        TextSpan(
          text: "$duration\n",
          style: Styles.textStyle20Bold(context)
              .copyWith(color: AppColors.primaryColor),
        ),
        TextSpan(
          text: distance,
          style: Styles.textStyle16Bold(context).copyWith(color: Colors.black),
        ),
      ],
    );

    textPainter.layout();

    final double width = textPainter.width + (padding * 2);
    final double height = textPainter.height + (padding * 2);

    final Path shadowPath = Path()
      ..addRRect(RRect.fromRectAndRadius(
          Rect.fromLTWH(5, 5, width, height), const Radius.circular(20)))
      ..moveTo(width / 2 - 15, height + 5)
      ..lineTo(width / 2, height + triangleHeight + 5)
      ..lineTo(width / 2 + 15, height + 5);
    canvas.drawPath(shadowPath, shadowPaint);

    final Path path = Path()
      ..addRRect(RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, width, height), const Radius.circular(20)))
      ..moveTo(width / 2 - 15, height)
      ..lineTo(width / 2, height + triangleHeight)
      ..lineTo(width / 2 + 15, height);

    canvas.drawPath(path, paint);
    canvas.drawPath(path, borderPaint);
    textPainter.paint(canvas, const Offset(padding, padding));

    final ui.Image image = await pictureRecorder.endRecording().toImage(
          (width + 10).toInt(),
          (height + triangleHeight + 10).toInt(),
        );
    final ByteData? data =
        await image.toByteData(format: ui.ImageByteFormat.png);
    final descriptor = BitmapDescriptor.fromBytes(data!.buffer.asUint8List());

    _infoMarkerCache[cacheKey] = descriptor;
    return descriptor;
  }

  static Future<BitmapDescriptor> createVehicleMarkerBitmap(
      {Color color = AppColors.primaryColor, bool isMotorcycle = false}) async {
    final String cacheKey =
        '${color.value.toRadixString(16)}_${isMotorcycle ? "moto" : "car"}';
    if (_carMarkerCache.containsKey(cacheKey)) {
      return _carMarkerCache[cacheKey]!;
    }

    // ✅ تحميل الأفاتار الجديد من الـ Assets
    final String path =
        isMotorcycle ? 'assets/models/motocycle.png' : 'assets/models/car.png';

    final ByteData data = await rootBundle.load(path);
    final ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: 100, // تصغير الحجم
    );
    final ui.FrameInfo fi = await codec.getNextFrame();
    final ui.Image image = fi.image;

    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()
      ..colorFilter = ui.ColorFilter.mode(color, ui.BlendMode.modulate);

    canvas.drawImage(image, Offset.zero, paint);

    final ui.Image tintedImage = await pictureRecorder.endRecording().toImage(
          image.width,
          image.height,
        );

    final ByteData? byteData =
        await tintedImage.toByteData(format: ui.ImageByteFormat.png);

    final descriptor =
        BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());

    _carMarkerCache[cacheKey] = descriptor;
    return descriptor;
  }

  static Future<BitmapDescriptor> create3DCarMarkerBitmap() async {
    const String cacheKey = 'car_3d';
    if (_carMarkerCache.containsKey(cacheKey)) {
      return _carMarkerCache[cacheKey]!;
    }

    final ByteData data = await rootBundle.load('assets/images/car_marker_3d.png');
    final ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: 100, // appropriate size for map marker
    );
    final ui.FrameInfo fi = await codec.getNextFrame();
    final ui.Image image = fi.image;

    final ByteData? byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);

    final descriptor =
        BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());

    _carMarkerCache[cacheKey] = descriptor;
    return descriptor;
  }

  /// تحميل مسبق للأيقونات الشائعة في الذاكرة لمنع أي Flickering عند فتح الخرائط
  static Future<void> preloadCommonMarkers() async {
    // تحميل أيقونة البداية (دائرة خضراء)
    await createCircleMarkerBitmap(Colors.green, isSquare: false);
    // تحميل أيقونة النهاية (مربع أحمر)
    await createCircleMarkerBitmap(Colors.red, isSquare: true);
    // تحميل أيقونة الدرايفر (سيارة وموتوسيكل)
    await createVehicleMarkerBitmap(isMotorcycle: false);
    await createVehicleMarkerBitmap(isMotorcycle: true);
    await create3DCarMarkerBitmap();
  }
}
