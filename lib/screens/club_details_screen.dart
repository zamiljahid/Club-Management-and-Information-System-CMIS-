import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ClubDetailsScreen extends StatelessWidget {
  final String imageName;
  final String name;
  final String description;
  final List<Map<String, dynamic>> events;

  ClubDetailsScreen({
    required this.imageName,
    required this.name,
    required this.description,
    required this.events,
  });

  // Categorize events
  List<Map<String, dynamic>> get previousEvents =>
      events.where((event) => event['status'] == 'upcoming').toList();

  List<Map<String, dynamic>> get upcomingEvents =>
      events.where((event) => event['status'] == 'upcoming').toList();

  List<Map<String, dynamic>> get ongoingEvents =>
      events.where((event) => event['status'] == 'upcoming').toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xff8c0000), Color(0xffff0039)],
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
                        onPressed: () {
                        },
                      ),
                    ],
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    imageName,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  name,
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
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    description,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),

                // Event categories
                _buildEventCategory('Previous Events', previousEvents),
                _buildEventCategory('Upcoming Events', upcomingEvents),
                _buildEventCategory('Ongoing Events', ongoingEvents),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build event category
  Widget _buildEventCategory(String title, List<Map<String, dynamic>> events) {
    // PageController for horizontal scrolling
    final PageController pageController = PageController();

    return Column(
      children: [
        // Event category title
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
          height: 350,  // Set height for event cards
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
                      Image.asset(
                        event['eventImage']!,
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          event['eventName']!,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        event['eventDate']!,
                        style: const TextStyle(fontSize: 16),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          event['eventDescription']!,
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
        const SizedBox(height: 20),  // Spacer
      ],
    );
  }
}
