import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'event_details_screen.dart';

class EventScreen extends StatefulWidget {
  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  final PageController _controller = PageController();

  final List<Map<String, dynamic>> events = [
    {
      'image': 'assets/images/eventIcon.jpg',
      'name': 'NextGen Diplomats' ,
      'description': 'Shaping the future of global leadership through innovation, collaboration, and vision.',
      'club': 'UIU Model United Nations Club'
    },
    {
      'image': 'assets/images/presentation_champs.jpg',
      'name': 'Presentation Champs: Season 1',
      'description': 'Master the art of impactful storytelling with Presentation Champs!',
      'club': 'UIU English Language Forum'

    },
    {
      'image': 'assets/images/Gen-Z.jpg',
      'name': 'Gen-Z',
      'description': 'The connected, creative, and change-driven generation redefining the norm.',
    'club': 'UIU'

    }
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
            "ON GOING EVENTS",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: events.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: InkWell(
                      onTap: () {
                        // Navigate to the ClubDetailsScreen and pass the image, name, and description
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EventDetailsScreen(
                              imageName: events[index]['image']!,
                              name:  events [index]['name']!,
                              description:  events[index]['description']!,
                              club:  events[index]['club']!,  // Pass events as an argument
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
                                  events[index]['image']!,
                                  height: 300,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),

                              const SizedBox(height: 16),
                              Text(
                                events[index]['name']!,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                events[index]['description']!,
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
              count:  events.length,
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
