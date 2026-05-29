import 'package:shakshak/core/network/local/cache_helper.dart';

class TripStorageService {
  static const String _activeTripKey = 'active_trip_id';

  /// Save current active trip ID
  static Future<bool> saveActiveTripId(int tripId) async {
    return await CacheHelper.saveData(key: _activeTripKey, value: tripId);
  }

  /// Get current active trip ID
  static int? getActiveTripId() {
    final dynamic data = CacheHelper.getData(key: _activeTripKey);
    if (data != null && data is int) {
      return data;
    }
    return null;
  }

  /// Remove active trip ID when trip is completed or cancelled
  static Future<bool> removeActiveTripId() async {
    return await CacheHelper.removeData(key: _activeTripKey);
  }

  /// Check if there is an active trip cached
  static bool hasActiveTrip() {
    return getActiveTripId() != null;
  }
}
