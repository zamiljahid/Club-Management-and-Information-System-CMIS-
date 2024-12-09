import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'club_details_screen.dart';

class ClubScreen extends StatefulWidget {
  @override
  _ClubScreenState createState() => _ClubScreenState();
}

class _ClubScreenState extends State<ClubScreen> {
  final PageController _controller = PageController();

  final List<Map<String, dynamic>> clubs = [
    {
      'image': 'assets/images/art_club.jpg',
      'name': 'Art Club',
      'description': 'Unleash your creativity with paints and crafts.',
      'events': [
        {
          'eventName': 'Art Exhibition',
          'eventDate': 'December 15, 2024',
          'eventDescription': 'An exhibition showcasing student art.',
          'eventImage': 'assets/images/test1.jpg',
          'status': 'upcoming', // Added status
        },
        {
          'eventName': 'Painting Workshop',
          'eventDate': 'January 5, 2025',
          'eventDescription': 'A workshop to improve painting skills.',
          'eventImage': 'assets/images/test2.jpg',
          'status': 'upcoming', // Added status
        },
        {
          'eventName': 'Craft Fair',
          'eventDate': 'February 20, 2025',
          'eventDescription': 'A fair where art and craft works will be displayed for sale.',
          'eventImage': 'assets/images/test3.jpg',
          'status': 'upcoming', // Added status
        },
        {
          'eventName': 'Sketching Session',
          'eventDate': 'March 10, 2025',
          'eventDescription': 'An open session for sketching and exploring different techniques.',
          'eventImage': 'assets/images/test4.jpg',
          'status': 'upcoming', // Added status
        },
      ],
    },
    {
      'image': 'assets/images/robotics_club.jpg',
      'name': 'Robotics Club',
      'description': 'Build robots and compete in challenges.',
      'events': [
        {
          'eventName': 'Art Exhibition',
          'eventDate': 'December 15, 2024',
          'eventDescription': 'An exhibition showcasing student art.',
          'eventImage': 'assets/images/test1.jpg',
          'status': 'upcoming', // Added status
        },
        {
          'eventName': 'Painting Workshop',
          'eventDate': 'January 5, 2025',
          'eventDescription': 'A workshop to improve painting skills.',
          'eventImage': 'assets/images/test2.jpg',
          'status': 'upcoming', // Added status
        },
        {
          'eventName': 'Craft Fair',
          'eventDate': 'February 20, 2025',
          'eventDescription': 'A fair where art and craft works will be displayed for sale.',
          'eventImage': 'assets/images/test3.jpg',
          'status': 'upcoming', // Added status
        },
        {
          'eventName': 'Sketching Session',
          'eventDate': 'March 10, 2025',
          'eventDescription': 'An open session for sketching and exploring different techniques.',
          'eventImage': 'assets/images/test4.jpg',
          'status': 'upcoming', // Added status
        },
      ],
    },
    {
      'image': 'assets/images/music_club.jpg',
      'name': 'Music Club',
      'description': 'Jam with fellow music enthusiasts.',
      'events': [
        {
          'eventName': 'Art Exhibition',
          'eventDate': 'December 15, 2024',
          'eventDescription': 'An exhibition showcasing student art.',
          'eventImage': 'assets/images/test1.jpg',
          'status': 'upcoming', // Added status
        },
        {
          'eventName': 'Painting Workshop',
          'eventDate': 'January 5, 2025',
          'eventDescription': 'A workshop to improve painting skills.',
          'eventImage': 'assets/images/test2.jpg',
          'status': 'upcoming', // Added status
        },
        {
          'eventName': 'Craft Fair',
          'eventDate': 'February 20, 2025',
          'eventDescription': 'A fair where art and craft works will be displayed for sale.',
          'eventImage': 'assets/images/test3.jpg',
          'status': 'upcoming', // Added status
        },
        {
          'eventName': 'Sketching Session',
          'eventDate': 'March 10, 2025',
          'eventDescription': 'An open session for sketching and exploring different techniques.',
          'eventImage': 'assets/images/test4.jpg',
          'status': 'upcoming', // Added status
        },
      ],
    },
    {
      'image': 'assets/images/sports_club.jpg',
      'name': 'Sports Club',
      'description': 'Stay active with various sports activities.',
      'events': [
        {
          'eventName': 'Art Exhibition',
          'eventDate': 'December 15, 2024',
          'eventDescription': 'An exhibition showcasing student art.',
          'eventImage': 'assets/images/test1.jpg',
          'status': 'upcoming', // Added status
        },
        {
          'eventName': 'Painting Workshop',
          'eventDate': 'January 5, 2025',
          'eventDescription': 'A workshop to improve painting skills.',
          'eventImage': 'assets/images/test2.jpg',
          'status': 'upcoming', // Added status
        },
        {
          'eventName': 'Craft Fair',
          'eventDate': 'February 20, 2025',
          'eventDescription': 'A fair where art and craft works will be displayed for sale.',
          'eventImage': 'assets/images/test3.jpg',
          'status': 'upcoming', // Added status
        },
        {
          'eventName': 'Sketching Session',
          'eventDate': 'March 10, 2025',
          'eventDescription': 'An open session for sketching and exploring different techniques.',
          'eventImage': 'assets/images/test4.jpg',
          'status': 'upcoming', // Added status
        },
      ],
    },
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff8c0000), Color(0xffda2851)], // Gradient colors
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Text(
              'CLUBS',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: clubs.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: InkWell(
                      onTap: () {
                        // Navigate to the ClubDetailsScreen and pass the image, name, and description
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ClubDetailsScreen(
                              imageName: clubs[index]['image']!,
                              name: clubs[index]['name']!,
                              description: clubs[index]['description']!,
                              events: clubs[index]['events']!,  // Pass events as an argument
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
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16), // Adjust the radius as needed
                                child: Image.asset(
                                  clubs[index]['image']!,
                                  height: 300,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),

                              const SizedBox(height: 16),
                              Text(
                                clubs[index]['name']!,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                clubs[index]['description']!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            SmoothPageIndicator(
              controller: _controller,
              count: clubs.length,
              effect: const WormEffect(
                dotHeight: 8,
                dotWidth: 8,
                activeDotColor: Colors.white,
                dotColor: Colors.black26,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
