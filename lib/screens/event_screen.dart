import 'dart:ui';

import 'package:club_management_and_information_system/model/club_model.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../api/api_client.dart';
import '../shared_preference.dart';
import 'event_details_screen.dart';

class EventScreen extends StatefulWidget {
  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  final PageController _controller = PageController();

  final List<Map<String, dynamic>> events = [
    {
      'image': 'assets/appIcon.jpg',
      'name': 'NextGen Diplomats',
      'description':
          'Shaping the future of global leadership through innovation, collaboration, and vision.',
      'club': 'UIU Model United Nations Club'
    },
    {
      'image': 'assets/appIcon.jpg',
      'name': 'Presentation Champs: Season 1',
      'description':
          'Master the art of impactful storytelling with Presentation Champs!',
      'club': 'UIU English Language Forum'
    },
    {
      'image': 'assets/appIcon.jpg',
      'name': 'Gen-Z',
      'description':
          'The connected, creative, and change-driven generation redefining the norm.',
      'club': 'UIU'
    }
  ];

  Future<List<EventModel>?> getEvents(BuildContext context) async {
    return await ApiClient().getEvents(context);
  }

  void _showCreateEventDialog(BuildContext context) {
    final TextEditingController eventNameController = TextEditingController();
    final TextEditingController eventDescriptionController = TextEditingController();
    final TextEditingController clubIdController = TextEditingController();
    final TextEditingController picUrlController = TextEditingController();
    final TextEditingController startDateController = TextEditingController();
    final TextEditingController endDateController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            "Create Event",
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
                  _buildTextField("Event Name", eventNameController),
                  SizedBox(height: 10),
                  _buildTextField("Event Description", eventDescriptionController),
                  SizedBox(height: 10),
                  _buildTextField("Club ID", clubIdController, keyboardType: TextInputType.number),
                  SizedBox(height: 10),
                  _buildTextField("Drive Link of Event Picture", picUrlController),
                  SizedBox(height: 10),
                  _buildTextField("Start Date (yyyy-MM-dd)", startDateController, keyboardType: TextInputType.datetime),
                  SizedBox(height: 10),
                  _buildTextField("End Date (yyyy-MM-dd)", endDateController, keyboardType: TextInputType.datetime),
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
                String eventName = eventNameController.text;
                String eventDescription = eventDescriptionController.text;
                String clubId = clubIdController.text;
                String picUrl = picUrlController.text;
                String startDate = startDateController.text;
                String endDate = endDateController.text;
                if (eventName.isNotEmpty &&
                    eventDescription.isNotEmpty &&
                    clubId.isNotEmpty &&
                    picUrl.isNotEmpty &&
                    startDate.isNotEmpty &&
                    endDate.isNotEmpty) {
                  var payload = {
                    "event_id": 0,
                    "event_name": eventName,
                    "event_description": eventDescription,
                    "club_id": int.parse(clubId),
                    "start_date": startDate,
                    "end_date": endDate,
                    "pic_url": picUrl,
                    "approval": "Pending",
                  };
                  print(payload);

                  ApiClient().postEvent(payload, context);

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
                "Create",
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

  Widget _buildTextField(String label, TextEditingController controller, {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.blueAccent),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: Color(0xff154973)),
        ),
        label: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xff154973),
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff154973), Color(0xff0f65a5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder<List<EventModel>?>(
            future: getEvents(context),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: CircularProgressIndicator(
                  color: Colors.white,
                ));
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
              final List<EventModel> events = snapshot.data!;
              return Column(
                children: [
                  const SizedBox(height: 40),
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
                        "EVENTS",
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
                  const SizedBox(height: 10),
                  if(SharedPrefs.getString('role_id') =='2')
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: GestureDetector(
                      onTap: (){
                        _showCreateEventDialog(context);
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
                                  'Create Event',
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
                  ),
                  Expanded(
                    child: PageView.builder(
                      controller: _controller,
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: InkWell(
                              onTap: () {
                                print(SharedPrefs.getString('role_id')
                                    .toString());
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EventDetailsScreen(
                                      imageName: events[index].picUrl!,
                                      name: events[index].eventName!,
                                      description:
                                          events[index].eventDescription!,
                                      club: events[index].clubName!,
                                      status: events[index].status!,
                                      clubId: events[index].clubId!,
                                      eventId: events[index].eventId!,
                                    ),
                                  ),
                                );
                              },
                              child: Card(
                                color: Colors.white,
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Center(
                                        child: Text(
                                          events[index].status!,
                                          style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xff154973),
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: Image.network(
                                          events[index].picUrl!,
                                          height: 300,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Center(
                                        child: Text(
                                          events[index].eventName!,
                                          style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        events[index].eventDescription!,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "By ${events[index].clubName!}",
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                        );
                      },
                    ),
                  ),
                  SmoothPageIndicator(
                    controller: _controller,
                    count: events.length,
                    effect: const WormEffect(
                      dotHeight: 8,
                      dotWidth: 8,
                      activeDotColor: Colors.white,
                      dotColor: Colors.black26,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              );
            }),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
