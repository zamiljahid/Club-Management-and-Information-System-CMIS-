import 'dart:convert';
import 'dart:io';

import 'package:club_management_and_information_system/model/announcement_model.dart';
import 'package:club_management_and_information_system/model/club_members_model.dart';
import 'package:club_management_and_information_system/model/club_model.dart';
import 'package:club_management_and_information_system/model/token_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/menu_model.dart';
import '../model/profile_model.dart';

const String baseUrl = 'http://10.0.2.2:5185';
// create real base url : ngrok http http://localhost:5185
// const String baseUrl = 'https://2416-27-147-142-242.ngrok-free.app';
// const String baseUrl = 'http://localhost:5185';
const String loginUrl = '/api/Account/Login';
const String menuUrl = '/api/Menu/MenusByRole';
const String profileUrl = '/api/Profile/UserProfile';
const String clubUrl = '/api/Club';
const String eventUrl = '/api/Club/events/upcoming-ongoing';
const String clubMembersUrl = '/api/Club/members';
const String announcementUrl = '/api/Profile/GetAnnouncements';

class ApiErrorHandler {
  static void handleError(dynamic error, BuildContext context) {
    if (error is SocketException) {
      _showErrorDialog(context, "Connection Error", "No internet connection. Please check your network.");
    } else if (error is HttpException) {
      _showErrorDialog(context, "Server Error", "Server error occurred. Please try again later.");
    } else if (error is FormatException) {
      _showErrorDialog(context, "Format Error", "Unexpected response format. Please contact support.");
    } else {
      _showErrorDialog(context, "Unexpected Error", "An unexpected error occurred: ${error.toString()}");
    }
  }

  static void _showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close the dialog
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}

class ApiClient {

