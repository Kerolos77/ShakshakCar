import 'dart:math' as Math;

class Converts {
  static String timeAgoFromNow(String dateTimeString) {
    final inputTime = DateTime.parse(dateTimeString);
    final now = DateTime.now();
    final diff = now.difference(inputTime);
    final duration = diff.abs();

    String unit;
    int value;

    if (duration.inSeconds < 60) {
      value = (duration.inSeconds).ceil();
      unit = "second";
    } else if (duration.inMinutes < 60) {
      value = (duration.inMinutes).ceil();
      unit = "minute";
    } else if (duration.inHours < 24) {
      value = (duration.inHours).ceil();
      unit = "hour";
    } else if (duration.inDays < 7) {
      value = (duration.inDays).ceil();
      unit = "day";
    } else if (duration.inDays < 30) {
      value = (duration.inDays / 7).ceil();
      unit = "week";
    } else if (duration.inDays < 365) {
      value = (duration.inDays / 30).ceil();
      unit = "month";
    } else {
      value = (duration.inDays / 365).ceil();
      unit = "year";
    }

    final pluralUnit = value == 1 ? unit : '${unit}s';
    // return  "$value $pluralUnit";
    return "${duration.inSeconds}";
  }

  String detectLanguageCodeByUnicode(String text) {
    for (int codeUnit in text.runes) {
      if (codeUnit >= 0x0600 && codeUnit <= 0x06FF) {
        return "ar"; // Arabic
      } else if ((codeUnit >= 0x0041 && codeUnit <= 0x007A) ||
          (codeUnit >= 0x0020 && codeUnit <= 0x007E)) {
        return "en"; // English (Basic Latin)
      } else if (codeUnit >= 0x4E00 && codeUnit <= 0x9FFF) {
        return "zh"; // Chinese
      } else if (codeUnit >= 0x0590 && codeUnit <= 0x05FF) {
        return "he"; // Hebrew
      } else if (codeUnit >= 0x0900 && codeUnit <= 0x097F) {
        return "hi"; // Hindi
      } else if (codeUnit >= 0x0400 && codeUnit <= 0x04FF) {
        return "ru"; // Russian (Cyrillic)
      } else if (codeUnit >= 0x0370 && codeUnit <= 0x03FF) {
        return "el"; // Greek
      } else if ((codeUnit >= 0x3040 && codeUnit <= 0x309F) ||
          (codeUnit >= 0x30A0 && codeUnit <= 0x30FF)) {
        return "ja"; // Japanese (Hiragana/Katakana)
      } else if (codeUnit >= 0xAC00 && codeUnit <= 0xD7AF) {
        return "ko"; // Korean (Hangul)
      }
    }
    return "und"; // undefined
  }

  static double calculateDistanceKm(
      double lat1, double lon1, double lat2, double lon2) {
    const p = 0.017453292519943295; // PI/180
    final a = 0.5 -
        Math.cos((lat2 - lat1) * p) / 2 +
        Math.cos(lat1 * p) *
            Math.cos(lat2 * p) *
            (1 - Math.cos((lon2 - lon1) * p)) /
            2;
    return 12742 * Math.asin(Math.sqrt(Math.max(0, a))); // 2*R ; R=6371
  }
}
