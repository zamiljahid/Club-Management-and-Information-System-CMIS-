import 'dart:math';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../api/api_client.dart';
import '../model/menu_model.dart';
import '../routes/menu_title_list.dart';
import '../shared_preference.dart';
import 'drawer_widget.dart';
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

  Future<List<MenuModelClass>?>? menuList;

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
    menuList = ApiClient().getMenu(
      '?role_id=${SharedPrefs.getString('role_id').toString()}',
      context,
    );
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
            colors:[Color(0xff154973),Color(0xff0f65a5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder<List<MenuModelClass>?>(
          future: menuList,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else if (snapshot.data == null) {
              return Center(
                child: CircularProgressIndicator(color: Colors.white),
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
                        empId: SharedPrefs.getString('id').toString(),
                        empName: SharedPrefs.getString('name').toString(),
                        pic: SharedPrefs.getString('pic').toString(),
                        position: SharedPrefs.getString('role').toString(),
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
                backgroundColor: Color(0xff154973),
                title: const Text(
                  'Dashboard',
                  style: TextStyle(color: Colors.white),
                ),
                actions: [
                  Container(
                    height: 75,
                    width: 75,
                    child: Image.asset(
                      'assets/logo.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 5,)
                ],
                leading: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: openDrawer,
                  child: Icon(
                    isDrawerOpen ? Icons.menu : Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
                flexibleSpace: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors:[Color(0xff154973),Color(0xff0f65a5)], // Gradient colors
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
            ),
          ),
    Center(
    child: Lottie.asset('animation/dashboard.json',
    height: MediaQuery.of(context).size.height / 4)
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
      child:GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemCount: dashboardList.length,
        itemBuilder: (BuildContext context, int i) {
          return MenuCard(
            name: ChooseMenu.getTitle(
                menuTitle:  dashboardList[i].menuName.toString()),
            icon: ChooseMenu.getIcon(
                menuTitle: dashboardList[i].menuName.toString()),
            onPressed: () {
              String route = ChooseMenu.getRoutes(
                menuTitle: dashboardList[i].menuName.toString(),
              );
              Navigator.pushNamed(
                context,
                route,
              );
            },
          );
        },
      ),

    );
  }
}