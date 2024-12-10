import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class GroupChatScreen extends StatefulWidget {
  @override
  _GroupChatScreenState createState() => _GroupChatScreenState();
}
class _GroupChatScreenState extends State<GroupChatScreen> {
  final List<Map<String, dynamic>> _messages = [
    {"sender": "Alice", "message": "Hi everyone!", "isSent": false, "time": "10:00 AM"},
    {"sender": "Bob", "message": "Hello Alice!", "isSent": false, "time": "10:01 AM"},
    {"sender": "You", "message": "Hey all!", "isSent": true, "time": "10:02 AM"},
  ];
  bool _isTyping = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.red[900],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(icon: Icon(Icons.arrow_back, color: Colors.white,),  onPressed: () {
              Navigator.pop(context);
            },),
            CircleAvatar(
              backgroundImage: AssetImage('assets/images/eventIcon.jpg'),
            ),
            SizedBox(width: 10),
            Center(child: Text("UIU MUN Club", style: TextStyle(color: Colors.white),)),
            IconButton(icon: Icon(Icons.more_vert, color: Colors.white,), onPressed: () {}),
          ],
        ),
      ),
      body: Container(

        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(10),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return _chatBubble(
                    message["message"],
                    message["isSent"],
                    message["sender"],
                    message["time"],
                  );
                },
              ),
            ),
            if (_isTyping) _typingIndicator(), // Show typing indicator when active
            _chatInputField(), // Input field at the bottom
          ],
        ),
      ),
    );
  }

  // Chat bubble widget
  Widget _chatBubble(String message, bool isSent, String sender, String time) {
    return Align(
      alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: Column(
          crossAxisAlignment:
          isSent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (!isSent) Text(sender, style: TextStyle(fontSize: 12, color: Colors.grey)),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                color: isSent ? Colors.red[100] : Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(message),
            ),
            SizedBox(height: 5),
            Text(time, style: TextStyle(fontSize: 10, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  // Typing indicator widget
  Widget _typingIndicator() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [

          CircleAvatar(
            radius: 12,
            backgroundImage: NetworkImage('https://randomuser.me/api/portraits/men/32.jpg'),
          ),

          SizedBox(width: 10),
          Lottie.asset(
            'assets/typing-indicator.json',
            width: 50,
            height: 20,
          ),
        ],
      ),
    );
  }

  // Chat input field
  Widget _chatInputField() {
    TextEditingController _controller = TextEditingController();

    return Padding(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.attach_file, color: Colors.red[900],),
            onPressed: () {},
          ),
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
              onChanged: (text) {
                setState(() {
                  _isTyping = text.isNotEmpty;
                });
              },
            ),
          ),
          SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              if (_controller.text.isNotEmpty) {
                setState(() {
                  _messages.add({
                    "sender": "You",
                    "message": _controller.text,
                    "isSent": true,
                    "time": "10:03 AM", // Static time for demo
                  });
                  _controller.clear();
                  _isTyping = false;
                });
              }
            },
            child: Icon(
              Icons.send,
              color: Colors.red[900],
            ),
          ),
        ],
      ),
    );
  }
}
