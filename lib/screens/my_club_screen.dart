import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../api/api_client.dart';
import '../model/club_members_model.dart';
import '../model/club_model.dart';
import '../shared_preference.dart';

class MyClubScreen extends StatefulWidget {
  @override
  _MyClubScreenState createState() => _MyClubScreenState();
}

class _MyClubScreenState extends State<MyClubScreen> {
  Future<List<ClubModel>?> getClubs(BuildContext context) async {
    return await ApiClient().getClubs(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xff154973), Color(0xff0f65a5)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<List<ClubModel>?>(
            future: getClubs(context),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: TextStyle(color: Colors.red),
                  ),
                );
              } else if (!snapshot.hasData || snapshot.data == null) {
                return Center(
                  child: Text(
                    'No data available.',
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }

              final List<ClubModel> clubs = snapshot.data!;
              final ClubModel? selectedClub = clubs.cast<ClubModel?>().firstWhere(
                    (club) => club?.clubId == SharedPrefs.getInt('club_id'),
                orElse: () => null,
              );

              if (selectedClub == null) {
                return Center(
                  child: Text(
                    'Club with ID 2 not found.',
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }

              final String? imageName = selectedClub.clubLogoUrl;
              final String? name = selectedClub.clubName;
              final String? description = selectedClub.clubDescription;
              final List<EventModel> previousEvents = selectedClub.events!
                  .where((event) => event.status == 'Previous Event')
                  .toList();
              final List<EventModel> upcomingEvents = selectedClub.events!
                  .where((event) => event.status == 'Upcoming Event')
                  .toList();
              final List<EventModel> ongoingEvents = selectedClub.events!
                  .where((event) => event.status == 'On Going Event')
                  .toList();
              return FutureBuilder<List<ClubMembersModel>?>(
                future: ApiClient().getClubMembers(selectedClub.clubId!, context),
                builder: (context, membersSnapshot) {
                  if (membersSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    );
                  } else if (membersSnapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${membersSnapshot.error}',
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  } else if (!membersSnapshot.hasData || membersSnapshot.data == null) {
                    return Center(
                      child: Text(
                        'No members found.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }
                  final List<ClubMembersModel> clubMembers = membersSnapshot.data!;
                  final filteredMembers = clubMembers
                      .where((member) => member.id != SharedPrefs.getString('id'))
                      .toList();

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
                              Text(
                                "Club Details",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Spacer(),
                              SizedBox(width: 10),
                            ],
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            imageName ?? '',
                            height: 300,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          name ?? '',
                          style: TextStyle(
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
                        ),
                        SizedBox(height: 10),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            description ?? '',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 20),
                        if (previousEvents.isNotEmpty)
                          _buildEventCategory('Previous Events', previousEvents),
                        if (upcomingEvents.isNotEmpty)
                          _buildEventCategory('Upcoming Events', upcomingEvents),
                        if (ongoingEvents.isNotEmpty)
                          _buildEventCategory('Ongoing Events', ongoingEvents),
                        SizedBox(height: 20),
                        if (SharedPrefs.getString('role_id') == '2' && clubMembers.isNotEmpty)...[
                          Text(
                            "Club Members",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 10),
                          Center(
                            child: Card(
                              color: Colors.white,
                              elevation: 8.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  columns: [
                                    DataColumn(label: Text('Rank', style: TextStyle(color: Color(0xff154973), fontWeight: FontWeight.bold))),
                                    DataColumn(label: Text('Name', style: TextStyle(color: Color(0xff154973), fontWeight: FontWeight.bold))),
                                    DataColumn(label: Text('ID', style: TextStyle(color: Color(0xff154973), fontWeight: FontWeight.bold))),
                                    DataColumn(label: Text('Position', style: TextStyle(color: Color(0xff154973), fontWeight: FontWeight.bold))),
                                    DataColumn(label: Text('Contact', style: TextStyle(color: Color(0xff154973), fontWeight: FontWeight.bold))),
                                  ],
                                  rows: filteredMembers.asMap().entries.map((entry) {
                                    int index = entry.key + 1;
                                    ClubMembersModel member = entry.value;
                                    return DataRow(
                                      cells: [
                                        DataCell(Text('$index', style: TextStyle(color: Colors.black))),
                                        DataCell(Text(member.memberName ?? '', style: TextStyle(color: Colors.black))),
                                        DataCell(Text(member.id ?? '', style: TextStyle(color: Colors.black))),
                                        DataCell(Text(member.position ?? '', style: TextStyle(color: Colors.black))),
                                        DataCell(Text(member.contact ?? '', style: TextStyle(color: Colors.black))),
                                      ],
                                      onLongPress: () {
                                        showModalBottomSheet(
                                          backgroundColor: Colors.transparent,
                                          context: context,
                                          builder: (context) {
                                            return Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: SpeedDial(
                                                icon: Icons.fingerprint,
                                                backgroundColor: Color(0xff154973),
                                                foregroundColor: Colors.white,
                                                children: [
                                                  SpeedDialChild(
                                                    child: Icon(Icons.remove, color: Colors.white,),
                                                    label: 'Remove',
                                                    labelBackgroundColor: Color(0xff154973),
                                                    labelStyle: TextStyle(color: Colors.white),
                                                    backgroundColor: Color(0xff154973),
                                                    onTap: () {
                                                    },
                                                  ),
                                                  SpeedDialChild(
                                                    child: Icon(Icons.arrow_downward, color: Colors.white),
                                                    label: 'Demote',
                                                    labelBackgroundColor: Color(0xff154973),
                                                    labelStyle: TextStyle(color: Colors.white),
                                                    backgroundColor: Color(0xff154973),
                                                    onTap: () {
                                                    },
                                                  ),
                                                  SpeedDialChild(
                                                    child: Icon(Icons.arrow_upward, color: Colors.white),
                                                    label: 'Promote',
                                                    labelBackgroundColor: Color(0xff154973),
                                                    backgroundColor: Color(0xff154973),
                                                    labelStyle: TextStyle(color: Colors.white),
                                                    onTap: () {
                                                    },
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Color(0xff0f65a5), Color(0xff154973)],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white, // White border
                                width: 2, // Border thickness
                              ),
                            ),
                            child: TextButton(
                              onPressed: () {
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 16.0),
                                child: Text(
                                  "Leave Club",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ]
                      ],
                    ),
                  );
                },
              );
            },
          )
        ),
      ),
    ));
  }
  Widget _buildEventCategory(String title, List<EventModel> events) {
    final PageController pageController = PageController();

    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 350,
          child: PageView.builder(
            controller: pageController,
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                  child: Column(
                    children: [
                      Image.network(
                        event.picUrl!,
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          event.eventName!,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        event.startDate!,
                        style: const TextStyle(fontSize: 16),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          event.eventDescription!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SmoothPageIndicator(
            controller: pageController,
            count: events.length,
            effect: WormEffect(
              dotWidth: 10.0,
              dotHeight: 10.0,
              spacing: 16.0,
              radius: 8.0,
              dotColor: Colors.white.withOpacity(0.7),
              activeDotColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
