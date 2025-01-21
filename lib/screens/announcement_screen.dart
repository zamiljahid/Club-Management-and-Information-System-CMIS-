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

    final user_id = SharedPrefs.getString('id').toString();
    final club_id = SharedPrefs.getInt('club_id').toString();
    String api = '';
    if (club_id.isNotEmpty && user_id.isNotEmpty) {
      api = '?club_id=$club_id&user_id=$user_id';
    } else if (club_id.isNotEmpty) {
      api = '?club_id=$club_id';
    } else if (user_id.isNotEmpty) {
      api = '?user_id=$user_id';
    }
    print('Constructed API: $api');

    announcementsFuture = ApiClient().getAnnouncement(api, context);
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
        child: FutureBuilder<List<AnnouncementModel>?>(
          future: announcementsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
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
                    )
                );
              }
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
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
                                fontSize: 28,
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
                  ),
                ),
              );
            } else {
              return Center(
                  child: Card(
                    elevation: 8.0,
                    child: Lottie.asset('animation/noData.json',
                        height: MediaQuery.of(context).size.height / 4),
                  )
              );
            }
          },
        ),
      ),
    );
  }
}
