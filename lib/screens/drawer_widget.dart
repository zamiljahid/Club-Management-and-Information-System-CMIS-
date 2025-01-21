import 'package:club_management_and_information_system/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import '../routes/menu_title_list.dart';
import '../shared_preference.dart';

class DrawerWidget extends StatelessWidget {
  final String empId;
  final String empName;
  final String pic;
  final String position;
  final List dashboardList;

  const DrawerWidget({
    required this.empId,
    required this.empName,
    required this.pic,
    required this.position,
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

    print('Employee Picture URL: $pic');

    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff154973), Color(0xff0f65a5)],
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey, 
                    child: ClipOval(
                      child: pic.isNotEmpty
                          ? Image.network(
                        pic,
                        fit: BoxFit.fill, // Ensure the image covers the circle
                      )
                          : Icon(Icons.person, size: 40, color: Colors.white), // Fallback icon if there's no image
                    ),
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
                          position,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
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
                    child:ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: dashboardList.length,
                      padding: EdgeInsets.symmetric(vertical: 2),
                      itemBuilder: (BuildContext context, int i) {
                        return Column(
                          children: [
                            ListTile(
                                iconColor: Colors.white,
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    ChooseMenu.getRoutes(
                                      menuTitle: dashboardList[i].menuName.toString(),
                                    ),
                                  );
                                },
                                title: Text(
                                  ChooseMenu.getTitle(
                                      menuTitle: dashboardList[i].menuName.toString()),
                                  style: TextStyle(
                                    fontSize: 15,
                                    color:Colors.white,
                                  ),
                                ),
                              leading: Icon(
                                ChooseMenu.getIcon(menuTitle: dashboardList[i].menuName.toString()),
                                size: 30,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          height: .1,
                        );
                      },
                    )




                    // ListView.builder(
                    //   itemCount: dashboardList.length,
                    //   itemBuilder: (context, index) {
                    //     final item = dashboardList[index];
                    //     return ListTile(
                    //       leading: Icon(
                    //         item['icon'],
                    //         color: Colors.white, // Set icon color to white
                    //         size: 30, // Increase icon size
                    //       ),
                    //       title: Text(
                    //         item['name'],
                    //         style: const TextStyle(
                    //           color: Colors.white, // Set text color to white
                    //           fontSize: 18, // Increase text size
                    //           fontWeight: FontWeight.bold, // Make text bold for better visibility
                    //         ),
                    //       ),
                    //       onTap: () {
                    //         // Navigator.pop(context);
                    //         Navigator.push(
                    //           context,
                    //           MaterialPageRoute(builder: (context) => item['screen']),
                    //         );
                    //       },
                    //     );
                    //   },
                    // ),
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
                      // Show confirmation dialog
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Logout Confirmation"),
                            content: const Text("Are you sure you want to log out?"),
                            actions: [
                              // Cancel button
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("Cancel"),
                              ),
                              // Confirm button
                              TextButton(
                                onPressed: () {
                                  SharedPrefs.remove('access_token');
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => SplashScreen()),
                                  );
                                },
                                child: const Text("Yes"),
                              ),
                            ],
                          );
                        },
                      );
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
