import 'package:club_management_and_information_system/api/api_client.dart';
import 'package:club_management_and_information_system/screens/dashboard_screen.dart';
import 'package:flutter/material.dart';

import '../shared_preference.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  bool _isObscure = true;
  final TextEditingController loginController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void handleLogin() async {
      final String loginID = loginController.text.trim();
      final String password = passwordController.text.trim();

      if (loginID.isEmpty || password.isEmpty) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Login Failed"),
            content: const Text("Please enter both email and password."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
        );
        return;
      }
      final loginApi = "?user_id=$loginID&password=$password";
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator(
          color: Colors.white,
        )),
      );

      try {
        final loginData = await ApiClient().getLogin(loginApi, context);

        final userData = await ApiClient().getProfile("?user_id=$loginID", context);

        Navigator.pop(context);

        if (loginData != null && userData != null) {
          SharedPrefs.setString('access_token', loginData.token!);
          print(SharedPrefs.getString('access_token').toString());
          SharedPrefs.setString('name', userData.name!);
          SharedPrefs.setString('id', userData.userID!);
          SharedPrefs.setString('role', userData.role!);
          SharedPrefs.setString('role_id', userData.roleId!);
          SharedPrefs.setInt('club_id', userData.clubId!);
          SharedPrefs.setString('pic', userData.profilePicUrl!);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => DashboardScreen()),
          );
        } else {
          throw Exception('Login or user data retrieval failed');
        }
      } catch (e) {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Error"),
            content: Text("An unexpected error occurred: $e"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }
    }

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff154973), Color(0xff0f65a5)],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 60.0, left: 15),
              child: Column(
                children: [
                  Text(
                    'Welcome To!',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Club Management & Information System',
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 200.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                color: Colors.white,
              ),
              height: double.infinity,
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.only(left: 18.0, right: 18),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 40),
                      Container(
                        padding: EdgeInsets.all(8), // Border width
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xff154973), Color(0xff0f65a5)],
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: ClipOval(
                          child: SizedBox.fromSize(
                            size: Size.fromRadius(80), // Image radius
                            child: Image.asset('assets/appIcon.jpg', fit: BoxFit.cover),
                          ),
                        ),
                      ),
                      SizedBox(height: 50),
                      TextField(
                        controller: loginController,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2, color: Colors.blueAccent),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2, color: Color(0xff154973)),
                          ),
                          suffixIcon: Icon(Icons.person, color: Color(0xff154973)),
                          label: Text(
                            'Login ID',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xff154973),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: passwordController,
                        obscureText: _isObscure, // Toggle password visibility
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2, color: Colors.blueAccent),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2, color: Color(0xff154973)),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isObscure ? Icons.visibility_off : Icons.visibility,
                              color: Color(0xff154973),
                            ),
                            onPressed: () {
                              setState(() {
                                _isObscure = !_isObscure; // Toggle the visibility state
                              });
                            },
                          ),
                          label: Text(
                            'Password',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xff154973),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 70),
                      GestureDetector(
                        onTap: () {
                          handleLogin();
                        },
                        child: Container(
                          height: 55,
                          width: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: LinearGradient(
                              colors: [Color(0xff154973), Color(0xff0f65a5)],
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'SIGN IN',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
