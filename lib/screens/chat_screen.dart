import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:convert';

import '../shared_preference.dart';
class GroupChatScreen extends StatefulWidget {
  GroupChatScreen();

  @override
  _GroupChatScreenState createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  late IOWebSocketChannel _channel;
  final List<Map<String, dynamic>> _messages = [];
  late TextEditingController _controller;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _scrollController = ScrollController();
    _connectWebSocket();
  }

  void _connectWebSocket() {
    try {
      print("Attempting to connect to WebSocket...");
      _channel = IOWebSocketChannel.connect('ws://10.0.2.2:5185/ws');
      // _channel = IOWebSocketChannel.connect('ws://2416-27-147-142-242.ngrok-free.app/ws');

      print("Connected to WebSocket");

      _channel.stream.listen((message) {
        print("WebSocket connection established. Message received: $message");

        final List<dynamic> receivedMessages = json.decode(message);
        setState(() {
          for (var msg in receivedMessages) {
            if (msg['club_id'] == SharedPrefs.getInt('club_id')) {
              print("Processing message: $msg");
              _messages.add({
                "sender": msg['user_id'],
                "message": msg['message'],
                "time": msg['timestamp'],
              });
            }
          }
          _scrollToBottom();
        });
      }, onError: (error) {
        print("WebSocket connection error: $error");
      }, onDone: () {
        print("WebSocket connection closed.");
      });

      print("WebSocket connection initialized.");
    } catch (e) {
      print("Error while connecting to WebSocket: $e");
    }
  }

  void _sendMessage(String message) {
    final messageData = {
      "user_id": SharedPrefs.getString('id'),
      "club_id": SharedPrefs.getInt('club_id'),
      "message": message,
      "timestamp": DateTime.now().toIso8601String(),
    };

    try {
      print("Sending message: $messageData");
      print("WebSocket URL: ws://2416-27-147-142-242.ngrok-free.app/ws");

      _channel.sink.add(json.encode(messageData));
      print("Message sent successfully.");

      setState(() {
        _messages.add({
          "sender": SharedPrefs.getString('id'),
          "message": message,
          "time": messageData['timestamp'],
        });
      });
      _scrollToBottom();
    } catch (e) {
      print("Error sending message: $e");
    }
  }

  void _scrollToBottom() {
    // Scroll to the bottom if the ListView is populated
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose(); // Dispose the controller
    _channel.sink.close();
    super.dispose();
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
              backgroundImage: AssetImage('assets/appIcon.jpg'),
            ),
            SizedBox(width: 10),
            Center(
                child: Text(
                  "UIU MUN Club",
                  style: TextStyle(color: Colors.white),
                )),
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
                controller: _scrollController, // Attach the ScrollController
                padding: EdgeInsets.all(10),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return _chatBubble(
                    message["message"],
                    message["sender"],
                    message["time"],
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
            if (!isCurrentUser) Text(sender, style: TextStyle(fontSize: 12, color: Colors.grey)),
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
            Text(time, style: TextStyle(fontSize: 10, color: Colors.grey)),
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
