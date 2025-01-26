import 'dart:async';
import 'dart:convert';

import 'package:club_management_and_information_system/api/api_client.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../model/club_model.dart';
import '../model/group_message_model.dart';
import '../shared_preference.dart';

class GroupChatScreen extends StatefulWidget {
  GroupChatScreen();

  @override
  _GroupChatScreenState createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  final List<GroupMessageModel> _messages = [];
  late TextEditingController _controller;
  late ScrollController _scrollController;
  Timer? _messageUpdater;
  String? globalClubName;
  String? globalClubLogoUrl;


  @override
  void initState() {
    super.initState();
    fetchClubDetails();

    _controller = TextEditingController();
    _scrollController = ScrollController();

    _fetchInitialMessages();
    _startMessageUpdater();
  }

  void fetchClubDetails() async {
    try {
      // Fetch clubs from API
      List<ClubModel>? clubs = await ApiClient().getClubs(context);
      if (clubs != null && clubs.isNotEmpty) {
        // Fetch the club ID from SharedPrefs
        int? clubIdFromPrefs = SharedPrefs.getInt('club_id');

        // Ensure the clubIdFromPrefs is not null
        if (clubIdFromPrefs != null) {
          // Find the club with the matching clubId
          ClubModel? selectedClub = clubs.firstWhere(
                (club) => club.clubId == clubIdFromPrefs, // Compare as integer
            orElse: () => ClubModel(), // Return a default ClubModel if not found
          );

          // Debugging prints
          print('Club ID from SharedPrefs: $clubIdFromPrefs');
          print('Selected Club Name: ${selectedClub.clubName}');

          // Set global variables if the club is found
          if (selectedClub.clubId != null) {
            globalClubName = selectedClub.clubName;
            globalClubLogoUrl = selectedClub.clubLogoUrl;
          }
        } else {
          debugPrint('Club ID from SharedPrefs is null');
        }
      } else {
        debugPrint('No clubs found from API');
      }
    } catch (e) {
      debugPrint('Error fetching clubs: $e');
    }
  }


  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _messageUpdater?.cancel();
    super.dispose();
  }

  Future<void> _fetchInitialMessages() async {
    final clubId = SharedPrefs.getInt('club_id').toString();
    final messages = await ApiClient().getMessages(clubId, context);
    if (messages != null) {
      if (mounted) {
        setState(() {
          _messages.clear();
          _messages.addAll(messages);
        });
        _scrollToBottom();
      }
    }
  }

  Future<void> _sendMessage(String message) async {
    final payload = {
      "messageId": 0, // Default value for the message ID
      "userId": SharedPrefs.getString('id'), // Match with "userId" from the cURL
      "clubId": SharedPrefs.getInt('club_id'), // Match with "clubId" from the cURL
      "messageText": message, // Match with "messageText" from the cURL
      "timestamp": DateTime.now().toIso8601String(), // Ensure the correct timestamp format
    };

    print("Payload: $payload");

    final response = await ApiClient().postMessages(payload, context);
    if (response != null) {
      _fetchInitialMessages(); // Refresh messages after sending
      _scrollToBottom(); // Ensure the list scrolls to the bottom after sending a message
    }
  }

  void _startMessageUpdater() {
    _messageUpdater = Timer.periodic(Duration(milliseconds: 2000), (_) async {
      final clubId = SharedPrefs.getInt('club_id').toString();
      final messages = await ApiClient().getMessages(clubId, context);
      if (messages != null) {
        setState(() {
          _messages.clear();
          _messages.addAll(messages);
        });
        _scrollToBottom(); // Scroll to the bottom after new messages are received
      }
    });
  }


  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      });
    }
  }
  String _formatTime(String time) {
    final dateTime = DateTime.parse(time);
    final formattedTime = DateFormat('hh:mm a, dd MMM yyyy').format(dateTime);
    return formattedTime;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xff154973),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            CircleAvatar(
              backgroundImage: NetworkImage(globalClubLogoUrl.toString()),
              radius: 25, // Adjust the radius as needed
            ),

            SizedBox(width: 10),
            Center(
              child: Text(
                globalClubName.toString(),
                style: TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
                overflow: TextOverflow.visible,
                softWrap: true,
              ),
            ),

            IconButton(icon: Icon(Icons.more_vert, color: Colors.transparent), onPressed: () {}),
          ],
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.all(10),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return _chatBubble(
                    message.messageText ?? "",
                    message.userId ?? "",
                    message.timestamp?.toIso8601String() ?? "",
                  );
                },
              ),
            ),
            _chatInputField(),
          ],
        ),
      ),
    );
  }

  Widget _chatBubble(String message, String sender, String time) {
    final isCurrentUser = sender == SharedPrefs.getString('id');
    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: Column(
          crossAxisAlignment:
          isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (!isCurrentUser) Text(sender, style: TextStyle(fontSize: 12, color: Color(0xff154973))),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                color: isCurrentUser ? Color(0xff154973) : Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                message,
                style: TextStyle(color: isCurrentUser ? Colors.white : Colors.black),
              ),
            ),
            SizedBox(height: 5),
            Text(
              _formatTime(time), // Call the _formatTime method to format the time
              style: TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chatInputField() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Type a message...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),
          SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              if (_controller.text.isNotEmpty) {
                _sendMessage(_controller.text);
                _controller.clear();
              }
            },
            child: Icon(
              Icons.send,
              color: Color(0xff154973),
            ),
          ),
        ],
      ),
    );
  }
}

