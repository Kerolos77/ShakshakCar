import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';

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

  WebSocketChannel? _channel;
  RealtimeConnectionStatus _status = RealtimeConnectionStatus.disconnected;
  String? _url;
  String? _socketId;
  bool _isManualDisconnect = false;
  bool _isReconnecting = false;

  final Set<String> _activeSubscribes = {};
  final List<RealtimeSubscription> _subscriptions = [];

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
      _channel?.sink.close();
      _channel = WebSocketChannel.connect(Uri.parse(url));

      _channel!.stream.listen(
        (message) {
          debugPrint('📥 RAW WebSocket Message: $message');
          _handleMessage(message);
        },
        onError: (error) {
          debugPrint('❌ RealtimeManager WebSocket Error: $error');
          _scheduleReconnect();
        },
        onDone: () {
          debugPrint('🔌 RealtimeManager WebSocket Closed');
          _scheduleReconnect();
        },
      );
    } catch (e) {
      debugPrint('❌ RealtimeManager Connection Exception: $e');
      _scheduleReconnect();
    }
  }

  void _scheduleReconnect() {
    _updateStatus(RealtimeConnectionStatus.disconnected);
    if (_isManualDisconnect || _isReconnecting) return;

    _isReconnecting = true;
    Future.delayed(const Duration(seconds: 3), () {
      if (!_isManualDisconnect && _url != null) {
        debugPrint('🔄 RealtimeManager Reconnecting...');
        _isReconnecting = false;
        connect(url: _url!);
      } else {
        _isReconnecting = false;
      }
    });
  }

  Future<Map<String, dynamic>> _authenticateChannel(String channelName) async {
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
          "socket_id": _socketId,
          "channel_name": channelName,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        debugPrint("Auth Error Response: ${response.body}");
        throw Exception("Authentication Failed");
      }
    } catch (e) {
      debugPrint("Authorizer Exception: $e");
      rethrow;
    }
  }

  /// ================= MESSAGE HANDLER =================
  void _handleMessage(dynamic message) {
    try {
      final decoded = jsonDecode(message);
      final String? event = decoded['event'];
      final String? channel = decoded['channel'];
      final dynamic data = decoded['data'];

      if (event == null) return;

      // Handle Ping/Pong
      if (event == 'pusher:ping') {
        _send({"event": "pusher:pong"});
        return;
      }

      // Handle Connection Established
      if (event == 'pusher:connection_established') {
        final Map<String, dynamic> connectionData = data is String 
            ? jsonDecode(data) 
            : data;
        _socketId = connectionData['socket_id'];
        _updateStatus(RealtimeConnectionStatus.connected);
        _resubscribeAll();
        return;
      }

      // Ignore standard pusher events
      if (event.startsWith('pusher:')) return;

      final parsedData = (data is String) ? jsonDecode(data) : data;

      final targets = _subscriptions
          .where((s) =>
              s.channel == channel &&
              (s.event == event ||
                  ".${s.event}" == event ||
                  s.event == ".$event"))
          .toList();

      for (var sub in targets) {
        sub.callback(parsedData);
      }
    } catch (e) {
      debugPrint('❌ RealtimeManager Parse Error: $e');
    }
  }

  void _send(Map<String, dynamic> data) {
    try {
      _channel?.sink.add(jsonEncode(data));
    } catch (e) {
      debugPrint('❌ RealtimeManager Send Error: $e');
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
      String? auth;
      if (channel.startsWith('private-') || channel.startsWith('presence-')) {
        final authData = await _authenticateChannel(channel);
        auth = authData['auth'];
      }

      _send({
        "event": "pusher:subscribe",
        "data": {
          "channel": channel,
          if (auth != null) "auth": auth,
        }
      });
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
        _send({
          "event": "pusher:unsubscribe",
          "data": {"channel": channel}
        });
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
      _channel?.sink.close();
      _channel = null;
    } catch (e) {
      debugPrint('❌ RealtimeManager Disconnect Error: $e');
    }
  }
}
