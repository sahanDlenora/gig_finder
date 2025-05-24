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

