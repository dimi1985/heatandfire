import 'package:flutter/material.dart';
import 'package:provider_tutorial/util/http_service.dart';
import 'package:provider_tutorial/models/user.dart';
import 'package:provider_tutorial/screens/home_screen.dart';
import 'package:provider_tutorial/screens/profile_screen.dart';
import 'package:easy_localization/easy_localization.dart';

class HomeNavigation extends StatefulWidget {
  const HomeNavigation({Key? key, required this.userId}) : super(key: key);
  final  String userId;
  @override
  State<HomeNavigation> createState() => _HomeNavigationState();
}

class _HomeNavigationState extends State<HomeNavigation> {
  int _selectedIndex = 0;
  late Future<User> getUser;


  @override
  void initState() {
    getUser = HttpService.getUserById();
    super.initState();
  }

  static final List<Widget> _pages = <Widget>[
    const HomeScreen(),
     const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
        future: getUser,
        builder: (context, snapshot) {
          return Scaffold(
            extendBody: true,
            backgroundColor: Colors.transparent,
            bottomNavigationBar: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black38, spreadRadius: 0, blurRadius: 10),
                ],
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
                child: BottomNavigationBar(
                  elevation: 0,
                  iconSize: 40,
                  backgroundColor: const Color(0xFFE4395F),
                  selectedFontSize: 20,
                  selectedIconTheme: const IconThemeData(
                      color: Color.fromARGB(255, 203, 159, 0), size: 40),
                  selectedItemColor: const Color.fromARGB(255, 214, 168, 0),
                  selectedLabelStyle:
                      const TextStyle(fontWeight: FontWeight.bold),
                  items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.home),
                      label: 'Home'.tr(),
                    ),
                    BottomNavigationBarItem(
                      //snapshot.data?.userImage ?? ''
                      icon: CircleAvatar(
                        child: ClipOval(
                          child: Image.network(
                            ('http://10.0.2.2:3000/${(snapshot.data?.userImage ?? '').replaceAll(r'\', '/')}'),
                            fit: BoxFit.cover,
                            width: 50.0,
                            height: 50.0,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: const Color.fromARGB(255, 32, 22, 92),
                                alignment: Alignment.center,
                                child: const Text(
                                  'Whoops!',
                                  style: TextStyle(fontSize: 12),
                                ),
                              );
                            },
                          ),
                        ),
                        radius: 25,
                      ),
                      label: snapshot.data?.username ?? '',
                    ),
                  ],
                  currentIndex: _selectedIndex,
                  onTap: _onItemTapped,
                ),
              ),
            ),
            body: Center(
              child: _pages.elementAt(_selectedIndex),
            ),
          );
        });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
