import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

typedef EventCallback = void Function(dynamic data);

enum RealtimeConnectionStatus { disconnected, connecting, connected }

class RealtimeService {
  static final RealtimeService _instance = RealtimeService._internal();

  factory RealtimeService() => _instance;

  RealtimeService._internal();

  WebSocketChannel? _channel;

  final Map<String, Map<String, List<EventCallback>>> _channelListeners = {};
  final Map<String, List<EventCallback>> _globalListeners = {};

  final ValueNotifier<RealtimeConnectionStatus> connectionStatus =
      ValueNotifier(RealtimeConnectionStatus.disconnected);

  String? _currentUrl;

  /// ================= CONNECT =================
  void connect({
    required String url,
    void Function()? onConnected,
    void Function(dynamic error)? onError,
  }) {
    _currentUrl = url;

    /// اقفل أي اتصال قديم الأول
    _channel?.sink.close();
    _channel = null;

    connectionStatus.value = RealtimeConnectionStatus.connecting;

    try {
      _channel = WebSocketChannel.connect(Uri.parse(url));

      _channel!.stream.listen(
        (message) {
          debugPrint('📥 RAW WebSocket Message: $message');
          final decoded = jsonDecode(message);

          /// الاتصال الحقيقي حصل هنا
          if (decoded['event'] == 'pusher:connection_established') {
            connectionStatus.value = RealtimeConnectionStatus.connected;
            onConnected?.call();
          }

          _handleMessage(message);
        },
        onError: (error) {
          debugPrint('❌ WebSocket Error: $error');
          _scheduleReconnect(onError);
        },
        onDone: () {
          debugPrint('🔌 WebSocket Closed');
          _scheduleReconnect(onError);
        },
      );
    } catch (e) {
      debugPrint('❌ Connection Exception: $e');
      _scheduleReconnect(onError);
    }
  }

  /// ================= RECONNECT =================
  bool _isReconnecting = false;

  void _scheduleReconnect(void Function(dynamic error)? onError) async {
    if (_isReconnecting) return;

    _isReconnecting = true;

    await Future.delayed(const Duration(seconds: 2));

    if (_currentUrl != null) {
      debugPrint('🔄 Reconnecting...');
      connect(url: _currentUrl!, onError: onError);
    }

    _isReconnecting = false;
  }

  /// ================= SUBSCRIBE =================
  void subscribe({required String channelName, String? eventName}) {
    debugPrint(
        '📡 Subscribing to channel: $channelName ${eventName != null ? "event: $eventName" : ""}');
    final data = <String, dynamic>{"channel": channelName};
    if (eventName != null) {
      data["event"] = eventName;
    }
    _send({"event": "pusher:subscribe", "data": data});
  }

  /// ================= UNSUBSCRIBE =================
  void unsubscribe(String channelName) {
    debugPrint('🚫 Unsubscribing from channel: $channelName');
    _send({
      "event": "pusher:unsubscribe",
      "data": {"channel": channelName}
    });

    _channelListeners.remove(channelName);
  }

  /// ================= LISTEN =================
  void on(
    String eventName, {
    required String channel,
    required EventCallback callback,
  }) {
    debugPrint('👂 Listen → event: $eventName | channel: $channel');

    _channelListeners.putIfAbsent(channel, () => {});
    _channelListeners[channel]!.putIfAbsent(eventName, () => []);
    _channelListeners[channel]![eventName]!.add(callback);
  }

  /// ================= REMOVE LISTENER =================
  void off(String eventName, {required String channel}) {
    debugPrint('🔕 Remove listener → event: $eventName | channel: $channel');
    _channelListeners[channel]?.remove(eventName);
  }

  /// ================= DISCONNECT =================
  void disconnect() {
    debugPrint('❌ Disconnect WebSocket manually');
    _channel?.sink.close();
    _disconnectCleanup();
  }

  void _disconnectCleanup() {
    _channel = null;
    connectionStatus.value = RealtimeConnectionStatus.disconnected;
  }

  /// ================= SEND =================
  void _send(Map<String, dynamic> data) {
    debugPrint('📤 SEND: ${jsonEncode(data)}');
    try {
      _channel?.sink.add(jsonEncode(data));
    } catch (e) {
      debugPrint('❌ Send Error: $e');
    }
  }

  /// ================= HANDLE MESSAGE =================
  void _handleMessage(dynamic message) {
    try {
      final decoded = jsonDecode(message);

      final String? event = decoded['event'];
      final String? channel = decoded['channel'];
      final dynamic data = decoded['data'];

      if (event == null) return;

      /// ❤️ الرد على ping
      if (event == 'pusher:ping') {
        _send({"event": "pusher:pong"});
        return;
      }

      /// ⭐ الاتصال الحقيقي حصل هنا فقط
      if (event == 'pusher:connection_established') {
        connectionStatus.value = RealtimeConnectionStatus.connected;

        /// بعد الاتصال نعمل subscribe لكل القنوات
        for (final ch in _channelListeners.keys) {
          subscribe(channelName: ch);
        }

        return;
      }

      /// تجاهل أحداث pusher
      if (event.startsWith('pusher:')) return;

      final parsedData = (data is String) ? jsonDecode(data) : data;

      final normalizedEvent = event.startsWith('.') ? event : '.$event';

      final listeners = _channelListeners[channel];

      if (listeners != null) {
        listeners[event]?.forEach((cb) => cb(parsedData));
        listeners[normalizedEvent]?.forEach((cb) => cb(parsedData));
      }
    } catch (e) {
      debugPrint('❌ Realtime parse error: $e');
    }
  }
}
