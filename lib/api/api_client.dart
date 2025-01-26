import 'dart:convert';
import 'dart:io';

import 'package:club_management_and_information_system/model/announcement_model.dart';
import 'package:club_management_and_information_system/model/club_members_model.dart';
import 'package:club_management_and_information_system/model/club_model.dart';
import 'package:club_management_and_information_system/model/token_model.dart';
import 'package:club_management_and_information_system/model/top_club_model.dart';
import 'package:club_management_and_information_system/model/top_presidents_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/candidate_model.dart';
import '../model/elected_president_model.dart';
import '../model/election_results_model.dart';
import '../model/group_message_model.dart';
import '../model/is_registered_model.dart';
import '../model/menu_model.dart';
import '../model/profile_model.dart';
import '../model/register_member_message_model.dart';
import '../model/voter_exist_model.dart';

const String baseUrl = 'http://10.0.2.2:5185';
// create real base url : ngrok http http://localhost:5185
// const String baseUrl = 'https://08ba-103-83-164-33.ngrok-free.app';
// const String baseUrl = 'http://localhost:5185';
const String loginUrl = '/api/Account/Login';
const String menuUrl = '/api/Menu/MenusByRole';
const String profileUrl = '/api/Profile/UserProfile';
const String clubUrl = '/api/Club';
const String eventUrl = '/api/Club/events/upcoming-ongoing';
const String clubMembersUrl = '/api/Club/members';
const String registerClubMembersUrl = '/api/Club/RegisterMember';
const String announcementUrl = '/api/Profile/GetAnnouncements';
const String topPresidentsUrl = '/api/Club/top-presidents';
const String topClubsUrl = '/api/Club/top-clubs';
const String pendingEventsUrl = '/api/Club/events/pending';
const String checkUserEventRegistrationUrl = '/api/Club/CheckUserEventRegistration';
const String checkVoterExistsUrl = '/api/Club/CheckVoterExists';
const String electedPresidentUrl = '/api/Club/elected-presidents';
const String electionResultsUrl = '/api/Club/election-results';
const String candidatesUrl = '/api/Club/GetCandidatesForVoting';
const String saveAnnouncementUrl = '/api/Club/SaveAnnouncement';
const String saveElectionUrl = '/api/Club/SaveElection';
const String saveElectionProcedureUrl = '/api/Club/SaveSelection';
const String saveClubUrl = '/api/Club/CreateClub';
const String saveEventUrl = '/api/Club/CreateEvent';
const String saveVoteUrl = '/api/Club/SaveVote';
const String saveEventRegistrationUrl = '/api/Club/SaveEventRegistration';

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

      final response = await http.get(url);

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

      final response = await http.get(url);

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

      final response = await http.get(url);

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
      final response = await http.get(url);
      print(url.toString());
      print(response.body.toString());
      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.body.isNotEmpty) {
          final jsonData = json.decode(response.body) as List<dynamic>;
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
      final response = await http.get(url);
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
      final response = await http.get(url);
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
      final response = await http.get(url);
      print(url.toString());
      print(response.body.toString());
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

  Future<List<TopPresidentsModel>?> getTopPresidents(BuildContext context) async {
    try {
      var url = Uri.parse(baseUrl + topPresidentsUrl);
      final response = await http.get(url);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.body.isNotEmpty) {
          final jsonData = json.decode(response.body) as List<dynamic>;
          return jsonData.map((presidents) => TopPresidentsModel.fromJson(presidents)).toList();
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

  Future<List<TopClubModel>?> getTopClubs(BuildContext context) async {
    try {
      var url = Uri.parse(baseUrl + topClubsUrl);
      final response = await http.get(url);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.body.isNotEmpty) {
          final jsonData = json.decode(response.body) as List<dynamic>;
          return jsonData.map((clubs) => TopClubModel.fromJson(clubs)).toList();
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

  Future<List<EventModel>?> getPendingEvents(BuildContext context) async {
    try {
      var url = Uri.parse(baseUrl + pendingEventsUrl);
      final response = await http.get(url);
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

  Future<List<CandidateModel>?> getCandidatesForVoting(String api,BuildContext context) async {
    try {
      var url = Uri.parse(baseUrl + candidatesUrl + api);
      final response = await http.get(url);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.body.isNotEmpty) {
          final jsonData = json.decode(response.body) as List<dynamic>;
          return jsonData.map((events) => CandidateModel.fromJson(events)).toList();
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

  Future<IsRegisterModel?> getCheckIsRegistered(String api, BuildContext context) async {
    try {
      var url = Uri.parse(baseUrl + checkUserEventRegistrationUrl + api);
      final response = await http.get(url);

      print(url.toString());
      print(response.body.toString());

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.body.isNotEmpty) {
          // Parse as a single object
          final jsonData = json.decode(response.body) as Map<String, dynamic>;
          return IsRegisterModel.fromJson(jsonData);
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

  Future<CheckVoterExists?> getCheckVoterExists(String api, BuildContext context) async {
    try {
      var url = Uri.parse(baseUrl + checkVoterExistsUrl + api);
      final response = await http.get(url);

      print(url.toString());
      print(response.body.toString());

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.body.isNotEmpty) {
          final jsonData = json.decode(response.body) as Map<String, dynamic>;
          return CheckVoterExists.fromJson(jsonData);
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

  Future<List<ElectedPresidentModel>?> getElectedPresidents(BuildContext context) async {
    try {
      var url = Uri.parse(baseUrl + electedPresidentUrl);
      final response = await http.get(url);
      print(response.body.toString());
      print(url.toString());
      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.body.isNotEmpty) {
          final jsonData = json.decode(response.body) as List<dynamic>;
          return jsonData.map((presidents) => ElectedPresidentModel.fromJson(presidents)).toList();
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

  Future<List<ElectionResultsModel>?> getElectionResults(int id, BuildContext context) async {
    try {
      var url = Uri.parse(baseUrl + electionResultsUrl +'?clubId=${id}');
      final response = await http.get(url);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.body.isNotEmpty) {
          final jsonData = json.decode(response.body) as List<dynamic>;
          return jsonData.map((results) => ElectionResultsModel.fromJson(results)).toList();
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
  Future<String?> updateEventStatus(int eventId, String action, BuildContext context) async {
    try {
      var url = Uri.parse("${baseUrl}/api/Club/UpdateEventStatus?eventId=$eventId&action=$action");
      final response = await http.put(url, headers: {'accept': '*/*'});


      print(url.toString());
      print(response.body.toString());

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.body.isNotEmpty) {
          final responseBody = json.decode(response.body);
          print('Success: ${responseBody['message']}');
          return responseBody['message'];
        } else {
          print('Empty response body.');
        }
      }
    } catch (error) {
      print('Unexpected error: $error');
      ApiErrorHandler.handleError(error, context);
    }
    return null;
  }

  Future<String?> updateMemberRole(String userId, String action, BuildContext context) async {
    try {
      var url = Uri.parse("${baseUrl}/api/Club/UpdateUserRole?userId=$userId&action=$action");
      final response = await http.put(url, headers: {'accept': '*/*'});


      print(url.toString());
      print(response.body.toString());

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.body.isNotEmpty) {
          final responseBody = json.decode(response.body);
          print('Success: ${responseBody['message']}');
          return responseBody['message'];
        } else {
          print('Empty response body.');
        }
      }
    } catch (error) {
      print('Unexpected error: $error');
      ApiErrorHandler.handleError(error, context);
    }
    return null;
  }

  Future<dynamic> postClub(Object payload,BuildContext context) async {
    var url = Uri.parse(baseUrl +  saveClubUrl);
    try {
      var response = await http.post(
        url,
        body: jsonEncode(payload),
        headers: {'Content-Type': 'application/json'},
      );
      print(url.toString());
      print(response.body.toString());
      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.body.isNotEmpty) {
          var responseBody = jsonDecode(response.body);
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: Colors.white,
                  content: Text(
                    responseBody,
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'OK',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ),
                  ],
                );
              });
          return response.body;
        }
      } else {
        var responseBody = jsonDecode(response.body);
        ApiErrorHandler.handleError(responseBody, context);
      }
    } catch (e) {
      print('Unexpected error: $e');
      ApiErrorHandler.handleError(e, context); // Call the error handler
      return 'Unexpected error: $e';
    }
  }

  Future<dynamic> postEventRegistration(Object payload,BuildContext context) async {
    var url = Uri.parse(baseUrl +  saveEventRegistrationUrl);
    try {
      var response = await http.post(
        url,
        body: jsonEncode(payload),
        headers: {'Content-Type': 'application/json'},
      );
      print(url.toString());
      print(response.body.toString());
      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.body.isNotEmpty) {
          var responseBody = jsonDecode(response.body);
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: Colors.white,
                  content: Text(
                    responseBody,
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'OK',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ),
                  ],
                );
              });
          return response.body;
        }
      } else {
        var responseBody = jsonDecode(response.body);
        ApiErrorHandler.handleError(responseBody, context);
      }
    } catch (e) {
      print('Unexpected error: $e');
      ApiErrorHandler.handleError(e, context); // Call the error handler
      return 'Unexpected error: $e';
    }
  }

  Future<dynamic> postEvent(Object payload,BuildContext context) async {
    var url = Uri.parse(baseUrl +  saveEventUrl);
    try {
      var response = await http.post(
        url,
        body: jsonEncode(payload),
        headers: {'Content-Type': 'application/json'},
      );
      print(url.toString());
      print(response.body.toString());
      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.body.isNotEmpty) {
          var responseBody = jsonDecode(response.body);
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: Colors.white,
                  content: Text(
                    responseBody.toString(),
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'OK',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ),
                  ],
                );
              });
          return response.body;
        }
      } else {
        var responseBody = jsonDecode(response.body);
        ApiErrorHandler.handleError(responseBody, context);
      }
    } catch (e) {
      print('Unexpected error: $e');
      ApiErrorHandler.handleError(e, context); // Call the error handler
      return 'Unexpected error: $e';
    }
  }

  Future<dynamic> postVote(Object payload,BuildContext context) async {
    var url = Uri.parse(baseUrl +  saveVoteUrl);
    try {
      var response = await http.post(
        url,
        body: jsonEncode(payload),
        headers: {'Content-Type': 'application/json'},
      );
      print(url.toString());
      print(response.body.toString());
      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.body.isNotEmpty) {
          var responseBody = jsonDecode(response.body);
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: Colors.white,
                  content: Text(
                    responseBody.toString(),
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'OK',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ),
                  ],
                );
              });
          return response.body;
        }
      } else {
        var responseBody = jsonDecode(response.body);
        ApiErrorHandler.handleError(responseBody, context);
      }
    } catch (e) {
      print('Unexpected error: $e');
      ApiErrorHandler.handleError(e, context);
      return 'Unexpected error: $e';
    }
  }

  Future<dynamic> postAnnouncement(Object payload,BuildContext context) async {
    var url = Uri.parse(baseUrl +  saveElectionUrl);
    try {
      var response = await http.post(
        url,
        body: jsonEncode(payload),
        headers: {'Content-Type': 'application/json'},
      );
      print(url.toString());
      print(response.body.toString());
      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.body.isNotEmpty) {
          var responseBody = jsonDecode(response.body);
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: Colors.white,
                  content: Text(
                    responseBody,
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'OK',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ),
                  ],
                );
              });
          return response.body;
        }
      } else {
        var responseBody = jsonDecode(response.body);
        ApiErrorHandler.handleError(responseBody, context);
      }
    } catch (e) {
      print('Unexpected error: $e');
      ApiErrorHandler.handleError(e, context);
      return 'Unexpected error: $e';
    }
  }

  Future<dynamic> postElection(Object payload,BuildContext context) async {
    var url = Uri.parse(baseUrl +  saveElectionUrl);
    try {
      var response = await http.post(
        url,
        body: jsonEncode(payload),
        headers: {'Content-Type': 'application/json'},
      );
      print(url.toString());
      print(response.body.toString());
      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.body.isNotEmpty) {
          var responseBody = jsonDecode(response.body);
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: Colors.white,
                  content: Text(
                    responseBody,
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'OK',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ),
                  ],
                );
              });
          return response.body;
        }
      } else {
        var responseBody = jsonDecode(response.body);
        ApiErrorHandler.handleError(responseBody, context);
      }
    } catch (e) {
      print('Unexpected error: $e');
      ApiErrorHandler.handleError(e, context);
      return 'Unexpected error: $e';
    }
  }

  Future<dynamic> postElectionProcedure(Object payload,BuildContext context) async {
    var url = Uri.parse(baseUrl +  saveElectionProcedureUrl);
    try {
      var response = await http.post(
        url,
        body: jsonEncode(payload),
        headers: {'Content-Type': 'application/json'},
      );
      print(url.toString());
      print(response.body.toString());
      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.body.isNotEmpty) {
          var responseBody = jsonDecode(response.body);
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: Colors.white,
                  content: Text(
                    responseBody,
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'OK',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ),
                  ],
                );
              });
          return response.body;
        }
      } else {
        var responseBody = jsonDecode(response.body);
        ApiErrorHandler.handleError(responseBody, context);
      }
    } catch (e) {
      print('Unexpected error: $e');
      ApiErrorHandler.handleError(e, context);
      return 'Unexpected error: $e';
    }
  }

  Future<RegisterMemberMessageModel?> getMemberRegistered(String api, BuildContext context) async {
    try {
      var url = Uri.parse(baseUrl + registerClubMembersUrl + api);
      final response = await http.get(url);
      print(url.toString());
      print(response.body.toString());
      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.body.isNotEmpty) {
          final jsonData = json.decode(response.body) as Map<String, dynamic>;
          return RegisterMemberMessageModel.fromJson(jsonData);
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


  Future<List<GroupMessageModel>?> getMessages(String api, BuildContext context) async {
    try {
      var url = Uri.parse(baseUrl + '/api/Club/GetMessages' +'?clubId='+ api);
      final response = await http.get(url);

      print(url.toString());
      print(response.body.toString());
      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.body.isNotEmpty) {
          final jsonData = json.decode(response.body) as List<dynamic>;
          return jsonData.map((messages) => GroupMessageModel.fromJson(messages)).toList();
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

  Future<String> fetchLatestElectionStatus() async {

    var url = Uri.parse('$baseUrl/api/Club/GetLatestElectionStatus');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load election status');
    }
  }

  Future<dynamic> postMessages(Object payload,BuildContext context) async {
    var url = Uri.parse(baseUrl +  '/api/Club/SendMessage');
    try {
      var response = await http.post(
        url,
        body: jsonEncode(payload),
        headers: {'Content-Type': 'application/json'},
      );
      print(url.toString());
      print(response.body.toString());
      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.body.isNotEmpty) {
          return response.body;
        }
      } else {
        var responseBody = jsonDecode(response.body);
        ApiErrorHandler.handleError(responseBody, context);
      }
    } catch (e) {
      print('Unexpected error: $e');
      ApiErrorHandler.handleError(e, context);
      return 'Unexpected error: $e';
    }
  }


}