  Future<LoginModelClass?> getLogin(String api, BuildContext context) async {
    try {
      var url = Uri.parse(baseUrl + loginUrl + api);
      print('Request URL: $url');

      final response = await http.get(url);
      print('Response: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.body.isNotEmpty) {
          final jsonData = json.decode(response.body);
          return LoginModelClass.fromJson(jsonData);
        } else {
          print('Empty response body.');
        }
      } else {
        print('Error: ${response.statusCode}');
        final responseBody = jsonDecode(response.body);
        if (responseBody == "You are Unauthorized.") {
          print("Unauthorized login attempt.");
          ApiErrorHandler._showErrorDialog(context, "Unauthorized", "Unauthorized login attempt.");
        }
      }
    } catch (error) {
      print('Unexpected error: $error');
      ApiErrorHandler.handleError(error, context);
    }
    return null;
  }
  Future<List<MenuModelClass>?> getMenu(String api, BuildContext context) async {
    try {
      var url = Uri.parse(baseUrl + menuUrl + api);
      print('Request URL: $url');

      final response = await http.get(url);
      print('Response: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.body.isNotEmpty) {
          List<dynamic> menuJson = json.decode(response.body);
          return menuJson.map((menu) => MenuModelClass.fromJson(menu)).toList();
        } else {
          print('Empty response body.');
        }
      } else {
        print('Error: ${response.statusCode}');
        final responseBody = jsonDecode(response.body);
        if (responseBody == "You are Unauthorized.") {
          print("Unauthorized access.");
          ApiErrorHandler._showErrorDialog(context, "Unauthorized", "Unauthorized access.");
        } else {
          print("Error: ${responseBody}");
        }
      }
    } catch (error) {
      print('Unexpected error: $error');
      ApiErrorHandler.handleError(error, context);
    }
    return null;
  }

  Future<UserModel?> getProfile(String api, BuildContext context) async {
    try {
      var url = Uri.parse(baseUrl + profileUrl +  api);
      print('Request URL: $url');

      final response = await http.get(url);
      print('Response: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.body.isNotEmpty) {
          final jsonData = json.decode(response.body);
          return UserModel.fromJson(jsonData);
        } else {
          print('Empty response body.');
        }
      } else {
        print('Error: ${response.statusCode}');
        final responseBody = jsonDecode(response.body);
        if (responseBody == "You are Unauthorized.") {
          print("Unauthorized access.");
          ApiErrorHandler._showErrorDialog(context, "Unauthorized", "Unauthorized access.");
        } else {
          print("Error: ${responseBody}");
        }
      }
    } catch (error) {
      print('Unexpected error: $error');
      ApiErrorHandler.handleError(error, context);
    }
    return null;
  }

  Future<List<ClubModel>?> getClubs(BuildContext context) async {
    try {
      var url = Uri.parse(baseUrl + clubUrl);
      print('Request URL: $url');

      final response = await http.get(url);
      print('Response: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.body.isNotEmpty) {
          final jsonData = json.decode(response.body) as List<dynamic>;
          // Parse the list of clubs
          return jsonData.map((club) => ClubModel.fromJson(club)).toList();
        } else {
          print('Empty response body.');
        }
      } else {
        print('Error: ${response.statusCode}');
        final responseBody = jsonDecode(response.body);
        if (responseBody == "You are Unauthorized.") {
          print("Unauthorized access.");
          ApiErrorHandler._showErrorDialog(context, "Unauthorized", "Unauthorized access.");
        } else {
          print("Error: ${responseBody}");
        }
      }
    } catch (error) {
      print('Unexpected error: $error');
      ApiErrorHandler.handleError(error, context);
    }
    return null;
  }

  Future<List<EventModel>?> getEvents(BuildContext context) async {
    try {
      var url = Uri.parse(baseUrl + eventUrl);
      print('Request URL: $url');
      final response = await http.get(url);
      print('Response: ${response.body}');
      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.body.isNotEmpty) {
          final jsonData = json.decode(response.body) as List<dynamic>;
          return jsonData.map((events) => EventModel.fromJson(events)).toList();
        } else {
          print('Empty response body.');
        }
      } else {
        print('Error: ${response.statusCode}');
        final responseBody = jsonDecode(response.body);
        if (responseBody == "You are Unauthorized.") {
          print("Unauthorized access.");
          ApiErrorHandler._showErrorDialog(context, "Unauthorized", "Unauthorized access.");
        } else {
          print("Error: ${responseBody}");
        }
      }
    } catch (error) {
      print('Unexpected error: $error');
      ApiErrorHandler.handleError(error, context);
    }
    return null;
  }

  Future<List<ClubMembersModel>?> getClubMembers(int api, BuildContext context) async {
    try {
      var url = Uri.parse(baseUrl + clubMembersUrl +'?clubId=' +'$api');
      print('Request URL: $url');
      final response = await http.get(url);
      print('Response: ${response.body}');
      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.body.isNotEmpty) {
          final jsonData = json.decode(response.body) as List<dynamic>;
          return jsonData.map((members) => ClubMembersModel.fromJson(members)).toList();
        } else {
          print('Empty response body.');
        }
      } else {
        print('Error: ${response.statusCode}');
        final responseBody = jsonDecode(response.body);
        if (responseBody == "You are Unauthorized.") {
          print("Unauthorized access.");
          ApiErrorHandler._showErrorDialog(context, "Unauthorized", "Unauthorized access.");
        } else {
          print("Error: ${responseBody}");
        }
      }
    } catch (error) {
      print('Unexpected error: $error');
      ApiErrorHandler.handleError(error, context);
    }
    return null;
  }



  Future<List<AnnouncementModel>?> getAnnouncement(String api, BuildContext context) async {
    try {
      var url = Uri.parse(baseUrl + announcementUrl + api);
      print('Request URL: $url');
      final response = await http.get(url);
      print('Response: ${response.body}');
      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.body.isNotEmpty) {
          final jsonData = json.decode(response.body) as List<dynamic>;
          return jsonData.map((announcement) => AnnouncementModel.fromJson(announcement)).toList();
        } else {
          print('Empty response body.');
        }
      } else {
        print('Error: ${response.statusCode}');
        final responseBody = jsonDecode(response.body);
        if (responseBody == "You are Unauthorized.") {
          print("Unauthorized access.");
          ApiErrorHandler._showErrorDialog(context, "Unauthorized", "Unauthorized access.");
        } else {
          print("Error: ${responseBody}");
        }
      }
    } catch (error) {
      print('Unexpected error: $error');
      ApiErrorHandler.handleError(error, context);
    }
    return null;
  }

}