// ignore_for_file: library_prefixes

import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService with ChangeNotifier {
  IO.Socket? socket;
  bool connected = false;

  final List<Map<String, dynamic>> messages = [];
  final Set<String> users = {};
  final Set<String> typingUsers = {};

  void connect(String username) {
    if (socket != null && socket!.connected) return;

    final uri = kIsWeb ? 'ws://localhost:3000' : 'http://192.168.1.3:3000';
    socket = IO.io(uri, <String, dynamic>{
      'transports': ['websocket'],
    });

    socket!.onConnect((_) {
      connected = true;
      socket!.emit('add user', username);
      notifyListeners();
    });

    socket!.on('login', (data) {
      users.clear();
      users.addAll(List<String>.from(data['usernames'] ?? []));
      notifyListeners();
    });

    socket!.on('user joined', (data) {
      users.add(data['username']);
      notifyListeners();
    });

    socket!.on('user left', (data) {
      users.remove(data['username']);
      typingUsers.remove(data['username']);
      notifyListeners();
    });

    socket!.on('new message', (data) {
      messages.add({'sender': data['username'], 'text': data['message']});
      notifyListeners();
    });

    socket!.on('typing', (data) {
      typingUsers.add(data['username']);
      notifyListeners();
    });

    socket!.on('stop typing', (data) {
      typingUsers.remove(data['username']);
      notifyListeners();
    });

    socket!.onDisconnect((_) {
      connected = false;
      notifyListeners();
    });
  }

  void sendMessage(String message, String username) {
    if (socket != null) {
      socket!.emit('new message', message);
    }
    messages.add({'sender': username, 'text': message});
    notifyListeners();
  }

  void sendTyping() => socket?.emit('typing');
  void sendStopTyping() => socket?.emit('stop typing');
}
 