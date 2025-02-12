import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import '../api/api_client.dart';
import '../model/announcement_model.dart';
import '../shared_preference.dart';

class AnnouncementScreen extends StatefulWidget {
  @override
  _AnnouncementScreenState createState() => _AnnouncementScreenState();
}

class _AnnouncementScreenState extends State<AnnouncementScreen> {
  late Future<List<AnnouncementModel>?> announcementsFuture;

  @override
  void initState() {
    super.initState();

    constructApiAndFetchAnnouncements();

  }


  Future<void> constructApiAndFetchAnnouncements() async {
    final userId = SharedPrefs.getString('id').toString();
    final clubId = SharedPrefs.getInt('club_id').toString();
    String api = '';

    if (clubId.isNotEmpty && userId.isNotEmpty) {
      api = '?club_id=$clubId&user_id=$userId';
    } else if (clubId.isNotEmpty) {
      api = '?club_id=$clubId';
    } else if (userId.isNotEmpty) {
      api = '?user_id=$userId';
    }

    print('Constructed API: $api');
    announcementsFuture = ApiClient().getAnnouncement(api, context);
  }

  void _showGiveAnnouncementDialog(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController announcementController = TextEditingController();
    final TextEditingController clubIdController = TextEditingController();
    final TextEditingController studentIdController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            "Give Announcement",
            style: TextStyle(color: Color(0xff154973), fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.6),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.blueAccent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Color(0xff154973)),
                      ),
                      label: Text(
                        'Title',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xff154973)),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: announcementController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.blueAccent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Color(0xff154973)),
                      ),
                      label: Text(
                        'Announcement',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xff154973)),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Announcement To',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xff154973)),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: clubIdController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.blueAccent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Color(0xff154973)),
                      ),
                      label: Text(
                        'Club ID',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xff154973)),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'OR',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xff154973)),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: studentIdController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.blueAccent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Color(0xff154973)),
                      ),
                      label: Text(
                        'Student ID',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xff154973)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Cancel",
                style: TextStyle(color: Color(0xff154973), fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
              onPressed: () {
                String title = titleController.text;
                String announcement = announcementController.text;
                String clubId = clubIdController.text;
                String studentId = studentIdController.text;

                if (clubIdController.text == SharedPrefs.getInt('club_id').toString()) {
                  if (title.isNotEmpty && announcement.isNotEmpty && (clubId.isNotEmpty || studentId.isNotEmpty)) {
                    var payload = {
                      "announcement_id": 0,
                      "announcement_by_id": SharedPrefs.getString('id').toString(),
                      "club_id": clubId.isNotEmpty ? clubId : null,
                      "user_id": studentId.isNotEmpty ? studentId : null,
                      "created_at": DateTime.now().toIso8601String(),
                      "announcement_text": announcement,
                      "announcement_title": title,
                    };
                    print(payload.toString());
                    ApiClient().postAnnouncement(payload, context).then((_) => constructApiAndFetchAnnouncements());
                    Navigator.pop(context);
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Error"),
                          content: Text("Please fill in all fields."),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("OK"),
                            ),
                          ],
                        );
                      },
                    );
                  }
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Error"),
                        content: Text("You can only send Announcement to your Club"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("OK"),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Text(
                "Send",
                style: TextStyle(color: Color(0xff154973), fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xff154973), Color(0xff0f65a5)],
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Spacer(),
                  Text(
                    "Announcements",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.transparent),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            Expanded( // This ensures the content takes available space and enables scrolling
              child: FutureBuilder<List<AnnouncementModel>?>(
                future: announcementsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (snapshot.hasData && snapshot.data != null) {
                    final announcements = snapshot.data!;
                    if (announcements.isEmpty) {
                      return Center(
                        child: Card(
                          elevation: 8.0,
                          child: Lottie.asset('animation/noData.json',
                              height: MediaQuery.of(context).size.height / 4),
                        ),
                      );
                    }
                    return ListView(
                      padding: const EdgeInsets.all(20.0),
                      children: [
                        if (SharedPrefs.getString('role_id') == '2')
                          GestureDetector(
                            onTap: () {
                              _showGiveAnnouncementDialog(context);
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                child: Container(
                                  height: 60,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.white.withOpacity(0.2),
                                    border: Border.all(
                                        color: Colors.white.withOpacity(0.3), width: 1),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Give Announcement',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: announcements.length,
                          itemBuilder: (context, index) {
                            final announcement = announcements[index];
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 4,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      announcement.announcementTitle ?? "No Title",
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      announcement.announcementText ?? "No Content",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      announcement.createdAt != null
                                          ? "Posted on: ${announcement.createdAt!.toLocal()}"
                                          : "Date not available",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  } else {
                    return Center(
                      child: Card(
                        elevation: 8.0,
                        child: Lottie.asset('animation/noData.json',
                            height: MediaQuery.of(context).size.height / 4),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
