import 'dart:ui';

import 'package:club_management_and_information_system/screens/chat_screen.dart';
import 'package:club_management_and_information_system/screens/club_details_screen.dart';
import 'package:club_management_and_information_system/screens/club_screen.dart';
import 'package:club_management_and_information_system/screens/election_screen.dart';
import 'package:club_management_and_information_system/screens/event_screen.dart';
import 'package:club_management_and_information_system/screens/profile_screen.dart';
import 'package:flutter/material.dart';

import '../screens/announcement_screen.dart';
import '../screens/my_club_screen.dart';
import '../screens/my_task_screen.dart';
import '../screens/splash_screen.dart';
import 'routes_names.dart';

class RouterGenerator {
  static Route<String> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteConstantName.splashScreen:
        return MaterialPageRoute(
          builder: (context) =>  SplashScreen(),
        );

      case RouteConstantName.clubScreen:
        return MaterialPageRoute(
          builder: (context) =>  ClubScreen(),
        );
      case RouteConstantName.profileScreen:
        return MaterialPageRoute(
          builder: (context) =>  ProfileScreen(),
        );
      case RouteConstantName.announcementScreen:
        return MaterialPageRoute(
          builder: (context) =>  AnnouncementScreen(),
        );
      case RouteConstantName.electionScreen:
        return MaterialPageRoute(
          builder: (context) =>  ElectionScreen(),
        );
      case RouteConstantName.myClubScreen:
        return MaterialPageRoute(
          builder: (context) =>  MyClubScreen(),
        );
      case RouteConstantName.myTaskScreen:
        return MaterialPageRoute(
          builder: (context) =>  MyTaskScreen(),
        );
      case RouteConstantName.eventScreen:
        return MaterialPageRoute(
          builder: (context) =>  EventScreen(),
        );
      case RouteConstantName.chatScreen:
        return MaterialPageRoute(
          builder: (context) =>  GroupChatScreen(),
        );


      default:
        return _errorRoute();
    }
  }

  static Route<String> _errorRoute() {
    return MaterialPageRoute(builder: (context) {
      return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(
            double.infinity,
            56.0,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: AppBar(
                backgroundColor:
                Theme.of(context).primaryColorDark.withOpacity(0.8),
                title: Text(
                  "Error Route",
                  style: TextStyle(color: Theme.of(context).primaryColorLight),
                ),
                leading: GestureDetector(
                  onTap: (){Navigator.pop(context);},
                  child: Icon(
                    Icons.arrow_back,
                    color: Theme.of(context).primaryColorLight,
                  ),
                ),
                elevation: 0.0,
              ),
            ),
          ),
        ),
        body: Center(
          child: Text('Page not found'),
        ),
      );
    });
  }
}
