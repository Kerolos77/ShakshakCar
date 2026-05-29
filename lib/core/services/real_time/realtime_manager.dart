import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

import 'package:shakshak/core/constants/app_const.dart';
import 'package:shakshak/core/network/local/cache_helper.dart';

typedef EventCallback = void Function(dynamic data);

enum RealtimeConnectionStatus { disconnected, connecting, connected }

class RealtimeSubscription {
  final String channel;
  final String event;
  final EventCallback callback;
  final String token;

  RealtimeSubscription({
    required this.channel,
    required this.event,
    required this.callback,
    required this.token,
  });
}

class RealtimeManager {
  static final RealtimeManager _instance = RealtimeManager._internal();
  factory RealtimeManager() => _instance;
  RealtimeManager._internal();

  final PusherChannelsFlutter _pusher = PusherChannelsFlutter.getInstance();
  RealtimeConnectionStatus _status = RealtimeConnectionStatus.disconnected;
  String? _url; // We'll keep url param for backward compatibility, but we might parse it

  final Set<String> _activeSubscribes = {};
  final List<RealtimeSubscription> _subscriptions = [];
  bool _isManualDisconnect = false;

  final ValueNotifier<RealtimeConnectionStatus> connectionStatus =
      ValueNotifier(RealtimeConnectionStatus.disconnected);

  void _updateStatus(RealtimeConnectionStatus status) {
    _status = status;
    connectionStatus.value = status;
    debugPrint('🌐 RealtimeManager Status: $status');
  }

  /// ================= CONNECT =================
  Future<void> connect({required String url}) async {
    if (_status == RealtimeConnectionStatus.connected) return;

    _url = url;
    _isManualDisconnect = false;
    _updateStatus(RealtimeConnectionStatus.connecting);

    try {
      // Parse host and port from URL (if it's something like ws://shakshak.net:6001)
      // We will fallback to defaults if parsing fails
      final uri = Uri.tryParse(url);
      final String host = uri?.host ?? 'shakshak.net';
      final int port = uri?.port ?? 6001;
      final bool useTLS = uri?.scheme == 'wss' || uri?.scheme == 'https';

      await _pusher.init(
        apiKey: "shakshak_key", // Since this is custom Reverb, key can be arbitrary if not enforced
        cluster: "mt1",
        wsHost: host,
        wsPort: port,
        wssPort: port,
        useTLS: useTLS,
        onConnectionStateChange: _onConnectionStateChange,
        onError: _onError,
        onSubscriptionSucceeded: _onSubscriptionSucceeded,
        onEvent: _onEvent,
        onAuthorizer: _onAuthorizer,
      );

      await _pusher.connect();
    } catch (e) {
      debugPrint('❌ RealtimeManager Connection Exception: $e');
      _updateStatus(RealtimeConnectionStatus.disconnected);
    }
  }

  Future<dynamic> _onAuthorizer(String channelName, String socketId, dynamic options) async {
    try {
      String? token = CacheHelper.getData(key: AppConstant.kToken);
      
      var response = await http.post(
        Uri.parse('https://shakshak.net/api/broadcasting/auth'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "socket_id": socketId,
          "channel_name": channelName,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        debugPrint("Auth Error: ${response.body}");
        throw Exception("Authentication Failed");
      }
    } catch (e) {
      debugPrint("Authorizer Exception: $e");
      rethrow;
    }
  }

  void _onConnectionStateChange(dynamic currentState, dynamic previousState) {
    debugPrint("🌐 Pusher Connection State: $currentState");
    if (currentState == 'CONNECTED') {
      _updateStatus(RealtimeConnectionStatus.connected);
      _resubscribeAll();
    } else if (currentState == 'DISCONNECTED') {
      if (!_isManualDisconnect) {
        _updateStatus(RealtimeConnectionStatus.disconnected);
      }
    } else if (currentState == 'CONNECTING') {
      _updateStatus(RealtimeConnectionStatus.connecting);
    }
  }

  void _onError(String message, int? code, dynamic e) {
    debugPrint("❌ Pusher Error: $message code: $code exception: $e");
  }

  void _onSubscriptionSucceeded(String channelName, dynamic data) {
    debugPrint("✅ Subscribed successfully to: $channelName");
  }

  /// ================= HANDLERS =================
  void _onEvent(PusherEvent event) {
    debugPrint('📥 RealtimeManager Received Event: ${event.eventName} on channel: ${event.channelName}');
    try {
      if (event.eventName.startsWith('pusher:')) return;

      final dynamic data = event.data;
      final parsedData = (data is String) ? jsonDecode(data) : data;

      final targets = _subscriptions
          .where((s) =>
              s.channel == event.channelName &&
              (s.event == event.eventName ||
                  ".${s.event}" == event.eventName ||
                  s.event == ".${event.eventName}"))
          .toList();

      for (var sub in targets) {
        sub.callback(parsedData);
      }
    } catch (e) {
      debugPrint('❌ RealtimeManager Parse Error: $e');
    }
  }

  /// ================= ACTIONS =================
  void subscribe(String channel, {String? eventName}) {
    final subKey = eventName != null ? '$channel|$eventName' : channel;
    if (_activeSubscribes.contains(subKey)) return;

    _activeSubscribes.add(subKey);
    if (_status == RealtimeConnectionStatus.connected) {
      _rawSubscribe(channel);
    }
  }

  Future<void> _rawSubscribe(String channel) async {
    debugPrint('📡 RealtimeManager: Subscribing to $channel');
    try {
      await _pusher.subscribe(channelName: channel);
    } catch (e) {
      debugPrint('❌ RealtimeManager Subscribe Error: $e');
    }
  }

  void _resubscribeAll() {
    for (var subKey in _activeSubscribes) {
      final parts = subKey.split('|');
      final channel = parts[0];
      _rawSubscribe(channel);
    }
  }

  String addListener({
    required String channel,
    required String event,
    required EventCallback callback,
  }) {
    subscribe(channel, eventName: event);

    final token = DateTime.now().microsecondsSinceEpoch.toString() +
        Random().nextInt(100).toString();
    _subscriptions.add(RealtimeSubscription(
      channel: channel,
      event: event,
      callback: callback,
      token: token,
    ));

    return token;
  }

  void removeListener(String token) {
    _subscriptions.removeWhere((s) => s.token == token);
  }

  Future<void> unsubscribe(String channel) async {
    _activeSubscribes
        .removeWhere((key) => key == channel || key.startsWith('$channel|'));
    _subscriptions.removeWhere((s) => s.channel == channel);

    if (_status == RealtimeConnectionStatus.connected) {
      try {
        await _pusher.unsubscribe(channelName: channel);
      } catch (e) {
        debugPrint('❌ RealtimeManager Unsubscribe Error: $e');
      }
    }
  }

  Future<void> disconnect() async {
    _isManualDisconnect = true;
    _activeSubscribes.clear();
    _subscriptions.clear();
    _updateStatus(RealtimeConnectionStatus.disconnected);
    try {
      await _pusher.disconnect();
    } catch (e) {
      debugPrint('❌ RealtimeManager Disconnect Error: $e');
    }
  }
}
