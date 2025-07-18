// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_t_c/services/socket_service.dart';

class ChatScreen extends StatefulWidget {
  final String username;
  const ChatScreen({super.key, required this.username});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();

  void _handleSend(SocketService socketService) {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    socketService.sendMessage(text, widget.username);
    _controller.clear();
    socketService.sendStopTyping();
  }

  void _onChanged(SocketService socketService, String v) {
    if (v.isNotEmpty) {
      socketService.sendTyping();
    } else {
      socketService.sendStopTyping();
    }
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<SocketService>(
        context,
        listen: false,
      ).connect(widget.username),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SocketService>(
      builder: (context, socketService, child) {
        final messages = socketService.messages;
        final users = socketService.users;
        final typingUsers = socketService.typingUsers;
        final isWide = MediaQuery.of(context).size.width > 600;

        return Scaffold(
          backgroundColor: Colors.grey[100],
          body: SafeArea(
            child: Row(
              children: [
                if (isWide)
                  Container(
                    width: 200,
                    color: Colors.grey[200],
                    child: _UserList(users: users),
                  ),
                Expanded(
                  child: Column(
                    children: [
                      _ChatHeader(username: widget.username),
                      const Divider(height: 1),
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          reverse: true,
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final msg = messages[messages.length - index - 1];
                            final isMe = msg['sender'] == widget.username;
                            return Align(
                              alignment:
                                  isMe
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color:
                                      isMe
                                          ? Colors.blue[100]
                                          : Colors.grey[300],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      isMe
                                          ? CrossAxisAlignment.end
                                          : CrossAxisAlignment.start,
                                  children: [
                                    if (!isMe)
                                      Text(
                                        msg['sender'] ?? "",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    Text(
                                      msg['text'] ?? "",
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      if (typingUsers.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(left: 16, bottom: 4),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "${typingUsers.join(', ')} typing...",
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ),
                      const Divider(height: 1),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _controller,
                                minLines: 1,
                                maxLines: 3,
                                onChanged: (v) => _onChanged(socketService, v),
                                decoration: InputDecoration(
                                  hintText: 'Type a message',
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(24),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.send),
                              color: Theme.of(context).primaryColor,
                              onPressed: () => _handleSend(socketService),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ChatHeader extends StatelessWidget {
  final String username;
  const _ChatHeader({required this.username});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          const Icon(Icons.chat_bubble_outline, color: Colors.blue),
          const SizedBox(width: 8),
          const Text(
            'Chatroom',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const Spacer(),
          CircleAvatar(child: Text(username[0].toUpperCase())),
          const SizedBox(width: 8),
          Text(username, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}

class _UserList extends StatelessWidget {
  final Set<String> users;
  const _UserList({required this.users});
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 24),
      children: [
        const ListTile(
          title: Text("Users", style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        ...users.map(
          (user) => ListTile(
            leading: CircleAvatar(child: Text(user[0].toUpperCase())),
            title: Text(user),
          ),
        ),
      ],
    );
  }
}
