import 'package:flutter/material.dart';
import 'routes_names.dart';

class ChooseMenu {
  static String getTitle({required String menuTitle}) {
    switch (menuTitle) {
      case "Clubs":
        return "Clubs";

      case "Election":
        return "Election";

      case "Inbox":
        return "Inbox";

      case "Announcement":
        return "Announcement";

      case "My Task":
        return "My Task";

      case "Events":
        return "Events";

      case "Profile":
        return "Profile";

      case "My Club":
        return "My Club";

      default:
        return menuTitle;
    }
  }

  static IconData getIcon({required String menuTitle}) {
    switch (menuTitle) {
      case "Clubs":
        return Icons.group;

      case "Election":
        return Icons.how_to_vote;

      case "Inbox":
        return Icons.inbox;

      case "Announcement":
        return Icons.announcement;

      case "My Task":
        return Icons.task;

      case "Events":
        return Icons.event;

      case "Profile":
        return Icons.person_pin;

      case "My Club":
        return Icons.school;


      default:
        return Icons.error;;
    }
  }

  static String getRoutes({required String menuTitle}) {
    switch (menuTitle) {
      case "Clubs":
        return RouteConstantName.clubScreen;

      case "Election":
        return RouteConstantName.electionScreen;

      case "Inbox":
        return RouteConstantName.chatScreen;

      case "Announcement":
        return RouteConstantName.announcementScreen;

      case "My Task":
        return RouteConstantName.myTaskScreen;

      case "Events":
        return RouteConstantName.eventScreen;

      case "Profile":
        return RouteConstantName.profileScreen;

      case "My Club":
        return RouteConstantName.myClubScreen;

      default:
        return RouteConstantName.errorRoute;
    }
  }
}
