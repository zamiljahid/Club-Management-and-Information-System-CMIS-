import 'dart:math';
import 'dart:ui';

import 'package:club_management_and_information_system/screens/chat_screen.dart';
import 'package:club_management_and_information_system/screens/profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'club_screen.dart';
import 'drawer_widget.dart';
import 'election_screen.dart';
import 'event_screen.dart';
import 'menu_card.dart';


class DashboardScreen extends StatefulWidget {
  DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  String? menuCode, profilePic;
  bool isDragging = false;
  bool isDrawerClose = true;

  Future<List<dynamic>>? menuList;

  late AnimationController _animationController;
  late Animation<double> animation;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
    )..addListener(() {
      setState(() {});
    });
    animation = Tween<double>(begin: 0, end: .9).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.fastOutSlowIn,
    ));
    scaleAnimation = Tween<double>(begin: 1, end: 0.7).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.fastOutSlowIn,
    ));
    // Initialize menuList with new screens
    menuList = Future.value([
      {'name': 'Clubs', 'icon': Icons.group, 'screen': ClubScreen()},
      {'name': 'Events', 'icon': Icons.event, 'screen': EventScreen()},
      {'name': 'Elections', 'icon': Icons.how_to_vote, 'screen': ElectionScreen()},
      {'name': 'Profile', 'icon': Icons.person, 'screen': ProfileScreen()},
      {'name': 'Chat', 'icon': Icons.chat, 'screen': GroupChatScreen()},
    ]);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void toggleDrawer() {
    if (isDrawerClose) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    setState(() {
      isDrawerClose = !isDrawerClose;
    });
  }

  void onDragStart(DragStartDetails details) {
    setState(() {
      isDragging = true;
    });
  }

  void onDragUpdate(DragUpdateDetails details) {
    if (details.primaryDelta != null) {
      if (details.primaryDelta! > 0) {
        if (isDrawerClose) {
          _animationController.value += details.primaryDelta! / 300;
        } else {
          _animationController.value -= details.primaryDelta! / 300;
        }
      } else {
        if (isDrawerClose) {
          _animationController.value += details.primaryDelta! / -300;
        } else {
          _animationController.value -= details.primaryDelta! / -300;
        }
      }
    }
  }
  void onDragEnd(DragEndDetails details) {
    if (_animationController.value >= 0.5) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    setState(() {
      isDrawerClose = _animationController.value < 0.5;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff8c0000), Color(0xffda2851)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder<List<dynamic>>(
          future: menuList,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else if (snapshot.data == null) {
              return Center(
                child: CircularProgressIndicator(color: Colors.red[900]),
              );
            } else {
              return Stack(
                children: [
                  AnimatedPositioned(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    left: isDrawerClose ? -250 : 0,
                    curve: Curves.fastOutSlowIn,
                    duration: Duration(milliseconds: 350),
                    child: GestureDetector(
                      onHorizontalDragStart: onDragStart,
                      onHorizontalDragUpdate: onDragUpdate,
                      onHorizontalDragEnd: onDragEnd,
                      child: DrawerWidget(
                        empId: 'EMP123',
                        empName: 'John Doe',
                        empPic: 'https://randomuser.me/api/portraits/men/32.jpg',
                        empPosition: 'Student',
                        dashboardList: snapshot.data!,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onHorizontalDragStart: onDragStart,
                    onHorizontalDragUpdate: onDragUpdate,
                    onHorizontalDragEnd: onDragEnd,
                    onTap: () {
                      if (!isDrawerClose) toggleDrawer();
                    },
                    child: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY(animation.value -
                            20 * animation.value * pi / 180),
                      child: Transform.translate(
                        offset: Offset(animation.value * 250, 0),
                        child: Transform.scale(
                          scale: scaleAnimation.value,
                          child: ClipRRect(
                            borderRadius:
                            BorderRadius.circular(isDrawerClose ? 0 : 30),
                            child: AbsorbPointer(
                              absorbing: !isDrawerClose,
                              child: HomeWidget(
                                dashboardList: snapshot.data!,
                                openDrawer: toggleDrawer,
                                isDrawerOpen: isDrawerClose,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}



class HomeWidget extends StatelessWidget {
  final VoidCallback openDrawer;
  final bool isDrawerOpen;
  final List dashboardList;

  const HomeWidget({
    super.key,
    required this.openDrawer,
    required this.isDrawerOpen,
    required this.dashboardList,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: [
          PreferredSize(
            preferredSize: Size(double.infinity, 56.0),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30)),
              child: AppBar(
                centerTitle: true,
                backgroundColor: Colors.red[900],
                title: const Text(
                  'Dashboard',
                  style: TextStyle(color: Colors.white),
                ),
                leading: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: openDrawer,
                  child: Icon(
                    isDrawerOpen ? Icons.menu : Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
                // Apply gradient directly to flexibleSpace
                flexibleSpace: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xff8c0000), Color(0xffda2851)], // Gradient colors
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
            ),
          ),
          MenuItems(dashboardList: dashboardList),
        ],
      ),
    );
  }
}
class MenuItems extends StatelessWidget {
  const MenuItems({super.key, required this.dashboardList});

  final List<dynamic> dashboardList;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemCount: dashboardList.length,
        itemBuilder: (BuildContext context, int i) {
          final item = dashboardList[i];
          return MenuCard(
            name: item['name'],
            icon: item['icon'],
            screen: item['screen'],
          );
        },
      ),
    );
  }
}