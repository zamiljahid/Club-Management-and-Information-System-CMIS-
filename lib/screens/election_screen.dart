import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';


class ElectionScreen extends StatefulWidget {
  @override
  _ElectionScreenState createState() => _ElectionScreenState();
}

class _ElectionScreenState extends State<ElectionScreen> {
  final PageController _controller = PageController();

  final List<Map<String, dynamic>> candidates = [
    {
      'image': 'https://randomuser.me/api/portraits/men/1.jpg',
      'name': 'John Doe',
      'position': 'President',
      'votes': 75,
      'bio': 'John has a strong background in leadership and community service, with a proven track record of organizing successful events.',
      'manifesto': 'Focus on transparency, innovation, and inclusivity to create a better community for everyone.',
    },
    {
      'image': 'https://randomuser.me/api/portraits/women/2.jpg',
      'name': 'Jane Smith',
      'position': 'Vice President',
      'votes': 5,
      'bio': 'Jane is passionate about fostering teamwork and empowering others to achieve their goals.',
      'manifesto': 'Advocate for equal opportunities and provide support for new initiatives in the community.',
    },
    {
      'image': 'https://randomuser.me/api/portraits/men/3.jpg',
      'name': 'Alex Johnson',
      'position': 'General Secretary',
      'votes': 50,
      'bio': 'Alex is experienced in managing logistics and ensuring smooth communication between different teams.',
      'manifesto': 'Prioritize efficient management and improved communication channels for everyone.',
    },
    {
      'image': 'https://randomuser.me/api/portraits/women/4.jpg',
      'name': 'Emily Davis',
      'position': 'Treasurer',
      'votes': 25,
      'bio': 'Emily has a strong financial acumen and is skilled in budgeting and resource allocation.',
      'manifesto': 'Ensure transparency in financial matters and optimize resources for maximum benefit.',
    },
    {
      'image': 'https://randomuser.me/api/portraits/men/5.jpg',
      'name': 'Michael Brown',
      'position': 'Cultural Secretary',
      'votes': 69,
      'bio': 'Michael is a creative thinker and a strong advocate for promoting cultural diversity.',
      'manifesto': 'Encourage cultural events and celebrate the diversity of our community.',
    },
  ];

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
        child: Column(
          children: [
            SizedBox(height: 20,),
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
                  'Election',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.transparent),
                  onPressed: () {
                  },
                ),
              ],
            ),
        SizedBox(
          height: 250, // Fixed height for the card
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0, right: 15, left: 15),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.3),
                    Colors.white.withOpacity(0.2),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, right: 15, left: 15),
                        child: Center(
                          child: Text(
                            'Vote Percentage',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: candidates.length,
                          itemBuilder: (context, index) {
                            final candidate = candidates[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(candidates[index]['image']!),
                                    radius: 25,
                                  ),

                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          candidate['name'],
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Stack(
                                          children: [
                                            Container(
                                              height: 20,
                                              decoration: BoxDecoration(
                                                color: Colors.grey.withOpacity(0.3),
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                            ),
                                            // Foreground Bar
                                            Container(
                                              height: 20,
                                              width: MediaQuery.of(context).size.width * 0.6 * (candidate['votes'] / 100),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  // Percentage Label
                                  Text(
                                    '${candidate['votes']}%',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          ),
        ),
        SizedBox(height: 8,),
        Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: candidates.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                    child: InkWell(
                      onTap: () {
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
                                borderRadius: BorderRadius.circular(16),
                                child: Image.network(
                                  candidates[index]['image']!,
                                  height: 200,
                                  width: 250,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                candidates[index]['name']!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                candidates[index]['bio']!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 12),
                              ),
                              SizedBox(height: 10,),
                              GestureDetector(
                                onTap: (){
                                },
                                child: Container(
                                  height: 40,
                                  width: 150,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    gradient: LinearGradient(
                                        colors:[Color(0xff154973), Color(0xff0f65a5)],
                                  ),
                                  ),
                                  child: Center(child: Text('Vote',style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.white
                                  ),),),

                                ),
                              )
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
              count: candidates.length,
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
