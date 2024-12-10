import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'club_details_screen.dart';

class ElectionScreen extends StatefulWidget {
  @override
  _ElectionScreenState createState() => _ElectionScreenState();
}

class _ElectionScreenState extends State<ElectionScreen> {
  final PageController _controller = PageController();

  final List<Map<String, dynamic>> candidates = [
    {
      'image': 'assets/images/Gen-Z.jpg',
      'name': 'John Doe',
      'position': 'President',
      'bio': 'John has a strong background in leadership and community service, with a proven track record of organizing successful events.',
      'manifesto': 'Focus on transparency, innovation, and inclusivity to create a better community for everyone.',
    },
    {
      'image': 'assets/images/Gen-Z.jpg',
      'name': 'Jane Smith',
      'position': 'Vice President',
      'bio': 'Jane is passionate about fostering teamwork and empowering others to achieve their goals.',
      'manifesto': 'Advocate for equal opportunities and provide support for new initiatives in the community.',
    },
    {
      'image': 'assets/images/Gen-Z.jpg',
      'name': 'Alex Johnson',
      'position': 'General Secretary',
      'bio': 'Alex is experienced in managing logistics and ensuring smooth communication between different teams.',
      'manifesto': 'Prioritize efficient management and improved communication channels for everyone.',
    },
    {
      'image': 'assets/images/Gen-Z.jpg',
      'name': 'Emily Davis',
      'position': 'Treasurer',
      'bio': 'Emily has a strong financial acumen and is skilled in budgeting and resource allocation.',
      'manifesto': 'Ensure transparency in financial matters and optimize resources for maximum benefit.',
    },
    {
      'image': 'assets/images/Gen-Z.jpg',
      'name': 'Michael Brown',
      'position': 'Cultural Secretary',
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
            colors: [Color(0xff8c0000), Color(0xffda2851)], // Gradient colors
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
            const SizedBox(height: 20),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: candidates.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
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
                                borderRadius: BorderRadius.circular(16), // Adjust the radius as needed
                                child: Image.asset(
                                  candidates[index]['image']!,
                                  height: 300,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),

                              const SizedBox(height: 16),
                              Text(
                                candidates[index]['name']!,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                candidates[index]['position']!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                candidates[index]['bio']!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 10,),
                              GestureDetector(
                                onTap: (){
                                },
                                child: Container(
                                  height: 55,
                                  width: 300,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    gradient: LinearGradient(
                                        colors:
                                        [Color(0xff8c0000), Color(0xffda2851)
                                        ]),
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
