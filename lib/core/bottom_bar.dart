import 'package:flutter/material.dart';
import 'package:hackbyte2/feautures/auth/presentation/screens/dashboard.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _currentIndex = 0 ;
  List<Widget> body =  [
    
    Dashboard(),
    
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
            icon: Icon(Icons.group,size: 27,),
            label: 'Community',
          ),
          

        ],
      ),
      body: body[_currentIndex],
    );
  }
}