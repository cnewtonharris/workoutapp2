import 'package:flutter/material.dart';
import 'workout_screen.dart';
import 'prebuilt_screen.dart';
import '../theme/app_styles.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout App'),
        centerTitle: true,
        elevation: 2,
      ),
      body: Padding(
        padding: AppStyles.screenPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome!',
              style: AppStyles.header,
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              icon: const Icon(Icons.fitness_center),
              label: const Text('Build Your Own Workout'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const WorkoutScreen()),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.library_books),
              label: const Text('Browse Built-in Workouts'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PrebuiltScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
