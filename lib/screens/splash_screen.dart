import 'package:club_management_and_information_system/screens/login_screeen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../shared_preference.dart';
import 'dashboard_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  String? version, token;


  @override
  void initState() {
    super.initState();
    token = SharedPrefs.getString('access_token');
    print("Token: ${token.toString()}");
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: Future.delayed(const Duration(seconds: 4)),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Color(0xff154973), Color(0xff0f65a5)],
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(8), // Border width
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xffffffff), Color(0xffffffff)],
                            ),
                            shape: BoxShape.circle),
                        child: ClipOval(
                          child: SizedBox.fromSize(
                            size: Size.fromRadius(100),
                            child: Image.asset('assets/appIcon.jpg',
                                fit: BoxFit.cover),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return Builder(
                builder: (context) {
                  if (token == null) {
                    return const LoginScreen();
                  }
                  return  DashboardScreen();
                },
              );
            }));
  }
}
