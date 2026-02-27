import 'dart:async';
import 'package:bloodfit/constants/app_constant_text.dart';
import 'package:bloodfit/endpoints.dart';
import 'package:bloodfit/helper/di.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketServices {
  static final SocketServices _instance = SocketServices._internal();
  factory SocketServices() => _instance;
  SocketServices._internal();

  IO.Socket? socket;
  String accessToken = '';
  bool _isConnecting = false; // Flag to prevent multiple simultaneous connections

  // void emitMessagePage(String userId) {
  //   socket?.emit('message-page', {'userId': userId});
  // }


  //=================================> Socket Init <=======================

  Future<void> init() async {
    if (socket != null && socket!.connected) return;
    if (_isConnecting) return; // Prevent multiple simultaneous connection attempts

    _isConnecting = true;
    try {
      // bearerToken = await PrefsHelper.getString(AppConstants.bearerToken);
      accessToken = await appData.read(kKeyAccessToken) ?? '';
      
      LoggerUtils.debug("🔑 Socket: Access token retrieved: ${accessToken.isNotEmpty ? 'YES (length: ${accessToken.length})' : 'NO'}");
      
      if (accessToken.isEmpty) {
        LoggerUtils.error("❌ Socket: Access token is empty! Socket authentication will fail.");
      }
      
      _connect();
    } finally {
      _isConnecting = false;
    }
  }

  //==========================> Ensure socket is initialized before emitting events <===================
  void checkSocketInitialized() {
    if (socket == null) {
      LoggerUtils.debug("⚠️ Socket not initialized, calling `init()`...");
      init();
    }
  }

  //================================> Connect the socket <====================================
  void _connect() {
    // Dispose of existing socket if present to prevent memory leaks
    if (socket != null) {
      socket!.offAny(); // Remove all listeners
      socket!.disconnect();
      socket!.dispose();
    }

    LoggerUtils.debug("🔌 Socket: Creating connection with auth token: Bearer ${accessToken.isNotEmpty ? '${accessToken.substring(0, 20)}...' : 'EMPTY'}");
    LoggerUtils.debug("🔌 Socket: Connecting to URL: $socketBaseUrl");

    socket = IO.io(
      socketBaseUrl,
      IO.OptionBuilder()
          .setTransports(['websocket', 'polling'])
          .setExtraHeaders({
            'Authorization': 'Bearer $accessToken',
            'authorization': 'Bearer $accessToken',
          })
          .setQuery({'token': accessToken})
          .setReconnectionAttempts(5)
          .setReconnectionDelay(2000)
          .setTimeout(20000)
          .build(),
    );
    socket!.onConnect((_) {
      LoggerUtils.debug('✅ Socket connected');
      _isConnecting = false; // Reset connecting flag on successful connection
    });
    socket!.onDisconnect((_) {
      LoggerUtils.debug('⚠️ Socket disconnected');
      _isConnecting = false; // Reset connecting flag on disconnect
    });
    socket!.onConnectError((err) {
      LoggerUtils.debug('❌ Socket connection error: $err');
      _isConnecting = false; // Reset connecting flag on error
    });
    socket!.onError((err) {
      LoggerUtils.debug('🚨 Socket error: $err');
      _isConnecting = false; // Reset connecting flag on error
    });
  }

  //============================> Emit data only if socket is connected <=================================
  void emit(String event, dynamic data) {

    checkSocketInitialized();
    if (socket != null && socket!.connected) {
      socket!.emit(event, data);
      LoggerUtils.debug('📤 Emit: $event \nData: $data');
    } else {
      LoggerUtils.debug("⚠️ Cannot emit, socket not connected.");
    }
  }


  //===================================> Disconnect socket properly <============================================

  void disconnect() {
    socket?.dispose();
    LoggerUtils.debug('🔌 Socket disconnected');
  }
}