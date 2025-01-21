import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../model/club_model.dart';
import '../shared_preference.dart';

class ClubDetailsScreen extends StatelessWidget {
  String? imageName;
  String? name;
  String? description;
  List<EventModel>? events;

  ClubDetailsScreen({
    this.imageName,
    this.name,
    this.description,
    this.events,
  });

  List<EventModel> get previousEvents =>
      events!.where((event) => event.status == 'On Going Event').toList();

  List<EventModel> get upcomingEvents =>
      events!.where((event) => event.status == 'Upcoming Event').toList();

  List<EventModel> get ongoingEvents =>
      events!.where((event) => event.status == 'Previous Event').toList();

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
                        "Club Details",
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
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    imageName!,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  name!,
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
                ),
                const SizedBox(height: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    description!,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                if (events!.isNotEmpty) ...[
                  if (previousEvents.isNotEmpty)
                  _buildEventCategory('Previous Events', previousEvents),
                  if (upcomingEvents.isNotEmpty)
                    _buildEventCategory('Upcoming Events', upcomingEvents),
                  if (ongoingEvents.isNotEmpty)
                    _buildEventCategory('Ongoing Events', ongoingEvents),
                ],
                const SizedBox(height: 20),
                SharedPrefs.getString('role_id') == '2' ||
                    SharedPrefs.getString('role_id') == '3'
                    ? Center(
                  child: Text(
                    "Executive Position holders of a club cannot register for another club",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                    ),
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
                        "Register as a General Member Now",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
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
          height: 350, // Set height for event cards
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
