import 'dart:io';
import 'package:flutter/material.dart';
import '../main.dart';
import '../shared_preference.dart';

import 'package:flutter/material.dart';

class DrawerWidget extends StatelessWidget {
  final String empId;
  final String empName;
  final String empPic;
  final String empPosition; // Added position field
  final List dashboardList;

  const DrawerWidget({
    required this.empId,
    required this.empName,
    required this.empPic,
    required this.empPosition,
    required this.dashboardList,
  });

  String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    }
    if (hour < 17) {
      return 'Good Afternoon';
    }
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff8c0000), Color(0xffda2851)], // Gradient colors
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40,),
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center, // Align image and text vertically
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(empPic),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // Align text to the start
                      mainAxisAlignment: MainAxisAlignment.center, // Center text vertically within the row
                      children: [
                        Text(
                          empName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          empPosition,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

            ),
            Center(
              child: Text(
                greeting(),
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
            const Divider(color: Colors.white70, thickness: 1),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: dashboardList.length,
                      itemBuilder: (context, index) {
                        final item = dashboardList[index];
                        return ListTile(
                          leading: Icon(
                            item['icon'],
                            color: Colors.white, // Set icon color to white
                            size: 30, // Increase icon size
                          ),
                          title: Text(
                            item['name'],
                            style: const TextStyle(
                              color: Colors.white, // Set text color to white
                              fontSize: 18, // Increase text size
                              fontWeight: FontWeight.bold, // Make text bold for better visibility
                            ),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => item['screen']),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const Divider(
                    color: Colors.white70,
                    thickness: 1, // Divider between list and logout
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.logout,
                      color: Colors.white,
                      size: 30, // Logout icon size
                    ),
                    title: const Text(
                      'Logout',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      // Add logout functionality here
                      Navigator.pop(context);
                      // Show a confirmation dialog or directly handle logout
                      print("User logged out!");
                    },
                  ),
                ],
              )

            ),
          ],
        ),
      ),
    );
  }
}
