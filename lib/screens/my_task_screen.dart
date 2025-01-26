import 'dart:ui';
import 'package:club_management_and_information_system/api/api_client.dart';
import 'package:club_management_and_information_system/model/elected_president_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lottie/lottie.dart';

import '../model/club_model.dart';
import '../model/top_club_model.dart';
import '../model/top_presidents_model.dart';

import 'package:intl/intl.dart';

import '../shared_preference.dart';


class MyTaskScreen extends StatefulWidget {
  @override
  _MyTaskScreenState createState() => _MyTaskScreenState();
}

class _MyTaskScreenState extends State<MyTaskScreen> {

  List<TopPresidentsModel>? topPresidents = [];
  List<TopClubModel>? topClubs = [];
  List<EventModel>? pendingEvents = [];
  List<ElectedPresidentModel>? electedPresidents = [];


  @override
  void initState() {
    super.initState();
    fetchData(context);
  }

  String? _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return null;
    try {
      final inputFormat = DateFormat("dd/MM/yyyy HH:mm:ss");
      final outputFormat = DateFormat("dd MMM yyyy");
      final dateTime = inputFormat.parse(dateStr);
      return outputFormat.format(dateTime);
    } catch (e) {
      print("Error formatting date: $e");
      return null;
    }
  }

  Future<void> fetchData(BuildContext context) async {
    try {
      topPresidents = await ApiClient().getTopPresidents(context);
      print("Top Presidents: $topPresidents");

      topClubs = await ApiClient().getTopClubs(context);
      print("Top Clubs: $topClubs");

      pendingEvents = await ApiClient().getPendingEvents(context);
      print("Pending Events: $pendingEvents");

      electedPresidents  = await ApiClient().getElectedPresidents(context);
      print("Pending Events: $pendingEvents");

    } catch (error) {
      print("Error fetching data: $error");
      ApiErrorHandler.handleError(error, context);
    }
  }

  Future<void> _updateEventStatus(BuildContext context, int eventId, String action) async {
    String? message = await ApiClient().updateEventStatus(eventId, action, context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(action == "Approve" ? "Approval Status" : "Rejection Status"),
        content: Text(message ?? "Failed to update event status."),
        actions: [
          TextButton(
            onPressed: () async {
              await fetchData(context);
              setState(() {});
              Navigator.of(ctx).pop();
            },
            child: const Text("Okay"),
          ),
        ],
      ),
    );
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
                  ApiClient().postAnnouncement(payload, context);
                  Navigator.pop(context);
                }
                else {
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

  void _showLaunchElectionDialog(BuildContext context) {
    final TextEditingController startDateController = TextEditingController();
    final TextEditingController endDateController = TextEditingController();
    final TextEditingController clubIdController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            "Launch Election",
            style: TextStyle(
              color: Color(0xff154973),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.6),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                        'Club Code',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xff154973),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: startDateController,
                    keyboardType: TextInputType.datetime,
                    decoration: InputDecoration(
                      hintText: "yyyy-MM-dd",
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.blueAccent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Color(0xff154973)),
                      ),
                      label: Text(
                        'Start Date',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xff154973),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: endDateController,
                    keyboardType: TextInputType.datetime,
                    decoration: InputDecoration(
                      hintText: "yyyy-MM-dd",
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.blueAccent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Color(0xff154973)),
                      ),
                      label: Text(
                        'End Date',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xff154973),
                        ),
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
                style: TextStyle(
                  color: Color(0xff154973),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                String clubId = clubIdController.text;
                String startDate = startDateController.text;
                String endDate = endDateController.text;
                if (clubId.isNotEmpty && startDate.isNotEmpty && endDate.isNotEmpty) {
                  var payload = {
                    "election_id": 0,
                    "start_date": startDate,
                    "end_date": endDate,
                    "club_id": clubId,
                    "status": 'voting',
                  };
                  print(payload.toString());
                  ApiClient().postElection(payload, context);
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
              },

              child: Text(
                "Launch",
                style: TextStyle(
                  color: Color(0xff154973),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }


  void _showCreateClubDialog(BuildContext context) {
    final TextEditingController clubNameController = TextEditingController();
    final TextEditingController clubDescriptionController = TextEditingController();
    final TextEditingController clubLogoController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            "Create Club",
            style: TextStyle(color: Color(0xff154973), fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: clubNameController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Colors.blueAccent),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Color(0xff154973)),
                  ),
                  label: Text(
                    'Club Name',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xff154973),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: clubDescriptionController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Colors.blueAccent),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Color(0xff154973)),
                  ),
                  label: Text(
                    'Club Description',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xff154973),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: clubLogoController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Colors.blueAccent),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Color(0xff154973)),
                  ),
                  label: Text(
                    'Drive Link of Club Logo',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xff154973),
                    ),
                  ),
                ),
              ),
            ],
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
                String clubName = clubNameController.text;
                String clubDescription = clubDescriptionController.text;
                String clubLogo = clubLogoController.text;
                if (clubName.isNotEmpty && clubDescription.isNotEmpty && clubLogo.isNotEmpty) {
                  var payload = {
                    "club_id": 0,
                    "club_name": clubName,
                    "club_description": clubDescription,
                    "club_logo_url": clubLogo,
                  };
                  print(payload);
                  ApiClient().postClub(payload, context);
                  Navigator.pop(context);
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Error"),
                        content: Text("All fields must be filled."),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Close error dialog
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
                "Create Club",
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
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff154973), Color(0xff0f65a5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder(
          future: fetchData(context),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(
                color: Colors.white,
              ));
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  "Failed to load data",
                  style: TextStyle(color: Colors.red),
                ),
              );
            } else {
              return Column(
                children: [
                  SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      Text(
                        "My Task",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.transparent),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: MasonryGridView.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        itemCount: 7,
                        itemBuilder: (context, index) {
                          switch (index) {
                            case 0:
                              return GestureDetector(
                                onTap: () => _showLaunchElectionDialog(context),
                                child: _buildGlassmorphicTile(
                                  lottieLink: 'animation/election.json',
                                  title: "Launch Election",
                                  isSquare: true,
                                  height: 150.0,
                                ),
                              );
                            case 1:
                              return GestureDetector(
                                onTap: () => _showGiveAnnouncementDialog(context),
                                child: _buildGlassmorphicTile(
                                  lottieLink: 'animation/announcement.json',
                                  title: "Give Announcement",
                                  isSquare: true,
                                  height: 200.0,
                                ),
                              );
                            case 2: // Create Club
                              return GestureDetector(
                                onTap: () => _showCreateClubDialog(context),
                                child: _buildGlassmorphicTile(
                                  lottieLink: 'animation/createClub.json',
                                  title: "Create Club",
                                  isSquare: true,
                                  height: 180.0,
                                ),
                              );
                            case 3:
                              return _buildEventView();
                            case 4:
                              return _buildElectionView();
                            case 5:
                              return _buildClubView();
                            case 6:
                              return _buildPresidentView();
                            default:
                              return Container();
                          }
                        },
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }


  Widget _buildElectionView() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white.withOpacity(0.2),
            border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
          ),
          child: Column(
            children: [
              Text(
                "Election Results",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              electedPresidents?.isEmpty ?? true
                  ? Center(
                child: Card(
                  color: Colors.white,
                  elevation: 8.0,
                  child: Lottie.asset(
                    'animation/noData.json',
                    height: MediaQuery.of(context).size.height / 6,
                  ),
                ),
              )
                  : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                    columns: [
                      DataColumn(label: Text("Club", style: TextStyle(color: Colors.white))),
                      DataColumn(label: Text("Elected Candidate", style: TextStyle(color: Colors.white))),
                      DataColumn(label: Text("Votes", style: TextStyle(color: Colors.white))),
                      DataColumn(label: Text("Action", style: TextStyle(color: Colors.white))),
                    ],
                    rows: electedPresidents!.map<DataRow>((president) {
                      return DataRow(cells: [
                        DataCell(Text(president.clubName ?? "", style: TextStyle(color: Colors.white))),
                        DataCell(Row(
                          children: [
                            CircleAvatar(
                              radius: 15,
                              backgroundImage: NetworkImage(president.candidateProfilePic ?? ""),
                            ),
                            SizedBox(width: 8),
                            Text(president.candidateName ?? "", style: TextStyle(color: Colors.white)),
                          ],
                        )),
                        DataCell(Text("${president.votePercentage ?? 0}%", style: TextStyle(color: Colors.white))),
                        DataCell(
                          ElevatedButton(
                            onPressed: () async {
                              var payload = {
                                "user_id": president.candidateUserId,
                                "club_id": president.clubId
                              };
                              print(payload.toString());
                              await ApiClient().postElectionProcedure(payload, context);
                              await fetchData(context);
                              setState(() {});
                              },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xff154973),
                              padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                              textStyle: TextStyle(fontSize: 14, color: Colors.white),
                            ),
                            child: Text("Confirm", style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ]);
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildEventView() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white.withOpacity(0.2),
            border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
          ),
          child: Column(
            children: [
              Text(
                "Event Proposals",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              pendingEvents == null || pendingEvents!.isEmpty
                  ? Center(
                child: Card(
                  color: Colors.white,
                  elevation: 8.0,
                  child: Lottie.asset(
                    'animation/noData.json',
                    height: MediaQuery.of(context).size.height / 6,
                  ),
                ),
              )
                  : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                    columns: [
                      DataColumn(label: Text("Event", style: TextStyle(color: Colors.white))),
                      DataColumn(label: Text("Club", style: TextStyle(color: Colors.white))),
                      DataColumn(label: Text("Start Date", style: TextStyle(color: Colors.white))),
                      DataColumn(label: Text("End Date", style: TextStyle(color: Colors.white))),
                      DataColumn(label: Text("Action", style: TextStyle(color: Colors.white))),
                    ],
                    rows: pendingEvents!
                        .map(
                          (event) => DataRow(
                        cells: [
                          DataCell(Text(event.eventName ?? "", style: TextStyle(color: Colors.white))),
                          DataCell(Text(event.clubName ?? "", style: TextStyle(color: Colors.white))),
                          DataCell(Text(
                            _formatDate(event.startDate) ?? "",
                            style: TextStyle(color: Colors.white),
                          )),
                          DataCell(Text(
                            _formatDate(event.endDate) ?? "",
                            style: TextStyle(color: Colors.white),
                          )),
                          DataCell(
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SpeedDial(
                                overlayColor: Colors.black,
                                icon: Icons.fingerprint,
                                backgroundColor: const Color(0xff154973),
                                foregroundColor: Colors.white,
                                buttonSize: const Size(50.0, 50.0),
                                childrenButtonSize: const Size(60.0, 50.0),
                                children: [
                                  SpeedDialChild(
                                    child: const Icon(Icons.clear, color: Colors.white),
                                    label: 'Reject',
                                    labelBackgroundColor: const Color(0xff154973),
                                    labelStyle: const TextStyle(color: Colors.white),
                                    backgroundColor: const Color(0xff154973),
                                    onTap: () {
                                      _updateEventStatus(context, event.eventId!, "Reject");
                                    },
                                  ),
                                  SpeedDialChild(
                                    child: const Icon(Icons.done_outline_sharp, color: Colors.white),
                                    label: 'Approve',
                                    labelBackgroundColor: const Color(0xff154973),
                                    labelStyle: const TextStyle(color: Colors.white),
                                    backgroundColor: const Color(0xff154973),
                                    onTap: () {
                                      _updateEventStatus(context, event.eventId!, "Approve");
                                    },
                                  ),
                                ],
                              ),
                            ),
                            ),

                        ],
                      ),
                    )
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildPresidentView() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white.withOpacity(0.2),
            border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
          ),
          child: Column(
            children: [
              Text(
                "Top Presidents",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: topPresidents == null || topPresidents!.isEmpty
                  // Show Lottie animation if list is empty
                      ? Center(
                    child: Card(
                      color: Colors.white,
                      elevation: 8.0,
                      child: Lottie.asset(
                        'animation/noData.json',
                        height: MediaQuery.of(context).size.height / 6,
                      ),
                    ),
                  )
                      : DataTable(
                    columns: [
                      DataColumn(label: Text("Rank", style: TextStyle(color: Colors.white))),
                      DataColumn(label: Text("Name", style: TextStyle(color: Colors.white))),
                      DataColumn(label: Text("Club", style: TextStyle(color: Colors.white))),
                      DataColumn(label: Text("ID", style: TextStyle(color: Colors.white))),
                    ],
                    rows: topPresidents!
                        .asMap()
                        .entries
                        .map((entry) {
                      int rank = entry.key + 1;
                      var president = entry.value;
                      return _buildRow(
                        president.profilePic!,
                        rank,
                        president.memberName!,
                        president.clubNames!,
                        president.id!,
                      );
                    })
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  DataRow _buildRow(String avatarUrl, int rank, String name, String club, String id) {

    return DataRow(cells: [
      DataCell(Text(rank.toString(), style: TextStyle(color: Colors.white))),
      DataCell(Row(
        children: [
          CircleAvatar(
            radius: 15,
            backgroundImage: NetworkImage(avatarUrl),
          ),
          SizedBox(width: 8),
          Text(name, style: TextStyle(color: Colors.white)),
        ],
      )),
      DataCell(Text(club, style: TextStyle(color: Colors.white))),
      DataCell(Text(id, style: TextStyle(color: Colors.white))),
    ]);
  }
  Widget _buildClubView() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white.withOpacity(0.2),
            border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
          ),
          child: Column(
            children: [
              Text(
                "Top Clubs",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: topClubs != null && topClubs!.isNotEmpty
                      ? DataTable(
                    columns: [
                      DataColumn(label: Text("Rank", style: TextStyle(color: Colors.white))),
                      DataColumn(label: Text("Club", style: TextStyle(color: Colors.white))),
                      DataColumn(label: Text("Total Members", style: TextStyle(color: Colors.white))),
                    ],
                    rows: topClubs!.map<DataRow>((club) {
                      return DataRow(cells: [
                        DataCell(Text(club.clubId.toString(), style: TextStyle(color: Colors.white))),
                        DataCell(Text(club.clubName ?? "", style: TextStyle(color: Colors.white))),
                        DataCell(Text(club.totalMembers.toString(), style: TextStyle(color: Colors.white))),
                      ]);
                    }).toList(),
                  )
                      : Center(
                    child: Card(
                      color: Colors.white,
                      elevation: 8.0,
                      child: Lottie.asset(
                        'animation/noData.json',
                        height: MediaQuery.of(context).size.height / 6,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlassmorphicTile({
    required String title,
    required bool isSquare,
    required double height,
    required String lottieLink,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white.withOpacity(0.2),
            border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                lottieLink,
                height: MediaQuery.of(context).size.height / 7,
              ),
              Text(
                title,
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
    );
  }

}

