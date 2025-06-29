import 'package:flutter/material.dart';
import 'package:workoutapp2/screens/routines_screen.dart';
import 'workout_screen.dart';
import 'prebuilt_screen.dart';



class MainNavScreen extends StatefulWidget {
  const MainNavScreen({super.key});

  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  int _selectedIndex = 0;

  final _screens = const [
    WorkoutScreen(),
    PrebuiltScreen(),
    RoutinesScreen(), // 👈 NEW
  ];

  final _titles = const [
    'Build Your Workout',
    'Built-in Workouts',
    'My Routines', // 👈 NEW
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titles[_selectedIndex])),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Build',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: 'Prebuilt',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Routines',
          ),

        ],
      ),
    );
  }
}
