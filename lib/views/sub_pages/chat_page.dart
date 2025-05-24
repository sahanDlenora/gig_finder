import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gig_finder/service/auth/auth_services.dart';
import 'package:gig_finder/service/chat/chat_service.dart';

class ChatPage extends StatefulWidget {
  final String receiverName;
  final String receiverID;

  const ChatPage({super.key, required this.receiverName, required this.receiverID});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();
  final ScrollController _scrollController = ScrollController();

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(widget.receiverID, _messageController.text);
      _messageController.clear();

      // Scroll to bottom after sending message
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 100,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverName),
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          _buildUserInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    String senderID = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: _chatService.getMessages(widget.receiverID, senderID),
      builder: (context, snapshot) {
        if (snapshot.hasError) return const Center(child: Text("Something went wrong"));
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());

        final messages = snapshot.data!.docs;

        return ListView.builder(
          controller: _scrollController,
          itemCount: messages.length,
          padding: const EdgeInsets.all(8),
          itemBuilder: (context, index) {
            final data = messages[index].data() as Map<String, dynamic>;
            final isMe = data['senderID'] == senderID;
            return Align(
              alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: isMe ? Colors.blueAccent : Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  data['message'],
                  style: TextStyle(color: isMe ? Colors.white : Colors.black),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildUserInput() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: "Type a message...",
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: Colors.blueAccent,
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
