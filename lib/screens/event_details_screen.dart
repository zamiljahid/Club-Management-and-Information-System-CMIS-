import 'package:club_management_and_information_system/api/api_client.dart';
import 'package:flutter/material.dart';

import '../model/is_registered_model.dart';
import '../shared_preference.dart';

class EventDetailsScreen extends StatefulWidget {
  final String imageName;
  final String name;
  final String description;
  final int eventId;
  final String club;
  final int clubId;
  final String status;

  EventDetailsScreen({
    required this.imageName,
    required this.name,
    required this.description,
    required this.club,
    required this.status,
    required this.clubId,
    required this.eventId,
  });

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  late Future<IsRegisterModel?> _future;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _future = ApiClient().getCheckIsRegistered(
      "?eventId=${widget.eventId.toString()}&userId=${SharedPrefs.getString('id')}",
      context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xff154973), Color(0xff0f65a5)],
            ),
          ),
          child: FutureBuilder<IsRegisterModel?>(
            future: _future,
            builder: (BuildContext context, AsyncSnapshot<IsRegisterModel?> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "Failed to load data",
                    style: TextStyle(color: Colors.red),
                  ),
                );
              } else {
                final isRegister = snapshot.data!.isRegistered;
                return Padding(
                  padding: const EdgeInsets.all(16.0),
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
                            const SizedBox(width: 10),
                            Text(
                              "Event Details",
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
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          widget.imageName,
                          height: 300,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: Text(
                          widget.name,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                blurRadius: 10,
                                color: Colors.black38,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          widget.description,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: Text(
                          "Organised By",
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          widget.club,
                          softWrap: true,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (SharedPrefs.getString('role_id') != '1') ...[
                        widget.clubId == SharedPrefs.getInt('club_id')
                            ? (SharedPrefs.getString('role_id') == '2' || SharedPrefs.getString('role_id') == '3'
                            ? Center(
                          child: Text(
                            "Executive Position holders cannot register for their own events",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.redAccent,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                            : _buildRegisterButton(isRegister!))
                            : _buildRegisterButton(isRegister!)
                      ],
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterButton(bool isRegister) {
    if (widget.status == "Upcoming Event") {
      return isRegister
          ? Center(
        child: Text(
          "Already Registered",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green),
          textAlign: TextAlign.center,
        ),
      )
          : Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xff0f65a5), Color(0xff154973)],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white,
            width: 2,
          ),
        ),
        child: TextButton(
          onPressed: () async {
            var payload = {
              "register_id": 0,
              "event_id": widget.eventId,
              "user_id": SharedPrefs.getString('id').toString(),
              "registration_date": DateTime.now().toIso8601String(),
            };
            print(payload);
            await ApiClient().postEventRegistration(payload, context);
            setState(() {
              _loadData(); // Reload the data
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              "Register Now",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ),
      );
    } else {
      return Center(
        child: Text(
          "Registration is Closed",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.redAccent),
          textAlign: TextAlign.center,
        ),
      );
    }
  }
}
