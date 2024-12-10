import 'package:flutter/material.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, String> userInfo = {
      'Name': 'John Doe',
      'Student ID': '12345678',
      'Date of Birth': '01-Jan-2000',
      'Blood Group': 'O+',
      'Club Position': 'President',
      'Club Name': 'Tech Club'
    };

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff8c0000), Color(0xffda2851)],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 60.0, left: 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Spacer(),
                  Text(
                    "Profile",
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
          ),
          // Profile content container
          Padding(
            padding: const EdgeInsets.only(top: 200.0),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                color: Colors.white,
              ),
              height: double.infinity,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Column(
                  children: [
                    const SizedBox(height: 40),


                    Container(
                      padding: EdgeInsets.all(8), // Border width
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xff8c0000), Color(0xffda2851)],),
                          shape: BoxShape.circle),
                      child: CircleAvatar(
                        radius: 80,
                        backgroundImage: NetworkImage('https://randomuser.me/api/portraits/men/32.jpg'),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text("Student Information",  style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff8c0000),
                    ),),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView.builder(
                        itemCount: userInfo.length,
                        itemBuilder: (context, index) {
                          String key = userInfo.keys.elementAt(index);
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  key,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff8c0000),
                                  ),
                                ),
                                Text(
                                  userInfo[key]!,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
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
        ],
      ),
    );
  }
}
