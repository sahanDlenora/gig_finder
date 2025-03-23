import 'package:flutter/material.dart';
import 'package:gig_finder/views/main_views/job_screen.dart';
import 'package:gig_finder/views/main_views/message_screen.dart';
import 'package:gig_finder/views/main_views/home_screen.dart';
import 'package:gig_finder/views/main_views/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    JobScreen(),
    FavouriteScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.gamepad),
            label: "Jobs",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: "Messages",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
      body: _pages[_currentIndex],
    );
  }
}
