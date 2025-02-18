import 'package:club_management_and_information_system/routes/routes.dart';
import 'package:club_management_and_information_system/screens/election_screen.dart';
import 'package:club_management_and_information_system/screens/my_task_screen.dart';
import 'package:club_management_and_information_system/screens/splash_screen.dart';

import 'package:club_management_and_information_system/shared_preference.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefs.init();
  runApp(const ProviderScope(child: MainClass()));
}

class MainClass extends StatefulWidget {
  const MainClass({Key? key}) : super(key: key);

  @override
  MainClassState createState() => MainClassState();
}

class MainClassState extends State<MainClass> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: RouterGenerator.generateRoute,
      home: SplashScreen(),
    );
  }


}
