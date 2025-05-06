import 'package:flutter/material.dart';
import 'package:gig_finder/service/auth/auth_services.dart';
import 'package:gig_finder/service/chat/chat_service.dart';
import 'package:gig_finder/views/main_views/sub_pages/chat_page.dart';
import 'package:gig_finder/widgets/reusable/user_tile.dart';

class MessageScreen extends StatelessWidget {
  MessageScreen({super.key});

  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          title: const Center(
            child: Text(
              "Messages",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFamily: "poppins",
                color: Colors.black,
              ),
            ),
          ),
        ),
        body: _buildUserList(),
      ),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatService.getUserStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("Something went wrong"));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.data == null || snapshot.data!.isEmpty) {
          return const Center(child: Text("No users to display"));
        }

        return ListView(
          children: snapshot.data!
              .map<Widget>((userData) => _buildUserListItem(userData, context))
              .toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    return UserTile(
      text: userData["name"],
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPage(
              receiverName: userData["name"],
              receiverID: userData["uid"],
            ),
          ),
        );
      },
    );
  }
}
