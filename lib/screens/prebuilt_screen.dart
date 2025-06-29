import 'package:flutter/material.dart';
import '../data/prebuilt_workout_data.dart';
import '../models/workout.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/workout_provider.dart';

class PrebuiltScreen extends ConsumerWidget {
  const PrebuiltScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Built-in Workouts')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: prebuiltWorkouts.length,
        itemBuilder: (context, index) {
          final workout = prebuiltWorkouts[index];
          return Card(
            child: ListTile(
              title: Text(workout.title),
              subtitle: Text(workout.exercises.join(', ')),
              trailing: ElevatedButton(
                child: const Text('Import'),
                onPressed: () {
                  for (var exercise in workout.exercises) {
                    ref.read(workoutProvider.notifier).addWorkout(
                      Workout(
                        exerciseName: exercise,
                        weight: 0,
                        reps: 10,
                        sets: 3,
                      ),
                    );
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${workout.title} added')),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
