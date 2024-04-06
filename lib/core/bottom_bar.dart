import 'package:flutter/material.dart';
import 'package:hackbyte2/feautures/auth/auth/presentation/screens/dashboard.dart';
import 'package:hackbyte2/feautures/hotline/presentation/screens/hotline_screen.dart';
import 'package:hackbyte2/feautures/resources/presentation/screens/resources_screen.dart';
import 'package:hackbyte2/feautures/users_profile/presentation/screens/profile.dart';


class BottomBar extends StatefulWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _currentIndex = 1 ;
  List<Widget> body =  [
    ProfileScreen(),
    Dashboard(),
    ResourcesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.teal, // Set the selected color here
        unselectedItemColor: Color(0xff3A4454),
        currentIndex: _currentIndex,
        onTap: (int newIndex) {
          setState(() {
            _currentIndex = newIndex;
          });
        },
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.emergency,size: 27,),
            label: 'Community',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home,size: 27,),
            label: 'Communit',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb,size: 27,),
            label: 'Communi',
          ),
          

        ],
      ),
      body: body[_currentIndex],
    );
  }
}